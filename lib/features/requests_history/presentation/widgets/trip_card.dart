import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/text_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/are_you_sure.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/usecases/request_come_with_me_usecase.dart';
import 'package:fourtyninehub/features/requests_history/domain/entities/trip_entity.dart';
import 'package:go_router/go_router.dart';
import 'package:google_static_maps_controller/google_static_maps_controller.dart';

import '../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../common/widgets/stateful/maps/static_map.dart';
import '../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

import '../../../ride/trip_details/domain/entities/trip_request_entity.dart';
import '../../../ride/trip_details/presentation/widgets/trip_details.dart';

class TripCard extends StatelessWidget {
  final TripEntity trip;
  final List<TripRequestEntity>? requests;
  final Function(String)? onAccept;
  final Function(String)? onReject;
  final Function(String)? onDelete;
  final bool showDelete;

  final Function(RequestParams)? onRequest;
  const TripCard(
      {super.key,
      required this.trip,
      this.requests,
      this.onAccept,
      this.onDelete,
      this.onRequest,
      this.showDelete = false,
      this.onReject});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => bottomSheet(
          context: context,
          isScrollControlled: true,
          widget: TripDetailsWidget(
            trip: trip,
          )),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: .5),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(FontAwesomeIcons.car,
                    color: AppColors.PRIMARY_COLOR),
                const Sizer(),
                Label(
                  text: context.isArabic?trip.category?.nameAr ?? '':trip.category?.nameEn??'',
                  style: Styles.mediumText(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (showDelete)
                  TextAppButton(
                      label: LocaleKeys.deleteAd.localize,
                      onPressed: () {
                        showAreYouSure(
                            title: LocaleKeys.alert.localize,
                            subTitle:
                            LocaleKeys.areDeleteThisAd.localize,
                            action: () {
                              if (onDelete != null) {
                                onDelete!(trip.id);
                              }
                            },
                            context: context);
                      })
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.location_searching,
                  color: AppColors.PRIMARY_COLOR,
                ),
                const Sizer(),
                Expanded(child: Label(text: trip.fromAddress)),
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: AppColors.SECONDARY_COLOR,
                ),
                const Sizer(),
                Expanded(child: Label(text: trip.toAddress)),
              ],
            ),
            if (trip.offers.isNotEmpty)
              Row(
                children: [
                  TextAppButton(label: LocaleKeys.offers.localize, onPressed: () {}),
                  const Sizer(),
                  Expanded(
                    child: SizedBox(
                      height: kToolbarHeight * .5,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final offer = trip.offers[index];
                            return CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 10,
                              backgroundImage:
                                  NetworkImage(offer.profileImage ?? ''),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(),
                          itemCount: trip.offers.length),
                    ),
                  ),
                ],
              ),
            const Sizer(),
            if (requests?.isNotEmpty ?? false)
              ListView.builder(
                  itemCount: requests?.length ?? 0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return _buildRequestCard(request: requests![index]);
                  }),
            const Sizer(),
            StaticMapWidget(
              height: kToolbarHeight * 1.5,
              radius: 10,
              markers: [
                Marker(locations: [
                  Location(trip.fromCoordinates[0], trip.fromCoordinates[1]),
                  Location(trip.toCoordinates[0], trip.toCoordinates[1]),
                ])
              ],
              paths: [
                Location(trip.fromCoordinates[0], trip.fromCoordinates[1]),
                Location(trip.toCoordinates[0], trip.toCoordinates[1]),
              ],
            ),
            const Sizer(),
            if (onRequest != null)
              AppButton(
                  label: LocaleKeys.request.localize,
                  onPressed: () {
                    bottomSheet(
                        context: context,
                        isScrollControlled: true,
                        widget: _buildPhoneWidget(context));
                  })
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneWidget(BuildContext context) {
    final formState = GlobalKey<FormState>();
    late String phone;
    return Form(
      key: formState,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        child: ListView(
          shrinkWrap: true,
          children: [
            Label(
                text: LocaleKeys.contactPhone.localize,
                style: Styles.mediumText(fontWeight: FontWeight.bold)),
            const Sizer(),
            FormTextField(
                hint: LocaleKeys.phone.localize,
                type: TextInputType.number,
                style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
                action: (v) => phone = v),
            const Sizer(),
            AppButton(
                label: LocaleKeys.done.localize,
                onPressed: () {
                  if (formState.currentState!.validate()) {
                    context.pop();

                    onRequest!(
                        RequestParams(subCategoryId: trip.id, phone: phone));
                  }
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard({required TripRequestEntity request}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(text: request.user?.fullName ?? ''),
        Label(text: request.phone),
        if (!request.isAccepted && !request.isRejected)
          Row(
            children: [
              Expanded(
                  child: AppButton(
                      label: LocaleKeys.reject.localize,
                      onPressed: () {
                        if (onReject != null) {
                          onReject!(request.id);
                        }
                      })),
              const Sizer(),
              Expanded(
                  child: AppButton(
                      label: LocaleKeys.Accept.localize,
                      backColor: Colors.green,
                      onPressed: () {
                        if (onAccept != null) {
                          onAccept!(request.id);
                        }
                      })),
            ],
          ),
        if (request.isAccepted)  BadgedLabel(label: LocaleKeys.Accept.localize),
        if (request.isRejected)  BadgedLabel(label: LocaleKeys.reject.localize)
      ],
    );
  }
}
