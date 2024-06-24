part of 'subcategories_cubit.dart';

class SubcategoriesState {
  final Failure? failure;
  final SubcategoriesStates status;
  final List<SubCategoryEntity>? subCategories;
  const SubcategoriesState(
      {this.failure,
      this.subCategories,
      this.status = SubcategoriesStates.loading});

  SubcategoriesState copyWith({
       Failure? failure,
   SubcategoriesStates? status,
   List<SubCategoryEntity>? subCategories,

  }) {
    return SubcategoriesState(
      failure: failure?? this.failure,
      status: status?? this.status,
      subCategories: subCategories?? this.subCategories,
    );
  }
}

enum SubcategoriesStates { loading, initState, error }

extension SubcategoriesStateX on SubcategoriesState {
  bool get isLoading => status == SubcategoriesStates.loading;
  bool get isInitState => status == SubcategoriesStates.initState;
  bool get isError => status == SubcategoriesStates.error;
}
