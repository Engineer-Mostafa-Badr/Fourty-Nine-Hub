import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/data/models/filter_option_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../common/widgets/dialogs/please_login_dialog.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class HealthBookingTypeCard extends StatelessWidget {
  final HealthBookingFilterModel bookingFilterModel;
  const HealthBookingTypeCard({super.key, required this.bookingFilterModel});

  @override
  Widget build(BuildContext context) {
    return ClickableWidget(
      onTap: () {
      ManageVibration.vibrate();
        if (context.read<UserCubit>().isLoggedIn) {
          serviceLocator<HealthSharedData>().doctorSearchParams.bookingType =
              bookingFilterModel.bookingType;
          context.push(bookingFilterModel.route,
              extra: bookingFilterModel.bookingType.name);
        } else {
          return pleaseLoginDialog(context);
          // context.push(Routes.REGISTER);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Expanded(child: Image.asset(bookingFilterModel.image)),
            Text(
              getTranslatedName(context,bookingFilterModel.bookingType.translatedName),
              style: Styles.mediumText(),
            ),
          ],
        ),
      ),
    );
  }

  String getTranslatedName(BuildContext context, var name) {
    switch (name) {
      case LocaleKeys.call:
        return context.isArabic ? 'اتصال' : 'Call';
      case LocaleKeys.clinicVisit:
        return context.isArabic ? 'زيارة عيادة' : 'Clinic Visit';
      case LocaleKeys.homeVisit:
        return context.isArabic ? 'زيارة منزلية' : 'Home Visit';
      case LocaleKeys.emergency:
        return context.isArabic ? 'طوارئ' : 'Emergency';
      default:
        return '';
    }
  }
}