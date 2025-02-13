import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
import 'package:fourtyninehub/features/trip_join/helpers/print_helper.dart';
import 'package:fourtyninehub/features/trip_join/notifications/data/models/trip_join_request_model/trip_join_request_model.dart';
import 'package:fourtyninehub/features/trip_join/notifications/presentation/views/widgets/trip_join_request_notification_widget.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/entities/trip_join_card_entity.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/report_view_trip_join.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../core/widget/custom_scaffold.dart';

class RequestTripJoinNotificationView extends StatefulWidget {
  const RequestTripJoinNotificationView({super.key, required this.payload});
  final Map<String, dynamic> payload;
  @override
  State<RequestTripJoinNotificationView> createState() =>
      _RequestTripJoinNotificationViewState();
}

class _RequestTripJoinNotificationViewState
    extends State<RequestTripJoinNotificationView> {
  late final TripJoinCardEntity tripJoinCardEntity;
  @override
  void initState() {
    tripJoinCardEntity = TripJoinRequestModel.fromJson(widget.payload);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pr(widget.payload, 'notication page build method is called');
    return SafeArea(
      child: CustomScaffold(
        appBar: AppBar(
          title: Transform(
            transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
            child: Text(
              LocaleKeys.tripJoinNotifications.localize,
              style: Styles.headerText(),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20.h),
          child: TripJoinRequestNotificationWidget(
            tripJoinCardEntity: tripJoinCardEntity,
            callOnTap: () async {
              if (await _userApproved(
                tripJoinCardEntity,
                UIConst.chatNormalId,
                LocaleKeys.chatSubscription.localize,
              )) {
                launchUrlString("tel://${tripJoinCardEntity.phone}");
              }
            },
            messageOnTap: () async {
              if (await _userApproved(
                tripJoinCardEntity,
                UIConst.chatNormalId,
                LocaleKeys.chatSubscription.localize,
              )) {}
            },
            reportOnTap: () {
              _reportOnTap(context, tripJoinCardEntity);
            },
            subscribeCallback: () async {
              if (await _isPremuim(
                tripJoinCardEntity,
                tripJoinCardEntity.categoryId ?? '',
                LocaleKeys.tripjoinPremuimSubscription.localize,
              )) {}
            },
            navigateToRequestHistoryCallback: () {},
          ),
        ),
      ),
    );
  }

  Future<bool> _isPremuim(TripJoinCardEntity tripJoinCardEntity,
      String subCategoryId, String title) async {
    if (tripJoinCardEntity.subscribedPremium == null ||
        tripJoinCardEntity.subscribedPremium == false) {
      await serviceLocator<SubscriptionController>().showSubscriptionPlans(
        wallets: [
          tripJoinCardEntity.paymentMethod?.toWalletType ?? WalletTypes.balance
        ],
        subCategoryId: subCategoryId,
        title: title,
      );
      return false;
    }
    return false;
  }

  Future<bool> _userApproved(TripJoinCardEntity tripJoinCardEntity,
      String subCategoryId, String title) async {
    if (tripJoinCardEntity.isApproved == null ||
        tripJoinCardEntity.isApproved == false) {
      await serviceLocator<SubscriptionController>().showSubscriptionPlans(
        wallets: [
          tripJoinCardEntity.paymentMethod?.toWalletType ?? WalletTypes.balance
        ],
        subCategoryId: subCategoryId,
        title: title,
      );
      return false;
    }
    return false;
  }

  void _reportOnTap(
      BuildContext context, TripJoinCardEntity tripJoinCardEntity) {
    bottomSheet(
        context: context,
        widget: ReportViewTripJoin(
          id: tripJoinCardEntity.userId ?? '',
          cardId: tripJoinCardEntity.id ?? '',
          categoryId: tripJoinCardEntity.categoryId ?? '',
        ));
  }
}
