import 'package:jos_ui/protobuf/message-buffer.pb.dart';

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
  if (str.length < 12) return str;

  // truncate str
  return '${str.substring(0, 16)} ... ${str.substring(str.length - 16)}';
}


class ProtobufBitwiseUtils {
  static List<int> getBitNumbers(int number) {
    var bitNumbers = <int>[];
    int count = 1;
    while (number != 0) {
      if (number & 1 == 1) bitNumbers.add(count);
      number >>= 1;
      count <<= 1;
    }
    return bitNumbers;
  }

  static List<Realm> getRealms(int number) {
    var realms = <Realm>[];
    var bitNumbers = getBitNumbers(number);
    for (var bn in bitNumbers) {
      var role = Realm.valueOf(bn);
      if (role != null) {
        realms.add(role);
      }
    }

    return realms;
  }
}
