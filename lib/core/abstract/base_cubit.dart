import 'package:bloc/bloc.dart';

abstract class BaseCubit<T> extends Cubit<T> {
  BaseCubit(super.initialState);
  @override
  void emit(T state) {
    if (isClosed) return;
    super.emit(state);
  }
}
