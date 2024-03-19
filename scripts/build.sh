current_path=`pwd`
cd ..
cargo clean
rustup target add x86_64-unknown-linux-musl
cargo build --release --target=x86_64-unknown-linux-musl
rustup target add x86_64-pc-windows-gnu
cargo build --release --target=x86_64-pc-windows-gnu

cd $current_path