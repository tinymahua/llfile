use rust_lib_llfile::api::sandbar::generate_auth;

fn main() {
    let _ = generate_auth(String::from("123456")).unwrap();
    // println!("auth: {:?}", auth.master_key_bytes_b32);
}

// use anyhow::Result;
// use base64::Engine;
//
// fn main() -> Result<()> {
//     test_argon2()
//     // test_sha()
// }
//
// // fn test_pbkdf2()->Result<()>{
// //
// //     use pbkdf2::{
// //         password_hash::{
// //             rand_core::OsRng,
// //             PasswordHash, PasswordHasher, PasswordVerifier, SaltString
// //         },
// //         Pbkdf2
// //     };
// //
// //     let password = b"hunter42"; // Bad password; don't actually use!
// //     // let salt = SaltString::generate(&mut OsRng);
// //     let salt = SaltString::from_b64("pF8oRdtfyWgRpFAYFf/w1Q").unwrap();
// //     println!("salt: {:?}", salt);
// //
// //     // Hash password to PHC string ($pbkdf2-sha256$...)
// //     let password_hash = Pbkdf2.hash_password(password, &salt).unwrap();
// //     println!("Password hash: {:?}", password_hash.params);
// //
// //     Ok(())
// // }
//
//
// fn test_sha()->Result<()>{
//     use sha3::{Sha3_512, Digest};
//
//     let mut hasher = Sha3_512::new();
//     hasher.update("134".as_bytes());
//     let hash = hasher.finalize();
//     println!("{:?}", hash.to_vec());
//
//     Ok(())
// }
//
// fn test_argon2()->Result<()>{
//     use argon2::{
//         password_hash::{
//             rand_core::OsRng,
//             PasswordHash, PasswordHasher, PasswordVerifier, SaltString
//         },
//         Argon2
//     };
//     use sha3::{Sha3_512, Digest};
//     use base64::prelude::*;
//
//     let password = b"123456";
//     //
//     // let password = b"hunter42"; // Bad password; don't actually use!
//     // // let salt = SaltString::generate(&mut OsRng);
//     // let salt = SaltString::from_b64("WoLBWpTfh8nTUFTljaOMIg").unwrap();
//     // println!("salt: {:?}", salt);
//     //
//     // // Argon2 with default params (Argon2id v19)
//     // let argon2 = Argon2::default();
//     // // let argon2 = Argon2::new(
//     // //     argon2::Algorithm::Argon2id,
//     // //     argon2::Version::V0x13,
//     // //     Params::new(Params::MIN_M_COST * 100, 50, 100, Some(64usize)).unwrap());
//     //
//     // // Hash password to PHC string ($argon2id$v=19$...)
//     // let password_hash = argon2.hash_password(password, &salt).unwrap();
//     // println!("Password hash: {}", password_hash.params);
//
//     let mut hasher = Sha3_512::new();
//     hasher.update(password);
//     let hash = hasher.finalize();
//     println!("hash: {:?}", hash.to_vec());
//     println!("BASE64_STANDARD.encode(hash.as_slice()): {:?}", BASE64_STANDARD.encode(hash.as_slice()));
//     let argon2_salt = SaltString::from_b64(BASE64_STANDARD.encode(hash.as_slice())[..64].trim()).unwrap();
//     let argon2 = Argon2::default();
//     let password_hash = argon2.hash_password(b"123", &argon2_salt).unwrap();
//     println!("Password hash: {:?}", password_hash.hash.unwrap().as_bytes());
//
//     Ok(())
// }