import 'package:encrypt/encrypt.dart';

class MyEncrtypt {
  final _key = Key.fromUtf8('wf2AcI6hYCrfiwjFHOm3YtsoSzhP1P88');
  final _iv = IV.fromUtf8('a0UniNe5xhf3y6iL');

  String encrypt(String val) {
    final encrypter = Encrypter(AES(_key));

    final encrypted = encrypter.encrypt(val, iv: _iv);

    return encrypted.base64;
  }

  String decrypt(String val) {
    final encrypter = Encrypter(AES(_key));

    final decrypted = encrypter.decrypt(Encrypted.fromBase64(val), iv: _iv);

    return decrypted;
  }
}
