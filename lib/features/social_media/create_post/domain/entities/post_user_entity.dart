class PostUserEntity  {
  final String id;
  final String firstName;
  final String lastName;
  final String? profilePicture;
  bool? isSelected;

  String get fullName => '$firstName $lastName';
  bool  isMyAccount(String anotherId){
    return id == anotherId;
  }
  PostUserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
    this.isSelected=false,
  });


}
