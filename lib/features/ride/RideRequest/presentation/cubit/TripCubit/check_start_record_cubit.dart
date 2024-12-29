import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class CheckStartRecordCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  CheckStartRecordCubit({required this.repository}) : super(RiderInitial());
  checkStart() {
    repository.checkStartRecord(
      () {
        emit(SuccessStartRecordState());
      },
    );
  }
}
