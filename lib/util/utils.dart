String formatSize(int size) {
  if (size < 0) throw ArgumentError('Size cannot be negative.');

  const int KB = 1024;
  const int MB = KB * 1024;
  const int GB = MB * 1024;
  const int TB = GB * 1024;
  const int PB = TB * 1024;
  const int EB = PB * 1024;

  if (size < KB) {
    return '$size B';
  } else if (size < MB) {
    return '${(size / KB).toStringAsFixed(2)} KB';
  } else if (size < GB) {
    return '${(size / MB).toStringAsFixed(2)} MB';
  } else if (size < TB) {
    return '${(size / GB).toStringAsFixed(2)} GB';
  } else if (size < PB) {
    return '${(size / TB).toStringAsFixed(2)} TB';
  } else if (size < EB) {
    return '${(size / PB).toStringAsFixed(2)} PB';
  } else {
    return '${(size / EB).toStringAsFixed(2)} EB';
  }
}

String truncateWithEllipsis(int length, String myString) {
  return (myString.length <= length) ? myString : '${myString.substring(0, length)}...';
}

String truncate(String str) {
  // return dummy str
  if (str.isEmpty) return str;
  if (str.length <= 16) return str;

  // truncate str
  return '${str.substring(0, 16)} ... ${str.substring(str.length - 16)}';
}
