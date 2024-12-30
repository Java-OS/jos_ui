import 'dart:convert';
import 'dart:typed_data';

import 'package:jos_ui/model/protocol/metadata.dart';

class Payload {
  final Metadata metadata;

  final String? content;

  Payload(this.metadata, this.content);

  Map<String, dynamic> toJson() {
    return {
      'metadata': metadata.toJson(),
      'content': content,
    };
  }

  Uint8List toUint8List() {
    return Uint8List.fromList(utf8.encode(jsonEncode(toJson())));
  }

  factory Payload.fromJson(Map<String, dynamic> json) {
    return Payload(
      Metadata.fromJson(json['metadata']),
      json['content'],
    );
  }

  bool isSuccess() {
    return metadata.success ?? false;
  }
}
