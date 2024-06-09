import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'lists_state.dart';

class ListsCubit extends Cubit<ListsState> {
  ListsCubit() : super(ListsInitial());
}
