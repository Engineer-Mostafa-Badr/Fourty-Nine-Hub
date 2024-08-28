import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class AvailableTripsBody extends StatelessWidget {
  const AvailableTripsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'These trips are for users who own cars and they want to share with other users ',
                style: Styles.headerText(color: AppColors.SECONDARY_COLOR),
                textAlign: TextAlign.start,
              ),
              const AvailableTripCard(),
              const AvailableTripCard(),
              const AvailableTripCard(),
              const AvailableTripCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class AvailableTripCard extends StatelessWidget {
  const AvailableTripCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Stack(
        children: [
          CustomCard(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.time_to_leave),
                  const Sizer(),
                  Text(
                    'Toyota, Corolla',
                    style: Styles.headerText(
                      fontSize: 45,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              const Sizer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_month),
                  const Sizer(),
                  Text('13 January, 3:00 PM', style: Styles.headerText()),
                ],
              ),
              const Sizer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.airline_seat_recline_extra_rounded),
                  const Sizer(),
                  Text('4 Seat', style: Styles.headerText()),
                  const Spacer(),
                  const Icon(Icons.check_box, color: AppColors.PRIMARY_COLOR),
                  const Sizer(),
                  Text('Repeated', style: Styles.headerText()),
                  const Sizer(width: 20),
                ],
              ),
              const Sizer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.trip_origin, color: AppColors.LIGHT_BLUE),
                  const Sizer(),
                  Flexible(
                    child: Text(
                      ' Cairo, Slaim Al Awal 21 (Zeitoun)',
                      style: Styles.headerText(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              const Sizer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.trip_origin, color: AppColors.CHECK_MARK_COLOR),
                  const Sizer(),
                  Text(
                    'Cairo, Slaim Al Awal 21 (Zeitoun)',
                    style: Styles.headerText(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
              const Sizer(),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: AvaialbleTripsButton(
                      title: 'Premium Request',
                      color: AppColors.SECONDARY_COLOR,
                    ),
                  ),
                  Sizer(),
                  Expanded(
                    flex: 2,
                    child: AvaialbleTripsButton(
                      title: 'Request',
                      color: AppColors.PRIMARY_COLOR,
                    ),
                  )
                ],
              ),
              const Sizer(),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: AvaialbleTripsButton(
                      title: 'Call',
                      color: AppColors.DARK_GRAY_COLOR,
                      icon: Icons.call,
                    ),
                  ),
                  Sizer(),
                  Expanded(
                    flex: 3,
                    child: AvaialbleTripsButton(
                      title: 'Message',
                      color: AppColors.DARK_GRAY_COLOR,
                      icon: Icons.email,
                    ),
                  ),
                  Sizer(),
                  Expanded(
                    flex: 3,
                    child: AvaialbleTripsButton(
                      title: 'Report',
                      color: AppColors.PRIMARY_COLOR,
                      icon: Icons.report,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 5,
            right: 5,
            child: Text('30', style: Styles.headerText(fontSize: 70, color: Colors.green[600])),
          )
        ],
      ),
    );
  }
}

class AvaialbleTripsButton extends StatelessWidget {
  const AvaialbleTripsButton({
    super.key,
    required this.title,
    this.onTap,
    this.color,
    this.noFill = false,
    this.icon,
  });
  final void Function()? onTap;
  final Color? color;
  final String title;
  final bool noFill;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: noFill ? null : color,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: color ?? Colors.transparent),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon != null ? Icon(icon, color: Colors.white, size: 20) : const SizedBox(),
            const Sizer(width: 5),
            Text(
              title,
              style: Styles.headerText(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
