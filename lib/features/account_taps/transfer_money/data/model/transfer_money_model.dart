import 'package:fourtyninehub/features/account_taps/transfer_money/domain/entities/transfer_money_entity.dart';

class TransferMoneyModel extends TransferMoneyEntity {
  TransferMoneyModel(
      {required super.from,
      required super.fromUsername,
      required super.to,
      required super.toUsername,
      required super.amount,
      required super.currency,
      required super.date,
      required super.fromEmail,
      required super.toEmail,
      });

  factory TransferMoneyModel.fromJson(Map<String, dynamic> json) {
    return TransferMoneyModel(
      from: json['from'] ??'',
      fromUsername: json['fromUsername'] ??'',
      fromEmail: json['fromEmail'] ??'',
      to: json['to'] ??'',
      toUsername: json['toUsername'] ??'',
      toEmail: json['toEmail'] ??'',
      amount: json['amount'] ??0,
      currency: json['currency'] ??'',
      date: json['date'] ??'',
    );
  }
}
