import 'package:dio/dio.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
import 'package:fourtyninehub/helpers/logging_helper.dart';
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
    // Log all errors for debugging
    LoggingHelper.error(
      "SubscriptionInterceptor: Network error occurred",
      data: {
        'url': err.requestOptions.uri.toString(),
        'method': err.requestOptions.method,
        'errorType': err.type.toString(),
        'statusCode': err.response?.statusCode,
        'hasResponseData': err.response?.data != null,
      },
    );
    
    // Only log endPointSubscription if it exists in the response
    if (err.response?.data != null && err.response!.data is Map) {
      final responseData = err.response!.data as Map<String, dynamic>;
      if (responseData.containsKey('endPointSubscription')) {
        LoggingHelper.info(
          "SubscriptionInterceptor: endPointSubscription check",
          data: {
            'endPointSubscription': responseData['endPointSubscription'],
            'url': err.requestOptions.uri.toString(),
          },
        );
      }
    }
    
    if (err.type == DioExceptionType.badResponse &&
        err.response?.data != null &&
        err.response!.data is Map) {
      final responseData = err.response!.data as Map<String, dynamic>;
      
      if (responseData['endPointSubscription'] != null &&
          responseData['endPointSubscription'] == true &&
          responseData['userSubscription'] == false) {
        List<WalletTypes> wallets = (responseData['paymentMethod'] as List)
            .map((e) => (e as String).toWalletType)
            .toList();
        await serviceLocator<SubscriptionController>().showSubscriptionPlans(
            subCategoryId: responseData['subCategoryId'], wallets: wallets);
      }
    }
    super.onError(err, handler);
  }
}
