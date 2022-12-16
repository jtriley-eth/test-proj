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

// REVERTS
pub fn test_unwrap_or<T>(val: T, default: T)
where
    T: Eq
{
    assert(Result::Ok::<T, T>(val).unwrap_or(default) == val);
    assert(Result::Err::<T, T>(val).unwrap_or(default) == default);
}

// PASSES
pub fn test_unwrap_or_ok<T>(val: T, default: T)
where
    T: Eq
{
    assert(Result::Ok::<T, T>(val).unwrap_or(default) == val);
}

// PASSES
pub fn test_unwrap_or_err<T>(val: T, default: T)
where
    T: Eq
{
    assert(Result::Err::<T, T>(val).unwrap_or(default) == default);
}

abi MyContract {
    fn passes_ok() -> bool;
    fn passes_err() -> bool;
    fn fails() -> bool;
}

impl MyContract for Contract {
    fn passes_ok() -> bool {
        test_unwrap_or_ok(true, false);

        true
    }

    fn passes_err() -> bool {
        test_unwrap_or_err(true, false);

        true
    }

    fn fails() -> bool {
        test_unwrap_or(true, false);

        true
    }
}
