contract;

use std::core::ops::*;

enum Result<T, E> {
    Ok: T,
    Err: E,
}

impl<T, E> Result<T, E> {
    pub fn unwrap_or(self, default: T) -> T {
        match self {
            Result::Ok(inner_value) => inner_value,
            Result::Err(_) => default,
        }
    }
}

pub fn test_unwrap_or<T>(val: T, default: T)
where
    T: Eq
{
    assert(Result::Ok::<T, T>(val).unwrap_or(default) == val);
    assert(Result::Err::<T, T>(val).unwrap_or(default) == default);
}

abi MyContract {
    fn test_function() -> bool;
}

impl MyContract for Contract {
    fn test_function() -> bool {
        test_unwrap_or(true, false);

        true
    }
}
