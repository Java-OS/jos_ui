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
    {'1': 'metadata', '3': 1, '4': 1, '5': 11, '6': '.jos.Metadata', '10': 'metadata'},
    {'1': 'post_json', '3': 2, '4': 1, '5': 9, '10': 'postJson'},
  ],
};

/// Descriptor for `Payload`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List payloadDescriptor = $convert.base64Decode(
    'CgdQYXlsb2FkEikKCG1ldGFkYXRhGAEgASgLMg0uam9zLk1ldGFkYXRhUghtZXRhZGF0YRIbCg'
    'lwb3N0X2pzb24YAiABKAlSCHBvc3RKc29u');

@$core.Deprecated('Use metadataDescriptor instead')
const Metadata$json = {
  '1': 'Metadata',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'rpc', '3': 2, '4': 1, '5': 5, '10': 'rpc'},
    {'1': 'error', '3': 3, '4': 1, '5': 5, '10': 'error'},
    {'1': 'need_restart', '3': 4, '4': 1, '5': 8, '10': 'needRestart'},
    {'1': 'log_package', '3': 5, '4': 1, '5': 9, '10': 'logPackage'},
    {'1': 'log_level', '3': 6, '4': 1, '5': 9, '10': 'logLevel'},
  ],
};

/// Descriptor for `Metadata`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List metadataDescriptor = $convert.base64Decode(
    'CghNZXRhZGF0YRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEhAKA3JwYxgCIAEoBVIDcnBjEh'
    'QKBWVycm9yGAMgASgFUgVlcnJvchIhCgxuZWVkX3Jlc3RhcnQYBCABKAhSC25lZWRSZXN0YXJ0'
    'Eh8KC2xvZ19wYWNrYWdlGAUgASgJUgpsb2dQYWNrYWdlEhsKCWxvZ19sZXZlbBgGIAEoCVIIbG'
    '9nTGV2ZWw=');

