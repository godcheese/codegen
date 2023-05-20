// lower camel
pub fn lower_camel(s: &str, hyphen: &str) -> String {
    let s_vec: Vec<&str>;
    if hyphen == "" {
        s_vec = s.split("_").collect();
    } else {
        s_vec = s.split(hyphen).collect();
    }
    let mut result: String = String::from("");
    for i in 0..s_vec.len() {
        let ss = s_vec[i];
        if i == 0 {
            result = result + ss[0..1].to_lowercase().as_str() + &ss[1..]
        } else {
            result = result + ss[0..1].to_uppercase().as_str() + &ss[1..]
        }
    }
    result
}

/// upper camel
pub fn upper_camel(s: &str, hyphen: &str) -> String {
    let s_arr;
    if hyphen == "" {
        s_arr = s.split("_");
    } else {
        s_arr = s.split(hyphen);
    }
    let mut result: String = String::from("");
    for ss in s_arr {
        result = result + ss[0..1].to_uppercase().as_str() + &ss[1..]
    }
    result
}
