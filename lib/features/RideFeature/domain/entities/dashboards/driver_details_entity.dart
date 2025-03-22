import 'package:equatable/equatable.dart';

class DriverDetailsEntity extends Equatable {
  final String id;
  final String subscriptionType;
  final bool isActive;

  const DriverDetailsEntity({
    required this.id,
    required this.subscriptionType,
    required this.isActive,
  });

  @override
  List<Object?> get props => [id, subscriptionType, isActive];
}
