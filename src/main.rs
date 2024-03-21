use clap::Parser;
use mysql::{params, PooledConn};
use mysql::prelude::Queryable;
use std::{env, fs};
use std::fs::{File, OpenOptions};
use std::io::{BufReader, Write};
use std::path::Path;
use tera::{Context, Tera};

use crate::model::{Config, DatabaseInfo, DatabaseTable, DatabaseTableField, TemplateConfig, TemplateItem, TemplateVar};
use crate::mysql_connect::get_db_connect;
use crate::tera_filter::register_tera_filter;

mod mysql_connect;
mod model;
mod util;
mod tera_filter;

/// Codegen cli
#[derive(Parser)]
#[command(author, version, about, long_about = None)]
struct Cli {
    /// Database names, example: test-db,test-db2, "*" assign all table
    #[arg(short = 'd', long = "databases")]
    databases: Option<String>,

    /// Table names, example: test-tb,test-tb2 , "*" assign all table
    #[arg(short = 't', long = "tables")]
    tables: Option<String>,

    /// Template path, example: default
    #[arg(short = 'p', long = "template")]
    template: Option<String>,
}

const SPLIT_PAT: &str = ",";
const ALL_PATTERN: &str = "*";

fn main() {
    // parse cli command.
    let cli = Cli::parse();
    let mut database_name_vec: Vec<String> = vec![];
    if let Some(databases) = cli.databases.as_deref() {
        if databases == ALL_PATTERN {
            // * assign all databases which config.yaml config.
            for config_database in get_config().databases {
                let config_database_name = config_database.name;
                database_name_vec.push(config_database_name);
            }
        } else {
            database_name_vec = databases.split(SPLIT_PAT)
                .map(|temp_str| { temp_str.to_string() }).collect();
        }
    }
    let mut is_all_table = false;
    let mut table_name_vec: Vec<String> = vec![];
    if let Some(tables) = cli.tables.as_deref() {
        // * assign all tables
        if tables == ALL_PATTERN {
            is_all_table = true;
        } else {
            table_name_vec = tables.split(SPLIT_PAT)
                .map(|temp_str| { temp_str.to_string() }).collect();
        }
    }
    let mut template = get_config_template();
    if let Some(tpl) = cli.template.as_deref() {
        template = tpl.to_string();
    }
    let mut database_info_vec = vec![];
    if database_name_vec.len() > 0 && (is_all_table || table_name_vec.len() > 0) {
        for database_name in database_name_vec {
            database_info_vec.push(get_database(&database_name, &table_name_vec));
        }
    }

    // new Tera
    let mut tera = Tera::default();
    let mut context = Context::new();
    register_tera_filter(&mut tera);
    let separator = &*std::path::MAIN_SEPARATOR_STR.to_string();
    let current_run_path = env::current_dir().unwrap().display().to_string();
    // Windows system path replace in JSON format.
    let current_run_path_to_json_context = current_run_path.replace("\\", "\\\\");
    context.insert("current_run_path", &current_run_path_to_json_context);
    let template_path = format!("{current_run_path}{separator}templates{separator}{template}");
    let template_path_exists = Path::new(&template_path).exists();
    if template_path_exists {
        let template_config_json_filename = format!("{template_path}{separator}template_config.json");
        let template_config_json_file = File::open(template_config_json_filename).unwrap();
        let template_config_json_file_buf_reader = BufReader::new(template_config_json_file);
        let template_config: TemplateConfig = serde_json::from_reader(template_config_json_file_buf_reader).unwrap();
        let var_vec = template_config.vars;
        let item_vec = template_config.items;
        let var_json = serde_json::to_string(&var_vec).unwrap();
        let item_json = serde_json::to_string(&item_vec).unwrap();
        for database_info in database_info_vec {
            let temp_database_info = &database_info;
            let temp_database_table_vec = &temp_database_info.tables;
            for table in temp_database_table_vec {
                context.insert("database", &temp_database_info);
                context.insert("table", &table);
                let var_json_str = tera.render_str(&var_json, &context).unwrap();
                let var_vec: Vec<TemplateVar> = serde_json::from_str(&var_json_str).unwrap();
                for temp_var in &var_vec {
                    context.insert(&temp_var.key, &temp_var.value);
                }
                let item_json_str = tera.render_str(&item_json, &context).unwrap();
                let item_vec: Vec<TemplateItem> = serde_json::from_str(&item_json_str).unwrap();

                let mut filenames: Vec<String> = vec![];
                get_files(&template_path, &mut filenames);

                for filename in filenames {
                    let _ = &tera.add_template_file(Path::new(&filename), None).expect("Template add failed.");
                }

                for temp_var in var_vec {
                    context.insert(&temp_var.key, &temp_var.value);
                }

                for temp_item in item_vec {
                    let template_output_path = temp_item.output_path.to_string();
                    let mut template_output_filename = temp_item.output_filename;
                    template_output_filename = format!("{template_output_path}{separator}{template_output_filename}");
                    println!("Code output filename: {template_output_filename}");
                    let template_output_path_exists = Path::new(&template_output_path).exists();
                    if !template_output_path_exists {
                        fs::create_dir_all(template_output_path).unwrap();
                    }
                    let template_output_filename_exists = Path::new(&template_output_filename).exists();
                    let mut temp_file: File;
                    if template_output_filename_exists {
                        temp_file = OpenOptions::new().read(true).write(true).open(template_output_filename).unwrap();
                    } else {
                        temp_file = File::create(template_output_filename).expect("Code file output failed.");
                    }
                    let mut template_filename = temp_item.template_filename;
                    template_filename = format!("{template_path}{separator}{template_filename}");
                    let template_output_content = tera.render(&template_filename, &context).unwrap();
                    temp_file.write_all(template_output_content.as_bytes()).expect("Code string write failed.");
                }
            }
        }
    }
}

