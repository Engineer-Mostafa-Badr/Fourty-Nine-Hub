import '../../domain/entities/status_all_services_entity.dart';

class StatusAllServicesModel extends StatusAllServicesEntity {
  const StatusAllServicesModel(
      {required super.rideRegistration,
      required super.shippingRegistration,
      required super.restaurantRegistration,
      required super.healthRegistration,
      required super.adsRegistration,
      required super.companyAdsRegistration,
      required super.talentRegistration,
      required super.yellowCardStatus,
      required super.billsStatus,
      required super.helpStatus,
      required super.cashbackWithdrawStatus,
      required super.walletWithdrawStatus,
      required super.reportStatus,
      required super.giftTransfer});

  factory StatusAllServicesModel.fromJson(Map<String, dynamic> json) {
    return StatusAllServicesModel(
        rideRegistration: json['RideRegistration'],
        shippingRegistration: json['ShippingRegistration'],
        restaurantRegistration: json['RestaurantRegistration'],
        healthRegistration: json['HealthRegistration'],
        adsRegistration: json['AdsRegistration'],
        companyAdsRegistration: json['CompanyAdsRegistration'],
        talentRegistration: json['TalentRegistration'],
        yellowCardStatus: json['YellowCardStatus'],
        billsStatus: json['BillsStatus'],
        helpStatus: json['HelpStatus'],
        cashbackWithdrawStatus: json['CashbackWithdrawStatus'],
        walletWithdrawStatus: json['WalletWithdrawStatus'],
        reportStatus: json['ReportStatus'],
        giftTransfer: json['GiftTransfer']);
  }
}
