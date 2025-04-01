// automatically generated by the FlatBuffers compiler, do not modify
// ignore_for_file: unused_import, unused_field, unused_element, unused_local_variable

library ir.moke.jos.protocol.fbs;

import 'dart:typed_data' show Uint8List;
import 'package:flat_buffers/flat_buffers.dart' as fb;


class Rpc {
  final int value;
  const Rpc._(this.value);

  factory Rpc.fromValue(int value) {
    final result = values[value];
    if (result == null) {
        throw StateError('Invalid value $value for bit flag enum Rpc');
    }
    return result;
  }

  static Rpc? _createOrNull(int? value) => 
      value == null ? null : Rpc.fromValue(value);

  static const int minValue = 0;
  static const int maxValue = 2201;
  static bool containsValue(int value) => values.containsKey(value);

  static const Rpc RPC_SYSTEM_SHUTDOWN = Rpc._(0);
  static const Rpc RPC_SYSTEM_REBOOT = Rpc._(1);
  static const Rpc RPC_SYSTEM_ENVIRONMENT_LIST = Rpc._(2);
  static const Rpc RPC_SYSTEM_ENVIRONMENT_SET = Rpc._(3);
  static const Rpc RPC_SYSTEM_ENVIRONMENT_GET = Rpc._(4);
  static const Rpc RPC_SYSTEM_ENVIRONMENT_UNSET = Rpc._(5);
  static const Rpc RPC_SYSTEM_OS_TYPE = Rpc._(6);
  static const Rpc RPC_SYSTEM_TOTAL_MEMORY = Rpc._(7);
  static const Rpc RPC_SYSTEM_FREE_MEMORY = Rpc._(8);
  static const Rpc RPC_SYSTEM_USED_MEMORY = Rpc._(9);
  static const Rpc RPC_SYSTEM_CPU_INFORMATION = Rpc._(10);
  static const Rpc RPC_SYSTEM_CPU_CORE_COUNT = Rpc._(11);
  static const Rpc RPC_SYSTEM_SET_HOSTNAME = Rpc._(12);
  static const Rpc RPC_SYSTEM_GET_HOSTNAME = Rpc._(13);
  static const Rpc RPC_SYSTEM_SET_DATE_TIME = Rpc._(14);
  static const Rpc RPC_SYSTEM_SET_TIMEZONE = Rpc._(15);
  static const Rpc RPC_SYSTEM_FULL_INFORMATION = Rpc._(16);
  static const Rpc RPC_SYSTEM_ENVIRONMENT_UPDATE = Rpc._(17);
  static const Rpc RPC_SYSTEM_ENVIRONMENT_BATCH_SET = Rpc._(18);
  static const Rpc RPC_SYSTEM_KERNEL_PARAMETER_LIST = Rpc._(19);
  static const Rpc RPC_SYSTEM_KERNEL_PARAMETER_SET = Rpc._(20);
  static const Rpc RPC_SYSTEM_KERNEL_PARAMETER_UNSET = Rpc._(21);
  static const Rpc RPC_SYSTEM_KERNEL_PARAMETER_GET = Rpc._(22);
  static const Rpc RPC_SYSTEM_KERNEL_MODULE_LIST = Rpc._(23);
  static const Rpc RPC_SYSTEM_KERNEL_MODULE_LOAD = Rpc._(24);
  static const Rpc RPC_SYSTEM_KERNEL_MODULE_UNLOAD = Rpc._(25);
  static const Rpc RPC_SYSTEM_KERNEL_MODULE_INFO = Rpc._(26);
  static const Rpc RPC_JVM_VERSION = Rpc._(100);
  static const Rpc RPC_JVM_VENDOR = Rpc._(101);
  static const Rpc RPC_JVM_TOTAL_HEAP_SIZE = Rpc._(102);
  static const Rpc RPC_JVM_MAX_HEAP_SIZE = Rpc._(103);
  static const Rpc RPC_JVM_USED_HEAP_SIZE = Rpc._(104);
  static const Rpc RPC_JVM_GC = Rpc._(105);
  static const Rpc RPC_JVM_RESTART = Rpc._(106);
  static const Rpc RPC_CONFIG_BACKUP_CREATE = Rpc._(200);
  static const Rpc RPC_CONFIG_BACKUP_RESTORE = Rpc._(201);
  static const Rpc RPC_CONFIG_BACKUP_DELETE = Rpc._(202);
  static const Rpc RPC_CONFIG_BACKUP_LIST = Rpc._(203);
  static const Rpc RPC_CONFIG_PRINT = Rpc._(204);
  static const Rpc RPC_DATE_TIME_INFORMATION = Rpc._(300);
  static const Rpc RPC_DATE_TIME_SYNC_HCTOSYS = Rpc._(301);
  static const Rpc RPC_DATE_TIME_SYNC_SYSTOHC = Rpc._(302);
  static const Rpc RPC_NTP_SERVER_NAME = Rpc._(400);
  static const Rpc RPC_NTP_SYNC = Rpc._(401);
  static const Rpc RPC_NTP_ACTIVATE = Rpc._(402);
  static const Rpc RPC_NTP_INFORMATION = Rpc._(403);
  static const Rpc RPC_MODULE_LIST = Rpc._(500);
  static const Rpc RPC_MODULE_INSTALL = Rpc._(501);
  static const Rpc RPC_MODULE_REMOVE = Rpc._(502);
  static const Rpc RPC_MODULE_ENABLE = Rpc._(503);
  static const Rpc RPC_MODULE_DISABLE = Rpc._(504);
  static const Rpc RPC_MODULE_DEPENDENCIES = Rpc._(505);
  static const Rpc RPC_MODULE_START = Rpc._(506);
  static const Rpc RPC_MODULE_STOP = Rpc._(507);
  static const Rpc RPC_MODULE_STOP_ALL = Rpc._(508);
  static const Rpc RPC_MODULE_START_ALL = Rpc._(509);
  static const Rpc RPC_MODULE_INIT = Rpc._(510);
  static const Rpc RPC_NETWORK_ETHERNET_INFORMATION = Rpc._(600);
  static const Rpc RPC_NETWORK_ETHERNET_SET_IP = Rpc._(601);
  static const Rpc RPC_NETWORK_ETHERNET_UP = Rpc._(602);
  static const Rpc RPC_NETWORK_ETHERNET_DOWN = Rpc._(603);
  static const Rpc RPC_NETWORK_ETHERNET_FLUSH = Rpc._(604);
  static const Rpc RPC_NETWORK_ROUTE_LIST = Rpc._(605);
  static const Rpc RPC_NETWORK_ROUTE_ADD = Rpc._(606);
  static const Rpc RPC_NETWORK_ROUTE_DELETE = Rpc._(607);
  static const Rpc RPC_NETWORK_ROUTE_DEFAULT_GATEWAY = Rpc._(608);
  static const Rpc RPC_NETWORK_SET_DNS_NAMESERVER = Rpc._(609);
  static const Rpc RPC_NETWORK_GET_DNS_NAMESERVER = Rpc._(610);
  static const Rpc RPC_NETWORK_HOSTS_ADD = Rpc._(611);
  static const Rpc RPC_NETWORK_HOSTS_DELETE = Rpc._(612);
  static const Rpc RPC_NETWORK_HOSTS_LIST = Rpc._(613);
  static const Rpc RPC_NETWORK_NETWORK_ADD = Rpc._(614);
  static const Rpc RPC_NETWORK_NETWORK_DELETE = Rpc._(615);
  static const Rpc RPC_NETWORK_NETWORK_LIST = Rpc._(616);
  static const Rpc RPC_FILESYSTEM_LIST = Rpc._(700);
  static const Rpc RPC_FILESYSTEM_MOUNT = Rpc._(701);
  static const Rpc RPC_FILESYSTEM_UMOUNT = Rpc._(702);
  static const Rpc RPC_FILESYSTEM_SWAP_ON = Rpc._(703);
  static const Rpc RPC_FILESYSTEM_SWAP_OFF = Rpc._(704);
  static const Rpc RPC_FILESYSTEM_DIRECTORY_TREE = Rpc._(705);
  static const Rpc RPC_FILESYSTEM_DELETE_FILE = Rpc._(706);
  static const Rpc RPC_FILESYSTEM_MOVE_FILE = Rpc._(707);
  static const Rpc RPC_FILESYSTEM_COPY_FILE = Rpc._(708);
  static const Rpc RPC_FILESYSTEM_CREATE_ARCHIVE = Rpc._(709);
  static const Rpc RPC_FILESYSTEM_EXTRACT_ARCHIVE = Rpc._(710);
  static const Rpc RPC_FILESYSTEM_CREATE_DIRECTORY = Rpc._(711);
  static const Rpc RPC_USER_LIST = Rpc._(800);
  static const Rpc RPC_USER_ADD = Rpc._(801);
  static const Rpc RPC_USER_REMOVE = Rpc._(802);
  static const Rpc RPC_USER_PASSWD = Rpc._(803);
  static const Rpc RPC_USER_LOCK = Rpc._(804);
  static const Rpc RPC_USER_UNLOCK = Rpc._(805);
  static const Rpc RPC_USER_UPDATE_ROLE = Rpc._(806);
  static const Rpc RPC_USER_REALM_LIST = Rpc._(808);
  static const Rpc RPC_LOG_APPENDER_LIST = Rpc._(900);
  static const Rpc RPC_LOG_APPENDER_ADD = Rpc._(901);
  static const Rpc RPC_LOG_APPENDER_REMOVE = Rpc._(902);
  static const Rpc RPC_LOG_SYSTEM = Rpc._(903);
  static const Rpc RPC_LOG_KERNEL = Rpc._(904);
  static const Rpc RPC_SSL_INSTALL_KEYSTORE = Rpc._(1000);
  static const Rpc RPC_SSL_GENERATE_SELF_SIGNED = Rpc._(1001);
  static const Rpc RPC_FIREWALL_TABLE_ADD = Rpc._(1100);
  static const Rpc RPC_FIREWALL_TABLE_REMOVE = Rpc._(1101);
  static const Rpc RPC_FIREWALL_TABLE_LIST = Rpc._(1102);
  static const Rpc RPC_FIREWALL_TABLE_RENAME = Rpc._(1103);
  static const Rpc RPC_FIREWALL_CHAIN_ADD = Rpc._(1104);
  static const Rpc RPC_FIREWALL_CHAIN_REMOVE = Rpc._(1105);
  static const Rpc RPC_FIREWALL_CHAIN_LIST = Rpc._(1106);
  static const Rpc RPC_FIREWALL_CHAIN_UPDATE = Rpc._(1107);
  static const Rpc RPC_FIREWALL_CHAIN_SWITCH = Rpc._(1108);
  static const Rpc RPC_FIREWALL_SET_ADD = Rpc._(1109);
  static const Rpc RPC_FIREWALL_SET_LIST = Rpc._(1110);
  static const Rpc RPC_FIREWALL_SET_REMOVE = Rpc._(1111);
  static const Rpc RPC_FIREWALL_SET_RENAME = Rpc._(1112);
  static const Rpc RPC_FIREWALL_SET_ELEMENT_ADD = Rpc._(1113);
  static const Rpc RPC_FIREWALL_SET_ELEMENT_REMOVE = Rpc._(1114);
  static const Rpc RPC_FIREWALL_RULE_ADD = Rpc._(1115);
  static const Rpc RPC_FIREWALL_RULE_INSERT = Rpc._(1116);
  static const Rpc RPC_FIREWALL_RULE_LIST = Rpc._(1117);
  static const Rpc RPC_FIREWALL_RULE_REMOVE = Rpc._(1118);
  static const Rpc RPC_FIREWALL_RULE_SWITCH = Rpc._(1119);
  static const Rpc RPC_FIREWALL_RULE_UPDATE = Rpc._(1120);
  static const Rpc RPC_CONTAINER_IMAGE_PULL = Rpc._(2000);
  static const Rpc RPC_CONTAINER_IMAGE_REMOVE = Rpc._(2001);
  static const Rpc RPC_CONTAINER_IMAGE_LIST = Rpc._(2002);
  static const Rpc RPC_CONTAINER_IMAGE_SEARCH = Rpc._(2004);
  static const Rpc RPC_CONTAINER_IMAGE_PRUNE = Rpc._(2005);
  static const Rpc RPC_CONTAINER_IMAGE_PULL_CANCEL = Rpc._(2006);
  static const Rpc RPC_CONTAINER_NETWORK_CREATE = Rpc._(2007);
  static const Rpc RPC_CONTAINER_NETWORK_REMOVE = Rpc._(2008);
  static const Rpc RPC_CONTAINER_NETWORK_CONNECT = Rpc._(2009);
  static const Rpc RPC_CONTAINER_NETWORK_DISCONNECT = Rpc._(2010);
  static const Rpc RPC_CONTAINER_NETWORK_LIST = Rpc._(2011);
  static const Rpc RPC_CONTAINER_VOLUME_CREATE = Rpc._(2012);
  static const Rpc RPC_CONTAINER_VOLUME_LIST = Rpc._(2013);
  static const Rpc RPC_CONTAINER_VOLUME_REMOVE = Rpc._(2014);
  static const Rpc RPC_CONTAINER_VOLUME_PRUNE = Rpc._(2015);
  static const Rpc RPC_CONTAINER_POD_CREATE = Rpc._(2016);
  static const Rpc RPC_CONTAINER_POD_LIST = Rpc._(2017);
  static const Rpc RPC_CONTAINER_POD_REMOVE = Rpc._(2018);
  static const Rpc RPC_CONTAINER_POD_PRUNE = Rpc._(2019);
  static const Rpc RPC_CONTAINER_POD_STATS = Rpc._(2020);
  static const Rpc RPC_CONTAINER_POD_STOP = Rpc._(2021);
  static const Rpc RPC_CONTAINER_POD_START = Rpc._(2022);
  static const Rpc RPC_CONTAINER_POD_KILL = Rpc._(2023);
  static const Rpc RPC_CONTAINER_POD_KUBE_PLAY = Rpc._(2024);
  static const Rpc RPC_CONTAINER_POD_KUBE_GENERATE = Rpc._(2025);
  static const Rpc RPC_CONTAINER_CREATE = Rpc._(2026);
  static const Rpc RPC_CONTAINER_REMOVE = Rpc._(2027);
  static const Rpc RPC_CONTAINER_LIST = Rpc._(2028);
  static const Rpc RPC_CONTAINER_STOP = Rpc._(2029);
  static const Rpc RPC_CONTAINER_START = Rpc._(2030);
  static const Rpc RPC_CONTAINER_KILL = Rpc._(2031);
  static const Rpc RPC_CONTAINER_PRUNE = Rpc._(2032);
  static const Rpc RPC_CONTAINER_SETTING_REGISTRIES_LOAD = Rpc._(2033);
  static const Rpc RPC_CONTAINER_SETTING_REGISTRIES_SAVE = Rpc._(2034);
  static const Rpc RPC_CONTAINER_CREATE_EXEC_INSTANCE = Rpc._(2035);
  static const Rpc RPC_CONTAINER_RESIZE_TTY = Rpc._(2036);
  static const Rpc RPC_EVENT_LIST = Rpc._(2100);
  static const Rpc RPC_EVENT_READ = Rpc._(2101);
  static const Rpc RPC_EVENT_READ_ALL = Rpc._(2102);
  static const Rpc RPC_EVENT_GET = Rpc._(2103);
  static const Rpc RPC_RRD_GRAPH_FETCH = Rpc._(2200);
  static const Rpc RPC_RRD_GRAPH_SORT = Rpc._(2201);
  static const Map<int, Rpc> values = {
    0: RPC_SYSTEM_SHUTDOWN,
    1: RPC_SYSTEM_REBOOT,
    2: RPC_SYSTEM_ENVIRONMENT_LIST,
    3: RPC_SYSTEM_ENVIRONMENT_SET,
    4: RPC_SYSTEM_ENVIRONMENT_GET,
    5: RPC_SYSTEM_ENVIRONMENT_UNSET,
    6: RPC_SYSTEM_OS_TYPE,
    7: RPC_SYSTEM_TOTAL_MEMORY,
    8: RPC_SYSTEM_FREE_MEMORY,
    9: RPC_SYSTEM_USED_MEMORY,
    10: RPC_SYSTEM_CPU_INFORMATION,
    11: RPC_SYSTEM_CPU_CORE_COUNT,
    12: RPC_SYSTEM_SET_HOSTNAME,
    13: RPC_SYSTEM_GET_HOSTNAME,
    14: RPC_SYSTEM_SET_DATE_TIME,
    15: RPC_SYSTEM_SET_TIMEZONE,
    16: RPC_SYSTEM_FULL_INFORMATION,
    17: RPC_SYSTEM_ENVIRONMENT_UPDATE,
    18: RPC_SYSTEM_ENVIRONMENT_BATCH_SET,
    19: RPC_SYSTEM_KERNEL_PARAMETER_LIST,
    20: RPC_SYSTEM_KERNEL_PARAMETER_SET,
    21: RPC_SYSTEM_KERNEL_PARAMETER_UNSET,
    22: RPC_SYSTEM_KERNEL_PARAMETER_GET,
    23: RPC_SYSTEM_KERNEL_MODULE_LIST,
    24: RPC_SYSTEM_KERNEL_MODULE_LOAD,
    25: RPC_SYSTEM_KERNEL_MODULE_UNLOAD,
    26: RPC_SYSTEM_KERNEL_MODULE_INFO,
    100: RPC_JVM_VERSION,
    101: RPC_JVM_VENDOR,
    102: RPC_JVM_TOTAL_HEAP_SIZE,
    103: RPC_JVM_MAX_HEAP_SIZE,
    104: RPC_JVM_USED_HEAP_SIZE,
    105: RPC_JVM_GC,
    106: RPC_JVM_RESTART,
    200: RPC_CONFIG_BACKUP_CREATE,
    201: RPC_CONFIG_BACKUP_RESTORE,
    202: RPC_CONFIG_BACKUP_DELETE,
    203: RPC_CONFIG_BACKUP_LIST,
    204: RPC_CONFIG_PRINT,
    300: RPC_DATE_TIME_INFORMATION,
    301: RPC_DATE_TIME_SYNC_HCTOSYS,
    302: RPC_DATE_TIME_SYNC_SYSTOHC,
    400: RPC_NTP_SERVER_NAME,
    401: RPC_NTP_SYNC,
    402: RPC_NTP_ACTIVATE,
    403: RPC_NTP_INFORMATION,
    500: RPC_MODULE_LIST,
    501: RPC_MODULE_INSTALL,
    502: RPC_MODULE_REMOVE,
    503: RPC_MODULE_ENABLE,
    504: RPC_MODULE_DISABLE,
    505: RPC_MODULE_DEPENDENCIES,
    506: RPC_MODULE_START,
    507: RPC_MODULE_STOP,
    508: RPC_MODULE_STOP_ALL,
    509: RPC_MODULE_START_ALL,
    510: RPC_MODULE_INIT,
    600: RPC_NETWORK_ETHERNET_INFORMATION,
    601: RPC_NETWORK_ETHERNET_SET_IP,
    602: RPC_NETWORK_ETHERNET_UP,
    603: RPC_NETWORK_ETHERNET_DOWN,
    604: RPC_NETWORK_ETHERNET_FLUSH,
    605: RPC_NETWORK_ROUTE_LIST,
    606: RPC_NETWORK_ROUTE_ADD,
    607: RPC_NETWORK_ROUTE_DELETE,
    608: RPC_NETWORK_ROUTE_DEFAULT_GATEWAY,
    609: RPC_NETWORK_SET_DNS_NAMESERVER,
    610: RPC_NETWORK_GET_DNS_NAMESERVER,
    611: RPC_NETWORK_HOSTS_ADD,
    612: RPC_NETWORK_HOSTS_DELETE,
    613: RPC_NETWORK_HOSTS_LIST,
    614: RPC_NETWORK_NETWORK_ADD,
    615: RPC_NETWORK_NETWORK_DELETE,
    616: RPC_NETWORK_NETWORK_LIST,
    700: RPC_FILESYSTEM_LIST,
    701: RPC_FILESYSTEM_MOUNT,
    702: RPC_FILESYSTEM_UMOUNT,
    703: RPC_FILESYSTEM_SWAP_ON,
    704: RPC_FILESYSTEM_SWAP_OFF,
    705: RPC_FILESYSTEM_DIRECTORY_TREE,
    706: RPC_FILESYSTEM_DELETE_FILE,
    707: RPC_FILESYSTEM_MOVE_FILE,
    708: RPC_FILESYSTEM_COPY_FILE,
    709: RPC_FILESYSTEM_CREATE_ARCHIVE,
    710: RPC_FILESYSTEM_EXTRACT_ARCHIVE,
    711: RPC_FILESYSTEM_CREATE_DIRECTORY,
    800: RPC_USER_LIST,
    801: RPC_USER_ADD,
    802: RPC_USER_REMOVE,
    803: RPC_USER_PASSWD,
    804: RPC_USER_LOCK,
    805: RPC_USER_UNLOCK,
    806: RPC_USER_UPDATE_ROLE,
    808: RPC_USER_REALM_LIST,
    900: RPC_LOG_APPENDER_LIST,
    901: RPC_LOG_APPENDER_ADD,
    902: RPC_LOG_APPENDER_REMOVE,
    903: RPC_LOG_SYSTEM,
    904: RPC_LOG_KERNEL,
    1000: RPC_SSL_INSTALL_KEYSTORE,
    1001: RPC_SSL_GENERATE_SELF_SIGNED,
    1100: RPC_FIREWALL_TABLE_ADD,
    1101: RPC_FIREWALL_TABLE_REMOVE,
    1102: RPC_FIREWALL_TABLE_LIST,
    1103: RPC_FIREWALL_TABLE_RENAME,
    1104: RPC_FIREWALL_CHAIN_ADD,
    1105: RPC_FIREWALL_CHAIN_REMOVE,
    1106: RPC_FIREWALL_CHAIN_LIST,
    1107: RPC_FIREWALL_CHAIN_UPDATE,
    1108: RPC_FIREWALL_CHAIN_SWITCH,
    1109: RPC_FIREWALL_SET_ADD,
    1110: RPC_FIREWALL_SET_LIST,
    1111: RPC_FIREWALL_SET_REMOVE,
    1112: RPC_FIREWALL_SET_RENAME,
    1113: RPC_FIREWALL_SET_ELEMENT_ADD,
    1114: RPC_FIREWALL_SET_ELEMENT_REMOVE,
    1115: RPC_FIREWALL_RULE_ADD,
    1116: RPC_FIREWALL_RULE_INSERT,
    1117: RPC_FIREWALL_RULE_LIST,
    1118: RPC_FIREWALL_RULE_REMOVE,
    1119: RPC_FIREWALL_RULE_SWITCH,
    1120: RPC_FIREWALL_RULE_UPDATE,
    2000: RPC_CONTAINER_IMAGE_PULL,
    2001: RPC_CONTAINER_IMAGE_REMOVE,
    2002: RPC_CONTAINER_IMAGE_LIST,
    2004: RPC_CONTAINER_IMAGE_SEARCH,
    2005: RPC_CONTAINER_IMAGE_PRUNE,
    2006: RPC_CONTAINER_IMAGE_PULL_CANCEL,
    2007: RPC_CONTAINER_NETWORK_CREATE,
    2008: RPC_CONTAINER_NETWORK_REMOVE,
    2009: RPC_CONTAINER_NETWORK_CONNECT,
    2010: RPC_CONTAINER_NETWORK_DISCONNECT,
    2011: RPC_CONTAINER_NETWORK_LIST,
    2012: RPC_CONTAINER_VOLUME_CREATE,
    2013: RPC_CONTAINER_VOLUME_LIST,
    2014: RPC_CONTAINER_VOLUME_REMOVE,
    2015: RPC_CONTAINER_VOLUME_PRUNE,
    2016: RPC_CONTAINER_POD_CREATE,
    2017: RPC_CONTAINER_POD_LIST,
    2018: RPC_CONTAINER_POD_REMOVE,
    2019: RPC_CONTAINER_POD_PRUNE,
    2020: RPC_CONTAINER_POD_STATS,
    2021: RPC_CONTAINER_POD_STOP,
    2022: RPC_CONTAINER_POD_START,
    2023: RPC_CONTAINER_POD_KILL,
    2024: RPC_CONTAINER_POD_KUBE_PLAY,
    2025: RPC_CONTAINER_POD_KUBE_GENERATE,
    2026: RPC_CONTAINER_CREATE,
    2027: RPC_CONTAINER_REMOVE,
    2028: RPC_CONTAINER_LIST,
    2029: RPC_CONTAINER_STOP,
    2030: RPC_CONTAINER_START,
    2031: RPC_CONTAINER_KILL,
    2032: RPC_CONTAINER_PRUNE,
    2033: RPC_CONTAINER_SETTING_REGISTRIES_LOAD,
    2034: RPC_CONTAINER_SETTING_REGISTRIES_SAVE,
    2035: RPC_CONTAINER_CREATE_EXEC_INSTANCE,
    2036: RPC_CONTAINER_RESIZE_TTY,
    2100: RPC_EVENT_LIST,
    2101: RPC_EVENT_READ,
    2102: RPC_EVENT_READ_ALL,
    2103: RPC_EVENT_GET,
    2200: RPC_RRD_GRAPH_FETCH,
    2201: RPC_RRD_GRAPH_SORT};

