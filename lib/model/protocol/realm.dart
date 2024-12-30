enum Realm {
  realmNone(0),
  realmSystem(1),
  realmJvm(2),
  realmNtpClient(4),
  realmDateTime(8),
  realmConfiguration(16),
  realmEnvironment(32),
  realmModule(64),
  realmNetwork(128),
  realmUser(256),
  realmLog(512),
  realmFilesystem(1024),
  realmSsl(2048),
  realmContainerEngine(4096),
  realmKernel(8192);

  final int bit;

  const Realm(this.bit);

  static Realm fromValue(int bit) {
    return Realm.values
        .firstWhere((realm) => realm.bit == bit, orElse: () => throw ArgumentError('Invalid bit value: $bit'),
    );
  }
}
