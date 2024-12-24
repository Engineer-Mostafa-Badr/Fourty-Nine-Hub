import 'package:equatable/equatable.dart';

class MembersEntity extends Equatable {
  final String id;
  final String name;
  final int points;

  const MembersEntity(this.id, this.name, this.points);
  @override
  List<Object> get props => [id, name, points];
}