  static const fb.Reader<Rpc> reader = _RpcReader();

  @override
  String toString() {
    return 'Rpc{value: $value}';
  }
}

class _RpcReader extends fb.Reader<Rpc> {
  const _RpcReader();

  @override
  int get size => 4;

  @override
  Rpc read(fb.BufferContext bc, int offset) =>
      Rpc.fromValue(const fb.Int32Reader().read(bc, offset));
}

class Realm {
  final int value;
  const Realm._(this.value);

  factory Realm.fromValue(int value) {
    final result = values[value];
    if (result == null) {
        throw StateError('Invalid value $value for bit flag enum Realm');
    }
    return result;
  }

  static Realm? _createOrNull(int? value) => 
      value == null ? null : Realm.fromValue(value);

  static const int minValue = 0;
  static const int maxValue = 16384;
  static bool containsValue(int value) => values.containsKey(value);

  static const Realm REALM_NONE = Realm._(0);
  static const Realm REALM_SYSTEM = Realm._(1);
  static const Realm REALM_JVM = Realm._(2);
  static const Realm REALM_NTP_CLIENT = Realm._(4);
  static const Realm REALM_DATE_TIME = Realm._(8);
  static const Realm REALM_CONFIGURATION = Realm._(16);
  static const Realm REALM_ENVIRONMENT = Realm._(32);
  static const Realm REALM_MODULE = Realm._(64);
  static const Realm REALM_NETWORK = Realm._(128);
  static const Realm REALM_USER = Realm._(256);
  static const Realm REALM_LOG = Realm._(512);
  static const Realm REALM_FILESYSTEM = Realm._(1024);
  static const Realm REALM_SSL = Realm._(2048);
  static const Realm REALM_CONTAINER_ENGINE = Realm._(4096);
  static const Realm REALM_KERNEL = Realm._(8192);
  static const Realm REALM_FIREWALL = Realm._(16384);
  static const Map<int, Realm> values = {
    0: REALM_NONE,
    1: REALM_SYSTEM,
    2: REALM_JVM,
    4: REALM_NTP_CLIENT,
    8: REALM_DATE_TIME,
    16: REALM_CONFIGURATION,
    32: REALM_ENVIRONMENT,
    64: REALM_MODULE,
    128: REALM_NETWORK,
    256: REALM_USER,
    512: REALM_LOG,
    1024: REALM_FILESYSTEM,
    2048: REALM_SSL,
    4096: REALM_CONTAINER_ENGINE,
    8192: REALM_KERNEL,
    16384: REALM_FIREWALL};

