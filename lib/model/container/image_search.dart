class ImageSearch {
  final String index;
  final String name;
  final String description;
  final String stars;
  final String official;
  final String automated;
  String tag;

  ImageSearch(this.index, this.name, this.description, this.stars, this.official, this.automated, this.tag);

  factory ImageSearch.fromMap(Map<String, dynamic> json) {
    var index = json['Index'];
    var name = json['Name'];
    var description = json['Description'] ?? '';
    var stars = json['Stars'];
    var official = json['Official'] ?? '';
    var automated = json['Automated'] ?? '';
    var tag = json['Tag'] ?? '';

    return ImageSearch(index, name, description, stars, official, automated, tag);
  }
}
