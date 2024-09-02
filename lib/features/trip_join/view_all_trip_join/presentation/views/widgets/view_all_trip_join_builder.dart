import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/entities/trip_join_card_entity.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/cubits/view_all_trip_join_cubit/view_all_trip_join_cubit.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trip_card.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trips_card_loading.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/report_view_trip_join.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class ViewAllTripJoinCardBuilder extends StatefulWidget {
  const ViewAllTripJoinCardBuilder({
    super.key,
  });

  @override
  State<ViewAllTripJoinCardBuilder> createState() => _ViewAllTripJoinCardBuilderState();
}

class _ViewAllTripJoinCardBuilderState extends State<ViewAllTripJoinCardBuilder> {
  late final ViewAllTripJoinCubit viewAllTripJoinCubit;

  @override
  void initState() {
    viewAllTripJoinCubit = context.read<ViewAllTripJoinCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewAllTripJoinCubit, ViewAllTripJoinState>(
      // buildWhen: (previous, current) => !viewAllTripJoinCubit.noMoreDataInDatabase,
      builder: (context, state) {
        return ListView.builder(
          itemCount: viewAllTripJoinCubit.tripJoinCards.length + 1,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            if (index < viewAllTripJoinCubit.tripJoinCards.length) {
              TripJoinCardEntity tripJoinCardEntity = viewAllTripJoinCubit.tripJoinCards[index];
              return AvailableTripCard(
                tripJoinCardEntity: tripJoinCardEntity,
                reportOnTap: () {
                  _reportOnTap(context, index);
                },
                premuimRequestOnTap: () async {
                  if (await _userApproved(
                    tripJoinCardEntity,
                    tripJoinCardEntity.categoryId ?? '',
                    'Trip Join Subscription',
                  )) {}
                },
                requestOnTap: () {},
                callOnTap: () async {
                  if (await _userApproved(
                    tripJoinCardEntity,
                    UIConst.chatNormalId,
                    'Chat Subscription',
                  )) {}
                },
                messageOnTap: () async {
                  if (await _userApproved(
                    tripJoinCardEntity,
                    UIConst.chatNormalId,
                    'Chat Subscription',
                  )) {}
                },
                subscribeMessageOnTap: () async {
                  if (await _userApproved(
                    tripJoinCardEntity,
                    tripJoinCardEntity.categoryId ?? '',
                    'Trip Join Subscription',
                  )) {}
                },
              );
            }
            return state is ViewAllTripJoinLoading && !viewAllTripJoinCubit.noMoreDataInDatabase
                ? const AvailableTripCardLoadingList()
                : const SizedBox();
          },
        );
      },
    );
  }

  Future<bool> _userApproved(TripJoinCardEntity tripJoinCardEntity, String subCategoryId, String title) async {
    if (tripJoinCardEntity.isApproved == null || tripJoinCardEntity.isApproved == false) {
      await serviceLocator<SubscriptionController>().showSubscriptionPlans(
        subCategoryId: subCategoryId,
        title: title,
      );
      return false;
    }
    return false;
  }

  void _reportOnTap(BuildContext context, int index) {
    bottomSheet(
        context: context,
        widget: ReportViewTripJoin(
          id: viewAllTripJoinCubit.tripJoinCards[index].userId ?? '',
          cardId: viewAllTripJoinCubit.tripJoinCards[index].id ?? '',
          categoryId: viewAllTripJoinCubit.tripJoinCards[index].categoryId ?? '',
        ));
  }
}
