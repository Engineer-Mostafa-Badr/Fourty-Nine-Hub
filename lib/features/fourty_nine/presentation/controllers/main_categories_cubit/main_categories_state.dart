part of 'main_categories_cubit.dart';

class MainCategoriesState {
  final StateStatus status;
  final Failure? failure;
  final int selectedIndex;
  final CurrencyEntity? currency;
  final List<MainCategoryEntity>? data;
  final List<MainCategoryEntity>? customPage;
  final List<SliderItemEntity>? sliders;
  final MainCategoryEntity? marriageMainCategory;
  final WalletHomeEntity? wallet;
  final QuestionEntity? question;
  final SettingsDashboardEntityResponse? setting;
  final bool? isDriverLady;
  MainCategoriesState({
    this.status = StateStatus.initial,
    this.failure,
    this.currency,
    this.marriageMainCategory,
    this.selectedIndex = 0,
    this.data,
    this.customPage,
    this.question,
    this.wallet,
    this.setting,
    this.sliders,
    this.isDriverLady,
  });

  MainCategoriesState copyWith({
    StateStatus? status,
    Failure? failure,
    int? selectedIndex,
    CurrencyEntity? currency,
    WalletHomeEntity? wallet,
    QuestionEntity? question,
    MainCategoryEntity? marriageMainCategory,
    List<MainCategoryEntity>? data,
    List<SliderItemEntity>? sliders,
    List<MainCategoryEntity>? customPage,
    bool? isDriverLady,
    SettingsDashboardEntityResponse? setting,
  }) {
    return MainCategoriesState(
      status: status ?? this.status,
      isDriverLady: isDriverLady ?? this.isDriverLady,
      currency: currency ?? this.currency,
      failure: failure ?? this.failure,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      data: data ?? this.data,
      customPage: customPage ?? this.customPage,
      wallet: wallet ?? this.wallet,
      question: question ?? this.question,
      marriageMainCategory: marriageMainCategory ?? this.marriageMainCategory,
      setting: setting ?? this.setting,
      sliders: sliders ?? this.sliders,
    );
  }
}
