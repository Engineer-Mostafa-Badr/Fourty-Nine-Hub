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
    await ShareHelper().share(text: """
سجل للحصول على 400 جنيه مصرى كهدية ترحيبية واستخدم التطبيق واحصل على استرداد نقدي فى معاملاتك وعندما تحصل على 1000 جنية مصرى سوف تحصل عليها نقداً 

$link
 
إذا لم يكن لديك تطبيق 49 في هاتفك المحمول ، فقم بتحميله من المتجر 
اندرويد 

https://play.google.com/store/apps/details?id=com.fourtyninehub.fourtynine
ايفون 


https://apps.apple.com/us/app/49-app/id1632305652
""", subject: '49Hub');
  }
}
