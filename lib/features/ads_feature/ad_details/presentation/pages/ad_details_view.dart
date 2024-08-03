import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/functions/global/button_availability.dart';
import 'package:fourtyninehub/common/functions/helper/launch_url.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';

import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/presentation/cubit/ad_details_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/ad_card.dart';
import 'package:fourtyninehub/features/requests_history/domain/entities/address_entity.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/stateless/appbar/back_appbar.dart';
import '../../../../../common/widgets/stateless/dynamic/CarouselSlider.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../../../ride/RideRequest/presentation/widgets/customer/createOrder/changePhoneNumber.dart';
import '../../../../subscripe/presentation/cubit/subscribe_cubit.dart';

class AdDetailsView extends StatefulWidget {
  final String id;
  const AdDetailsView({super.key, required this.id});

  @override
  State<AdDetailsView> createState() => _AdDetailsViewState();
}

class _AdDetailsViewState extends State<AdDetailsView> {
  @override
  void initState() {
    context.read<AdDetailsCubit>().loadData(adId: widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BackAppBar(),
        body: BlocConsumer<AdDetailsCubit, AdDetailsState>(
            listener: (contex, state) {
          if (state.isError) {
            showErrorMessage(
              context,
              getFailureMessage(
                state.failure!,
                context,
              ),
            );
          } else if (state.isSuccess) {
            showSuccessMessage(context, Labels.success);
          }
        }, builder: (context, state) {
          if (state.ad == null) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      _buildAdInfoWidget(ad: state.ad!),
                      const Sizer(),
                      // const GoogleAddsBanner(
                      //   margin: 0,
                      // ),
                      const Sizer(),
                      _buildDetailsWidget(ad: state.ad!),
                      _buildLocationWidget(address: state.ad!.address!),
                      const Sizer(),
                      _buildRelevantAdsWidget(),
                    ],
                  ),
                ),
                _buildActionsWidget(),
              ],
            ),
          );
        }));
  }

  Widget _buildRelevantAdsWidget() {
    return BlocBuilder<AdDetailsCubit, AdDetailsState>(
        builder: (context, state) {
      if (state.relevantAds?.isEmpty ?? true) {
        return const SizedBox();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(
            text: 'Relevant Ads',
            style: Styles.mediumText(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: kToolbarHeight * 3.5,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) =>
                    AdCard(item: state.relevantAds![index]),
                separatorBuilder: (context, index) => const Sizer(),
                itemCount: state.relevantAds?.length ?? 0),
          ),
        ],
      );
    });
  }

  Widget _buildActionsWidget() {
    return BlocBuilder<AdDetailsCubit, AdDetailsState>(
        builder: (context, state) {
      final controller = context.read<AdDetailsCubit>();
      return Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            FutureBuilder(
                future: ButtonAvailability().isShowButton(
                    otherUserId: state.ad?.user?.id ?? '',
                    subcategoryId: state.ad?.subCategoryId ?? ''),
                builder: (context, snap) {
                  if (snap.data ?? false) {
                    return Row(
                      children: [
                        Expanded(
                            child: AppButton(
                                label: 'Chat',
                                icon: Icons.chat_bubble_outline,
                                onPressed: () =>
                                    context.push(Routes.CHATROOM))),
                        const Sizer(
                          width: 5,
                        ),
                        Expanded(
                            child: AppButton(
                                label: 'Call',
                                icon: Icons.call,
                                onPressed: () => LaunchURLHelper()
                                    .call(phone: state.ad?.phone ?? ''))),
                      ],
                    );
                  }
                  return const SizedBox();
                }),
            const Sizer(),
            Row(
              children: [
                Expanded(
                    child: AppButton(
                        label: 'Premium Request',
                        icon: Icons.bookmark,
                        onPressed: () {
                          serviceLocator<SubscribeCubit>()
                              .checkIfUserSubscribed(
                                  // context: context,
                                  onSubscribed: () {
                                    if (controller.phone == null) {
                                      bottomSheet(
                                          context: context,
                                          widget: RideContactPhoneNumber(
                                            onChanged: (String v) =>
                                                controller.changePhone(v: v),
                                            onSubmit: () => controller
                                                .makeAdRequest(id: widget.id),
                                          ));
                                    } else {
                                      controller.makeAdRequest(id: widget.id);
                                    }
                                  },
                                  subCategoryId: state.ad?.subCategoryId ??
                                      '62c8ba9f8e28a58a3edf57eb');
                        })),
                const Sizer(
                  width: 5,
                ),
                Expanded(
                    child: AppButton(
                        label: 'Request',
                        icon: Icons.bookmark,
                        onPressed: () {
                          if (controller.phone == null) {
                            bottomSheet(
                                context: context,
                                widget: RideContactPhoneNumber(
                                  onChanged: (String v) =>
                                      controller.changePhone(v: v),
                                  onSubmit: () =>
                                      controller.makeAdRequest(id: widget.id),
                                ));
                          } else {
                            controller.makeAdRequest(id: widget.id);
                          }
                        })),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildLocationWidget({required AddressEntity address}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          text: 'Address',
          style: Styles.mediumText(fontWeight: FontWeight.bold),
        ),
        InkWell(
          onTap: () => LaunchURLHelper().openLocation(
              lat: address.coordinates[0], lng: address.coordinates[1]),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined),
              const Sizer(),
              Expanded(child: Label(text: address.address)),
            ],
          ),
        ),
        const Sizer(),
        SizedBox(
            height: kToolbarHeight * 2,
            width: double.infinity,
            child: Stack(
              children: [
                const Positioned.fill(
                    child: SquareImage(
                        radius: 10,
                        source: NetworkImage(UIConst.mapPlaceHolderImage))),
                Positioned.fill(
                  child: Center(
                    child: AppButton(
                      label: 'Open Location',
                      width: kToolbarHeight * 2,
                      onPressed: () => LaunchURLHelper().openLocation(
                          lat: address.coordinates[0],
                          lng: address.coordinates[1]),
                    ),
                  ),
                ),
              ],
            ))
      ],
    );
  }

  Widget _buildAdInfoWidget({required AdModel ad}) {
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
        Label(
          text: ad.title,
          style: Styles.mediumText(fontWeight: FontWeight.bold),
        ),
        InkWell(
          onTap: () => LaunchURLHelper().openLocation(
              lat: ad.address!.coordinates[0], lng: ad.address!.coordinates[1]),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined),
              const Sizer(),
              Expanded(child: Label(text: ad.address?.address ?? "")),
              const Sizer(),
              Label(text: ad.formatedDate)
            ],
          ),
        ),
        const Sizer(),
        Label(
          text: 'Description',
          style: Styles.mediumText(fontWeight: FontWeight.bold),
        ),
        Label(text: ad.description),
      ],
    );
  }

  Widget _buildDetailsWidget({required AdModel ad}) {
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
}
