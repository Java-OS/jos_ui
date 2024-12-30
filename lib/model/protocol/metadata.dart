class Metadata {
  final bool? success;
  final int? rpc;
  final int? error;
  final bool? needRestart;
  final String? message;

  const Metadata(this.success, this.rpc, this.error, this.needRestart, this.message);

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'rpc': rpc,
      'error': error,
      'needRestart': needRestart,
      'message': message,
    };
  }

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      json['success'] as bool?,
      json['rpc'] as int?,
      json['error'] as int?,
      json['needRestart'] as bool?,
      json['message'] as String?,
    );
  }
}
