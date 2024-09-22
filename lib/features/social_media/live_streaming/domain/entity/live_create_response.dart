// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class LiveCreateResponse extends Equatable {
final String id;
final String liveTitle;
final List<String> tags;
//object will be changed
final List<Object> liveGoals;
  const LiveCreateResponse({
    required this.id,
    required this.liveTitle,
    required this.tags,
    required this.liveGoals,
  });


  @override
  List<Object> get props => [id, liveTitle, tags, liveGoals];
}
