// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.5.1.

#![allow(
    non_camel_case_types,
    unused,
    non_snake_case,
    clippy::needless_return,
    clippy::redundant_closure_call,
    clippy::redundant_closure,
    clippy::useless_conversion,
    clippy::unit_arg,
    clippy::unused_unit,
    clippy::double_parens,
    clippy::let_and_return,
    clippy::too_many_arguments,
    clippy::match_single_binding,
    clippy::clone_on_copy,
    clippy::let_unit_value,
    clippy::deref_addrof,
    clippy::explicit_auto_deref,
    clippy::borrow_deref_ref,
    clippy::needless_borrow
)]

// Section: imports

use flutter_rust_bridge::for_generated::byteorder::{NativeEndian, ReadBytesExt, WriteBytesExt};
use flutter_rust_bridge::for_generated::{transform_result_dco, Lifetimeable, Lockable};
use flutter_rust_bridge::{Handler, IntoIntoDart};

// Section: boilerplate

flutter_rust_bridge::frb_generated_boilerplate!(
    default_stream_sink_codec = SseCodec,
    default_rust_opaque = RustOpaqueMoi,
    default_rust_auto_opaque = RustAutoOpaqueMoi,
);
pub(crate) const FLUTTER_RUST_BRIDGE_CODEGEN_VERSION: &str = "2.5.1";
pub(crate) const FLUTTER_RUST_BRIDGE_CODEGEN_CONTENT_HASH: i32 = 1866773956;

// Section: executor

flutter_rust_bridge::frb_generated_default_handler!();

// Section: wire_funcs

