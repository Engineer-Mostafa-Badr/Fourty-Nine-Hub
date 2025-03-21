class TransferMoneyEntity {
  final String from;
  final String fromUsername;
  final String fromEmail;
  final String to;
  final String toUsername;
  final String toEmail;
  final num amount;
  final String currencyEn;
  final String currencyAr;
  final String date;

  TransferMoneyEntity({
    required this.from,
    required this.fromUsername,
    required this.to,
    required this.toUsername,
    required this.amount,
    required this.currencyEn,
    required this.currencyAr,
    required this.date,
    required this.fromEmail,
    required this.toEmail,
  });
}
