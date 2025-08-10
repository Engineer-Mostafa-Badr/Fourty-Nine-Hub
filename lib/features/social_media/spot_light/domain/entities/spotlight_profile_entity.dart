import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/features/social_media/spot_light/domain/entities/spotlight_media_entity.dart';

class SpotlightProfileEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String username;
  final String? profilePicture;
  final String? bio;
  final DateTime? birthDate;
  final String? zodiacSign;
  final bool isOnline;
  final int mutualFriendsCount;
  final int mediaCount;
  final List<SpotlightMediaEntity> recentMedia;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SpotlightProfileEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    this.profilePicture,
    this.bio,
    this.birthDate,
    this.zodiacSign,
    required this.isOnline,
    required this.mutualFriendsCount,
    required this.mediaCount,
    required this.recentMedia,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        username,
        profilePicture,
        bio,
        birthDate,
        zodiacSign,
        isOnline,
        mutualFriendsCount,
        mediaCount,
        recentMedia,
        createdAt,
        updatedAt,
      ];
}