import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'edit_page_state.dart';

class EditPageCubit extends Cubit<EditPageState> {
  EditPageCubit() : super(EditPageInitial());
  int currentIndex = 0;
  void changePage(int index) {
    emit(EditPageInitial());

    currentIndex = index;
    emit(EditPageIndexChanged());
  }
}
