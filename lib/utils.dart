import 'package:jos_ui/model/protocol/realm.dart';

String formatSize(int size) {
  if (size < 0) throw ArgumentError('Size cannot be negative.');

  const kb = 1024;
  const mb = kb * 1024;
  const gb = mb * 1024;
  const tb = gb * 1024;
  const pb = tb * 1024;
  const eb = pb * 1024;

  if (size < kb) {
    return '$size B';
  } else if (size < mb) {
    return '${(size / kb).toStringAsFixed(2)} KB';
  } else if (size < gb) {
    return '${(size / mb).toStringAsFixed(2)} MB';
  } else if (size < tb) {
    return '${(size / gb).toStringAsFixed(2)} GB';
  } else if (size < pb) {
    return '${(size / tb).toStringAsFixed(2)} TB';
  } else if (size < eb) {
    return '${(size / pb).toStringAsFixed(2)} PB';
  } else {
    return '${(size / eb).toStringAsFixed(2)} EB';
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
      var role = Realm.fromValue(bn);
      realms.add(role);
    }

    return realms;
  }
}