enum UploadType {
  uploadTypeModule(0),
  uploadTypeConfig(1),
  uploadTypeSsl(2),
  uploadTypeFile(3);

  final int code;

  const UploadType(this.code);
}
