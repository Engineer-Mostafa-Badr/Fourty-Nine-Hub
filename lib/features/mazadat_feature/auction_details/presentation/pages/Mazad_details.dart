import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_entity.dart';
import 'package:fourtyninehub/features/mazadat_feature/auction_details/presentation/cubit/auction_details_cubit.dart';
import '../../../../../common/functions/helper/launch_url.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/dynamic/CarouselSlider.dart';
import '../../../../../common/widgets/stateless/images/square_image.dart';
import '../../../../../common/widgets/stateless/labels/ReadMoreLabel.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../auction_list/domain/entities/auction_entity.dart';
import '../widgets/DetailsCounterWidget.dart';
import '../widgets/PlaceBidding.dart';

class MazadDetails extends StatelessWidget {
  const MazadDetails({super.key});

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
          bottomNavigationBar: AppButton(
              margin: 10,
              label: Labels.placeBidding,
              onPressed: () {
                bottomSheet(
                    context: context,
                    widget: PlaceBidding(
                      auction: state.auction!,
                      onPlaced: (num v) => controller.sendBidding(bidding: v),
                    ));
              }),
          body: state.status == AuctionDetailsStates.loading
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
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                    color: index.isEven
                        ? AppColors.LIGHT_GRAY_COLOR
                        : Colors.white),
                child: Row(
                  children: [
                    Expanded(child: Label(text: detail.label)),
                    Expanded(child: Label(text: detail.value)),
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
        _buildUserInfo(ad: ad, context: context),
      ],
    );
  }

  Widget _buildUserInfo({required AdEntity ad, required BuildContext context}) {
    final controller = context.read<AuctionDetailsCubit>();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(ad.user.image),
          ),
          const Sizer(),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(
                  text: ad.user.name,
                  style: Styles.mediumText(color: Colors.black)),
              Label(
                  text: ad.user.email,
                  style: Styles.mediumText(color: Colors.grey)),
            ],
          )),
          const Sizer(),
          AppButton(
              padding: 3,
              height: 30,
              label: 'Follow',
              onPressed: () => controller.followUser())
        ],
      ),
    );
  }
}
