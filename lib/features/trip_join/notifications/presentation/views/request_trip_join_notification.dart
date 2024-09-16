import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/trip_join/helpers/print_helper.dart';
import 'package:fourtyninehub/features/trip_join/notifications/presentation/views/widgets/trip_join_request_notification_widget.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/entities/trip_join_card_entity.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class RequestTripJoinNotificationView extends StatefulWidget {
  const RequestTripJoinNotificationView({super.key, required this.payload});
  final Map<String, dynamic> payload;
  @override
  State<RequestTripJoinNotificationView> createState() =>
      _RequestTripJoinNotificationViewState();
}

class _RequestTripJoinNotificationViewState
    extends State<RequestTripJoinNotificationView> {
  @override
  Widget build(BuildContext context) {
    TripJoinCardEntity tripJoinCardEntity = TripJoinCardEntity(
      requestOwnerFirstName: 'Eslam',
      gender: 'male',
      brand: 'Toyota',
      model: 'Corolla',
      journeyPrice: 300,
      status: 'regular',
      startingAddressEn:
          'Samia El Gamal, Mansoura Qism 2, El Mansoura, Dakahlia Governorate 7650310, Egypt',
      destinationAddressEn: 'El Gomhouria St, Dakahlia Governorate, Egypt',
      publishDate: 1726399641,
      isRepeated: true,
    );
    pr(widget.payload, 'notication page build method is called');
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Transform(
            transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
            child: Text(
              'Trip Join Notification',
              style: Styles.headerText(),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20.h),
          child: TripJoinRequestNotificationWidget(
            tripJoinCardEntity: tripJoinCardEntity,
          ),
        ),
      ),
    );
  }
}
