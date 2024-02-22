//
//  Generated code. Do not modify.
//  source: message-buffer.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use packetDescriptor instead')
const Packet$json = {
  '1': 'Packet',
  '2': [
    {'1': 'iv', '3': 1, '4': 1, '5': 12, '10': 'iv'},
    {'1': 'hash', '3': 2, '4': 1, '5': 12, '10': 'hash'},
    {'1': 'content', '3': 3, '4': 1, '5': 12, '10': 'content'},
  ],
};

/// Descriptor for `Packet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packetDescriptor = $convert.base64Decode(
    'CgZQYWNrZXQSDgoCaXYYASABKAxSAml2EhIKBGhhc2gYAiABKAxSBGhhc2gSGAoHY29udGVudB'
    'gDIAEoDFIHY29udGVudA==');

@$core.Deprecated('Use payloadDescriptor instead')
const Payload$json = {
  '1': 'Payload',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'rpc', '3': 2, '4': 1, '5': 5, '10': 'rpc'},
    {'1': 'error', '3': 3, '4': 1, '5': 5, '10': 'error'},
    {'1': 'message', '3': 4, '4': 1, '5': 9, '10': 'message'},
    {'1': 'data', '3': 5, '4': 1, '5': 9, '10': 'data'},
    {'1': 'needRestart', '3': 6, '4': 1, '5': 8, '10': 'needRestart'},
    {'1': 'logPackage', '3': 7, '4': 1, '5': 9, '10': 'logPackage'},
    {'1': 'logLevel', '3': 8, '4': 1, '5': 9, '10': 'logLevel'},
  ],
};

/// Descriptor for `Payload`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List payloadDescriptor = $convert.base64Decode(
    'CgdQYXlsb2FkEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSEAoDcnBjGAIgASgFUgNycGMSFA'
    'oFZXJyb3IYAyABKAVSBWVycm9yEhgKB21lc3NhZ2UYBCABKAlSB21lc3NhZ2USEgoEZGF0YRgF'
    'IAEoCVIEZGF0YRIgCgtuZWVkUmVzdGFydBgGIAEoCFILbmVlZFJlc3RhcnQSHgoKbG9nUGFja2'
    'FnZRgHIAEoCVIKbG9nUGFja2FnZRIaCghsb2dMZXZlbBgIIAEoCVIIbG9nTGV2ZWw=');

