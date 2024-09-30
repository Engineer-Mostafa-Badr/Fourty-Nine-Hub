class DisableEntity {
  final String? id;
  final String? firstName;
  final String? username;
  final bool isDisabled;

  DisableEntity(
      { this.id,
       this.firstName,
       this.username,
      required this.isDisabled});

  DisableEntity copyWith({bool? isDisabled}) {
    return DisableEntity(
      isDisabled: isDisabled ?? this.isDisabled,
    );
  }
}
