import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import '../../../../../core/error/failure.dart';
import '../../domain/entities/company_ad_option_entity.dart';
import '../../domain/entities/price_entity.dart';
import '../../domain/usecases/get_company_add_use_case.dart';
import '../../domain/usecases/get_price_use_case.dart';

part 'create_company_ad_state.dart';

class CreateCompanyAdCubit extends Cubit<CreateCompanyAdState> {
  final GetPriceUseCases _getPriceUseCases;
  final GetCompanyAddUseCases _companyAddUseCases;

  CreateCompanyAdCubit(this._getPriceUseCases, this._companyAddUseCases)
      : super(const CreateCompanyAdState());

  void loadData() async {
    await getCompanyAdPrice();
  }

  Future<void> getCompanyAdPrice() async {
    final response = await _getPriceUseCases.call(const NoParams());
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (data) => emit(state.copyWith(price: data)));
  }

  Future<void> addPostCompanyAdvertise({
    String? post,
    required String type,
    String? description,
    required int totalPrice,
    List<String>? mediaIds, // Make sure this is used correctly
  }) async {
    var response = await _companyAddUseCases(
      CompanyAddParams(
          advertisementType: type,
          totalPrice: totalPrice,
          media: mediaIds,
          description: description,
          post: post,
      ),
    );

    return response.fold(
          (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
            (data) {
              emit(state.copyWith(advertise: data,status: StateStatus.success));
              mediaIds?.clear();
              print('Media IDs cleared after successful post.');
            }
    );
    // var result = await companyAdvertiseRepo.addPostCompanyAdvertise(
    //   type: type,
    //   totalPrice: totalPrice,
    //   post: post,
    //   description: description,
    //   mediaIds: mediaIds, // Pass mediaIds here
    // );
    //
    // result.fold((failure) {
    //   emit(AddCompanyAdvertiseError(
    //       errMessage: getFailureMessage(failure, context)));
    //   print('Error: ${getFailureMessage(failure, context)}');
    // }, (_) {
    //   emit(AddCompanyAdvertiseSuccess());
    //   mediaIds?.clear(); // Clear the mediaIds if needed after successful post
    //   print('Media IDs cleared after successful post.');
    // });
  }

// bool optionSelected(CompanyAdOptionEntity option) {
//   return state.selectedOptions?.contains(option) ?? false;
// }
//
// num totalPrice() {
//   num total = 0;
//   for (CompanyAdOptionEntity item in state.selectedOptions ?? []) {
//     total += item.price;
//   }
//   return total;
// }
//
// void onSelection(CompanyAdOptionEntity option) {
//   final list = state.selectedOptions ?? [];
//   if (optionSelected(option)) {
//     list.remove(option);
//   } else {
//     list.add(option);
//   }
//   emit(state.copyWith(
//     selectedOptions: list,
//   ));
// }
}
