import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/picture_optional_model/picture_optional_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class PictureOptionalCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  PictureOptionalCubit({required this.repository}) : super(RiderInitial());
  getData() async {
    var response = await repository.pictureOptional();
    response.fold(
      (l) {},
      (r) {
        emit(SuccessGetPictureOptionalState(
            value: PictureOptionalModel.fromJson(r['data'])));
      },
    );
  }
}
