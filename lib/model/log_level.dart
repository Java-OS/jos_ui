enum LogLevel {
  info,
  warn,
  debug,
  error,
  trace,
  all;

  static LogLevel getValue(String str) {
    return LogLevel.values.singleWhere((element) => element.name.toUpperCase() == str.toUpperCase());
  }
}
