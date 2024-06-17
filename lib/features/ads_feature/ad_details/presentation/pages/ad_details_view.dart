import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/launch_url.dart';
import 'package:fourtyninehub/common/widgets/dynamic/google_ads_banner.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/presentation/cubit/ad_details_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:fourtyninehub/features/requests_history/domain/entities/address_entity.dart';
import 'package:fourtyninehub/res/style/const.dart';

import '../../../../../common/widgets/stateless/appbar/back_appbar.dart';
import '../../../../../common/widgets/stateless/dynamic/CarouselSlider.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class AdDetailsView extends StatelessWidget {
  const AdDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BackAppBar(
          label: 'Ad Details',
        ),
        bottomNavigationBar: _buildActionsWidget(),
        body: BlocBuilder<AdDetailsCubit, AdDetailsState>(
            builder: (context, state) {
          if (state.ad == null) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: [
                _buildAdInfoWidget(ad: state.ad!),
                const Sizer(),
                const GoogleAddsBanner(
                  margin: 0,
                ),
                const Sizer(),
                _buildDetailsWidget(ad: state.ad!),
                _buildLocationWidget(address: state.ad!.address),
              ],
            ),
          );
        }));
  }

  Widget _buildActionsWidget() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
              child: AppButton(
                  label: 'Chat',
                  icon: Icons.chat_bubble_outline,
                  onPressed: () {})),
          const Sizer(),
          Expanded(
              child:
                  AppButton(label: 'Call', icon: Icons.call, onPressed: () {})),
          const Sizer(),
          Expanded(
              child: AppButton(
                  label: 'Request', icon: Icons.bookmark, onPressed: () {})),
        ],
      ),
    );
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
        Label(
          text: ad.description,
          style: Styles.mediumText(),
        ),
        InkWell(
          onTap: () => LaunchURLHelper().openLocation(
              lat: ad.address.coordinates[0], lng: ad.address.coordinates[1]),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined),
              const Sizer(),
              Expanded(child: Label(text: ad.address.address)),
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
