class QuestionEntity{
  final String id;
  final String messageEn;
  final String messageAr;
  final bool enableAnswers;
  final bool openInfoOrQuestions;
  QuestionEntity({required this.id, required this.messageEn, required this.messageAr, required this.enableAnswers, required this.openInfoOrQuestions,});

  //toJson
  Map<String, dynamic> toJson() => {
    'id': id,
    'messageEn': messageEn,
    'messageAr': messageAr,
    'enableAnswers': enableAnswers,
    'openInfoOrQuestions': openInfoOrQuestions,
  };
}