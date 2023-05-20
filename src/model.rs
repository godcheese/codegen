use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize)]
pub struct Config {
    pub databases: Vec<Database>,
    pub template: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct Database {
    pub name: String,
    pub url: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct TemplateConfig {
    pub vars: Vec<TemplateVar>,
    pub items: Vec<TemplateItem>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct TemplateVar {
    pub key: String,
    pub value: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct TemplateItem {
    pub template_filename: String,
    pub output_path: String,
    pub output_filename: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct DatabaseInfo {
    pub name: String,
    pub tables: Vec<DatabaseTable>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct DatabaseTable {
    pub table_name: String,
    pub table_comment: String,
    pub fields: Vec<DatabaseTableField>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct DatabaseTableField {
    pub column_name: Option<String>,
    pub data_type: Option<String>,
    pub is_nullable: Option<String>,
    pub column_key: Option<String>,
    pub column_default: Option<String>,
    pub extra: Option<String>,
    pub column_comment: Option<String>,
}
