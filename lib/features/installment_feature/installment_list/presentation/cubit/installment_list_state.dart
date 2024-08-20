part of 'installment_list_cubit.dart';

enum InstallmentListStates { loading, error, initState }

extension InstallmentListStateX on InstallmentListState {
  bool get isLoading => status == InstallmentListStates.loading;
  bool get isError => status == InstallmentListStates.error;
  bool get isInitState => status == InstallmentListStates.initState;
}

class InstallmentListState {
  final InstallmentListStates status;
  final Failure? failure;
  final List<InstallmentEntity>? installments;
  final List<SubCategoryEntity>? subCategories;
  final SubCategoryEntity? selectedSubCategory;
  final bool isGrid;
  const InstallmentListState(
      {this.failure,
      this.installments,
      this.subCategories,
      this.selectedSubCategory,
      this.status = InstallmentListStates.loading,
      this.isGrid = true});

  InstallmentListState copyWith(
      {InstallmentListStates? status,
      Failure? failure,
      List<InstallmentEntity>? installments,
      List<SubCategoryEntity>? subCategories,
      SubCategoryEntity? selectedSubCategory,
      bool? isGrid}) {
    return InstallmentListState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      subCategories: subCategories ?? this.subCategories,
      selectedSubCategory: selectedSubCategory ?? this.selectedSubCategory,
      installments: installments ?? this.installments,
      isGrid: isGrid ?? this.isGrid,
    );
  }
}
