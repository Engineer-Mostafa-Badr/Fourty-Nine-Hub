import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'create_new_forgot_password_state.dart';

class CreateNewForgotPasswordCubit extends Cubit<CreateNewForgotPasswordState> {
  CreateNewForgotPasswordCubit() : super(CreateNewForgotPasswordInitial());
}
