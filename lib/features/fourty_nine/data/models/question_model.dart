import 'package:fourtyninehub/features/fourty_nine/domain/entities/question_entity.dart';

class QuestionModel extends QuestionEntity{
  QuestionModel({required super.id, required super.messageEn, required super.messageAr, required super.enableAnswers, required super.openInfoOrQuestions,});

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
    id: json['_id']??'',
    messageEn: json['message']!=null?json['message']['en']:'',
    messageAr: json['message']!=null?json['message']['ar']:'',
    enableAnswers: json['enableAnswers']??false,
    openInfoOrQuestions: json['openInfosOrQuestions']??false,
  );}