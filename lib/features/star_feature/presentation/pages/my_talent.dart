import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/star_feature/presentation/pages/all_winner_view.dart';

import '../../../../core/localization/locale_keys.g.dart';
import '../../../../service_locator/service_locator.dart';
import '../controller/cubit/star_cubit.dart';
import 'get_all_talents.dart';

class MyTalentView extends StatelessWidget {
  const MyTalentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => serviceLocator<StarCubit>(),
                    child: const AllWinnerView(),
                  ),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.only(
                  right: context.locale.languageCode == 'ar' ? 0 : 8.0,
                  left: context.locale.languageCode == 'ar' ? 8.0 : 0),
              child: Row(
                children: [
                  Text(
                    LocaleKeys.winners.localize,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 32.sp,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Image.asset(
                    'assets/49-New-icons/winners.png',
                    // height: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
        title: Text(
          LocaleKeys.myTalent.localize,
          // 'My Talent',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 36.sp,
          ),
        ),
      ),
      body: const GetAllTalents(
        isMyTalent: true,
      ),
    );
  }
}
