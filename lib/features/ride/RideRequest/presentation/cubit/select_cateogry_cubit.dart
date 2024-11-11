import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class SelectCateogryCubit extends Cubit<RiderState> {
  SelectCateogryCubit() : super(RiderInitial());
  select({required String id, required int type}) {
    emit(SuccessSelectCateogryState(id: id, type: type));
  }
}
