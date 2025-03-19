import 'package:equatable/equatable.dart';

class CarTypeEntity extends Equatable {
  final String id;
  final String brand;
  final String model;

  const CarTypeEntity(
      {required this.id, required this.brand, required this.model});

  @override
  List<Object?> get props => [id, brand, model];
}
