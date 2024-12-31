import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:jos_ui/message_buffer.dart';

String formatSize(int size) {
  if (size < 0) throw ArgumentError('Size cannot be negative.');

  const int KB = 1024;
  const int MB = KB * 1024;
  const int GB = MB * 1024;
  const int TB = GB * 1024;
  const int PB = TB * 1024;
  const int EB = PB * 1024;

  if (size < KB) {
    return '$size B';
  } else if (size < MB) {
    return '${(size / KB).toStringAsFixed(2)} KB';
  } else if (size < GB) {
    return '${(size / MB).toStringAsFixed(2)} MB';
  } else if (size < TB) {
    return '${(size / GB).toStringAsFixed(2)} GB';
  } else if (size < PB) {
    return '${(size / TB).toStringAsFixed(2)} TB';
  } else if (size < EB) {
    return '${(size / PB).toStringAsFixed(2)} PB';
  } else {
    return '${(size / EB).toStringAsFixed(2)} EB';
  }
}

String truncateWithEllipsis(int length, String myString) {
  return (myString.length <= length) ? myString : '${myString.substring(0, length)}...';
}

String truncate(String str) {
  // return dummy str
  if (str.isEmpty) return str;
  if (str.length <= 16) return str;

  // truncate str
  return '${str.substring(0, 16)} ... ${str.substring(str.length - 16)}';
}

class ProtobufBitwiseUtils {
  static List<int> getBitNumbers(int number) {
    var bitNumbers = <int>[];
    int count = 1;
    while (number != 0) {
      if (number & 1 == 1) bitNumbers.add(count);
      number >>= 1;
      count <<= 1;
    }
    return bitNumbers;
  }

  static List<Realm> getRealms(int number) {
    var realms = <Realm>[];
    var bitNumbers = getBitNumbers(number);
    for (var bn in bitNumbers) {
      var role = Realm.fromValue(bn);
      realms.add(role);
    }

    return realms;
  }
}

class ProtocolUtils {
  ProtocolUtils._();

  static Uint8List serializePacket(Uint8List? iv, Uint8List? hash, Uint8List? payload) {
    var builder = fb.Builder();
    var ivOffset = iv != null ? builder.writeListUint8(iv) : null;
    var hashOffset = hash != null ? builder.writeListUint8(hash) : null;
    var payloadOffset = payload != null ? builder.writeListUint8(payload) : null;
    builder.startTable(3);
    if (ivOffset != null) builder.addOffset(0, ivOffset);
    if (hashOffset != null) builder.addOffset(1, hashOffset);
    if (payloadOffset != null) builder.addOffset(2, payloadOffset);
    var packetOffset = builder.endTable();
    builder.finish(packetOffset);
    return builder.buffer;
  }

  static Uint8List serializeMetadata(bool? success, int? rpc, int? error, bool? needRestart, String? message) {
    var builder = fb.Builder();
    final messageOffset = message != null ? builder.writeString(message) : null;
    builder.startTable(5);

    if (success != null) builder.addBool(0, success);
    if (rpc != null) builder.addInt32(1, rpc);
    if (error != null) builder.addInt32(2, error);
    if (needRestart != null) builder.addBool(3, needRestart);
    if (messageOffset != null) builder.addOffset(4, messageOffset);

    final metadataOffset = builder.endTable();
    builder.finish(metadataOffset);

    return builder.buffer;
  }

  static Uint8List serializePayload(Uint8List? metadata, String? content) {
    var builder = fb.Builder();

    var metadataOffset = 0;
    if (metadata != null) {
      // Deserialize the metadata and rebuild the table
      var m = Metadata(metadata);
      final messageOffset = m.message != null ? builder.writeString(m.message!) : null;
      builder.startTable(5);

      builder.addBool(0, m.success);
      builder.addInt32(1, m.rpc);
      builder.addInt32(2, m.error);
      builder.addBool(3, m.needRestart);
      if (messageOffset != null) builder.addOffset(4, messageOffset);

      metadataOffset = builder.endTable();
    }

    // Serialize the content field
    var contentOffset = content != null ? builder.writeString(content) : null;

    // Start and finish the Payload table
    builder.startTable(2);
    builder.addOffset(0, metadataOffset);
    if (contentOffset != null) builder.addOffset(1, contentOffset);

    var payloadOffset = builder.endTable();
    builder.finish(payloadOffset);

    return builder.buffer;
  }
}
