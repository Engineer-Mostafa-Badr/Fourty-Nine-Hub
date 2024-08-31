import '../../../data/models/company_advertise_model.dart';

abstract class CompanyAdvertiseState{}

class CompanyAdvertiseInitial extends CompanyAdvertiseState{}

class AddCompanyAdvertiseLoading extends CompanyAdvertiseState{}
class AddCompanyAdvertiseSuccess extends CompanyAdvertiseState{}
class AddCompanyAdvertiseError extends CompanyAdvertiseState{
  final String errMessage;

  AddCompanyAdvertiseError({required this.errMessage});
}

class FetchAllCompanyAdvertiseLoading extends CompanyAdvertiseState{}
class FetchAllCompanyAdvertiseSuccess extends CompanyAdvertiseState{
  final AdvertiseCompanyModel advertiseCompanyModel;

  FetchAllCompanyAdvertiseSuccess({required this.advertiseCompanyModel});
}
class FetchAllCompanyAdvertiseError extends CompanyAdvertiseState{
  final String errMessage;

  FetchAllCompanyAdvertiseError({required this.errMessage});
}