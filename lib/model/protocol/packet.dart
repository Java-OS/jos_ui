import 'dart:convert';

class Packet {
  final String? iv;

  final String? hash;

  final String cipher;

  Packet(this.iv, this.hash, this.cipher);

  factory Packet.fromBase64(String b64Hash) {
    var map = json.decode(utf8.decode(base64.decode(b64Hash)));
    var iv = map['iv'];
    var hash = map['hash'];
    var cipher = map['cipher'];

    return Packet(iv, hash, cipher);
  }

  String toJson() {
    var map = {
      'iv': iv,
      'hash': hash,
      'cipher': cipher,
    };
    return json.encode(map);
  }
}
