//
//  Generated code. Do not modify.
//  source: message-buffer.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class RPC extends $pb.ProtobufEnum {
  static const RPC RPC_SYSTEM_SHUTDOWN = RPC._(0, _omitEnumNames ? '' : 'RPC_SYSTEM_SHUTDOWN');
  static const RPC RPC_SYSTEM_REBOOT = RPC._(1, _omitEnumNames ? '' : 'RPC_SYSTEM_REBOOT');
  static const RPC RPC_SYSTEM_ENVIRONMENT_LIST = RPC._(2, _omitEnumNames ? '' : 'RPC_SYSTEM_ENVIRONMENT_LIST');
  static const RPC RPC_SYSTEM_ENVIRONMENT_SET = RPC._(3, _omitEnumNames ? '' : 'RPC_SYSTEM_ENVIRONMENT_SET');
  static const RPC RPC_SYSTEM_ENVIRONMENT_GET = RPC._(4, _omitEnumNames ? '' : 'RPC_SYSTEM_ENVIRONMENT_GET');
  static const RPC RPC_SYSTEM_ENVIRONMENT_UNSET = RPC._(5, _omitEnumNames ? '' : 'RPC_SYSTEM_ENVIRONMENT_UNSET');
  static const RPC RPC_SYSTEM_OS_TYPE = RPC._(6, _omitEnumNames ? '' : 'RPC_SYSTEM_OS_TYPE');
  static const RPC RPC_SYSTEM_TOTAL_MEMORY = RPC._(7, _omitEnumNames ? '' : 'RPC_SYSTEM_TOTAL_MEMORY');
  static const RPC RPC_SYSTEM_FREE_MEMORY = RPC._(8, _omitEnumNames ? '' : 'RPC_SYSTEM_FREE_MEMORY');
  static const RPC RPC_SYSTEM_USED_MEMORY = RPC._(9, _omitEnumNames ? '' : 'RPC_SYSTEM_USED_MEMORY');
  static const RPC RPC_SYSTEM_CPU_INFORMATION = RPC._(10, _omitEnumNames ? '' : 'RPC_SYSTEM_CPU_INFORMATION');
  static const RPC RPC_SYSTEM_CPU_CORE_COUNT = RPC._(11, _omitEnumNames ? '' : 'RPC_SYSTEM_CPU_CORE_COUNT');
  static const RPC RPC_SYSTEM_SET_HOSTNAME = RPC._(12, _omitEnumNames ? '' : 'RPC_SYSTEM_SET_HOSTNAME');
  static const RPC RPC_SYSTEM_GET_HOSTNAME = RPC._(13, _omitEnumNames ? '' : 'RPC_SYSTEM_GET_HOSTNAME');
  static const RPC RPC_SYSTEM_SET_DATE_TIME = RPC._(14, _omitEnumNames ? '' : 'RPC_SYSTEM_SET_DATE_TIME');
  static const RPC RPC_SYSTEM_SET_TIMEZONE = RPC._(15, _omitEnumNames ? '' : 'RPC_SYSTEM_SET_TIMEZONE');
  static const RPC RPC_SYSTEM_FULL_INFORMATION = RPC._(16, _omitEnumNames ? '' : 'RPC_SYSTEM_FULL_INFORMATION');
  static const RPC RPC_SYSTEM_ENVIRONMENT_UPDATE = RPC._(17, _omitEnumNames ? '' : 'RPC_SYSTEM_ENVIRONMENT_UPDATE');
  static const RPC RPC_SYSTEM_ENVIRONMENT_BATCH_SET = RPC._(18, _omitEnumNames ? '' : 'RPC_SYSTEM_ENVIRONMENT_BATCH_SET');
  static const RPC RPC_SYSTEM_KERNEL_PARAMETER_LIST = RPC._(19, _omitEnumNames ? '' : 'RPC_SYSTEM_KERNEL_PARAMETER_LIST');
  static const RPC RPC_SYSTEM_KERNEL_PARAMETER_SET = RPC._(20, _omitEnumNames ? '' : 'RPC_SYSTEM_KERNEL_PARAMETER_SET');
  static const RPC RPC_SYSTEM_KERNEL_PARAMETER_UNSET = RPC._(21, _omitEnumNames ? '' : 'RPC_SYSTEM_KERNEL_PARAMETER_UNSET');
  static const RPC RPC_SYSTEM_KERNEL_PARAMETER_GET = RPC._(22, _omitEnumNames ? '' : 'RPC_SYSTEM_KERNEL_PARAMETER_GET');
  static const RPC RPC_SYSTEM_KERNEL_MODULE_LIST = RPC._(23, _omitEnumNames ? '' : 'RPC_SYSTEM_KERNEL_MODULE_LIST');
  static const RPC RPC_SYSTEM_KERNEL_MODULE_LOAD = RPC._(24, _omitEnumNames ? '' : 'RPC_SYSTEM_KERNEL_MODULE_LOAD');
  static const RPC RPC_SYSTEM_KERNEL_MODULE_UNLOAD = RPC._(25, _omitEnumNames ? '' : 'RPC_SYSTEM_KERNEL_MODULE_UNLOAD');
  static const RPC RPC_SYSTEM_KERNEL_MODULE_INFO = RPC._(26, _omitEnumNames ? '' : 'RPC_SYSTEM_KERNEL_MODULE_INFO');
  static const RPC RPC_JVM_VERSION = RPC._(100, _omitEnumNames ? '' : 'RPC_JVM_VERSION');
  static const RPC RPC_JVM_VENDOR = RPC._(101, _omitEnumNames ? '' : 'RPC_JVM_VENDOR');
  static const RPC RPC_JVM_TOTAL_HEAP_SIZE = RPC._(102, _omitEnumNames ? '' : 'RPC_JVM_TOTAL_HEAP_SIZE');
  static const RPC RPC_JVM_MAX_HEAP_SIZE = RPC._(103, _omitEnumNames ? '' : 'RPC_JVM_MAX_HEAP_SIZE');
  static const RPC RPC_JVM_USED_HEAP_SIZE = RPC._(104, _omitEnumNames ? '' : 'RPC_JVM_USED_HEAP_SIZE');
  static const RPC RPC_JVM_GC = RPC._(105, _omitEnumNames ? '' : 'RPC_JVM_GC');
  static const RPC RPC_JVM_RESTART = RPC._(106, _omitEnumNames ? '' : 'RPC_JVM_RESTART');
  static const RPC RPC_CONFIG_BACKUP_CREATE = RPC._(200, _omitEnumNames ? '' : 'RPC_CONFIG_BACKUP_CREATE');
  static const RPC RPC_CONFIG_BACKUP_RESTORE = RPC._(201, _omitEnumNames ? '' : 'RPC_CONFIG_BACKUP_RESTORE');
  static const RPC RPC_CONFIG_BACKUP_DELETE = RPC._(202, _omitEnumNames ? '' : 'RPC_CONFIG_BACKUP_DELETE');
  static const RPC RPC_CONFIG_BACKUP_LIST = RPC._(203, _omitEnumNames ? '' : 'RPC_CONFIG_BACKUP_LIST');
  static const RPC RPC_CONFIG_PRINT = RPC._(204, _omitEnumNames ? '' : 'RPC_CONFIG_PRINT');
  static const RPC RPC_DATE_TIME_INFORMATION = RPC._(300, _omitEnumNames ? '' : 'RPC_DATE_TIME_INFORMATION');
  static const RPC RPC_DATE_TIME_SYNC_HCTOSYS = RPC._(301, _omitEnumNames ? '' : 'RPC_DATE_TIME_SYNC_HCTOSYS');
  static const RPC RPC_DATE_TIME_SYNC_SYSTOHC = RPC._(302, _omitEnumNames ? '' : 'RPC_DATE_TIME_SYNC_SYSTOHC');
  static const RPC RPC_NTP_SERVER_NAME = RPC._(400, _omitEnumNames ? '' : 'RPC_NTP_SERVER_NAME');
  static const RPC RPC_NTP_SYNC = RPC._(401, _omitEnumNames ? '' : 'RPC_NTP_SYNC');
  static const RPC RPC_NTP_ACTIVATE = RPC._(402, _omitEnumNames ? '' : 'RPC_NTP_ACTIVATE');
  static const RPC RPC_NTP_INFORMATION = RPC._(403, _omitEnumNames ? '' : 'RPC_NTP_INFORMATION');
  static const RPC RPC_MODULE_LIST = RPC._(500, _omitEnumNames ? '' : 'RPC_MODULE_LIST');
  static const RPC RPC_MODULE_INSTALL = RPC._(501, _omitEnumNames ? '' : 'RPC_MODULE_INSTALL');
  static const RPC RPC_MODULE_REMOVE = RPC._(502, _omitEnumNames ? '' : 'RPC_MODULE_REMOVE');
  static const RPC RPC_MODULE_ENABLE = RPC._(503, _omitEnumNames ? '' : 'RPC_MODULE_ENABLE');
  static const RPC RPC_MODULE_DISABLE = RPC._(504, _omitEnumNames ? '' : 'RPC_MODULE_DISABLE');
  static const RPC RPC_MODULE_DEPENDENCIES = RPC._(505, _omitEnumNames ? '' : 'RPC_MODULE_DEPENDENCIES');
  static const RPC RPC_MODULE_START = RPC._(506, _omitEnumNames ? '' : 'RPC_MODULE_START');
  static const RPC RPC_MODULE_STOP = RPC._(507, _omitEnumNames ? '' : 'RPC_MODULE_STOP');
  static const RPC RPC_MODULE_STOP_ALL = RPC._(508, _omitEnumNames ? '' : 'RPC_MODULE_STOP_ALL');
  static const RPC RPC_MODULE_START_ALL = RPC._(509, _omitEnumNames ? '' : 'RPC_MODULE_START_ALL');
  static const RPC RPC_MODULE_INIT = RPC._(510, _omitEnumNames ? '' : 'RPC_MODULE_INIT');
  static const RPC RPC_NETWORK_ETHERNET_INFORMATION = RPC._(600, _omitEnumNames ? '' : 'RPC_NETWORK_ETHERNET_INFORMATION');
  static const RPC RPC_NETWORK_ETHERNET_SET_IP = RPC._(601, _omitEnumNames ? '' : 'RPC_NETWORK_ETHERNET_SET_IP');
  static const RPC RPC_NETWORK_ETHERNET_UP = RPC._(602, _omitEnumNames ? '' : 'RPC_NETWORK_ETHERNET_UP');
  static const RPC RPC_NETWORK_ETHERNET_DOWN = RPC._(603, _omitEnumNames ? '' : 'RPC_NETWORK_ETHERNET_DOWN');
  static const RPC RPC_NETWORK_ETHERNET_FLUSH = RPC._(604, _omitEnumNames ? '' : 'RPC_NETWORK_ETHERNET_FLUSH');
  static const RPC RPC_NETWORK_ROUTE_LIST = RPC._(605, _omitEnumNames ? '' : 'RPC_NETWORK_ROUTE_LIST');
  static const RPC RPC_NETWORK_ROUTE_ADD = RPC._(606, _omitEnumNames ? '' : 'RPC_NETWORK_ROUTE_ADD');
  static const RPC RPC_NETWORK_ROUTE_DELETE = RPC._(607, _omitEnumNames ? '' : 'RPC_NETWORK_ROUTE_DELETE');
  static const RPC RPC_NETWORK_ROUTE_DEFAULT_GATEWAY = RPC._(608, _omitEnumNames ? '' : 'RPC_NETWORK_ROUTE_DEFAULT_GATEWAY');
  static const RPC RPC_NETWORK_SET_DNS_NAMESERVER = RPC._(609, _omitEnumNames ? '' : 'RPC_NETWORK_SET_DNS_NAMESERVER');
  static const RPC RPC_NETWORK_GET_DNS_NAMESERVER = RPC._(610, _omitEnumNames ? '' : 'RPC_NETWORK_GET_DNS_NAMESERVER');
  static const RPC RPC_NETWORK_HOSTS_ADD = RPC._(611, _omitEnumNames ? '' : 'RPC_NETWORK_HOSTS_ADD');
  static const RPC RPC_NETWORK_HOSTS_DELETE = RPC._(612, _omitEnumNames ? '' : 'RPC_NETWORK_HOSTS_DELETE');
  static const RPC RPC_NETWORK_HOSTS_LIST = RPC._(613, _omitEnumNames ? '' : 'RPC_NETWORK_HOSTS_LIST');
  static const RPC RPC_NETWORK_NETWORK_ADD = RPC._(614, _omitEnumNames ? '' : 'RPC_NETWORK_NETWORK_ADD');
  static const RPC RPC_NETWORK_NETWORK_DELETE = RPC._(615, _omitEnumNames ? '' : 'RPC_NETWORK_NETWORK_DELETE');
  static const RPC RPC_NETWORK_NETWORK_LIST = RPC._(616, _omitEnumNames ? '' : 'RPC_NETWORK_NETWORK_LIST');
  static const RPC RPC_FILESYSTEM_LIST = RPC._(700, _omitEnumNames ? '' : 'RPC_FILESYSTEM_LIST');
  static const RPC RPC_FILESYSTEM_MOUNT = RPC._(701, _omitEnumNames ? '' : 'RPC_FILESYSTEM_MOUNT');
  static const RPC RPC_FILESYSTEM_UMOUNT = RPC._(702, _omitEnumNames ? '' : 'RPC_FILESYSTEM_UMOUNT');
  static const RPC RPC_FILESYSTEM_SWAP_ON = RPC._(703, _omitEnumNames ? '' : 'RPC_FILESYSTEM_SWAP_ON');
  static const RPC RPC_FILESYSTEM_SWAP_OFF = RPC._(704, _omitEnumNames ? '' : 'RPC_FILESYSTEM_SWAP_OFF');
  static const RPC RPC_FILESYSTEM_DIRECTORY_TREE = RPC._(705, _omitEnumNames ? '' : 'RPC_FILESYSTEM_DIRECTORY_TREE');
  static const RPC RPC_FILESYSTEM_DELETE_FILE = RPC._(706, _omitEnumNames ? '' : 'RPC_FILESYSTEM_DELETE_FILE');
  static const RPC RPC_FILESYSTEM_MOVE_FILE = RPC._(707, _omitEnumNames ? '' : 'RPC_FILESYSTEM_MOVE_FILE');
  static const RPC RPC_FILESYSTEM_CREATE_ARCHIVE = RPC._(708, _omitEnumNames ? '' : 'RPC_FILESYSTEM_CREATE_ARCHIVE');
  static const RPC RPC_FILESYSTEM_EXTRACT_ARCHIVE = RPC._(709, _omitEnumNames ? '' : 'RPC_FILESYSTEM_EXTRACT_ARCHIVE');
  static const RPC RPC_FILESYSTEM_CREATE_DIRECTORY = RPC._(710, _omitEnumNames ? '' : 'RPC_FILESYSTEM_CREATE_DIRECTORY');
  static const RPC RPC_USER_LIST = RPC._(800, _omitEnumNames ? '' : 'RPC_USER_LIST');
  static const RPC RPC_USER_ADD = RPC._(801, _omitEnumNames ? '' : 'RPC_USER_ADD');
  static const RPC RPC_USER_REMOVE = RPC._(802, _omitEnumNames ? '' : 'RPC_USER_REMOVE');
  static const RPC RPC_USER_PASSWD = RPC._(803, _omitEnumNames ? '' : 'RPC_USER_PASSWD');
  static const RPC RPC_USER_LOCK = RPC._(804, _omitEnumNames ? '' : 'RPC_USER_LOCK');
  static const RPC RPC_USER_UNLOCK = RPC._(805, _omitEnumNames ? '' : 'RPC_USER_UNLOCK');
  static const RPC RPC_USER_UPDATE_ROLE = RPC._(806, _omitEnumNames ? '' : 'RPC_USER_UPDATE_ROLE');
  static const RPC RPC_USER_REALM_LIST = RPC._(808, _omitEnumNames ? '' : 'RPC_USER_REALM_LIST');
  static const RPC RPC_LOG_APPENDER_LIST = RPC._(900, _omitEnumNames ? '' : 'RPC_LOG_APPENDER_LIST');
  static const RPC RPC_LOG_APPENDER_ADD = RPC._(901, _omitEnumNames ? '' : 'RPC_LOG_APPENDER_ADD');
  static const RPC RPC_LOG_APPENDER_REMOVE = RPC._(902, _omitEnumNames ? '' : 'RPC_LOG_APPENDER_REMOVE');
  static const RPC RPC_LOG_SYSTEM = RPC._(903, _omitEnumNames ? '' : 'RPC_LOG_SYSTEM');
  static const RPC RPC_LOG_KERNEL = RPC._(904, _omitEnumNames ? '' : 'RPC_LOG_KERNEL');
  static const RPC RPC_SSL_STATUS = RPC._(1000, _omitEnumNames ? '' : 'RPC_SSL_STATUS');
  static const RPC RPC_SSL_JKS_UPLOAD = RPC._(1001, _omitEnumNames ? '' : 'RPC_SSL_JKS_UPLOAD');
  static const RPC RPC_SSL_JKS_REMOVE = RPC._(1002, _omitEnumNames ? '' : 'RPC_SSL_JKS_REMOVE');
  static const RPC RPC_SSL_JKS_INFO = RPC._(1003, _omitEnumNames ? '' : 'RPC_SSL_JKS_INFO');
  static const RPC RPC_CONTAINER_IMAGE_PULL = RPC._(2000, _omitEnumNames ? '' : 'RPC_CONTAINER_IMAGE_PULL');
  static const RPC RPC_CONTAINER_IMAGE_REMOVE = RPC._(2001, _omitEnumNames ? '' : 'RPC_CONTAINER_IMAGE_REMOVE');
  static const RPC RPC_CONTAINER_IMAGE_LIST = RPC._(2002, _omitEnumNames ? '' : 'RPC_CONTAINER_IMAGE_LIST');
  static const RPC RPC_CONTAINER_IMAGE_SEARCH = RPC._(2004, _omitEnumNames ? '' : 'RPC_CONTAINER_IMAGE_SEARCH');
  static const RPC RPC_CONTAINER_IMAGE_PRUNE = RPC._(2005, _omitEnumNames ? '' : 'RPC_CONTAINER_IMAGE_PRUNE');
  static const RPC RPC_CONTAINER_IMAGE_PULL_CANCEL = RPC._(2006, _omitEnumNames ? '' : 'RPC_CONTAINER_IMAGE_PULL_CANCEL');
  static const RPC RPC_CONTAINER_NETWORK_CREATE = RPC._(2007, _omitEnumNames ? '' : 'RPC_CONTAINER_NETWORK_CREATE');
  static const RPC RPC_CONTAINER_NETWORK_REMOVE = RPC._(2008, _omitEnumNames ? '' : 'RPC_CONTAINER_NETWORK_REMOVE');
  static const RPC RPC_CONTAINER_NETWORK_CONNECT = RPC._(2009, _omitEnumNames ? '' : 'RPC_CONTAINER_NETWORK_CONNECT');
  static const RPC RPC_CONTAINER_NETWORK_DISCONNECT = RPC._(2010, _omitEnumNames ? '' : 'RPC_CONTAINER_NETWORK_DISCONNECT');
  static const RPC RPC_CONTAINER_NETWORK_LIST = RPC._(2011, _omitEnumNames ? '' : 'RPC_CONTAINER_NETWORK_LIST');
  static const RPC RPC_CONTAINER_VOLUME_CREATE = RPC._(2012, _omitEnumNames ? '' : 'RPC_CONTAINER_VOLUME_CREATE');
  static const RPC RPC_CONTAINER_VOLUME_LIST = RPC._(2013, _omitEnumNames ? '' : 'RPC_CONTAINER_VOLUME_LIST');
  static const RPC RPC_CONTAINER_VOLUME_REMOVE = RPC._(2014, _omitEnumNames ? '' : 'RPC_CONTAINER_VOLUME_REMOVE');
  static const RPC RPC_CONTAINER_VOLUME_PRUNE = RPC._(2015, _omitEnumNames ? '' : 'RPC_CONTAINER_VOLUME_PRUNE');
  static const RPC RPC_CONTAINER_POD_CREATE = RPC._(2016, _omitEnumNames ? '' : 'RPC_CONTAINER_POD_CREATE');
  static const RPC RPC_CONTAINER_POD_LIST = RPC._(2017, _omitEnumNames ? '' : 'RPC_CONTAINER_POD_LIST');
  static const RPC RPC_CONTAINER_POD_REMOVE = RPC._(2018, _omitEnumNames ? '' : 'RPC_CONTAINER_POD_REMOVE');
  static const RPC RPC_CONTAINER_POD_PRUNE = RPC._(2019, _omitEnumNames ? '' : 'RPC_CONTAINER_POD_PRUNE');
  static const RPC RPC_CONTAINER_POD_STATS = RPC._(2020, _omitEnumNames ? '' : 'RPC_CONTAINER_POD_STATS');
  static const RPC RPC_CONTAINER_POD_STOP = RPC._(2021, _omitEnumNames ? '' : 'RPC_CONTAINER_POD_STOP');
  static const RPC RPC_CONTAINER_POD_START = RPC._(2022, _omitEnumNames ? '' : 'RPC_CONTAINER_POD_START');
  static const RPC RPC_CONTAINER_POD_KILL = RPC._(2023, _omitEnumNames ? '' : 'RPC_CONTAINER_POD_KILL');
  static const RPC RPC_CONTAINER_POD_KUBE_PLAY = RPC._(2024, _omitEnumNames ? '' : 'RPC_CONTAINER_POD_KUBE_PLAY');
  static const RPC RPC_CONTAINER_POD_KUBE_GENERATE = RPC._(2025, _omitEnumNames ? '' : 'RPC_CONTAINER_POD_KUBE_GENERATE');
  static const RPC RPC_CONTAINER_CREATE = RPC._(2026, _omitEnumNames ? '' : 'RPC_CONTAINER_CREATE');
  static const RPC RPC_CONTAINER_REMOVE = RPC._(2027, _omitEnumNames ? '' : 'RPC_CONTAINER_REMOVE');
  static const RPC RPC_CONTAINER_LIST = RPC._(2028, _omitEnumNames ? '' : 'RPC_CONTAINER_LIST');
  static const RPC RPC_CONTAINER_STOP = RPC._(2029, _omitEnumNames ? '' : 'RPC_CONTAINER_STOP');
  static const RPC RPC_CONTAINER_START = RPC._(2030, _omitEnumNames ? '' : 'RPC_CONTAINER_START');
  static const RPC RPC_CONTAINER_KILL = RPC._(2031, _omitEnumNames ? '' : 'RPC_CONTAINER_KILL');
  static const RPC RPC_CONTAINER_PRUNE = RPC._(2032, _omitEnumNames ? '' : 'RPC_CONTAINER_PRUNE');
  static const RPC RPC_CONTAINER_SETTING_REGISTRIES_LOAD = RPC._(2033, _omitEnumNames ? '' : 'RPC_CONTAINER_SETTING_REGISTRIES_LOAD');
  static const RPC RPC_CONTAINER_SETTING_REGISTRIES_SAVE = RPC._(2034, _omitEnumNames ? '' : 'RPC_CONTAINER_SETTING_REGISTRIES_SAVE');

  static const $core.List<RPC> values = <RPC> [
    RPC_SYSTEM_SHUTDOWN,
    RPC_SYSTEM_REBOOT,
    RPC_SYSTEM_ENVIRONMENT_LIST,
    RPC_SYSTEM_ENVIRONMENT_SET,
    RPC_SYSTEM_ENVIRONMENT_GET,
    RPC_SYSTEM_ENVIRONMENT_UNSET,
    RPC_SYSTEM_OS_TYPE,
    RPC_SYSTEM_TOTAL_MEMORY,
    RPC_SYSTEM_FREE_MEMORY,
    RPC_SYSTEM_USED_MEMORY,
    RPC_SYSTEM_CPU_INFORMATION,
    RPC_SYSTEM_CPU_CORE_COUNT,
    RPC_SYSTEM_SET_HOSTNAME,
    RPC_SYSTEM_GET_HOSTNAME,
    RPC_SYSTEM_SET_DATE_TIME,
    RPC_SYSTEM_SET_TIMEZONE,
    RPC_SYSTEM_FULL_INFORMATION,
    RPC_SYSTEM_ENVIRONMENT_UPDATE,
    RPC_SYSTEM_ENVIRONMENT_BATCH_SET,
    RPC_SYSTEM_KERNEL_PARAMETER_LIST,
    RPC_SYSTEM_KERNEL_PARAMETER_SET,
    RPC_SYSTEM_KERNEL_PARAMETER_UNSET,
    RPC_SYSTEM_KERNEL_PARAMETER_GET,
    RPC_SYSTEM_KERNEL_MODULE_LIST,
    RPC_SYSTEM_KERNEL_MODULE_LOAD,
    RPC_SYSTEM_KERNEL_MODULE_UNLOAD,
    RPC_SYSTEM_KERNEL_MODULE_INFO,
    RPC_JVM_VERSION,
    RPC_JVM_VENDOR,
    RPC_JVM_TOTAL_HEAP_SIZE,
    RPC_JVM_MAX_HEAP_SIZE,
    RPC_JVM_USED_HEAP_SIZE,
    RPC_JVM_GC,
    RPC_JVM_RESTART,
    RPC_CONFIG_BACKUP_CREATE,
    RPC_CONFIG_BACKUP_RESTORE,
    RPC_CONFIG_BACKUP_DELETE,
    RPC_CONFIG_BACKUP_LIST,
    RPC_CONFIG_PRINT,
    RPC_DATE_TIME_INFORMATION,
    RPC_DATE_TIME_SYNC_HCTOSYS,
    RPC_DATE_TIME_SYNC_SYSTOHC,
    RPC_NTP_SERVER_NAME,
    RPC_NTP_SYNC,
    RPC_NTP_ACTIVATE,
    RPC_NTP_INFORMATION,
    RPC_MODULE_LIST,
    RPC_MODULE_INSTALL,
    RPC_MODULE_REMOVE,
    RPC_MODULE_ENABLE,
    RPC_MODULE_DISABLE,
    RPC_MODULE_DEPENDENCIES,
    RPC_MODULE_START,
    RPC_MODULE_STOP,
    RPC_MODULE_STOP_ALL,
    RPC_MODULE_START_ALL,
    RPC_MODULE_INIT,
    RPC_NETWORK_ETHERNET_INFORMATION,
    RPC_NETWORK_ETHERNET_SET_IP,
    RPC_NETWORK_ETHERNET_UP,
    RPC_NETWORK_ETHERNET_DOWN,
    RPC_NETWORK_ETHERNET_FLUSH,
    RPC_NETWORK_ROUTE_LIST,
    RPC_NETWORK_ROUTE_ADD,
    RPC_NETWORK_ROUTE_DELETE,
    RPC_NETWORK_ROUTE_DEFAULT_GATEWAY,
    RPC_NETWORK_SET_DNS_NAMESERVER,
    RPC_NETWORK_GET_DNS_NAMESERVER,
    RPC_NETWORK_HOSTS_ADD,
    RPC_NETWORK_HOSTS_DELETE,
    RPC_NETWORK_HOSTS_LIST,
    RPC_NETWORK_NETWORK_ADD,
    RPC_NETWORK_NETWORK_DELETE,
    RPC_NETWORK_NETWORK_LIST,
    RPC_FILESYSTEM_LIST,
    RPC_FILESYSTEM_MOUNT,
    RPC_FILESYSTEM_UMOUNT,
    RPC_FILESYSTEM_SWAP_ON,
    RPC_FILESYSTEM_SWAP_OFF,
    RPC_FILESYSTEM_DIRECTORY_TREE,
    RPC_FILESYSTEM_DELETE_FILE,
    RPC_FILESYSTEM_MOVE_FILE,
    RPC_FILESYSTEM_CREATE_ARCHIVE,
    RPC_FILESYSTEM_EXTRACT_ARCHIVE,
    RPC_FILESYSTEM_CREATE_DIRECTORY,
    RPC_USER_LIST,
    RPC_USER_ADD,
    RPC_USER_REMOVE,
    RPC_USER_PASSWD,
    RPC_USER_LOCK,
    RPC_USER_UNLOCK,
    RPC_USER_UPDATE_ROLE,
    RPC_USER_REALM_LIST,
    RPC_LOG_APPENDER_LIST,
    RPC_LOG_APPENDER_ADD,
    RPC_LOG_APPENDER_REMOVE,
    RPC_LOG_SYSTEM,
    RPC_LOG_KERNEL,
    RPC_SSL_STATUS,
    RPC_SSL_JKS_UPLOAD,
    RPC_SSL_JKS_REMOVE,
    RPC_SSL_JKS_INFO,
    RPC_CONTAINER_IMAGE_PULL,
    RPC_CONTAINER_IMAGE_REMOVE,
    RPC_CONTAINER_IMAGE_LIST,
    RPC_CONTAINER_IMAGE_SEARCH,
    RPC_CONTAINER_IMAGE_PRUNE,
    RPC_CONTAINER_IMAGE_PULL_CANCEL,
    RPC_CONTAINER_NETWORK_CREATE,
    RPC_CONTAINER_NETWORK_REMOVE,
    RPC_CONTAINER_NETWORK_CONNECT,
    RPC_CONTAINER_NETWORK_DISCONNECT,
    RPC_CONTAINER_NETWORK_LIST,
    RPC_CONTAINER_VOLUME_CREATE,
    RPC_CONTAINER_VOLUME_LIST,
    RPC_CONTAINER_VOLUME_REMOVE,
    RPC_CONTAINER_VOLUME_PRUNE,
    RPC_CONTAINER_POD_CREATE,
    RPC_CONTAINER_POD_LIST,
    RPC_CONTAINER_POD_REMOVE,
    RPC_CONTAINER_POD_PRUNE,
    RPC_CONTAINER_POD_STATS,
    RPC_CONTAINER_POD_STOP,
    RPC_CONTAINER_POD_START,
    RPC_CONTAINER_POD_KILL,
    RPC_CONTAINER_POD_KUBE_PLAY,
    RPC_CONTAINER_POD_KUBE_GENERATE,
    RPC_CONTAINER_CREATE,
    RPC_CONTAINER_REMOVE,
    RPC_CONTAINER_LIST,
    RPC_CONTAINER_STOP,
    RPC_CONTAINER_START,
    RPC_CONTAINER_KILL,
    RPC_CONTAINER_PRUNE,
    RPC_CONTAINER_SETTING_REGISTRIES_LOAD,
    RPC_CONTAINER_SETTING_REGISTRIES_SAVE,
  ];

  static final $core.Map<$core.int, RPC> _byValue = $pb.ProtobufEnum.initByValue(values);
  static RPC? valueOf($core.int value) => _byValue[value];

  const RPC._($core.int v, $core.String n) : super(v, n);
}

