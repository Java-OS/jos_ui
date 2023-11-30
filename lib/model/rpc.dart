enum RPC {
  /*
     * System RPC
     * */
  systemShutdown(0),
  systemReboot(1),
  systemEnvironmentList(2),
  systemEnvironmentSet(3),
  systemEnvironmentGet(4),
  systemEnvironmentUnset(5),
  systemOsType(6),
  systemTotalMemory(7),
  systemFreeMemory(8),
  systemUsedMemory(9),
  systemCpuInformation(10),
  systemCpuCoreCount(11),
  systemSetHostname(12),
  systemGetHostname(13),
  systemSetDateTime(14),
  systemSetTimezone(15),
  systemFullInformation(16),
  jvmVersion(100),
  jvmVendor(101),
  jvmTotalHeapSize(102),
  jvmMaxHeapSize(103),
  jvmUsedHeapSize(104),
  jvmGc(105),
  jvmRestart(106),

  /*
     * configuration
     * */
  configBackupCreate(200),
  configBackupRestore(201),
  configBackupDelete(202),
  configBackupList(203),
  configPrint(204),

  /*
     * date and time
     * */
  dateTimeInformation(300),
  dateTimeSyncHctosys(301),
  dateTimeSyncSystohc(302),

  /*
     * ntp
     * */
  ntpServerName(400),
  ntpSync(401),
  ntpActivate(402),

  /*
     * module rpc
     * */
  moduleList(500),
  moduleInstall(501),
  moduleRemove(502),
  moduleEnable(503),
  moduleDisable(504),
  moduleDependencies(505),
  moduleStart(506),
  moduleStop(507),
  moduleStopAll(508),
  moduleStartAll(509),
  moduleInit(510),

  /*
     * network rpc
     * */
  networkEthernetInformation(600),
  networkEthernetSetIp(601),
  networkEthernetUp(602),
  networkEthernetDown(603),
  networkEthernetFlush(604),
  networkRouteList(605),
  networkRouteAdd(606),
  networkRouteDelete(607),
  networkRouteDefaultGateway(608),
  networkDnsNameserver(609),

  /*
     * hosts
     * */
  hostsAdd(700),
  hostsDelete(701),
  hostsList(702),

  /*
     * user
     * */
  userList(700),
  userAdd(701),
  userRemove(702),
  userPasswd(703),
  userLock(704),
  userUnlock(705),
  userRoleAdd(706),
  userRoleRemove(707),
  userRealmList(707);

  final num value;

  const RPC(this.value);
}
