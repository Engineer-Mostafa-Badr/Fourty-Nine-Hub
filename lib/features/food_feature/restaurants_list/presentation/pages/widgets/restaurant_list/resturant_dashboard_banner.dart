
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../cubit/restaurants_list_cubit.dart';

class ResturantDashboardButton extends StatelessWidget {
  const ResturantDashboardButton({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RestaurantsCubit>().state;
    return InkWell(
      onTap: () async{
        var result =await context.push(Routes.RestaurantDashboard,
            extra: state.isResturant!.restaurantId!);
        if(result == true){
          context.read<RestaurantsCubit>().loadData();
        }
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 30.h),
          decoration: BoxDecoration(
              color: context.isDarkMode?AppColors.PRIMARY_COLOR:Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(20.r)),
          child: Row(
            children: [
              Expanded(
                child: Label(
                  text: LocaleKeys.restaurantDashboard.localize,
                  style: Styles.mediumText(
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colors.white,
                size: 35.w,
              ),
            ],
          )),
    );
  }
}
