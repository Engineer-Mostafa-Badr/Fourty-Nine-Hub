import 'package:equatable/equatable.dart';

class GiftMessageEntity extends Equatable {
  final String ar;
  final String en;

  const GiftMessageEntity({required this.ar, required this.en});

  @override
  List<Object?> get props => [ar, en];
}