fn wire__crate__api__lldisk__get_disk_partitions_impl(
    ptr_: flutter_rust_bridge::for_generated::PlatformGeneralizedUint8ListPtr,
    rust_vec_len_: i32,
    data_len_: i32,
) -> flutter_rust_bridge::for_generated::WireSyncRust2DartSse {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap_sync::<flutter_rust_bridge::for_generated::SseCodec, _>(
        flutter_rust_bridge::for_generated::TaskInfo {
            debug_name: "get_disk_partitions",
            port: None,
            mode: flutter_rust_bridge::for_generated::FfiCallMode::Sync,
        },
        move || {
            let message = unsafe {
                flutter_rust_bridge::for_generated::Dart2RustMessageSse::from_wire(
                    ptr_,
                    rust_vec_len_,
                    data_len_,
                )
            };
            let mut deserializer =
                flutter_rust_bridge::for_generated::SseDeserializer::new(message);
            deserializer.end();
            transform_result_sse::<_, flutter_rust_bridge::for_generated::anyhow::Error>(
                (move || {
                    let output_ok = crate::api::lldisk::get_disk_partitions()?;
                    Ok(output_ok)
                })(),
            )
        },
    )
}
fn wire__crate__api__llfs__get_fs_entities_impl(
    port_: flutter_rust_bridge::for_generated::MessagePort,
    ptr_: flutter_rust_bridge::for_generated::PlatformGeneralizedUint8ListPtr,
    rust_vec_len_: i32,
    data_len_: i32,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap_normal::<flutter_rust_bridge::for_generated::SseCodec, _, _>(
        flutter_rust_bridge::for_generated::TaskInfo {
            debug_name: "get_fs_entities",
            port: Some(port_),
            mode: flutter_rust_bridge::for_generated::FfiCallMode::Normal,
        },
        move || {
            let message = unsafe {
                flutter_rust_bridge::for_generated::Dart2RustMessageSse::from_wire(
                    ptr_,
                    rust_vec_len_,
                    data_len_,
                )
            };
            let mut deserializer =
                flutter_rust_bridge::for_generated::SseDeserializer::new(message);
            let api_s = <StreamSink<
                crate::api::llfs::FsEntity,
                flutter_rust_bridge::for_generated::SseCodec,
            >>::sse_decode(&mut deserializer);
            let api_root_path = <String>::sse_decode(&mut deserializer);
            deserializer.end();
            move |context| {
                transform_result_sse::<_, flutter_rust_bridge::for_generated::anyhow::Error>(
                    (move || {
                        let output_ok = crate::api::llfs::get_fs_entities(api_s, api_root_path)?;
                        Ok(output_ok)
                    })(),
                )
            }
        },
    )
}
fn wire__crate__api__sandbar__aes_decrypt_impl(
    port_: flutter_rust_bridge::for_generated::MessagePort,
    ptr_: flutter_rust_bridge::for_generated::PlatformGeneralizedUint8ListPtr,
    rust_vec_len_: i32,
    data_len_: i32,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap_normal::<flutter_rust_bridge::for_generated::SseCodec, _, _>(
        flutter_rust_bridge::for_generated::TaskInfo {
            debug_name: "aes_decrypt",
            port: Some(port_),
            mode: flutter_rust_bridge::for_generated::FfiCallMode::Normal,
        },
        move || {
            let message = unsafe {
                flutter_rust_bridge::for_generated::Dart2RustMessageSse::from_wire(
                    ptr_,
                    rust_vec_len_,
                    data_len_,
                )
            };
            let mut deserializer =
                flutter_rust_bridge::for_generated::SseDeserializer::new(message);
            let api_pal_aes_key_bytes = <Vec<u8>>::sse_decode(&mut deserializer);
            let api_encrypted_bytes = <Vec<u8>>::sse_decode(&mut deserializer);
            let api_nonce_len = <Option<usize>>::sse_decode(&mut deserializer);
            deserializer.end();
            move |context| {
                transform_result_sse::<_, flutter_rust_bridge::for_generated::anyhow::Error>(
                    (move || {
                        let output_ok = crate::api::sandbar::aes_decrypt(
                            api_pal_aes_key_bytes,
                            api_encrypted_bytes,
                            api_nonce_len,
                        )?;
                        Ok(output_ok)
                    })(),
                )
            }
        },
    )
}
fn wire__crate__api__sandbar__aes_encrypt_impl(
    port_: flutter_rust_bridge::for_generated::MessagePort,
    ptr_: flutter_rust_bridge::for_generated::PlatformGeneralizedUint8ListPtr,
    rust_vec_len_: i32,
    data_len_: i32,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap_normal::<flutter_rust_bridge::for_generated::SseCodec, _, _>(
        flutter_rust_bridge::for_generated::TaskInfo {
            debug_name: "aes_encrypt",
            port: Some(port_),
            mode: flutter_rust_bridge::for_generated::FfiCallMode::Normal,
        },
        move || {
            let message = unsafe {
                flutter_rust_bridge::for_generated::Dart2RustMessageSse::from_wire(
                    ptr_,
                    rust_vec_len_,
                    data_len_,
                )
            };
            let mut deserializer =
                flutter_rust_bridge::for_generated::SseDeserializer::new(message);
            let api_pal_aes_key_bytes = <Vec<u8>>::sse_decode(&mut deserializer);
            let api_plain_bytes = <Vec<u8>>::sse_decode(&mut deserializer);
            deserializer.end();
            move |context| {
                transform_result_sse::<_, flutter_rust_bridge::for_generated::anyhow::Error>(
                    (move || {
                        let output_ok = crate::api::sandbar::aes_encrypt(
                            api_pal_aes_key_bytes,
                            api_plain_bytes,
                        )?;
                        Ok(output_ok)
                    })(),
                )
            }
        },
    )
}
fn wire__crate__api__sandbar__argon2_pwd_hash_impl(
    port_: flutter_rust_bridge::for_generated::MessagePort,
    ptr_: flutter_rust_bridge::for_generated::PlatformGeneralizedUint8ListPtr,
    rust_vec_len_: i32,
    data_len_: i32,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap_normal::<flutter_rust_bridge::for_generated::SseCodec, _, _>(
        flutter_rust_bridge::for_generated::TaskInfo {
            debug_name: "argon2_pwd_hash",
            port: Some(port_),
            mode: flutter_rust_bridge::for_generated::FfiCallMode::Normal,
        },
        move || {
            let message = unsafe {
                flutter_rust_bridge::for_generated::Dart2RustMessageSse::from_wire(
                    ptr_,
                    rust_vec_len_,
                    data_len_,
                )
            };
            let mut deserializer =
                flutter_rust_bridge::for_generated::SseDeserializer::new(message);
            let api_password = <Vec<u8>>::sse_decode(&mut deserializer);
            deserializer.end();
            move |context| {
                transform_result_sse::<_, flutter_rust_bridge::for_generated::anyhow::Error>(
                    (move || {
                        let output_ok = crate::api::sandbar::argon2_pwd_hash(api_password)?;
                        Ok(output_ok)
                    })(),
                )
            }
        },
    )
}
fn wire__crate__api__sandbar__cb_decrypt_impl(
    port_: flutter_rust_bridge::for_generated::MessagePort,
    ptr_: flutter_rust_bridge::for_generated::PlatformGeneralizedUint8ListPtr,
    rust_vec_len_: i32,
    data_len_: i32,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap_normal::<flutter_rust_bridge::for_generated::SseCodec, _, _>(
        flutter_rust_bridge::for_generated::TaskInfo {
            debug_name: "cb_decrypt",
            port: Some(port_),
            mode: flutter_rust_bridge::for_generated::FfiCallMode::Normal,
        },
        move || {
            let message = unsafe {
                flutter_rust_bridge::for_generated::Dart2RustMessageSse::from_wire(
                    ptr_,
                    rust_vec_len_,
                    data_len_,
                )
            };
            let mut deserializer =
                flutter_rust_bridge::for_generated::SseDeserializer::new(message);
            let api_peer_pal_crypto_public_key_bytes = <Vec<u8>>::sse_decode(&mut deserializer);
            let api_my_pal_crypto_secret_key_bytes = <Vec<u8>>::sse_decode(&mut deserializer);
            let api_encrypted_bytes = <Vec<u8>>::sse_decode(&mut deserializer);
            let api_nonce_len = <Option<usize>>::sse_decode(&mut deserializer);
            deserializer.end();
            move |context| {
                transform_result_sse::<_, flutter_rust_bridge::for_generated::anyhow::Error>(
                    (move || {
                        let output_ok = crate::api::sandbar::cb_decrypt(
                            api_peer_pal_crypto_public_key_bytes,
                            api_my_pal_crypto_secret_key_bytes,
                            api_encrypted_bytes,
                            api_nonce_len,
                        )?;
                        Ok(output_ok)
                    })(),
                )
            }
        },
    )
}
fn wire__crate__api__sandbar__cb_encrypt_impl(
    port_: flutter_rust_bridge::for_generated::MessagePort,
    ptr_: flutter_rust_bridge::for_generated::PlatformGeneralizedUint8ListPtr,
    rust_vec_len_: i32,
    data_len_: i32,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap_normal::<flutter_rust_bridge::for_generated::SseCodec, _, _>(
        flutter_rust_bridge::for_generated::TaskInfo {
            debug_name: "cb_encrypt",
            port: Some(port_),
            mode: flutter_rust_bridge::for_generated::FfiCallMode::Normal,
        },
        move || {
            let message = unsafe {
                flutter_rust_bridge::for_generated::Dart2RustMessageSse::from_wire(
                    ptr_,
                    rust_vec_len_,
                    data_len_,
                )
            };
            let mut deserializer =
                flutter_rust_bridge::for_generated::SseDeserializer::new(message);
            let api_peer_pal_crypto_public_key_bytes = <Vec<u8>>::sse_decode(&mut deserializer);
            let api_my_pal_crypto_secret_key_bytes = <Vec<u8>>::sse_decode(&mut deserializer);
            let api_plain_bytes = <Vec<u8>>::sse_decode(&mut deserializer);
            deserializer.end();
            move |context| {
                transform_result_sse::<_, flutter_rust_bridge::for_generated::anyhow::Error>(
                    (move || {
                        let output_ok = crate::api::sandbar::cb_encrypt(
                            api_peer_pal_crypto_public_key_bytes,
                            api_my_pal_crypto_secret_key_bytes,
                            api_plain_bytes,
                        )?;
                        Ok(output_ok)
                    })(),
                )
            }
        },
    )
}
fn wire__crate__api__sandbar__generate_aes_key_impl(
    port_: flutter_rust_bridge::for_generated::MessagePort,
    ptr_: flutter_rust_bridge::for_generated::PlatformGeneralizedUint8ListPtr,
    rust_vec_len_: i32,
    data_len_: i32,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap_normal::<flutter_rust_bridge::for_generated::SseCodec, _, _>(
        flutter_rust_bridge::for_generated::TaskInfo {
            debug_name: "generate_aes_key",
            port: Some(port_),
            mode: flutter_rust_bridge::for_generated::FfiCallMode::Normal,
        },
        move || {
            let message = unsafe {
                flutter_rust_bridge::for_generated::Dart2RustMessageSse::from_wire(
                    ptr_,
                    rust_vec_len_,
                    data_len_,
                )
            };
            let mut deserializer =
                flutter_rust_bridge::for_generated::SseDeserializer::new(message);
            deserializer.end();
            move |context| {
                transform_result_sse::<_, flutter_rust_bridge::for_generated::anyhow::Error>(
                    (move || {
                        let output_ok = crate::api::sandbar::generate_aes_key()?;
                        Ok(output_ok)
                    })(),
                )
            }
        },
    )
}
fn wire__crate__api__sandbar__generate_auth_impl(
    port_: flutter_rust_bridge::for_generated::MessagePort,
    ptr_: flutter_rust_bridge::for_generated::PlatformGeneralizedUint8ListPtr,
    rust_vec_len_: i32,
    data_len_: i32,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap_normal::<flutter_rust_bridge::for_generated::SseCodec, _, _>(
        flutter_rust_bridge::for_generated::TaskInfo {
            debug_name: "generate_auth",
            port: Some(port_),
            mode: flutter_rust_bridge::for_generated::FfiCallMode::Normal,
        },
        move || {
            let message = unsafe {
                flutter_rust_bridge::for_generated::Dart2RustMessageSse::from_wire(
                    ptr_,
                    rust_vec_len_,
                    data_len_,
                )
            };
            let mut deserializer =
                flutter_rust_bridge::for_generated::SseDeserializer::new(message);
            let api_password = <String>::sse_decode(&mut deserializer);
            deserializer.end();
            move |context| {
                transform_result_sse::<_, flutter_rust_bridge::for_generated::anyhow::Error>(
                    (move || {
                        let output_ok = crate::api::sandbar::generate_auth(api_password)?;
                        Ok(output_ok)
                    })(),
                )
            }
        },
    )
}
fn wire__crate__api__sandbar__generate_cb_key_pair_impl(
    port_: flutter_rust_bridge::for_generated::MessagePort,
    ptr_: flutter_rust_bridge::for_generated::PlatformGeneralizedUint8ListPtr,
    rust_vec_len_: i32,
    data_len_: i32,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap_normal::<flutter_rust_bridge::for_generated::SseCodec, _, _>(
        flutter_rust_bridge::for_generated::TaskInfo {
            debug_name: "generate_cb_key_pair",
            port: Some(port_),
            mode: flutter_rust_bridge::for_generated::FfiCallMode::Normal,
        },
        move || {
            let message = unsafe {
                flutter_rust_bridge::for_generated::Dart2RustMessageSse::from_wire(
                    ptr_,
                    rust_vec_len_,
                    data_len_,
                )
            };
            let mut deserializer =
                flutter_rust_bridge::for_generated::SseDeserializer::new(message);
            deserializer.end();
            move |context| {
                transform_result_sse::<_, flutter_rust_bridge::for_generated::anyhow::Error>(
                    (move || {
                        let output_ok = crate::api::sandbar::generate_cb_key_pair()?;
                        Ok(output_ok)
                    })(),
                )
            }
        },
    )
}
fn wire__crate__api__simple__greet_impl(
    ptr_: flutter_rust_bridge::for_generated::PlatformGeneralizedUint8ListPtr,
    rust_vec_len_: i32,
    data_len_: i32,
) -> flutter_rust_bridge::for_generated::WireSyncRust2DartSse {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap_sync::<flutter_rust_bridge::for_generated::SseCodec, _>(
        flutter_rust_bridge::for_generated::TaskInfo {
            debug_name: "greet",
            port: None,
            mode: flutter_rust_bridge::for_generated::FfiCallMode::Sync,
        },
        move || {
            let message = unsafe {
                flutter_rust_bridge::for_generated::Dart2RustMessageSse::from_wire(
                    ptr_,
                    rust_vec_len_,
                    data_len_,
                )
            };
            let mut deserializer =
                flutter_rust_bridge::for_generated::SseDeserializer::new(message);
            let api_name = <String>::sse_decode(&mut deserializer);
            deserializer.end();
            transform_result_sse::<_, ()>((move || {
                let output_ok = Result::<_, ()>::Ok(crate::api::simple::greet(api_name))?;
                Ok(output_ok)
            })())
        },
    )
}
fn wire__crate__api__simple__init_app_impl(
    port_: flutter_rust_bridge::for_generated::MessagePort,
    ptr_: flutter_rust_bridge::for_generated::PlatformGeneralizedUint8ListPtr,
    rust_vec_len_: i32,
    data_len_: i32,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap_normal::<flutter_rust_bridge::for_generated::SseCodec, _, _>(
        flutter_rust_bridge::for_generated::TaskInfo {
            debug_name: "init_app",
            port: Some(port_),
            mode: flutter_rust_bridge::for_generated::FfiCallMode::Normal,
        },
        move || {
            let message = unsafe {
                flutter_rust_bridge::for_generated::Dart2RustMessageSse::from_wire(
                    ptr_,
                    rust_vec_len_,
                    data_len_,
                )
            };
            let mut deserializer =
                flutter_rust_bridge::for_generated::SseDeserializer::new(message);
            deserializer.end();
            move |context| {
                transform_result_sse::<_, ()>((move || {
                    let output_ok = Result::<_, ()>::Ok({
                        crate::api::simple::init_app();
                    })?;
                    Ok(output_ok)
                })())
            }
        },
    )
}

