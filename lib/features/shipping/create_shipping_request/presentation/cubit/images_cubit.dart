import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/repositories/images_repository.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';

class ImagesCubit extends Cubit<ShippingState> {
  final ImagesRepository repository;
  ImagesCubit({required this.repository}) : super(ShippingInitial());
  // getIdS3({required IdS3RequestModel model}) async {
  //   var response = await repository.getS3Id(model: model);
  //   response.fold(
  //     (error) {
  //       emit(FailureShippingState(message: "Error"));
  //     },
  //     (data) {
  //       emit(SucccessGetIdS3(model: data));
  //     },
  //   );
  // }
}
