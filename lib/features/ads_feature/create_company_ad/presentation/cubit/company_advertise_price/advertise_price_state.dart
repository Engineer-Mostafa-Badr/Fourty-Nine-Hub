import 'package:fourtyninehub/features/ads_feature/create_company_ad/data/models/company_price_model.dart';

import '../../../data/models/company_advertise_model.dart';

abstract class AdvertisePriceState{}

class AdvertisePriceInitial extends AdvertisePriceState{}
class AdvertisePriceLoading extends AdvertisePriceState{}
class AdvertisePriceSuccess extends AdvertisePriceState{
  final AdvertisePriceModel advertisePriceModel;

  AdvertisePriceSuccess({required this.advertisePriceModel});
}
class AdvertisePriceError extends AdvertisePriceState{
  final String errMessage;

  AdvertisePriceError({required this.errMessage});
}

class AdvertiseSuccess extends AdvertisePriceState{}