///
/// Realm should be bitwise value
/// WARNING: DO NOT CHANGE THIS
class Realm extends $pb.ProtobufEnum {
  static const Realm REALM_NONE = Realm._(0, _omitEnumNames ? '' : 'REALM_NONE');
  static const Realm REALM_SYSTEM = Realm._(1, _omitEnumNames ? '' : 'REALM_SYSTEM');
  static const Realm REALM_JVM = Realm._(2, _omitEnumNames ? '' : 'REALM_JVM');
  static const Realm REALM_NTP_CLIENT = Realm._(4, _omitEnumNames ? '' : 'REALM_NTP_CLIENT');
  static const Realm REALM_DATE_TIME = Realm._(8, _omitEnumNames ? '' : 'REALM_DATE_TIME');
  static const Realm REALM_CONFIGURATION = Realm._(16, _omitEnumNames ? '' : 'REALM_CONFIGURATION');
  static const Realm REALM_ENVIRONMENT = Realm._(32, _omitEnumNames ? '' : 'REALM_ENVIRONMENT');
  static const Realm REALM_MODULE = Realm._(64, _omitEnumNames ? '' : 'REALM_MODULE');
  static const Realm REALM_NETWORK = Realm._(128, _omitEnumNames ? '' : 'REALM_NETWORK');
  static const Realm REALM_USER = Realm._(256, _omitEnumNames ? '' : 'REALM_USER');
  static const Realm REALM_LOG = Realm._(512, _omitEnumNames ? '' : 'REALM_LOG');
  static const Realm REALM_FILESYSTEM = Realm._(1024, _omitEnumNames ? '' : 'REALM_FILESYSTEM');
  static const Realm REALM_SSL = Realm._(2048, _omitEnumNames ? '' : 'REALM_SSL');
  static const Realm REALM_CONTAINER_ENGINE = Realm._(4096, _omitEnumNames ? '' : 'REALM_CONTAINER_ENGINE');
  static const Realm REALM_KERNEL = Realm._(8192, _omitEnumNames ? '' : 'REALM_KERNEL');

