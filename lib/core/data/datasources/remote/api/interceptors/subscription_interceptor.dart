import 'package:dio/dio.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class SubscriptionInterceptor extends Interceptor {
  @override
  Future<void> onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    // if (response.data['endPointSubscription'] != null &&
    //     response.data['endPointSubscription'] == true &&
    //     response.data['userSubscription'] == false) {
    //   List<WalletTypes> wallets = (response.data['paymentMethod'] as List)
    //       .map((e) => (e as String).toWalletType)
    //       .toList();
    //   await serviceLocator<SubscriptionController>().showSubscriptionPlans(
    //       subCategoryId: response.data['subCategoryId'], wallets: wallets);
    // }
    super.onResponse(response, handler);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    print("err.response?.data['endPointSubscription']${err.response?.data['endPointSubscription']}");
    if (err.type == DioExceptionType.badResponse &&
        err.response?.data['endPointSubscription'] != null &&
        err.response?.data['endPointSubscription'] == true &&
        err.response?.data['userSubscription'] == false) {
      List<WalletTypes> wallets = (err.response?.data['paymentMethod'] as List)
          .map((e) => (e as String).toWalletType)
          .toList();
      await serviceLocator<SubscriptionController>().showSubscriptionPlans(
          subCategoryId: err.response?.data['subCategoryId'], wallets: wallets);
    }
    super.onError(err, handler);
  }
}
