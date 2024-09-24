import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
import 'package:fourtyninehub/features/trip_join/view_all_pick_me/domain/entities/pickme_entity.dart';
import 'package:fourtyninehub/features/trip_join/view_all_pick_me/presentation/widgets/all_pick_me_card.dart';
import 'package:fourtyninehub/features/trip_join/view_all_pick_me/presentation/widgets/all_pick_me_card_loading.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/report_view_trip_join.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AllPickMeBody extends StatelessWidget {
  const AllPickMeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5.h),
      child: const AllPickMeBuilder(),
    );
  }
}

class AllPickMeBuilder extends StatefulWidget {
  const AllPickMeBuilder({super.key});

  @override
  State<AllPickMeBuilder> createState() => _AllPickMeBuilderState();
}

class _AllPickMeBuilderState extends State<AllPickMeBuilder> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pickMeStaticData.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "You don't own a car/Someone will share the trip with you and pay half price",
              // "Users own cars/share the trip with them" ,
              style: Styles.headerText(
                color: AppColors.getSecondryColor(context),
              ),
              textAlign: TextAlign.start,
            ),
          );
        }
        index--;

        if (index < pickMeStaticData.length) {
          final pickMeCardEntity = pickMeStaticData[index];
          return AllPickMeCard(
            pickMeCardEntity: pickMeCardEntity,
            reportOnTap: () {
              _reportOnTap(context, pickMeCardEntity);
            },
            premuimRequestOnTap: () async {
              if (await _isPremuim(
                pickMeCardEntity,
                pickMeCardEntity.categoryId ?? '',
                LocaleKeys.tripjoinPremuimSubscription.localize,
              )) {
                // await showModalBottomSheet(
                //   context: context,
                //   isDismissible: true,
                //   isScrollControlled: true,
                //   builder: (_) {
                //     return BlocProvider.value(
                //         value: BlocProvider.of<RequestTripJoinCubit>(context),
                //         child: RequstTripJoinBottomSheet(tripJoinCardEntity: tripJoinCardEntity, isPremium: true));
                //   },
                // );
              }
            },
            requestOnTap: () async {
              // await showModalBottomSheet(
              //   context: context,
              //   isDismissible: true,
              //   isScrollControlled: true,
              //   builder: (_) {
              //     return BlocProvider.value(
              //         value: BlocProvider.of<RequestTripJoinCubit>(context),
              //         child: RequstTripJoinBottomSheet(tripJoinCardEntity: tripJoinCardEntity));
              //   },
              // );
            },
            callOnTap: () async {
              // launchUrlString("tel://${tripJoinCardEntity.phone}");
              // return;
              if (await _userApproved(
                pickMeCardEntity,
                UIConst.chatNormalId,
                LocaleKeys.chatSubscription.localize,
              )) {
                launchUrlString("tel://${pickMeCardEntity.phone}");
              }
            },
            messageOnTap: () async {
              if (await _userApproved(
                pickMeCardEntity,
                UIConst.chatNormalId,
                LocaleKeys.chatSubscription.localize,
              )) {}
            },
            subscribeMessageOnTap: () async {
              if (await _userApproved(
                pickMeCardEntity,
                pickMeCardEntity.categoryId ?? '',
                LocaleKeys.tripjoinPremuimSubscription.localize,
              )) {}
            },
          );
        }
        return const PickMeCardLoadingList();
      },
    );
  }

  Future<bool> _isPremuim(PickMeCardEntity pickMeCardEntity,
      String subCategoryId, String title) async {
    if (pickMeCardEntity.subscribedPremium == null ||
        pickMeCardEntity.subscribedPremium == false) {
      await serviceLocator<SubscriptionController>().showSubscriptionPlans(
        wallets: [
          pickMeCardEntity.paymentMethod?.toWalletType ?? WalletTypes.balance
        ],
        subCategoryId: subCategoryId,
        title: title,
      );
      return false;
    }
    return true;
  }

  Future<bool> _userApproved(PickMeCardEntity pickMeCardEntity,
      String subCategoryId, String title) async {
    if (pickMeCardEntity.isApproved == null ||
        pickMeCardEntity.isApproved == false) {
      await serviceLocator<SubscriptionController>().showSubscriptionPlans(
        wallets: [
          pickMeCardEntity.paymentMethod?.toWalletType ?? WalletTypes.balance
        ],
        subCategoryId: subCategoryId,
        title: title,
      );
      return false;
    }
    return true;
  }

  void _reportOnTap(BuildContext context, PickMeCardEntity pickMeCardEntity) {
    bottomSheet(
        context: context,
        widget: ReportViewTripJoin(
          id: pickMeCardEntity.userId ?? '',
          cardId: pickMeCardEntity.id ?? '',
          categoryId: pickMeCardEntity.categoryId ?? '',
        ));
  }
}
