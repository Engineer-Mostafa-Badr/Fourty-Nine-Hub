import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
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
    super.initState();
    widget.tripEntity!.modeType =  widget.modeType;
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        
        context.push(Routes.rideDashboardDetailsScreen, extra: widget.tripEntity);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
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
            PriceColumn(
                title:
                    widget.tripEntity?.tripDetails?.startLocation.title ?? '',
                date: "Feb 13 - 12:41 PM",
                price:
                    widget.tripEntity?.tripDetails?.price.toStringAsFixed(0) ??
                        '0.0'),
            const Spacer(),
            SizedBox(
              width: 70,
              child: Column(
                children: [
                  Container(
                    alignment: AlignmentDirectional.topEnd,
                    height: 55,
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
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                          color: AppColors.colorGreyLight,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 1,
                        children: [
                          const Icon(Icons.star,
                              size: 12, color: AppColors.YELLOW_COLOR),
                          Text(
                              "${widget.tripEntity?.rating?.yourRating.rating ?? '0.0'}",
                              style: const TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),
                  Text(
                      widget.tripEntity?.clientDetails?.firstName ??
                          '', //'Ahmed',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
