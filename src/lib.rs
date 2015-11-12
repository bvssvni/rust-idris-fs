#![crate_type = "lib"]
#![crate_name = "idrisfs"]

//! Documentation goes here.

/// Returns the number of bytes in an isize.
#[no_mangle]
pub extern "C" fn sizeof_isize() -> u64 {
    std::mem::size_of::<isize>() as u64
}
