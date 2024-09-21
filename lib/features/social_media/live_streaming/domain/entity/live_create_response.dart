// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class LiveCreateResponse extends Equatable {
  final String id;

  const LiveCreateResponse({required this.id});

  @override
  List<Object> get props => [id];
}
