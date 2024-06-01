import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'subcategories_state.dart';

class SubcategoriesCubit extends Cubit<SubcategoriesState> {
  SubcategoriesCubit() : super(SubcategoriesInitial());
}