// Section: dart2rust

impl SseDecode for flutter_rust_bridge::for_generated::anyhow::Error {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut inner = <String>::sse_decode(deserializer);
        return flutter_rust_bridge::for_generated::anyhow::anyhow!("{}", inner);
    }
}

impl SseDecode
    for StreamSink<crate::api::llfs::FsEntity, flutter_rust_bridge::for_generated::SseCodec>
{
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut inner = <String>::sse_decode(deserializer);
        return StreamSink::deserialize(inner);
    }
}

impl SseDecode for String {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut inner = <Vec<u8>>::sse_decode(deserializer);
        return String::from_utf8(inner).unwrap();
    }
}

impl SseDecode for bool {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        deserializer.cursor.read_u8().unwrap() != 0
    }
}

impl SseDecode for crate::api::sandbar::CbKeyPair {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut var_publicKeyBytesB64 = <String>::sse_decode(deserializer);
        let mut var_privateKeyBytesB64 = <String>::sse_decode(deserializer);
        return crate::api::sandbar::CbKeyPair {
            public_key_bytes_b64: var_publicKeyBytesB64,
            private_key_bytes_b64: var_privateKeyBytesB64,
        };
    }
}

impl SseDecode for crate::api::lldisk::DiskPartition {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut var_name = <String>::sse_decode(deserializer);
        let mut var_mountPoint = <String>::sse_decode(deserializer);
        return crate::api::lldisk::DiskPartition {
            name: var_name,
            mount_point: var_mountPoint,
        };
    }
}