  static const fb.Reader<Realm> reader = _RealmReader();

  @override
  String toString() {
    return 'Realm{value: $value}';
  }
}

class _RealmReader extends fb.Reader<Realm> {
  const _RealmReader();

  @override
  int get size => 4;

  @override
  Realm read(fb.BufferContext bc, int offset) =>
      Realm.fromValue(const fb.Int32Reader().read(bc, offset));
}

class EventStatus {
  final int value;
  const EventStatus._(this.value);

  factory EventStatus.fromValue(int value) {
    final result = values[value];
    if (result == null) {
        throw StateError('Invalid value $value for bit flag enum EventStatus');
    }
    return result;
  }

  static EventStatus? _createOrNull(int? value) => 
      value == null ? null : EventStatus.fromValue(value);

  static const int minValue = 0;
  static const int maxValue = 2;
  static bool containsValue(int value) => values.containsKey(value);

  static const EventStatus PROGRESS = EventStatus._(0);
  static const EventStatus FAILURE = EventStatus._(1);
  static const EventStatus SUCCESS = EventStatus._(2);
  static const Map<int, EventStatus> values = {
    0: PROGRESS,
    1: FAILURE,
    2: SUCCESS};

  static const fb.Reader<EventStatus> reader = _EventStatusReader();

  @override
  String toString() {
    return 'EventStatus{value: $value}';
  }
}

