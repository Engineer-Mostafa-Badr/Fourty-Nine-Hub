import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/entities/company_ad_entity.dart';

import '../../../../../core/error/failure.dart';
import '../../domain/entities/company_ad_option_entity.dart';
import '../../domain/usecases/get_company_ads_options_usecase.dart';

part 'create_company_ad_state.dart';

class CreateCompanyAdCubit extends Cubit<CreateCompanyAdState> {
  final GetCompanyAdsOptionsUseCase _getCompanyAdsOptionsUseCase;

  CreateCompanyAdCubit(this._getCompanyAdsOptionsUseCase)
      : super(const CreateCompanyAdState());

  void loadData() async {
    await getCompanyAdOptions();
  }

  Future<void> getCompanyAdOptions() async {
    final response = await _getCompanyAdsOptionsUseCase(const NoParams());
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (data) =>
            emit(state.copyWith(adOptions: data, status: StateStatus.initial)));
  }

  bool optionSelected(CompanyAdOptionEntity option) {
    return state.selectedOptions?.contains(option) ?? false;
  }

  num totalPrice() {
    num total = 0;
    for (CompanyAdOptionEntity item in state.selectedOptions ?? []) {
      total += item.price;
    }
    return total;
  }

  void onSelection(CompanyAdOptionEntity option) {
    final list = state.selectedOptions ?? [];
    if (optionSelected(option)) {
      list.remove(option);
    } else {
      list.add(option);
    }
    emit(state.copyWith(
      selectedOptions: list,
    ));
  }
}
