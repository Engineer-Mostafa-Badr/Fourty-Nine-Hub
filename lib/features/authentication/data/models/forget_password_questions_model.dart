import '../../domain/entities/forget_password_questions_entity.dart';

class ForgetPasswordQuestionsModel extends ForgetPasswordQuestionsEntity {
  const ForgetPasswordQuestionsModel({
    required super.withQuestions,
    required super.questions,
    required super.userId,
  });

  factory ForgetPasswordQuestionsModel.fromJson(Map<String, dynamic> json) {
    return ForgetPasswordQuestionsModel(
      withQuestions: json['withQuestions'],
      questions: QuestionsModel.fromJson(json['questions']),
      userId: json['userId'],
    );
  }
}

class QuestionsModel extends Questions {
  const QuestionsModel({
    required super.questionsAr,
    required super.questionsEn,
  });

  factory QuestionsModel.fromJson(Map<String, dynamic> json) {
    return QuestionsModel(
      questionsAr: json['ar'].cast<String>(),
      questionsEn: json['en'].cast<String>(),
    );
  }
}
