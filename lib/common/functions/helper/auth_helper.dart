import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';

import '../../../service_locator/service_locator.dart';

class AuthHelper {
  bool isLoggedIn() {
   return serviceLocator<UserCubit>().isLoggedIn;
  }
}
