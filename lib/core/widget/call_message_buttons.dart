import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/global/button_availability.dart';
import 'package:fourtyninehub/common/functions/helper/launch_url.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trip_button.dart';
import 'package:fourtyninehub/helpers/subscription_method.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class CallMessageButtons extends StatefulWidget {
  const CallMessageButtons({super.key, required this.otherUserId, required this.subcategoryId, required this.phone, required this.id, this.hasReport=false, this.clientId});
  final String otherUserId;
  final String? clientId;
  final String subcategoryId;
  final String phone;
  final String id;
  final bool? hasReport;

  @override
  State<CallMessageButtons> createState() => _CallMessageButtonsState();
}

class _CallMessageButtonsState extends State<CallMessageButtons> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ButtonAvailability().isShowButton(
          clientId: widget.clientId,
            otherUserId: widget.otherUserId, subcategoryId: widget.subcategoryId ),
        builder: (context, snap) {
          print(snap.data);
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: AvaialbleTripsButton(
                  title: LocaleKeys.call.localize,
                  color: snap.data == true ? AppColors.SECONDARY_COLOR : AppColors.DARK_GRAY_COLOR,
                  icon: Icons.call,
                  onTap: snap.data == true ? () {
                    LaunchURLHelper().call( phone: widget.phone);
                  } : () async{
                    SubscriptionMethod().subscribe(subscribeId: widget.subcategoryId, title: LocaleKeys.ads.localize);
                  },
                ),
              ),
              const Sizer(width: 5),
              Expanded(
                flex: 3,
                child: AvaialbleTripsButton(
                  title: LocaleKeys.message.localize,
                  color: snap.data == true ? AppColors.SECONDARY_COLOR : AppColors.DARK_GRAY_COLOR,
                  icon: Icons.email,
                  onTap: snap.data == true ? () {} : () {
                    SubscriptionMethod().subscribe(subscribeId: widget.subcategoryId, title: LocaleKeys.ads.localize);
                  },
                ),
              ),
             if(widget.hasReport==true)...[ const Sizer(width: 5),
              Expanded(
                flex: 3,
                child: AvaialbleTripsButton(
                  title: LocaleKeys.report.localize,
                  color: AppColors.SECONDARY_COLOR,
                  icon: Icons.report,
                  onTap: () {
                    bottomSheet(
                        context: context,
                        widget: ReportView(
                          id: widget.id,
                          categoryId: widget.subcategoryId,
                        ));
                  },
                ),
              ),]
            ],
          );
        });
  }
}
