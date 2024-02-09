enum Realm {
  system(1, 'System'),
  jvm(2, 'JVM'),
  ntpClient(4, 'NTP Client'),
  dateTime(8, 'Date & Time'),
  configuration(16, 'Configuration'),
  environment(32, 'Environment'),
  host(64, 'Host'),
  module(128, 'Modules'),
  network(256, 'Network'),
  user(512, 'Users'),
  log(1024, 'Log'),
  filesystem(2048, 'Filesystem');

  final int bit;
  final String displayName;

  const Realm(this.bit, this.displayName);

  int getBit() {
    return bit;
  }

  static Realm getRealm(int bit) {
    return Realm.values.singleWhere((element) => element.getBit() == bit);
  }

  static List<Realm> getAllRealms() {
    return Realm.values;
  }

  static Set<Realm> getRealmsOfBit(int number) {
    return getBitNumbers(number).map((e) => getRealm(e)).toSet();
  }

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

  static int getRealmBit(List<Realm> realms) {
    return realms.map((e) => e.getBit()).reduce((value, element) => value + element);
  }
}
