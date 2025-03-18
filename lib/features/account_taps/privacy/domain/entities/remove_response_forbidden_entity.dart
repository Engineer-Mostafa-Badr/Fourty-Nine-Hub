
class RemoveForbiddenDataEntity {
  final String? feature;
  final String? privacyOption;
  final List<String>? forbiddenUsers;
  final List<String>? removedUsers;

  RemoveForbiddenDataEntity({
    this.feature,
    this.privacyOption,
    this.forbiddenUsers,
    this.removedUsers,
  });
}
