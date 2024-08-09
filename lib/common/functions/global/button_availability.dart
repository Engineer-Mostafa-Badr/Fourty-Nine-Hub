import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class ButtonAvailability {
  Future<bool> isShowButton({
    required String otherUserId,
    required String subcategoryId,
  }) async {
    try {
      final userId = serviceLocator<UserCubit>().state.data?.id ?? '';
      final response = await serviceLocator<ApiConsumer>()
          .post(EndPoints.buttonAvailable, data: {
        "clientId": userId,
        "ownerId": otherUserId,
        "subcategoryId": subcategoryId
      });
      response.fold((l) {
        return false;
      }, (data) {
        if (data['data'] == 'disable') {
          return false;
        } else {
          return true;
        }
      });
    } catch (e) {
      return false;
    }
    return false;
  }
}
