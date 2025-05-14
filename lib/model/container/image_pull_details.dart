class ProgressDetail {
  int current;
  int total;

  ProgressDetail(this.current, this.total);

  factory ProgressDetail.fromMap(Map<String, dynamic> map) {
    var current = map['current'];
    var total = map['total'];
    return ProgressDetail(current, total);
  }
}

class ImagePullDetails {
  String name;
  String id;
  String status;
  ProgressDetail progressDetail;

  ImagePullDetails(this.name, this.id, this.status, this.progressDetail);

  factory ImagePullDetails.fromMap(Map<String, dynamic> map) {
    var name = map['name'];
    var id = map['id'];
    var status = map['status'];
    var progressDetail = ProgressDetail.fromMap(map['progressDetail']);

    return ImagePullDetails(name, id, status, progressDetail);
  }
}
