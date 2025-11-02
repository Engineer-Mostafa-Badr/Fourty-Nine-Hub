import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart'; // For Either
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
part 'get_currency_state.dart';

class GetCurrencyCubit extends Cubit<GetCurrencyState> {
  final ApiConsumer apiConsumer;
  String currnecyAr = "";
  String currnecyEn = "";
  // Inject ApiConsumer through the constructor
  GetCurrencyCubit(this.apiConsumer) : super(GetCurrencyInitial());

  Future<void> getCurrencyData() async {
    try {
      emit(GetCurrencyLoading());
      // Make the API call using ApiConsumer
      final Either<Failure, Map<String, dynamic>> response =
          await apiConsumer.get(EndPoints.getCurrencyCarPool);

      response.fold(
        (failure) {
          var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(failure, currentContext));
          emit(GetCurrencyFailure(_mapFailureToMessage(failure)));
        },
        (data) {
          if (data['status']) {
            currnecyEn = data['data']["currencyEn"];
            currnecyAr = data['data']["currencyAr"];

            emit(GetCurrencySuccess(data['data']));
          } else {
            emit(GetCurrencyFailure('Failed to fetch currency'));
          }
        },
      );
    } catch (e) {
      emit(GetCurrencyFailure('An error occurred: ${e.toString()}'));
    }
  }

  // Helper method to map failures to error messages
  String _mapFailureToMessage(Failure failure) {
    // Customize this based on your failure handling strategy
    return 'Unexpected error occurred';
  }
}
