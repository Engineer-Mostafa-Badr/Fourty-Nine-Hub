import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'transfer_money_state.dart';

class TransferMoneyCubit extends Cubit<TransferMoneyState> {
  TransferMoneyCubit() : super(TransferMoneyInitial());
}
