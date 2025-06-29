class ArrivedToClientEntity {
  final String tripId;
  final String message;

  ArrivedToClientEntity({required this.tripId, required this.message});

  //toJson
  Map<String, dynamic> toJson() => {'message': message};
}