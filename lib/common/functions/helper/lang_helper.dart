import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';


String getLang() {
  return AppPages
      .router.configuration.navigatorKey.currentContext!.locale.languageCode;
}

Future<void> changeLang({required Locale locale, required BuildContext context}) async {
  // final context = AppPages.router.configuration.navigatorKey.currentContext!;
  locale.languageCode;

  context.setLocale(locale);
  await serviceLocator<ApiConsumer>().put('/users/settings/change-language',data: {
    'language':locale.languageCode
  });
  // var categoryCubit = BlocProvider.of<MainCategoriesCubit>(context);
  // categoryCubit.loadDataCategory();
  // categoryCubit.getMainCategoryCustomPage();
  //context.read<MainCategoriesCubit>().loadData();
}
