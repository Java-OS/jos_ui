enum EventCode {
  jvmLogs('JVM_LOGS'),
  ociContainerNotification('OCI_CONTAINER_NOTIFICATION'),
  ociImageNotification('OCI_IMAGE_NOTIFICATION'),
  ociContainerLogs('OCI_CONTAINER_LOGS');

  final String value ;
  const EventCode(this.value);

  static EventCode getValue(String str) {
    return EventCode.values.singleWhere((element) => element.value.toUpperCase() == str.toUpperCase());
  }
}