  static const $core.List<Realm> values = <Realm> [
    REALM_NONE,
    REALM_SYSTEM,
    REALM_JVM,
    REALM_NTP_CLIENT,
    REALM_DATE_TIME,
    REALM_CONFIGURATION,
    REALM_ENVIRONMENT,
    REALM_MODULE,
    REALM_NETWORK,
    REALM_USER,
    REALM_LOG,
    REALM_FILESYSTEM,
    REALM_SSL,
    REALM_CONTAINER_ENGINE,
    REALM_KERNEL,
  ];

  static final $core.Map<$core.int, Realm> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Realm? valueOf($core.int value) => _byValue[value];

  const Realm._($core.int v, $core.String n) : super(v, n);
}

class UploadType extends $pb.ProtobufEnum {
  static const UploadType UPLOAD_TYPE_MODULE = UploadType._(0, _omitEnumNames ? '' : 'UPLOAD_TYPE_MODULE');
  static const UploadType UPLOAD_TYPE_CONFIG = UploadType._(1, _omitEnumNames ? '' : 'UPLOAD_TYPE_CONFIG');
  static const UploadType UPLOAD_TYPE_SSL = UploadType._(2, _omitEnumNames ? '' : 'UPLOAD_TYPE_SSL');
  static const UploadType UPLOAD_TYPE_FILE = UploadType._(3, _omitEnumNames ? '' : 'UPLOAD_TYPE_FILE');

  static const $core.List<UploadType> values = <UploadType> [
    UPLOAD_TYPE_MODULE,
    UPLOAD_TYPE_CONFIG,
    UPLOAD_TYPE_SSL,
    UPLOAD_TYPE_FILE,
  ];

  static final $core.Map<$core.int, UploadType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static UploadType? valueOf($core.int value) => _byValue[value];

  const UploadType._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
