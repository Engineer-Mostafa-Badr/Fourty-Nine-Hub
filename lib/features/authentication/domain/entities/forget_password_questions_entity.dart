import 'package:equatable/equatable.dart';

class ForgetPasswordQuestionsEntity extends Equatable {
  final bool withQuestions;
  final Questions questions;
  final String userId;

  const ForgetPasswordQuestionsEntity({
    required this.withQuestions,
    required this.questions,
    required this.userId,
  });

  @override
  List<Object> get props => [
        withQuestions,
        questions,
        userId,
      ];
}

class Questions extends Equatable {
  final List<String> questionsAr;
  final List<String> questionsEn;

  const Questions({required this.questionsAr, required this.questionsEn});

  @override
  List<Object> get props => [
        questionsAr,
        questionsEn,
      ];
}