/// get_config_template
pub fn get_config_template() -> String {
    let config = get_config();
    let config_template = config.template;
    if config_template != "" {
        return config_template;
    }
    return "default".to_string();
}

/// get_files
pub fn get_files(path: &str, filenames: &mut Vec<String>) {
    let temp_dir = Path::new(path);
    if temp_dir.exists() {
        if temp_dir.is_dir() {
            let dirs = temp_dir.read_dir().unwrap();
            for d in dirs {
                let dd = d.unwrap().path();
                if dd.exists() {
                    if dd.is_dir() {
                        get_files(dd.display().to_string().as_str(), filenames);
                    } else if dd.is_file() {
                        filenames.push(dd.display().to_string());
                    }
                }
            }
        }
    }
}

/// get_database
pub fn get_database(database_name: &str, table_name_vec: &Vec<String>) -> DatabaseInfo {
    let mut database_info = DatabaseInfo {
        name: String::from(""),
        tables: vec![],
    };
    println!("Loading config...");
    let config = get_config();
    for config_database in config.databases {
        if database_name == config_database.name {
            println!("Connecting database...");
            let mut connect = get_db_connect(&config_database.url);
            let current_database_option = get_database_info(&mut connect);
            let database_name = current_database_option.unwrap().name.to_string();
            database_info.name = database_name.clone();
            let table_vec_opt = get_database_tables(&mut connect, &database_name, table_name_vec);
            if !table_vec_opt.is_none() {
                let mut table_vec = vec![];
                for mut table in table_vec_opt.unwrap() {
                    let table_name = table.table_name.clone().to_string();
                    let field_vec_opt = get_database_table_fields(&mut connect, &database_name, &table_name);
                    table.fields = field_vec_opt.unwrap();
                    table_vec.push(table);
                }
                database_info.tables = table_vec
            }
        }
    }
    return database_info;
}

/// get_database_info
pub fn get_database_info(conn: &mut PooledConn) -> Option<DatabaseInfo> {
    let query_result = conn.query_first("select database();").map(|row| { row.map(|name| DatabaseInfo { name, tables: vec![] }) });
    match query_result {
        Ok(result) => {
            result
        }
        Err(error) => {
            panic!("{}", error)
        }
    }
}

/// get_database_tables
pub fn get_database_tables(conn: &mut PooledConn, database_name: &str, table_name_vec: &Vec<String>) -> Option<Vec<DatabaseTable>> {
    let table_name_vec2: Vec<String> = table_name_vec.iter().map(|table_name| format!("'{table_name}'")).collect();
    let query_result;
    if table_name_vec2.len() > 0 {
        let table_names = table_name_vec2.join(",");
        let sql = format!("
        select table_name, table_comment
        from information_schema.tables
        where table_schema = '{database_name}'
        and table_name in ({table_names});");
        query_result = conn.query_map(sql, |(table_name, table_comment)|
            DatabaseTable { table_name, table_comment, fields: vec![] });
    } else {
        query_result = conn.exec_map("select table_name, table_comment from information_schema.tables where table_schema = :database_name;",
                                     params! { database_name },
                                     |(table_name, table_comment)| DatabaseTable { table_name, table_comment, fields: vec![] });
    }
    match query_result {
        Ok(result) => {
            Some(result)
        }
        Err(error) => {
            panic!("error: {:?}", error)
        }
    }
}

/// get_database_table_fields
pub fn get_database_table_fields(conn: &mut PooledConn, database_name: &str, table_name: &str) -> Option<Vec<DatabaseTableField>> {
    let query_result = conn.exec_map("select
	column_name, data_type, is_nullable, column_key,column_default, extra, column_comment from information_schema.columns where
	table_schema = :database_name and table_name = :table_name order by ordinal_position;",
                                     params! {database_name, table_name},
                                     |(column_name, data_type, is_nullable, column_key, column_default, extra, column_comment)| DatabaseTableField { column_name, data_type, is_nullable, column_key, column_default, extra, column_comment });
    match query_result {
        Ok(result) => {
            Some(result)
        }
        Err(error) => {
            panic!("error: {:?}", error)
        }
    }
}

/// get_config
pub fn get_config() -> Config {
    let file = File::open("config.yaml").expect("Could not open file.");
    let config: Config = serde_yaml::from_reader(file).expect("Could not read values.");
    config
}