class ImageSearch {
  final String index;
  final String name;
  final String description;
  final int stars;
  final String official;
  final String automated;
  String tag;

  ImageSearch(this.index, this.name, this.description, this.stars, this.official, this.automated, this.tag);

  factory ImageSearch.fromMap(Map<String, dynamic> map) {
    var index = map['Index'];
    var name = map['Name'];
    var description = map['Description'] ?? '';
    var stars = map['Stars'] as int;
    var official = map['Official'] ?? '';
    var automated = map['Automated'] ?? '';
    var tag = map['Tag'] ?? '';

    return ImageSearch(index, name, description, stars, official, automated, tag);
  }
}
