import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String? username;
  final String firstName;
  final String lastName;
  final String? email;
  final String? bio;
  final String? phone;
  final String? city;
  final String? country;
  final String? job;
  final String? gender;
  final String? profilePicture;
  final String? profileCover;
  final int? friendsCount;
  final int? followersCount;
  final int? followingCount;
  final num? wallet;
  final bool? isRider;
  final bool? isDoctor;
  final bool? isRestaurant;
  final bool? isLoading;
  final bool? isDocument;
  final bool? isAccountVerified;
  final String? firebaseToken;
  final bool isGuest;
  final UserType userType;

  // Existing
  final DateTime? birthday;

  // NEW
  final int? profileViews;     // ← add this
  final DateTime? joinedAt;    // ← optional, if your API sends "joinedAt"

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
    required this.wallet,
    this.username,
    this.isRider = false,
    this.isDoctor = false,
    this.isRestaurant = false,
    this.isLoading = false,
    this.isDocument = false,
    this.isAccountVerified = false,
    this.bio,
    this.phone,
    this.city,
    this.country,
    this.job,
    this.gender,
    this.firebaseToken,
    this.birthday,
    this.isGuest = false,
    this.userType = UserType.authenticated,
    // NEW
    this.profileViews,
    this.joinedAt,
  });

  factory UserEntity.guest() {
    return const UserEntity(
      id: 'guest_user',
      firstName: 'ضيف',
      lastName: '',
      email: null,
      profilePicture: null,
      profileCover: null,
      friendsCount: 0,
      followersCount: 0,
      followingCount: 0,
      wallet: 0,
      isGuest: true,
      userType: UserType.guest,
       profileViews: 0,
      joinedAt: null,
    );
  }

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [
    id,
    username,
    firstName,
    lastName,
    email,
    profilePicture,
    profileCover,
    friendsCount,
    followersCount,
    followingCount,
    wallet,
    firebaseToken,
    birthday,
    isAccountVerified,
    isGuest,
    userType,
     profileViews,
    joinedAt,
    gender,
  ];

  bool isMyAccount(String anotherId) {
    return id == anotherId;
  }
}

enum UserType { guest, authenticated, anonymous }