impl SseDecode for crate::api::llfs::FsEntity {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut var_name = <String>::sse_decode(deserializer);
        let mut var_isDir = <bool>::sse_decode(deserializer);
        let mut var_dateCreated = <String>::sse_decode(deserializer);
        return crate::api::llfs::FsEntity {
            name: var_name,
            is_dir: var_isDir,
            date_created: var_dateCreated,
        };
    }
}

impl SseDecode for Vec<crate::api::lldisk::DiskPartition> {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut len_ = <i32>::sse_decode(deserializer);
        let mut ans_ = vec![];
        for idx_ in 0..len_ {
            ans_.push(<crate::api::lldisk::DiskPartition>::sse_decode(
                deserializer,
            ));
        }
        return ans_;
    }
}

impl SseDecode for Vec<u8> {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut len_ = <i32>::sse_decode(deserializer);
        let mut ans_ = vec![];
        for idx_ in 0..len_ {
            ans_.push(<u8>::sse_decode(deserializer));
        }
        return ans_;
    }
}

impl SseDecode for Option<usize> {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        if (<bool>::sse_decode(deserializer)) {
            return Some(<usize>::sse_decode(deserializer));
        } else {
            return None;
        }
    }
}

impl SseDecode for crate::api::sandbar::SandbarAuth {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut var_masterKeyBytesB64 = <String>::sse_decode(deserializer);
        let mut var_masterKeyEncryptedBytesB64 = <String>::sse_decode(deserializer);
        let mut var_publicKeyBytesB64 = <String>::sse_decode(deserializer);
        let mut var_privateKeyBytesB64 = <String>::sse_decode(deserializer);
        let mut var_privateKeyEncryptedBytesB64 = <String>::sse_decode(deserializer);
        return crate::api::sandbar::SandbarAuth {
            master_key_bytes_b64: var_masterKeyBytesB64,
            master_key_encrypted_bytes_b64: var_masterKeyEncryptedBytesB64,
            public_key_bytes_b64: var_publicKeyBytesB64,
            private_key_bytes_b64: var_privateKeyBytesB64,
            private_key_encrypted_bytes_b64: var_privateKeyEncryptedBytesB64,
        };
    }
}

