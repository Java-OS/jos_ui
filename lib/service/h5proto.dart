import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:basic_utils/basic_utils.dart';
import 'package:cryptography/cryptography.dart' as cryptography;
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:jos_ui/message_buffer.dart';
import 'package:jos_ui/service/storage_service.dart';
import 'package:jos_ui/util/protobuf_utils.dart';
import 'package:pointycastle/export.dart';

class H5Proto {
  late final AsymmetricKeyPair _keyPair;
  late final ECDomainParameters _domainParameters;

  H5Proto.init() {
    developer.log('H5proto initialize ...');
    _domainParameters = ECDomainParameters(ECCurve_prime256v1().domainName);
    var ecParams = ECKeyGeneratorParameters(_domainParameters);
    var params = ParametersWithRandom<ECKeyGeneratorParameters>(ecParams, getSecureRandom());

    var keyGenerator = ECKeyGenerator();
    keyGenerator.init(params);
    _keyPair = keyGenerator.generateKeyPair();
  }

  ECPublicKey _getPublicKey() {
    return _keyPair.publicKey as ECPublicKey;
  }

  ECPrivateKey _getPrivateKey() {
    return CryptoUtils.ecPrivateKeyFromPem(StorageService.getItem('private-key')!);
  }

  String exportPublicKey() {
    developer.log('H5proto export public key');
    var pem = CryptoUtils.encodeEcPublicKeyToPem(_getPublicKey());
    return pem.replaceAll('-----BEGIN PUBLIC KEY-----', '').replaceAll('-----END PUBLIC KEY-----', '').replaceAll('\n', '');
  }

  void storePrivateKey() {
    developer.log('H5proto export private key');
    var privateKey = CryptoUtils.encodeEcPrivateKeyToPem(_keyPair.privateKey as ECPrivateKey);
    StorageService.addItem('private-key', privateKey);
  }

  ECPublicKey bytesToPublicKey(Uint8List bytes) {
    return CryptoUtils.ecPublicKeyFromDerBytes(bytes);
  }

  void makeSharedSecret(ECPublicKey remotePublicKey) {
    var agreement = ECDHBasicAgreement();
    agreement.init(_getPrivateKey());
    var value = agreement.calculateAgreement(remotePublicKey);
    var bytes = CryptoUtils.i2osp(value);
    var b64 = base64.encode(bytes);
    developer.log('H5proto generate shared secret : $b64');
    StorageService.addItem('shared-secret', b64);
  }

  static Uint8List generatePadding() {
    var random = Random.secure();
    return Uint8List.fromList(List.generate(10, (index) => random.nextInt(256)));
  }

  static bigIntToUint8List(BigInt bigInt) {
    int byteCount = (bigInt.bitLength + 7) ~/ 8;
    Uint8List bytes = Uint8List(byteCount);
    for (int i = byteCount - 1; i >= 0; i--) {
      bytes[i] = bigInt.toUnsigned(8).toInt();
      bigInt = bigInt >> 8;
    }
    return bytes;
  }

  static Uint8List getKey() {
    var sharedSecret = StorageService.getItem('shared-secret')!;
    var salt = StorageService.getItem('activation-key');
    if (salt != null) {
      const iterationCount = 1000;

      final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64));
      final params = Pbkdf2Parameters(utf8.encode(salt), iterationCount, 32);
      pbkdf2.init(params);
      return pbkdf2.process(Uint8List.fromList(utf8.encode(sharedSecret)));
    } else {
      return base64Decode(sharedSecret);
    }
  }

  static Uint8List sha256(Uint8List data) {
    var sha256digest = SHA256Digest();
    return sha256digest.process(data);
  }

  static String sha256Hex(Uint8List data) {
    return CryptoUtils.getHash(data);
  }

  static bool checkSha256(Uint8List data, Uint8List hash) {
    var sha256digest = SHA256Digest();
    var newHash = sha256digest.process(data);
    return newHash.toString() == hash.toString();
  }

  SecureRandom getSecureRandom() {
    var secureRandom = FortunaRandom();
    var random = Random.secure();
    List<int> seeds = [];
    for (int i = 0; i < 32; i++) {
      seeds.add(random.nextInt(255));
    }
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));
    return secureRandom;
  }

  void storeSharedSecret(Uint8List sharedSecret) {
    StorageService.addItem('shared-secret', base64Encode(sharedSecret));
  }

  void storeActivationKey(String activationKey) {
    StorageService.addItem('activation-key', base64Encode(utf8.encode(activationKey)));
  }

  void invalidateCredentials() {
    // removeDeviceId();
    developer.log('Invalidate credentials');
    removeSharedSecret();
    removeActivationKey();
  }

  void removeSharedSecret() {
    StorageService.removeItem('shared-secret');
  }

  void removePrivateKey() {
    StorageService.removeItem('private-key');
  }

  void removeActivationKey() {
    StorageService.removeItem('activation-key');
  }

  static Int64 randomNumber() {
    Random random = Random();
    return Int64(1000000 + random.nextInt(pow(2, 32).toInt()));
  }

  static String? getSharedSecret() {
    var sharedSecret = StorageService.getItem('shared-secret');
    if (sharedSecret == null || sharedSecret.isEmpty) return null;
    return sharedSecret;
  }

  static String? getActivationKey() {
    var activationKey = StorageService.getItem('activation-key');
    if (activationKey == null || activationKey.isEmpty) return null;
    return utf8.decode(base64Decode(activationKey));
  }

  /* Encrypt message */
  Future<Uint8List> encode(Uint8List payload) async {
    var hash = sha256(payload);
    var key = getKey();

    var secretBox = await _encrypt(payload, key);
    var iv = secretBox.nonce;
    var data = secretBox.concatenation(nonce: false, mac: true);
    developer.log('Request hash: ${base64Encode(hash)}');
    return ProtobufUtils.serializePacket(Uint8List.fromList(iv), hash, data);
  }

  Future<cryptography.SecretBox> _encrypt(Uint8List bytes, Uint8List key) async {
    final algorithm = cryptography.AesGcm.with256bits();
    var iv = algorithm.newNonce();
    final secretKey = await algorithm.newSecretKeyFromBytes(key);
    final secretBox = await algorithm.encrypt(
      bytes,
      secretKey: secretKey,
      nonce: iv,
    );
    return secretBox;
  }

  /* Decrypt server message */
  Future<Payload> decrypt(Uint8List bytes, Uint8List iv) async {
    developer.log('Payload encrypted size: ${bytes.length}, iv size: ${iv.length}');
    var key = getKey();
    final algorithm = cryptography.AesGcm.with256bits();
    final secretKey = await algorithm.newSecretKeyFromBytes(key);
    var mac = bytes.sublist(bytes.length - 16);
    bytes = bytes.sublist(0, bytes.length - 16);
    var secretBox = cryptography.SecretBox(bytes, nonce: iv, mac: cryptography.Mac(mac));
    var result = await algorithm.decrypt(secretBox, secretKey: secretKey);
    developer.log('Payload decrypted size: ${result.length}');
    return Payload(result);
  }
}
