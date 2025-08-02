import 'package:equatable/equatable.dart';

class FirebaseUserEntity extends Equatable {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final bool isEmailVerified;
  final String? phoneNumber;
  final DateTime? creationTime;
  final DateTime? lastSignInTime;

  const FirebaseUserEntity({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    required this.isEmailVerified,
    this.phoneNumber,
    this.creationTime,
    this.lastSignInTime,
  });

  @override
  int get hashCode => uid.hashCode;

  @override
  List<Object?> get props => [
        uid,
        email,
        displayName,
        photoURL,
        isEmailVerified,
        phoneNumber,
        creationTime,
        lastSignInTime
      ];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FirebaseUserEntity && other.uid == uid;
  }
}