impl SseDecode for u8 {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        deserializer.cursor.read_u8().unwrap()
    }
}

impl SseDecode for () {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {}
}

impl SseDecode for usize {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        deserializer.cursor.read_u64::<NativeEndian>().unwrap() as _
    }
}

impl SseDecode for i32 {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        deserializer.cursor.read_i32::<NativeEndian>().unwrap()
    }
}

fn pde_ffi_dispatcher_primary_impl(
    func_id: i32,
    port: flutter_rust_bridge::for_generated::MessagePort,
    ptr: flutter_rust_bridge::for_generated::PlatformGeneralizedUint8ListPtr,
    rust_vec_len: i32,
    data_len: i32,
) {
    // Codec=Pde (Serialization + dispatch), see doc to use other codecs
    match func_id {
        2 => wire__crate__api__llfs__get_fs_entities_impl(port, ptr, rust_vec_len, data_len),
        3 => wire__crate__api__sandbar__aes_decrypt_impl(port, ptr, rust_vec_len, data_len),
        4 => wire__crate__api__sandbar__aes_encrypt_impl(port, ptr, rust_vec_len, data_len),
        5 => wire__crate__api__sandbar__argon2_pwd_hash_impl(port, ptr, rust_vec_len, data_len),
        6 => wire__crate__api__sandbar__cb_decrypt_impl(port, ptr, rust_vec_len, data_len),
        7 => wire__crate__api__sandbar__cb_encrypt_impl(port, ptr, rust_vec_len, data_len),
        8 => wire__crate__api__sandbar__generate_aes_key_impl(port, ptr, rust_vec_len, data_len),
        9 => wire__crate__api__sandbar__generate_auth_impl(port, ptr, rust_vec_len, data_len),
        10 => {
            wire__crate__api__sandbar__generate_cb_key_pair_impl(port, ptr, rust_vec_len, data_len)
        }
        12 => wire__crate__api__simple__init_app_impl(port, ptr, rust_vec_len, data_len),
        _ => unreachable!(),
    }
}

