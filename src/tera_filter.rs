use serde_json::{to_value, Value};
use std::collections::HashMap;
use tera::{Tera, try_get_value};

use crate::util::{lower_camel, upper_camel};

/// register tera filter
pub fn register_tera_filter(tera_ref: &mut Tera) {
    tera_ref.register_filter("lower_camel", tera_lower_camel);
    tera_ref.register_filter("upper_camel", tera_upper_camel);
}

/// tera lower camel
pub fn tera_lower_camel(value: &Value, args: &HashMap<String, Value>) -> tera::Result<Value> {
    let s = try_get_value!("lower_camel", "value", String, value);
    let hyphen = match args.get("hyphen") {
        Some(hyphen) => try_get_value!("lower_camel", "hyphen", String, hyphen),
        None => "_".to_string(),
    };
    Ok(to_value(lower_camel(&s, &hyphen).as_str()).unwrap())
}

/// tera upper_camel
pub fn tera_upper_camel(value: &Value, args: &HashMap<String, Value>) -> tera::Result<Value> {
    let s = try_get_value!("upper_camel", "value", String, value);
    let hyphen = match args.get("hyphen") {
        Some(hyphen) => try_get_value!("upper_camel", "hyphen", String, hyphen),
        None => "_".to_string(),
    };
    Ok(to_value(upper_camel(&s, &hyphen)).unwrap())
}