class _EventStatusReader extends fb.Reader<EventStatus> {
  const _EventStatusReader();

  @override
  int get size => 4;

  @override
  EventStatus read(fb.BufferContext bc, int offset) =>
      EventStatus.fromValue(const fb.Int32Reader().read(bc, offset));
}

class Packet {
  Packet._(this._bc, this._bcOffset);
  factory Packet(List<int> bytes) {
    final rootRef = fb.BufferContext.fromBytes(bytes);
    return reader.read(rootRef, 0);
  }

  static const fb.Reader<Packet> reader = _PacketReader();

  final fb.BufferContext _bc;
  final int _bcOffset;

  List<int>? get iv => const fb.Int8ListReader().vTableGetNullable(_bc, _bcOffset, 4);
  List<int>? get hash => const fb.Int8ListReader().vTableGetNullable(_bc, _bcOffset, 6);
  List<int>? get payload => const fb.Int8ListReader().vTableGetNullable(_bc, _bcOffset, 8);

  @override
  String toString() {
    return 'Packet{iv: ${iv}, hash: ${hash}, payload: ${payload}}';
  }
}

class _PacketReader extends fb.TableReader<Packet> {
  const _PacketReader();

  @override
  Packet createObject(fb.BufferContext bc, int offset) => 
    Packet._(bc, offset);
}

