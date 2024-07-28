import '../../domain/entities/installment_request_entity.dart';

class InstallmentRequestModel extends InstallmentRequestEntity {
  InstallmentRequestModel(
      { super.id,
      required super.installmentId,
      required super.downPayment,
      required super.installment,
      required super.duration,
       super.userId,
       super.isApproved,
      super.createdAt});

  factory InstallmentRequestModel.fromJson(Map<String, dynamic> json) {
    return InstallmentRequestModel(
      id: json['_id'],
      installmentId: json['installment_id'],
      downPayment: json['start_price'],
      installment: json['financial_payment'],
      duration: json['number_months'],
      userId: json['user_id'] ?? '',
      isApproved: json['is_approved'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
  Map<String, dynamic> toJson() => {
     "start_price" : downPayment,
    "number_months" : duration,
    "financial_payment" : installment
  };
}
