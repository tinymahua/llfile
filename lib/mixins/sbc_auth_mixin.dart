import 'dart:convert';

import 'package:llfile/models/app_config_model.dart';
import 'package:llfile/models/sbc_auth_model.dart';
import 'package:llfile/src/rust/api/sandbar.dart';

mixin SbcAuthMixin {
  Future<SandbarAuthInfo> decryptSbcAuth(SbcRegisterResponse resp, String password)async{
    var passwdAesKey = await argon2PwdHash(password: utf8.encode(password));
    print("pak: ${passwdAesKey.length}");
    var masterKey = await aesDecrypt(palAesKeyBytes: passwdAesKey, encryptedBytes: base64Url.decode(resp.masterKeyEncrypted!));
    var privateKey = await aesDecrypt(palAesKeyBytes: masterKey, encryptedBytes: base64Url.decode(resp.privateKeyEncrypted!));
    var fernetKey = await cbDecrypt(
        peerPalCryptoPublicKeyBytes: base64Url.decode(resp.serverPublicKey!),
        myPalCryptoSecretKeyBytes: privateKey,
        encryptedBytes: base64Url.decode(resp.fernetKeyEncrypted!),
    );
    var accessToken = await aesDecrypt(
        palAesKeyBytes: fernetKey,
        encryptedBytes: base64Url.decode(resp.accessTokenEncrypted!));
    return SandbarAuthInfo(
        resp.email!,
        utf8.decode(accessToken),
        base64Url.encode(passwdAesKey),
        resp.serverPublicKey!,
        resp.publicKey!,
        base64Url.encode(privateKey),
    );
  }
}