import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/picture_optional_model/picture_optional_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/routes/pages.dart';
class PictureOptionalCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  PictureOptionalCubit({required this.repository}) : super(RiderInitial());
  getData() async {
    var response = await repository.pictureOptional();
    response.fold(
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
      },
      (r) {
        emit(SuccessGetPictureOptionalState(
            value: PictureOptionalModel.fromJson(r['data'])));
      },
    );
  }
}
