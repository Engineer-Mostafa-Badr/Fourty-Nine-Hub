import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/contact_us/data/models/contact_us_model.dart';

import '../../../../../res/strings/labels.dart';
import '../../domain/usecases/create_contact_us_usecase.dart';
import '../../domain/usecases/get_contact_us_messages.dart';

part 'contact_us_state.dart';

class ContactUsCubit extends Cubit<ContactUsState> {
  final phoneController = TextEditingController();
  final messageController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final GetContactUsMessages _getContactUsMessages;
  final CreateContactUsUseCase _createContactUsUseCase;
  ContactUsCubit(this._createContactUsUseCase, this._getContactUsMessages)
      : super(const ContactUsState());

  void createContactUs() async {
    if (formKey.currentState?.validate() ?? false) {
      final response = await _createContactUsUseCase(ContactUsModel(
          content: messageController.text, phone: phoneController.text));
      response.fold(
          (l) => state.copyWith(failure: l, status: StateStatus.error),
          (r) => state.copyWith(
              successMessage: Labels.success, status: StateStatus.success));
    }
  }
}
