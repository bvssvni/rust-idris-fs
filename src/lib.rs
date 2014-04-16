#![crate_id = "idrisfs"]
#![deny(missing_doc)]

//! Documentation goes here.

/// Returns the number of bytes in an int.
#[no_mangle]
pub extern "C" fn sizeof_int() -> int {
    std::mem::size_of::<int>() as int
}