class PacketBuilder {
  PacketBuilder(this.fbBuilder);

  final fb.Builder fbBuilder;

  void begin() {
    fbBuilder.startTable(3);
  }

  int addIvOffset(int? offset) {
    fbBuilder.addOffset(0, offset);
    return fbBuilder.offset;
  }
  int addHashOffset(int? offset) {
    fbBuilder.addOffset(1, offset);
    return fbBuilder.offset;
  }
  int addPayloadOffset(int? offset) {
    fbBuilder.addOffset(2, offset);
    return fbBuilder.offset;
  }

  int finish() {
    return fbBuilder.endTable();
  }
}

class PacketObjectBuilder extends fb.ObjectBuilder {
  final List<int>? _iv;
  final List<int>? _hash;
  final List<int>? _payload;

  PacketObjectBuilder({
    List<int>? iv,
    List<int>? hash,
    List<int>? payload,
  })
      : _iv = iv,
        _hash = hash,
        _payload = payload;

  /// Finish building, and store into the [fbBuilder].
  @override
  int finish(fb.Builder fbBuilder) {
    final int? ivOffset = _iv == null ? null
        : fbBuilder.writeListInt8(_iv!);
    final int? hashOffset = _hash == null ? null
        : fbBuilder.writeListInt8(_hash!);
    final int? payloadOffset = _payload == null ? null
        : fbBuilder.writeListInt8(_payload!);
    fbBuilder.startTable(3);
    fbBuilder.addOffset(0, ivOffset);
    fbBuilder.addOffset(1, hashOffset);
    fbBuilder.addOffset(2, payloadOffset);
    return fbBuilder.endTable();
  }

