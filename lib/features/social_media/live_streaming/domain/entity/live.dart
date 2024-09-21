// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../../../tinder/data/models/gift_model.dart';

class LiveEntity extends Equatable {
  final String id;
  final String title;
  final String topic;
  final List<GiftApi> gift;
  const LiveEntity({
    required this.id,
    required this.title,
    required this.topic,
    required this.gift,
  });

  @override
  List<Object> get props => [id, title, topic, gift];
}
