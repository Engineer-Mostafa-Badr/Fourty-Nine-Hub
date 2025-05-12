import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/functions/helper/lang_helper.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../health_feature/create_doctor/domain/entities/city.dart';
import '../../../../health_feature/create_doctor/domain/entities/governorate_entity.dart';
import '../../controllers/client_trips_cubit/client_trips_cubit.dart';
import 'bottom_sheet/custom_bottom_sheet.dart';

class PickUpLocationCard extends StatefulWidget {
  final Color? firstColor;
  final ClientTripsCubit cubit;
  final bool isStartLocation;

  const PickUpLocationCard(
      {super.key,
      this.firstColor,
      required this.cubit,
      this.isStartLocation = true});

  @override
  State<PickUpLocationCard> createState() => _PickUpLocationCardState();
}

class _PickUpLocationCardState extends State<PickUpLocationCard> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientTripsCubit, ClientTripsState>(
      builder: (context, state) {
        String? title = widget.isStartLocation
            ? (widget.cubit.makeNonTrackingTripParam.fromTitle ??
                LocaleKeys.startPoint.localize)
            : (widget.cubit.makeNonTrackingTripParam.toTitle ??
                LocaleKeys.destination.localize);
        return GestureDetector(
          onTap: () {
            widget.cubit.getGovernorates();
            String resultGovernorate = '';
            String resultCity = '';
            customBottomSheet2(context,height: 750.0,
                    child: BlocBuilder<ClientTripsCubit, ClientTripsState>(
                      bloc: widget.cubit,
                      builder: (context, state) {
                        if (state.isLoadingCities ||
                            state.isLoadingGovernorates) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state.isSuccess) {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: state.cities?.length,
                              itemBuilder: (context, index) {
                                CityEntity? city = state.cities?[index];
                                return GestureDetector(
                                  onTap: () {
                                    resultCity = (getLang() == "ar"
                                        ? city?.nameAr ?? ""
                                        : city?.nameEn ?? "");
                                    if (widget.isStartLocation) {
                                      widget.cubit.makeNonTrackingTripParam
                                              .fromTitle =
                                          '$resultGovernorate, $resultCity';
                                    } else {
                                      widget.cubit.makeNonTrackingTripParam
                                              .toTitle =
                                          '$resultGovernorate, $resultCity';
                                    }
                                    context
                                        .pop('$resultGovernorate, $resultCity');
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      (getLang() == "ar"
                                              ? city?.nameAr
                                              : city?.nameEn) ??
                                          '',
                                      style: Styles.headerText(
                                        color:  AppColors.PRIMARY_COLOR
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return Expanded(
                            child: ListView.builder(
                              // shrinkWrap: true,
                              // physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.governorates?.length,
                              itemBuilder: (context, index) {
                                GovernorateEntity? governorate =
                                    state.governorates?[index];
                                return GestureDetector(
                                  onTap: () {
                                    resultGovernorate = (getLang() == "ar"
                                        ? governorate?.nameAr ?? ""
                                        : governorate?.nameEn ?? "");
                                    widget.cubit.getCities(governorate!.id);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      (getLang() == "ar"
                                              ? governorate?.nameAr
                                              : governorate?.nameEn) ??
                                          '',
                                      style: Styles.headerText(
                                        color:  AppColors.PRIMARY_COLOR
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                    title: title!)
                .then((value) {
              setState(() {
                title = value;
              });
            });
          },
          child: Container(
              height: 48,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: widget.firstColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  // Text "PickUp Location"
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color:  AppColors.PRIMARY_COLOR
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }
}
