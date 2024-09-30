import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/domain/entities/tripjoin_request_history_entity.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/presentation/cubits/get_request/get_request_cubit.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/presentation/widgets/trip_join_request_history_card.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/presentation/widgets/trip_join_request_history_card_loading.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/report_view_trip_join.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TripJoinRequestHistoryBuilder extends StatefulWidget {
  const TripJoinRequestHistoryBuilder({super.key, required this.id});
  final String id;
  @override
  State<TripJoinRequestHistoryBuilder> createState() =>
      _TripJoinRequestHistoryBuilderState();
}

class _TripJoinRequestHistoryBuilderState
    extends State<TripJoinRequestHistoryBuilder> {
  late final GetRequestCubit getRequestCubit;
  late final ScrollController scrollController;
  late double scrollPosition;
  late double scrollMaxExtent;
  bool isLoading = false;
  @override
  void initState() {
    getRequestCubit = context.read<GetRequestCubit>();
    _fetchRequestsIfEmpty();
    _scrollListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // serviceLocator<GetRequestUsecase>().call(id: widget.id, page: 1);
    // List<TripJoinRequestHistoryEntity> staticData = List.generate(10, (_) {
    //   return TripJoinRequestHistoryEntity(
    //     firstName: 'Eslam',
    //     gender: 'Male',
    //     allowStatus: 'disable',
    //   );
    // });
    return BlocConsumer<GetRequestCubit, GetRequestState>(
      listener: (context, state) {
        if (state is GetRequestFailed) {
          showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
        return ListView.builder(
          controller: scrollController,
          itemCount: getRequestCubit.requests.length + 1,
          itemBuilder: (context, index) {
            final tripJoinRequestHistoryEntity =
                index < getRequestCubit.requests.length
                    ? getRequestCubit.requests[index]
                    : null;
            if (getRequestCubit.requests.isEmpty &&
                state is! GetRequestLoading) {
              return Container(
                height: context.screenHeight * 0.8,
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(LocaleKeys.noTripRequests.localize),
              );
            }
            if (index < getRequestCubit.requests.length) {
              return TripJoinRequestHistoryCard(
                tripJoinRequestHistoryEntity: tripJoinRequestHistoryEntity!,
                callOnTap: () async {
                  if (await _userApproved(
                    tripJoinRequestHistoryEntity,
                    UIConst.chatNormalId,
                    LocaleKeys.chatSubscription.localize,
                  )) {
                    launchUrlString(
                        "tel://${tripJoinRequestHistoryEntity.phone}");
                  }
                },
                messageOnTap: () async {
                  if (await _userApproved(
                    tripJoinRequestHistoryEntity,
                    UIConst.chatNormalId,
                    LocaleKeys.chatSubscription.localize,
                  )) {}
                },
                reportOnTap: () {
                  _reportOnTap(context, tripJoinRequestHistoryEntity);
                },
              );
            }
            return state is GetRequestLoading
                ? const TripJoinRequestHistoryLoadingList()
                : const SizedBox();
          },
        );
      },
    );
  }

  Future<bool> _userApproved(
      TripJoinRequestHistoryEntity tripJoinRequestHistoryEntity,
      String subCategoryId,
      String title) async {
    if (tripJoinRequestHistoryEntity.allowStatus == null ||
        tripJoinRequestHistoryEntity.allowStatus != 'enable') {
      await serviceLocator<SubscriptionController>().showSubscriptionPlans(
        wallets: [
          tripJoinRequestHistoryEntity.paymentType?.toWalletType ??
              WalletTypes.balance
        ],
        subCategoryId: subCategoryId,
        title: title,
      );
      return false;
    }
    return true;
  }

  void _reportOnTap(BuildContext context,
      TripJoinRequestHistoryEntity tripJoinRequestHistoryEntity) {
    bottomSheet(
        context: context,
        widget: ReportViewTripJoin(
          id: tripJoinRequestHistoryEntity.userIdStr ?? '',
          cardId: tripJoinRequestHistoryEntity.id ?? '',
          categoryId: UIConst.tripJoinCategoryId,
        ));
  }

  void _scrollListener() {
    scrollController = ScrollController();
    scrollController.addListener(() async {
      scrollPosition = scrollController.position.pixels;
      scrollMaxExtent = scrollController.position.maxScrollExtent;
      if (scrollPosition >= 0.7 * scrollMaxExtent) {
        if (!isLoading &&
            (getRequestCubit.requests.last.hasNextPage ?? false)) {
          isLoading = true;
          getRequestCubit.page = getRequestCubit.requests.last.nextPage!;
          await getRequestCubit.getRequets(id: widget.id);
          isLoading = false;
        }
      }
    });
  }

  void _fetchRequestsIfEmpty() {
    if (getRequestCubit.requests.isEmpty) {
      getRequestCubit.page = 1;
      getRequestCubit.getRequets(id: widget.id);
    }
  }
}
