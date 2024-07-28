class InstallmentRequestEntity{
  final String? id;
  final String installmentId;
  final num downPayment;
  final num installment;
  final num duration;
  final String? userId;
  final bool? isApproved;
  final DateTime? createdAt;
  InstallmentRequestEntity(
    {
       this.id, 
      required this.installmentId, 
      required this.downPayment, 
      required this.installment, 
      required this.duration, 
       this.userId, 
       this.isApproved, 
       this.createdAt, 

    }
  );
}




