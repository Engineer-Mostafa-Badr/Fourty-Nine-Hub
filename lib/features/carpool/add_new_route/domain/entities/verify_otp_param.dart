class VerifyOtpParam {
  final String otp;
  final String userId;
  List<double> driverLocation;

  VerifyOtpParam({
    required this.otp,
    required this.userId,
    required this.driverLocation,
  });

  Map<String, dynamic> toMap() {
    return {
      'otp': otp,
      'userId': userId,
      'driverLocation': driverLocation,
    };
  }
}
