part of 'create_company_ad_cubit.dart';

 class CreateCompanyAdState {
  final StateStatus status;
  final Failure? failure;
  final List<CompanyAdEntity>? adOptions;
  final List<CompanyAdOptionEntity>? selectedOptions;
  const CreateCompanyAdState({
    this.status = StateStatus.loading,
    this.failure,
    this.adOptions,
    this.selectedOptions,
  });
  CreateCompanyAdState copyWith({
      StateStatus? status,
   Failure? failure,
   List<CompanyAdEntity>? adOptions,
   List<CompanyAdOptionEntity>? selectedOptions,
  }) {
    return CreateCompanyAdState(
      status: status?? this.status, 
      failure: failure?? this.failure, 
      adOptions: adOptions?? this.adOptions, 
      selectedOptions:  selectedOptions?? this.selectedOptions,
    );
  }
}
