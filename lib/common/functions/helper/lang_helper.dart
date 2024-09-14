import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/routes/pages.dart';

import '../../../features/fourty_nine/presentation/controllers/main_categories_cubit/main_categories_cubit.dart';

String getLang() {
  return AppPages
      .router.configuration.navigatorKey.currentContext!.locale.languageCode;
}

void changeLang({required Locale locale, required BuildContext context}) {
  // final context = AppPages.router.configuration.navigatorKey.currentContext!;

  context.setLocale(locale);

  var categoryCubit = BlocProvider.of<MainCategoriesCubit>(context);
  categoryCubit.loadData();
  //context.read<MainCategoriesCubit>().loadData();
}
