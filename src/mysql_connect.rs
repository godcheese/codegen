use mysql::{Pool, PooledConn};

/// get_db_connect
pub fn get_db_connect(url: &str) -> PooledConn {
    // Create database connect pool.
    let pool = Pool::new(url).expect("Database connect failed.");
    pool.get_conn().unwrap()
}