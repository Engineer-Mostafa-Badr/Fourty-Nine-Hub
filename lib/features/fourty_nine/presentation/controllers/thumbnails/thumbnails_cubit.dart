// import 'package:bloc/bloc.dart';
// import 'package:fourtyninehub/core/abstract/use_case.dart';
// import 'package:fourtyninehub/core/enums/base_status_enum.dart';
// import 'package:fourtyninehub/core/states/basic_state.dart';
// import 'package:fourtyninehub/features/ride/RideRequest/domain/entity/ride_thumbnail_entity.dart';
// import 'package:fourtyninehub/features/ride/RideRequest/domain/usecases/get_ride_thumbnails.dart';
//
// class ThumbnailsCubit extends Cubit<BasicState<List<RideThumbnailEntity>>> {
//   final GetRideThumbnailsUseCase _getRideThumbnailsUseCase;
//
//   ThumbnailsCubit(this._getRideThumbnailsUseCase) : super(const BasicState());
//
//   void loadData() async {
//     await _getRideThumbnails();
//   }
//
//   Future<void> _getRideThumbnails() async {
//     emit(state.copyWith(status: StateStatus.loading));
//     final result = await _getRideThumbnailsUseCase(const NoParams());
//
//     emit(
//       result.fold(
//         (failure) => state.copyWith(
//           failure: failure,
//           status: StateStatus.error,
//         ),
//         (data) => state.copyWith(
//           status: StateStatus.success,
//           data: data,
//         ),
//       ),
//     );
//   }
// }