fn pde_ffi_dispatcher_sync_impl(
    func_id: i32,
    ptr: flutter_rust_bridge::for_generated::PlatformGeneralizedUint8ListPtr,
    rust_vec_len: i32,
    data_len: i32,
) -> flutter_rust_bridge::for_generated::WireSyncRust2DartSse {
    // Codec=Pde (Serialization + dispatch), see doc to use other codecs
    match func_id {
        1 => wire__crate__api__lldisk__get_disk_partitions_impl(ptr, rust_vec_len, data_len),
        11 => wire__crate__api__simple__greet_impl(ptr, rust_vec_len, data_len),
        _ => unreachable!(),
    }
}

// Section: rust2dart

// Codec=Dco (DartCObject based), see doc to use other codecs
impl flutter_rust_bridge::IntoDart for crate::api::sandbar::CbKeyPair {
    fn into_dart(self) -> flutter_rust_bridge::for_generated::DartAbi {
        [
            self.public_key_bytes_b64.into_into_dart().into_dart(),
            self.private_key_bytes_b64.into_into_dart().into_dart(),
        ]
        .into_dart()
    }
}
impl flutter_rust_bridge::for_generated::IntoDartExceptPrimitive
    for crate::api::sandbar::CbKeyPair
{
}
impl flutter_rust_bridge::IntoIntoDart<crate::api::sandbar::CbKeyPair>
    for crate::api::sandbar::CbKeyPair
{
    fn into_into_dart(self) -> crate::api::sandbar::CbKeyPair {
        self
    }
}
// Codec=Dco (DartCObject based), see doc to use other codecs
impl flutter_rust_bridge::IntoDart for crate::api::lldisk::DiskPartition {
    fn into_dart(self) -> flutter_rust_bridge::for_generated::DartAbi {
        [
            self.name.into_into_dart().into_dart(),
            self.mount_point.into_into_dart().into_dart(),
        ]
        .into_dart()
    }
}
impl flutter_rust_bridge::for_generated::IntoDartExceptPrimitive
    for crate::api::lldisk::DiskPartition
{
}
impl flutter_rust_bridge::IntoIntoDart<crate::api::lldisk::DiskPartition>
    for crate::api::lldisk::DiskPartition
{
    fn into_into_dart(self) -> crate::api::lldisk::DiskPartition {
        self
    }
}
// Codec=Dco (DartCObject based), see doc to use other codecs
impl flutter_rust_bridge::IntoDart for crate::api::llfs::FsEntity {
    fn into_dart(self) -> flutter_rust_bridge::for_generated::DartAbi {
        [
            self.name.into_into_dart().into_dart(),
            self.is_dir.into_into_dart().into_dart(),
            self.date_created.into_into_dart().into_dart(),
        ]
        .into_dart()
    }
}
impl flutter_rust_bridge::for_generated::IntoDartExceptPrimitive for crate::api::llfs::FsEntity {}
impl flutter_rust_bridge::IntoIntoDart<crate::api::llfs::FsEntity> for crate::api::llfs::FsEntity {
    fn into_into_dart(self) -> crate::api::llfs::FsEntity {
        self
    }
}
// Codec=Dco (DartCObject based), see doc to use other codecs
impl flutter_rust_bridge::IntoDart for crate::api::sandbar::SandbarAuth {
    fn into_dart(self) -> flutter_rust_bridge::for_generated::DartAbi {
        [
            self.master_key_bytes_b64.into_into_dart().into_dart(),
            self.master_key_encrypted_bytes_b64
                .into_into_dart()
                .into_dart(),
            self.public_key_bytes_b64.into_into_dart().into_dart(),
            self.private_key_bytes_b64.into_into_dart().into_dart(),
            self.private_key_encrypted_bytes_b64
                .into_into_dart()
                .into_dart(),
        ]
        .into_dart()
    }
}
impl flutter_rust_bridge::for_generated::IntoDartExceptPrimitive
    for crate::api::sandbar::SandbarAuth
{
}
impl flutter_rust_bridge::IntoIntoDart<crate::api::sandbar::SandbarAuth>
    for crate::api::sandbar::SandbarAuth
{
    fn into_into_dart(self) -> crate::api::sandbar::SandbarAuth {
        self
    }
}

