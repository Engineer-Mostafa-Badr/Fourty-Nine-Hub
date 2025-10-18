class ViewerEntity {
  final String id;
  final String name;
  final String profileImage;
  final DateTime viewTime;

  ViewerEntity({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.viewTime,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ViewerEntity &&
        other.id == id &&
        other.name == name &&
        other.profileImage == profileImage &&
        other.viewTime == viewTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        profileImage.hashCode ^
        viewTime.hashCode;
  }
}
