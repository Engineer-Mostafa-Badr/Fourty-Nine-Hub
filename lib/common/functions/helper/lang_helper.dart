import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/routes/pages.dart';


String getLang() {
  return AppPages
      .router.configuration.navigatorKey.currentContext!.locale.languageCode;
}

void changeLang({required Locale locale, required BuildContext context}) {
  // final context = AppPages.router.configuration.navigatorKey.currentContext!;

  context.setLocale(locale);

  // var categoryCubit = BlocProvider.of<MainCategoriesCubit>(context);
  // categoryCubit.loadDataCategory();
  // categoryCubit.getMainCategoryCustomPage();
  //context.read<MainCategoriesCubit>().loadData();
}
