import 'dart:convert';
import 'dart:typed_data';

class Graph {
  final String name;
  final Uint8List bytes;

  const Graph(this.name, this.bytes);

  factory Graph.fromMap(Map<String, dynamic> json) {
    var name = json['name'];
    var bytes = base64Decode(json['bytes']);
    return Graph(name, bytes);
  }
}
