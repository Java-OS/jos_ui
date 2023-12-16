class EthernetStatistic {
  String rxBytes;
  String rxErrors;
  String rxPkts;
  String txBytes;
  String txErrors;
  String txPkts;

  EthernetStatistic({required this.rxBytes, required this.rxErrors, required this.rxPkts, required this.txBytes, required this.txErrors, required this.txPkts});

  factory EthernetStatistic.fromJson(Map<String, dynamic> jsonObject) {
    return EthernetStatistic(
      rxBytes: jsonObject['rx_bytes'].toString(),
      rxErrors: jsonObject['rx_errors'].toString(),
      rxPkts: jsonObject['rx_pkts'].toString(),
      txBytes: jsonObject['tx_bytes'].toString(),
      txErrors: jsonObject['tx_errors'].toString(),
      txPkts: jsonObject['tx_pkts'].toString(),
    );
  }
}
