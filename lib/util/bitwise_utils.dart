import 'package:jos_ui/message_buffer.dart';

class BitwiseUtils {
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
