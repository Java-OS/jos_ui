
class ContainerImage {
  final String? id;
  final String? parentId;
  final int? size;
  final int? containers;
  final String name;
  final String? digest;

  ContainerImage(this.id, this.parentId, this.size, this.containers, this.name, this.digest);

  factory ContainerImage.fromMap(Map<String, dynamic> map) {
    var id = map['Id'] ?? '';
    var parentId = map['ParentId'] ?? '';
    var size = map['Size'] ?? 0;
    var containers = map['Containers'] ?? 0;
    var name = map['Names'] != null ? map['Names'][0] : 'NONE';
    var digest = map['Digest'] ?? '';

    return ContainerImage(id, parentId, size, containers, name, digest);
  }
}
