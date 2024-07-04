import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

import '../../../../../common/functions/helper/share_helper.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../res/strings/labels.dart';

part 'share_app_state.dart';

class ShareAppCubit extends Cubit<ShareAppState> {
  String link = 'https://49hub.com/register?reference=300404004';
  ShareAppCubit() : super(ShareAppInitial());
  void copyToClipboard(context) async {
    await Clipboard.setData(ClipboardData(text: link));
    showSuccessMessage(context, Labels.copiedToClipboard);
  }

  void shareTheApp() async {
    await ShareHelper().share(text: '49Hub App', subject: link);
  }
}
