enum EventCode {
  jvmLogs('JVM_LOGS'),
  containerNotification('CONTAINER_NOTIFICATION'),
  containerLogs('CONTAINER_LOGS');

  final String value ;
  const EventCode(this.value);

  static EventCode getValue(String str) {
    return EventCode.values.singleWhere((element) => element.value.toUpperCase() == str.toUpperCase());
  }
}