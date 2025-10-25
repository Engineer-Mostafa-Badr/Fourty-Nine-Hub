import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/account_taps/contact_us/data/models/contact_us_model.dart';
import 'package:fourtyninehub/routes/pages.dart';

import '../../domain/usecases/create_contact_us_usecase.dart';

part 'contact_us_state.dart';

class ContactUsCubit extends Cubit<ContactUsState> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final CreateContactUsUseCase _createContactUsUseCase;

  ContactUsCubit(
    this._createContactUsUseCase,
  ) : super(const ContactUsState());

  void createContactUs(BuildContext context) async {
    state.copyWith(status: StateStatus.loading);

    if (formKey.currentState?.validate() ?? false) {
      // Exclude the phone field if it's empty
      final data = {
        'content': messageController.text,
        if (phoneController.text.isNotEmpty)
          'phone': phoneController.text.toEnglishNumbers(), // تحويل الأرقام العربية للإنجليزية
      };

      final response =
          await _createContactUsUseCase(ContactUsModel.fromJson(data));

      response.fold(
        (l) {
          var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
          emit(state.copyWith(failure: l, status: StateStatus.error));
        },
        (r) {
          messageController = TextEditingController(text: "");
          phoneController = TextEditingController(text: "");
          print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
          print(r);
          print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
          return emit(state.copyWith(status: StateStatus.success));
        },
      );
    }
  }
}