impl SseEncode for flutter_rust_bridge::for_generated::anyhow::Error {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <String>::sse_encode(format!("{:?}", self), serializer);
    }
}

impl SseEncode
    for StreamSink<crate::api::llfs::FsEntity, flutter_rust_bridge::for_generated::SseCodec>
{
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        unimplemented!("")
    }
}

impl SseEncode for String {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <Vec<u8>>::sse_encode(self.into_bytes(), serializer);
    }
}

impl SseEncode for bool {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        serializer.cursor.write_u8(self as _).unwrap();
    }
}

impl SseEncode for crate::api::sandbar::CbKeyPair {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <String>::sse_encode(self.public_key_bytes_b64, serializer);
        <String>::sse_encode(self.private_key_bytes_b64, serializer);
    }
}

impl SseEncode for crate::api::lldisk::DiskPartition {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <String>::sse_encode(self.name, serializer);
        <String>::sse_encode(self.mount_point, serializer);
    }
}

impl SseEncode for crate::api::llfs::FsEntity {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <String>::sse_encode(self.name, serializer);
        <bool>::sse_encode(self.is_dir, serializer);
        <String>::sse_encode(self.date_created, serializer);
    }
}

impl SseEncode for Vec<crate::api::lldisk::DiskPartition> {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <i32>::sse_encode(self.len() as _, serializer);
        for item in self {
            <crate::api::lldisk::DiskPartition>::sse_encode(item, serializer);
        }
    }
}

