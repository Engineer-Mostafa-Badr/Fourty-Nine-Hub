import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

import '../../../../res/style/app_colors.dart';
import '../pages/create_chance_view.dart';
import '../controller/cubit/chance_cubit.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import '../../../../service_locator/service_locator.dart';
import '../../../custom_page/presentation/page/widget/edit_page.dart';

class FloatingActionButtonWidget extends StatelessWidget {
  const FloatingActionButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      onPressed: () {
        ManageVibration.vibrate();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider<ChanceCubit>(
              create: (context) => serviceLocator<ChanceCubit>(),
              child: const CreateChanceView(),
            ),
          ),
        );
      },
      backgoundColor: context.isDarkMode
          ? AppColors.Floating_Button_COLOR_DARK
          : AppColors.PRIMARY_COLOR,
      borderRadius: 28,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.isArabic ? 'اضافة فرصة' : 'Add Chance',
            style: TextStyle(
              color: context.isDarkMode
                  ? Colors.black
                  : Colors.white, // then Colors.white,
              fontSize: 32.sp,
            ),
          ),
          Sizer(width: 10.w),
          Icon(
            Icons.add,
            color: context.isDarkMode ? Colors.black : Colors.white,
          ),
        ],
      ),
    );
  }
}
