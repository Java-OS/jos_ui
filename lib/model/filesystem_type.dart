enum FilesystemType {
  ext4,
  vfat,
  ntfs;

  static FilesystemType getValue(String str) {
    return FilesystemType.values.singleWhere((element) => element.name.toUpperCase() == str.toUpperCase());
  }
}
