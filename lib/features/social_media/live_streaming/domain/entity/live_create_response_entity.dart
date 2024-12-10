// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class LiveCreateResponseEntity extends Equatable {
  final String id;
  final String streamId;

  const LiveCreateResponseEntity({required this.id,required this.streamId});

  @override
  List<Object> get props {
    return [id,streamId];
  }
}