  /// Convenience method to serialize to byte list.
  @override
  Uint8List toBytes([String? fileIdentifier]) {
    final fbBuilder = fb.Builder(deduplicateTables: false);
    fbBuilder.finish(finish(fbBuilder), fileIdentifier);
    return fbBuilder.buffer;
  }
}
class Payload {
  Payload._(this._bc, this._bcOffset);
  factory Payload(List<int> bytes) {
    final rootRef = fb.BufferContext.fromBytes(bytes);
    return reader.read(rootRef, 0);
  }

  static const fb.Reader<Payload> reader = _PayloadReader();

  final fb.BufferContext _bc;
  final int _bcOffset;

  Metadata? get metadata => Metadata.reader.vTableGetNullable(_bc, _bcOffset, 4);
  String? get content => const fb.StringReader().vTableGetNullable(_bc, _bcOffset, 6);

  @override
  String toString() {
    return 'Payload{metadata: ${metadata}, content: ${content}}';
  }
}

class _PayloadReader extends fb.TableReader<Payload> {
  const _PayloadReader();

  @override
  Payload createObject(fb.BufferContext bc, int offset) => 
    Payload._(bc, offset);
}

class PayloadBuilder {
  PayloadBuilder(this.fbBuilder);

  final fb.Builder fbBuilder;