impl SseEncode for Vec<u8> {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <i32>::sse_encode(self.len() as _, serializer);
        for item in self {
            <u8>::sse_encode(item, serializer);
        }
    }
}

impl SseEncode for Option<usize> {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <bool>::sse_encode(self.is_some(), serializer);
        if let Some(value) = self {
            <usize>::sse_encode(value, serializer);
        }
    }
}

impl SseEncode for crate::api::sandbar::SandbarAuth {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <String>::sse_encode(self.master_key_bytes_b64, serializer);
        <String>::sse_encode(self.master_key_encrypted_bytes_b64, serializer);
        <String>::sse_encode(self.public_key_bytes_b64, serializer);
        <String>::sse_encode(self.private_key_bytes_b64, serializer);
        <String>::sse_encode(self.private_key_encrypted_bytes_b64, serializer);
    }
}

impl SseEncode for u8 {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        serializer.cursor.write_u8(self).unwrap();
    }
}

impl SseEncode for () {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {}
}

impl SseEncode for usize {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        serializer
            .cursor
            .write_u64::<NativeEndian>(self as _)
            .unwrap();
    }
}

impl SseEncode for i32 {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        serializer.cursor.write_i32::<NativeEndian>(self).unwrap();
    }
}

#[cfg(not(target_family = "wasm"))]
mod io {
    // This file is automatically generated, so please do not edit it.
    // @generated by `flutter_rust_bridge`@ 2.5.1.

    // Section: imports

    use super::*;
    use flutter_rust_bridge::for_generated::byteorder::{
        NativeEndian, ReadBytesExt, WriteBytesExt,
    };
    use flutter_rust_bridge::for_generated::{transform_result_dco, Lifetimeable, Lockable};
    use flutter_rust_bridge::{Handler, IntoIntoDart};

    // Section: boilerplate

    flutter_rust_bridge::frb_generated_boilerplate_io!();
}
#[cfg(not(target_family = "wasm"))]
pub use io::*;

/// cbindgen:ignore
#[cfg(target_family = "wasm")]
mod web {
    // This file is automatically generated, so please do not edit it.
    // @generated by `flutter_rust_bridge`@ 2.5.1.

    // Section: imports

    use super::*;
    use flutter_rust_bridge::for_generated::byteorder::{
        NativeEndian, ReadBytesExt, WriteBytesExt,
    };
    use flutter_rust_bridge::for_generated::wasm_bindgen;
    use flutter_rust_bridge::for_generated::wasm_bindgen::prelude::*;
    use flutter_rust_bridge::for_generated::{transform_result_dco, Lifetimeable, Lockable};
    use flutter_rust_bridge::{Handler, IntoIntoDart};

    // Section: boilerplate

    flutter_rust_bridge::frb_generated_boilerplate_web!();
}
#[cfg(target_family = "wasm")]
pub use web::*;
