import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:jos_ui/message_buffer.dart';

class ProtobufUtils {
  ProtobufUtils._();

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

  static Uint8List serializePayload(Uint8List? metadata, Uint8List? content) {
    var builder = fb.Builder();

    var metadataOffset = 0;
    if (metadata != null) {
      // Deserialize the metadata and rebuild the table
      var m = Metadata(metadata);
      final messageOffset = m.message != null ? builder.writeString(m.message!) : null;
      builder.startTable(4);

      builder.addBool(0, m.success);
      builder.addInt32(1, m.rpc);
      builder.addBool(2, m.needRestart);
      if (messageOffset != null) builder.addOffset(3, messageOffset);

      metadataOffset = builder.endTable();
    }

    // Serialize the content field
    var contentOffset = content != null ? builder.writeListUint8(content) : null;

    // Start and finish the Payload table
    builder.startTable(2);
    builder.addOffset(0, metadataOffset);
    if (contentOffset != null) builder.addOffset(1, contentOffset);

    var payloadOffset = builder.endTable();
    builder.finish(payloadOffset);

    return builder.buffer;
  }

  static Uint8List serializeTransfer(String fileName, String path, int parts, int index, Uint8List bytes, int size) {
    var builder = fb.Builder();
    final fileNameOffset = builder.writeString(fileName);
    final pathOffset = builder.writeString(path);
    final bytesOffset = builder.writeListUint8(bytes);
    final sizeOffset = builder.writeString(size.toString());

    builder.startTable(6);

    builder.addOffset(0, fileNameOffset);
    builder.addOffset(1, pathOffset);
    builder.addInt32(2, parts);
    builder.addInt32(3, index);
    builder.addOffset(4, bytesOffset);
    builder.addOffset(5, sizeOffset);

    final metadataOffset = builder.endTable();
    builder.finish(metadataOffset);

    return builder.buffer;
  }
}