  void begin() {
    fbBuilder.startTable(2);
  }

  int addMetadataOffset(int? offset) {
    fbBuilder.addOffset(0, offset);
    return fbBuilder.offset;
  }
  int addContentOffset(int? offset) {
    fbBuilder.addOffset(1, offset);
    return fbBuilder.offset;
  }

  int finish() {
    return fbBuilder.endTable();
  }
}

class PayloadObjectBuilder extends fb.ObjectBuilder {
  final MetadataObjectBuilder? _metadata;
  final String? _content;

  PayloadObjectBuilder({
    MetadataObjectBuilder? metadata,
    String? content,
  })
      : _metadata = metadata,
        _content = content;

  /// Finish building, and store into the [fbBuilder].
  @override
  int finish(fb.Builder fbBuilder) {
    final int? metadataOffset = _metadata?.getOrCreateOffset(fbBuilder);
    final int? contentOffset = _content == null ? null
        : fbBuilder.writeString(_content!);
    fbBuilder.startTable(2);
    fbBuilder.addOffset(0, metadataOffset);
    fbBuilder.addOffset(1, contentOffset);
    return fbBuilder.endTable();
  }

  /// Convenience method to serialize to byte list.
  @override
  Uint8List toBytes([String? fileIdentifier]) {
    final fbBuilder = fb.Builder(deduplicateTables: false);
    fbBuilder.finish(finish(fbBuilder), fileIdentifier);
    return fbBuilder.buffer;
  }
}
class Metadata {
  Metadata._(this._bc, this._bcOffset);
  factory Metadata(List<int> bytes) {
    final rootRef = fb.BufferContext.fromBytes(bytes);
    return reader.read(rootRef, 0);
  }

  static const fb.Reader<Metadata> reader = _MetadataReader();

  final fb.BufferContext _bc;
  final int _bcOffset;

  bool get success => const fb.BoolReader().vTableGet(_bc, _bcOffset, 4, false);
  int get rpc => const fb.Int32Reader().vTableGet(_bc, _bcOffset, 6, 0);
  int get error => const fb.Int32Reader().vTableGet(_bc, _bcOffset, 8, 0);
  bool get needRestart => const fb.BoolReader().vTableGet(_bc, _bcOffset, 10, false);
  String? get message => const fb.StringReader().vTableGetNullable(_bc, _bcOffset, 12);

  @override
  String toString() {
    return 'Metadata{success: ${success}, rpc: ${rpc}, error: ${error}, needRestart: ${needRestart}, message: ${message}}';
  }
}

class _MetadataReader extends fb.TableReader<Metadata> {
  const _MetadataReader();

  @override
  Metadata createObject(fb.BufferContext bc, int offset) => 
    Metadata._(bc, offset);
}

class MetadataBuilder {
  MetadataBuilder(this.fbBuilder);

  final fb.Builder fbBuilder;

  void begin() {
    fbBuilder.startTable(5);
  }

  int addSuccess(bool? success) {
    fbBuilder.addBool(0, success);
    return fbBuilder.offset;
  }
  int addRpc(int? rpc) {
    fbBuilder.addInt32(1, rpc);
    return fbBuilder.offset;
  }
  int addError(int? error) {
    fbBuilder.addInt32(2, error);
    return fbBuilder.offset;
  }
  int addNeedRestart(bool? needRestart) {
    fbBuilder.addBool(3, needRestart);
    return fbBuilder.offset;
  }
  int addMessageOffset(int? offset) {
    fbBuilder.addOffset(4, offset);
    return fbBuilder.offset;
  }

