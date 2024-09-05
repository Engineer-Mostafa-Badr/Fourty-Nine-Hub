import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import '../../../../../core/error/failure.dart';
import '../../domain/entities/price_entity.dart';
import '../../domain/usecases/get_price_use_case.dart';

part 'create_company_ad_state.dart';

class CreateCompanyAdCubit extends Cubit<CreateCompanyAdState> {
  final GetPriceUseCases _getPriceUseCases;

  CreateCompanyAdCubit(this._getPriceUseCases)
      : super(const CreateCompanyAdState());

  void loadData() async {
    await getCompanyAdPrice();
  }

  Future<void> getCompanyAdPrice() async {
    final response = await _getPriceUseCases.call(const NoParams());
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (data) =>
            emit(state.copyWith(price: data)));
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
