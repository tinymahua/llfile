pub mod client_api;

use anyhow::Result;
use flutter_rust_bridge::frb;
use base64::prelude::*;
use palcrypto_rs::aes_crypto::{generate_pal_aes_key, pal_aes_decrypt, pal_aes_encrypt};
use palcrypto_rs::crypto_box_crypto::{generate_pal_key_pair, pal_cb_decrypt, pal_cb_encrypt};
use palcrypto_rs::hash::argon2_password_hash;

#[frb]
pub struct SandbarAuth{
    pub master_key_bytes_b64: String,
    pub master_key_encrypted_bytes_b64: String,
    pub public_key_bytes_b64: String,
    pub private_key_bytes_b64: String,
    pub private_key_encrypted_bytes_b64: String,
}

pub fn generate_auth(password: String) -> Result<SandbarAuth> {
    let password_hash_output = argon2_password_hash(password.as_bytes())?;
    let master_key_bytes = generate_pal_aes_key();
    let master_key_encrypted_bytes = pal_aes_encrypt(password_hash_output.as_slice(), master_key_bytes.as_bytes().as_slice())?;

    let cb_key_pair = generate_pal_key_pair();
    let cb_private_key_bytes = cb_key_pair.secret_key_bytes;
    let cb_private_key_encrypted_bytes = pal_aes_encrypt(master_key_bytes.as_bytes().as_slice(), cb_private_key_bytes.as_slice())?;

    Ok(SandbarAuth{
        master_key_bytes_b64: BASE64_STANDARD.encode(master_key_encrypted_bytes.as_slice()),
        master_key_encrypted_bytes_b64: BASE64_STANDARD.encode(master_key_encrypted_bytes.as_slice()),
        public_key_bytes_b64: BASE64_STANDARD.encode(cb_key_pair.public_key_bytes.as_slice()),
        private_key_bytes_b64: BASE64_STANDARD.encode(cb_private_key_bytes.as_slice()),
        private_key_encrypted_bytes_b64: BASE64_STANDARD.encode(cb_private_key_encrypted_bytes.as_slice()),
    })
}

pub fn generate_aes_key() -> Result<Vec<u8>> {
    let key = generate_pal_aes_key();
    Ok(key.as_bytes())
}


pub fn aes_encrypt(pal_aes_key_bytes: Vec<u8>, plain_bytes:Vec<u8>) -> Result<Vec<u8>> {
    let encrypted_bytes = pal_aes_encrypt(
        pal_aes_key_bytes.as_slice(), plain_bytes.as_slice())?;
    Ok(encrypted_bytes)
}

pub fn aes_decrypt(pal_aes_key_bytes: Vec<u8>, encrypted_bytes:Vec<u8>, nonce_len: Option<usize>) -> Result<Vec<u8>> {
    let decrypted_bytes = pal_aes_decrypt(
        pal_aes_key_bytes.as_slice(), encrypted_bytes.as_slice(), nonce_len)?;
    Ok(decrypted_bytes)
}

#[frb]
pub struct CbKeyPair {
    pub public_key_bytes_b64: String,
    pub private_key_bytes_b64: String,
}

pub fn generate_cb_key_pair() -> Result<CbKeyPair>{
    let key_pair = generate_pal_key_pair();
    Ok(CbKeyPair{
        public_key_bytes_b64: BASE64_STANDARD.encode(key_pair.public_key_bytes.as_slice()),
        private_key_bytes_b64: BASE64_STANDARD.encode(key_pair.secret_key_bytes.as_slice())
    })
}

pub fn cb_encrypt(peer_pal_crypto_public_key_bytes: Vec<u8>,
                  my_pal_crypto_secret_key_bytes: Vec<u8>,
                  plain_bytes: Vec<u8>) -> Result<Vec<u8>> {
    let encrypted_bytes = pal_cb_encrypt(
        peer_pal_crypto_public_key_bytes.as_slice(),
        my_pal_crypto_secret_key_bytes.as_slice(), plain_bytes.as_slice())?;
    Ok(encrypted_bytes)
}

pub fn cb_decrypt(
    peer_pal_crypto_public_key_bytes: Vec<u8>,
    my_pal_crypto_secret_key_bytes: Vec<u8>,
    encrypted_bytes: Vec<u8>,
    nonce_len: Option<usize>) -> Result<Vec<u8>> {
    let decrypted_bytes = pal_cb_decrypt(
        peer_pal_crypto_public_key_bytes.as_slice(), my_pal_crypto_secret_key_bytes.as_slice(),
        encrypted_bytes.as_slice(), nonce_len)?;
    Ok(decrypted_bytes)
}

pub fn argon2_pwd_hash(password: Vec<u8>) -> Result<Vec<u8>>{
    let hash_output_bytes = argon2_password_hash(password.as_slice())?;
    Ok(hash_output_bytes)
}