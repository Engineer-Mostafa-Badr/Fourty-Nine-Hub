import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class ButtonAvailability {
  Future<bool> isShowButton({
    required String otherUserId,
    String? clientId,
    required String subcategoryId,
  }) async {
    bool result =false;
    try {
      final userId = serviceLocator<UserCubit>().state.data?.id ?? '';
      final response = await serviceLocator<ApiConsumer>()
          .post(EndPoints.buttonAvailable, data: {
        "clientId": clientId??userId,
        "ownerId": otherUserId,
        "subcategoryId": subcategoryId
      });
      response.fold((l) {
        result = false;
        return result;
      }, (data) {
        if (data['data'] == 'disable') {
          print("object disable");
          print("object disable");
          result = false;
          return result;
        } else {
          print("object enable");
          result = true;
          return result;
        }
      });
    } catch (e) {
      result = false;
      return result;
    }
    return result;
  }
}
