//
//  Generated code. Do not modify.
//  source: message-buffer.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Packet extends $pb.GeneratedMessage {
  factory Packet({
    $core.List<$core.int>? iv,
    $core.List<$core.int>? hash,
    $core.List<$core.int>? content,
  }) {
    final $result = create();
    if (iv != null) {
      $result.iv = iv;
    }
    if (hash != null) {
      $result.hash = hash;
    }
    if (content != null) {
      $result.content = content;
    }
    return $result;
  }
  Packet._() : super();
  factory Packet.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Packet.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Packet', package: const $pb.PackageName(_omitMessageNames ? '' : 'jos'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'iv', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'hash', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'content', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Packet clone() => Packet()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Packet copyWith(void Function(Packet) updates) => super.copyWith((message) => updates(message as Packet)) as Packet;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Packet create() => Packet._();
  Packet createEmptyInstance() => create();
  static $pb.PbList<Packet> createRepeated() => $pb.PbList<Packet>();
  @$core.pragma('dart2js:noInline')
  static Packet getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Packet>(create);
  static Packet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get iv => $_getN(0);
  @$pb.TagNumber(1)
  set iv($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIv() => $_has(0);
  @$pb.TagNumber(1)
  void clearIv() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get hash => $_getN(1);
  @$pb.TagNumber(2)
  set hash($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasHash() => $_has(1);
  @$pb.TagNumber(2)
  void clearHash() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get content => $_getN(2);
  @$pb.TagNumber(3)
  set content($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasContent() => $_has(2);
  @$pb.TagNumber(3)
  void clearContent() => clearField(3);
}

class Payload extends $pb.GeneratedMessage {
  factory Payload({
    Metadata? metadata,
    $core.String? postJson,
  }) {
    final $result = create();
    if (metadata != null) {
      $result.metadata = metadata;
    }
    if (postJson != null) {
      $result.postJson = postJson;
    }
    return $result;
  }
  Payload._() : super();
  factory Payload.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Payload.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Payload', package: const $pb.PackageName(_omitMessageNames ? '' : 'jos'), createEmptyInstance: create)
    ..aOM<Metadata>(1, _omitFieldNames ? '' : 'metadata', subBuilder: Metadata.create)
    ..aOS(2, _omitFieldNames ? '' : 'postJson')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Payload clone() => Payload()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Payload copyWith(void Function(Payload) updates) => super.copyWith((message) => updates(message as Payload)) as Payload;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Payload create() => Payload._();
  Payload createEmptyInstance() => create();
  static $pb.PbList<Payload> createRepeated() => $pb.PbList<Payload>();
  @$core.pragma('dart2js:noInline')
  static Payload getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Payload>(create);
  static Payload? _defaultInstance;

  @$pb.TagNumber(1)
  Metadata get metadata => $_getN(0);
  @$pb.TagNumber(1)
  set metadata(Metadata v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasMetadata() => $_has(0);
  @$pb.TagNumber(1)
  void clearMetadata() => clearField(1);
  @$pb.TagNumber(1)
  Metadata ensureMetadata() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get postJson => $_getSZ(1);
  @$pb.TagNumber(2)
  set postJson($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPostJson() => $_has(1);
  @$pb.TagNumber(2)
  void clearPostJson() => clearField(2);
}

class Metadata extends $pb.GeneratedMessage {
  factory Metadata({
    $core.bool? success,
    $core.int? rpc,
    $core.int? error,
    $core.bool? needRestart,
    $core.String? logPackage,
    $core.String? logLevel,
  }) {
    final $result = create();
    if (success != null) {
      $result.success = success;
    }
    if (rpc != null) {
      $result.rpc = rpc;
    }
    if (error != null) {
      $result.error = error;
    }
    if (needRestart != null) {
      $result.needRestart = needRestart;
    }
    if (logPackage != null) {
      $result.logPackage = logPackage;
    }
    if (logLevel != null) {
      $result.logLevel = logLevel;
    }
    return $result;
  }
  Metadata._() : super();
  factory Metadata.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Metadata.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Metadata', package: const $pb.PackageName(_omitMessageNames ? '' : 'jos'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'rpc', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'error', $pb.PbFieldType.O3)
    ..aOB(4, _omitFieldNames ? '' : 'needRestart')
    ..aOS(5, _omitFieldNames ? '' : 'logPackage')
    ..aOS(6, _omitFieldNames ? '' : 'logLevel')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Metadata clone() => Metadata()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Metadata copyWith(void Function(Metadata) updates) => super.copyWith((message) => updates(message as Metadata)) as Metadata;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Metadata create() => Metadata._();
  Metadata createEmptyInstance() => create();
  static $pb.PbList<Metadata> createRepeated() => $pb.PbList<Metadata>();
  @$core.pragma('dart2js:noInline')
  static Metadata getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Metadata>(create);
  static Metadata? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get rpc => $_getIZ(1);
  @$pb.TagNumber(2)
  set rpc($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRpc() => $_has(1);
  @$pb.TagNumber(2)
  void clearRpc() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get error => $_getIZ(2);
  @$pb.TagNumber(3)
  set error($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasError() => $_has(2);
  @$pb.TagNumber(3)
  void clearError() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get needRestart => $_getBF(3);
  @$pb.TagNumber(4)
  set needRestart($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasNeedRestart() => $_has(3);
  @$pb.TagNumber(4)
  void clearNeedRestart() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get logPackage => $_getSZ(4);
  @$pb.TagNumber(5)
  set logPackage($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasLogPackage() => $_has(4);
  @$pb.TagNumber(5)
  void clearLogPackage() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get logLevel => $_getSZ(5);
  @$pb.TagNumber(6)
  set logLevel($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasLogLevel() => $_has(5);
  @$pb.TagNumber(6)
  void clearLogLevel() => clearField(6);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
