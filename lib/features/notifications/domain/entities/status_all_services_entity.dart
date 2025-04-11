import 'package:equatable/equatable.dart';

class StatusAllServicesEntity extends Equatable {
  final String rideRegistration;
  final String shippingRegistration;
  final String restaurantRegistration;
  final String healthRegistration;
  final String adsRegistration;
  final String companyAdsRegistration;
  final String talentRegistration;
  final String yellowCardStatus;
  final String billsStatus;
  final String helpStatus;
  final String cashbackWithdrawStatus;
  final String walletWithdrawStatus;
  final String reportStatus;
  final String giftTransfer;

  const StatusAllServicesEntity({
    required this.rideRegistration,
    required this.shippingRegistration,
    required this.restaurantRegistration,
    required this.healthRegistration,
    required this.adsRegistration,
    required this.companyAdsRegistration,
    required this.talentRegistration,
    required this.yellowCardStatus,
    required this.billsStatus,
    required this.helpStatus,
    required this.cashbackWithdrawStatus,
    required this.walletWithdrawStatus,
    required this.reportStatus,
    required this.giftTransfer,
  });

  @override
  List<Object?> get props => [
        rideRegistration,
        shippingRegistration,
        restaurantRegistration,
        healthRegistration,
        adsRegistration,
        companyAdsRegistration,
        talentRegistration,
        yellowCardStatus,
        billsStatus,
        helpStatus,
        cashbackWithdrawStatus,
        walletWithdrawStatus,
        reportStatus,
        giftTransfer,
      ];
}
