import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/helpers/responsive/responsive.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../res/assets/assets.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../routes/routes.dart';
import '../../../../domain/entities/dashboards/trip_entity.dart';
import '../../widgets/car_circle_widget.dart';
import '../../widgets/info_column_widget.dart';

class PastTripsWidget extends StatefulWidget {
  final String modeType;
  final TripEntity? tripEntity;
  const PastTripsWidget(
      {super.key, required this.modeType,required  this.tripEntity});

  @override
  State<PastTripsWidget> createState() => _PastTripsWidgetState();
}

class _PastTripsWidgetState extends State<PastTripsWidget> {
  @override
  initState() {
  widget.tripEntity!.modeType =  widget.modeType;
    super.initState();
  }

  String formatDateLocalized(String dateString ) {
    DateTime dateTime = DateTime.parse(dateString).toLocal();
    final formatter = DateFormat('MMM d - hh:mm a', context.isArabic ? 'ar' : 'en');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return ClickableWidget(
      onTap: () {
        ManageVibration.vibrate();

        context.push(Routes.rideDashboardDetailsScreen, extra: widget.tripEntity);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 4),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: context.isDarkMode?AppColors.GREY_LIGHT_COLOR:AppColors.DARK_BLUE_COLOR),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarContainer(
              title: context.isArabic
                  ? widget.tripEntity?.subCategory?.nameAr ?? ''
                  : widget.tripEntity?.subCategory?.nameEn ?? '',
              image: widget.tripEntity!.subCategory!
                                    .pictureUrl//Assets.redCar,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: PriceColumn(
                  startAddressTitle:
                      widget.tripEntity?.tripDetails?.startLocation.title ?? '',
                  date:formatDateLocalized(widget.tripEntity?.tripDetails?.createdAt??''),
                  price:
                  FormatNumbers().convertNumberToLocalizedString(widget.tripEntity?.tripDetails?.price.toStringAsFixed(0) ?? '0.0', isArabic: context.isArabic)
                      ),
            ),
            SizedBox(
              width: 70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if(widget.tripEntity?.tripDetails?.clientRateDriver != null&& widget.tripEntity?.tripDetails?.clientRateDriver != 0)
                    Container(
                      alignment: AlignmentDirectional.topEnd,
                      height: 22,
                      width: 55,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: widget.tripEntity?.clientDetails
                                  ?.profilePictureUrl ==
                                  null
                                  ? AssetImage(Assets.personalImage)
                                  : NetworkImage(widget.tripEntity!.clientDetails!
                                  .profilePictureUrl) as ImageProvider)),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4.ws),
                        decoration: BoxDecoration(
                            color: AppColors.colorGreyLight,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 4.ws,
                          children: [
                            Icon(Icons.star,
                                size: 12.ws, color: AppColors.YELLOW_COLOR),
                            Text(
                                FormatNumbers().convertNumberToLocalizedString(widget.tripEntity?.tripDetails?.clientRateDriver.toString() ?? '0.0', isArabic: context.isArabic),
                                style: TextStyle(
                                    fontSize: 10.ts, fontWeight: FontWeight.w500,
                                    color: Colors.black
                                )),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                      alignment: AlignmentDirectional.center,
                      child: Image.asset(widget.tripEntity?.clientDetails?.gender=='male'?Assets.maleImagePlaceholder:Assets.femaleImagePlacehlder,width: 70,height: 30,)),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                      widget.tripEntity?.clientDetails?.firstName ??
                          '', //'Ahmed',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12.ts, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