  int finish() {
    return fbBuilder.endTable();
  }
}

class MetadataObjectBuilder extends fb.ObjectBuilder {
  final bool? _success;
  final int? _rpc;
  final int? _error;
  final bool? _needRestart;
  final String? _message;

  MetadataObjectBuilder({
    bool? success,
    int? rpc,
    int? error,
    bool? needRestart,
    String? message,
  })
      : _success = success,
        _rpc = rpc,
        _error = error,
        _needRestart = needRestart,
        _message = message;

  /// Finish building, and store into the [fbBuilder].
  @override
  int finish(fb.Builder fbBuilder) {
    final int? messageOffset = _message == null ? null
        : fbBuilder.writeString(_message!);
    fbBuilder.startTable(5);
    fbBuilder.addBool(0, _success);
    fbBuilder.addInt32(1, _rpc);
    fbBuilder.addInt32(2, _error);
    fbBuilder.addBool(3, _needRestart);
    fbBuilder.addOffset(4, messageOffset);
    return fbBuilder.endTable();
  }

  /// Convenience method to serialize to byte list.
  @override
  Uint8List toBytes([String? fileIdentifier]) {
    final fbBuilder = fb.Builder(deduplicateTables: false);
    fbBuilder.finish(finish(fbBuilder), fileIdentifier);
    return fbBuilder.buffer;
  }
}
class Event {
  Event._(this._bc, this._bcOffset);
  factory Event(List<int> bytes) {
    final rootRef = fb.BufferContext.fromBytes(bytes);
    return reader.read(rootRef, 0);
  }

  static const fb.Reader<Event> reader = _EventReader();

  final fb.BufferContext _bc;
  final int _bcOffset;

  String? get uid => const fb.StringReader().vTableGetNullable(_bc, _bcOffset, 4);
  String? get username => const fb.StringReader().vTableGetNullable(_bc, _bcOffset, 6);
  EventStatus get eventStatus => EventStatus.fromValue(const fb.Int32Reader().vTableGet(_bc, _bcOffset, 8, 0));
  double get percentage => const fb.Float64Reader().vTableGet(_bc, _bcOffset, 10, 0.0);
  bool get read => const fb.BoolReader().vTableGet(_bc, _bcOffset, 12, false);
  String? get message => const fb.StringReader().vTableGetNullable(_bc, _bcOffset, 14);

  @override
  String toString() {
    return 'Event{uid: ${uid}, username: ${username}, eventStatus: ${eventStatus}, percentage: ${percentage}, read: ${read}, message: ${message}}';
  }
}

class _EventReader extends fb.TableReader<Event> {
  const _EventReader();

  @override
  Event createObject(fb.BufferContext bc, int offset) => 
    Event._(bc, offset);
}

class EventBuilder {
  EventBuilder(this.fbBuilder);

  final fb.Builder fbBuilder;

  void begin() {
    fbBuilder.startTable(6);
  }

  int addUidOffset(int? offset) {
    fbBuilder.addOffset(0, offset);
    return fbBuilder.offset;
  }
  int addUsernameOffset(int? offset) {
    fbBuilder.addOffset(1, offset);
    return fbBuilder.offset;
  }
  int addEventStatus(EventStatus? eventStatus) {
    fbBuilder.addInt32(2, eventStatus?.value);
    return fbBuilder.offset;
  }
  int addPercentage(double? percentage) {
    fbBuilder.addFloat64(3, percentage);
    return fbBuilder.offset;
  }
  int addRead(bool? read) {
    fbBuilder.addBool(4, read);
    return fbBuilder.offset;
  }
  int addMessageOffset(int? offset) {
    fbBuilder.addOffset(5, offset);
    return fbBuilder.offset;
  }

  int finish() {
    return fbBuilder.endTable();
  }
}

class EventObjectBuilder extends fb.ObjectBuilder {
  final String? _uid;
  final String? _username;
  final EventStatus? _eventStatus;
  final double? _percentage;
  final bool? _read;
  final String? _message;

  EventObjectBuilder({
    String? uid,
    String? username,
    EventStatus? eventStatus,
    double? percentage,
    bool? read,
    String? message,
  })
      : _uid = uid,
        _username = username,
        _eventStatus = eventStatus,
        _percentage = percentage,
        _read = read,
        _message = message;

  /// Finish building, and store into the [fbBuilder].
  @override
  int finish(fb.Builder fbBuilder) {
    final int? uidOffset = _uid == null ? null
        : fbBuilder.writeString(_uid!);
    final int? usernameOffset = _username == null ? null
        : fbBuilder.writeString(_username!);
    final int? messageOffset = _message == null ? null
        : fbBuilder.writeString(_message!);
    fbBuilder.startTable(6);
    fbBuilder.addOffset(0, uidOffset);
    fbBuilder.addOffset(1, usernameOffset);
    fbBuilder.addInt32(2, _eventStatus?.value);
    fbBuilder.addFloat64(3, _percentage);
    fbBuilder.addBool(4, _read);
    fbBuilder.addOffset(5, messageOffset);
    return fbBuilder.endTable();
  }

  /// Convenience method to serialize to byte list.
  @override
  Uint8List toBytes([String? fileIdentifier]) {
    final fbBuilder = fb.Builder(deduplicateTables: false);
    fbBuilder.finish(finish(fbBuilder), fileIdentifier);
    return fbBuilder.buffer;
  }
}
