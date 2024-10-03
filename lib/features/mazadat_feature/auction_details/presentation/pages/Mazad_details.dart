import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_entity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:fourtyninehub/features/mazadat_feature/auction_details/domain/usecases/send_bidding_usecase.dart';
import 'package:fourtyninehub/features/mazadat_feature/auction_details/presentation/cubit/auction_details_cubit.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/dynamic/carousel_slider.dart';
import '../../../../../common/widgets/stateless/images/square_image.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../auction_list/domain/entities/auction_entity.dart';
import '../widgets/DetailsCounterWidget.dart';
import '../widgets/PlaceBidding.dart';

class MazadDetails extends StatefulWidget {
  final String id;
  const MazadDetails({super.key, required this.id});

  @override
  State<MazadDetails> createState() => _MazadDetailsState();
}

class _MazadDetailsState extends State<MazadDetails> {
  @override
  void initState() {
    context.read<AuctionDetailsCubit>().loadData(id: widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuctionDetailsCubit, AuctionDetailsState>(
      listener: (BuildContext context, AuctionDetailsState state) {
        if (state.isError && state.failure != null) {
          showErrorMessage(
            context,
            getFailureMessage(
              state.failure!,
              context,
            ),
          );
        } else if (state.isSuccess && state.successMessage != null) {
          showSuccessMessage(context, state.successMessage ?? '');
        }
      },
      builder: (context, state) {
        final controller = context.read<AuctionDetailsCubit>();
        return Scaffold(
          appBar: const BackAppBar(),
          bottomNavigationBar: ((state.auction?.isMine ?? false) &&
                  !(state.auction?.isFinished ?? false))
              ? AppButton(
                  margin: 10,
                  label: Labels.endAuction,
                  color: AppColors.AUTH_CONTAINER_COLOR,
                  onPressed: () => controller.endAuction(id: widget.id))
              : ((state.auction?.isMine ?? false) &&
                      (state.auction?.isFinished ?? false))
                  ? AppButton(
                      color: AppColors.AUTH_CONTAINER_COLOR,
                      margin: 10,
                      label: Labels.biddings,
                      onPressed: () {
                        controller.showAuctionRequests(
                            id: widget.id, context: context);
                      })
                  : AppButton(
                      color: AppColors.AUTH_CONTAINER_COLOR,
                      margin: 10,
                      label: Labels.placeBidding,
                      onPressed: () {
                        bottomSheet(
                            context: context,
                            widget: PlaceBidding(
                              auction: state.auction!,
                              onPlaced: (num v) async =>
                                  await controller.sendBidding(
                                      params: SendBiddingParams(
                                          auctionId: widget.id, price: v)),
                            ));
                      }),
          body: state.isLoading
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    children: [
                      _buildAdInfoWidget(
                          ad: state.auction!.ad,
                          auction: state.auction!,
                          context: context),
                      _buildDetailsWidget(ad: state.auction!.ad),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildDetailsWidget({required AdEntity ad}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          text: 'Details',
          style: Styles.mediumText(fontWeight: FontWeight.bold),
        ),
        ListView.builder(
            itemCount: ad.details.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final detail = ad.details[index];
              return Container(
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5),
                decoration: BoxDecoration(
                    color: index.isEven
                        ? AppColors.AUTH_CONTAINER_COLOR
                        : AppColors.AUTH_CONTAINER_COLOR),
                child: Row(
                  children: [
                    Expanded(
                        child: Label(
                      text: getLang() == 'ar'
                          ? detail.value.nameAr
                          : detail.value.nameEn,
                      color: AppColors.QUANTITY_COLOR,
                    )),
                    Expanded(
                        child: Label(
                      text: getLang() == 'ar'
                          ? detail.value.nameAr
                          : detail.value.nameEn,
                      color: AppColors.QUANTITY_COLOR,
                    )),
                  ],
                ),
              );
            }),
      ],
    );
  }

  Widget _buildAdInfoWidget(
      {required AdEntity ad,
      required AuctionEntity auction,
      required BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CarouselSliderWidget(
          height: kToolbarHeight * 2,
          widgets: ad.images.map((e) {
            return SquareImage(
              source: NetworkImage(e),
              fit: BoxFit.cover,
            );
          }).toList(),
        ),
        DetailsCounterWidget(
          auction: auction,
        ),
        Label(
          text: ad.title,
          style: Styles.mediumText(fontWeight: FontWeight.bold),
        ),
        Label(
          text: ad.description,
          style: Styles.mediumText(),
        ),
        Label(
          text: 'Description',
          style: Styles.mediumText(fontWeight: FontWeight.bold),
        ),
        Label(text: ad.description),
        _buildUserInfo(ad: ad, auction: auction, context: context),
      ],
    );
  }

  Widget _buildUserInfo(
      {required AdEntity ad,
      AuctionEntity? auction,
      required BuildContext context}) {
    final controller = context.read<AuctionDetailsCubit>();
    if ((auction?.isMine ?? false)) {
      return const SizedBox();
    }
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(auction?.user?.profilePicture ?? ''),
          ),
          const Sizer(),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(
                  text: auction?.user?.fullName ?? '',
                  style: Styles.mediumText(color: Colors.black)),
              Label(
                  text: auction?.user?.email ?? '',
                  style: Styles.mediumText(color: Colors.grey)),
            ],
          )),
          const Sizer(),
          AppButton(
              padding: 3,
              height: 30.h,
              label: 'Follow',
              onPressed: () => controller.followUser(userId: auction?.id ?? ''))
        ],
      ),
    );
  }
}
