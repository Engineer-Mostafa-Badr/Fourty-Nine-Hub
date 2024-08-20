import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'quraan_state.dart';

class QuraanCubit extends Cubit<QuraanState> {
  QuraanCubit() : super(QuraanInitial());
}
