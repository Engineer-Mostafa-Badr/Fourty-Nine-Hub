import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String? email;
  final String? profilePicture;
  final String? profileCover;
  final int? friendsCount;
  final int? followersCount;
  final int? followingCount;
  final bool? isRider;
  final bool? isDoctor;
  final bool? isRestaurant;
  final bool? isLoading;
  final bool? isDocument;

  String get fullName => '$firstName $lastName';
  bool isMyAccount(String anotherId) {
    return id == anotherId;
  }

  const UserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profilePicture,
    required this.profileCover,
    required this.friendsCount,
    required this.followersCount,
    required this.followingCount,
    this.isRider=false,
    this.isDoctor=false,
    this.isRestaurant=false,
    this.isLoading=false,
    this.isDocument=false,
  });

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        profilePicture,
        profileCover,
        friendsCount,
        followersCount,
        followingCount
      ];
}
