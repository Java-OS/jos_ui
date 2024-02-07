class LogInfo {
  final int id;
  final String packageName;
  final String pattern;
  final String type;
  final String level;
  final String? syslogHost;
  final int? syslogPort;
  final String? syslogFacility;
  final String? fileArchivePattern;
  final int? fileMaxSize;
  final int? fileTotalSize;
  final int? fileMaxHistory;

  LogInfo({required this.id, required this.packageName, required this.pattern, required this.type, required this.level, required this.syslogHost, required this.syslogPort, required this.syslogFacility, required this.fileArchivePattern, required this.fileMaxSize, required this.fileTotalSize, required this.fileMaxHistory});

  factory LogInfo.fromJson(Map<String, dynamic> json) {
    return LogInfo(
      id: json['id'],
      packageName: json['packageName'],
      pattern: json['pattern'],
      type: json['type'],
      level: json['level'],
      syslogHost: json['syslogHost'],
      syslogPort: json['syslogPort'],
      syslogFacility: json['syslogFacility'],
      fileArchivePattern: json['fileArchivePattern'],
      fileMaxSize: json['fileMaxSize'],
      fileTotalSize: json['fileTotalSize'],
      fileMaxHistory: json['fileMaxHistory'],
    );
  }
}
