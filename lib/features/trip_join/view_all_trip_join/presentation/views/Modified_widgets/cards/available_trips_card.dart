import 'package:easy_localization/easy_localization.dart' as EasyLocale;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/phone_number_text_field.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../../core/extensions/context_extension.dart';
import '../../../../../../../core/extensions/string_extension.dart';
import '../../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../../core/widget/custom_loading_search_widget.dart';
import '../../../../../../../helpers/manage_vibration.dart';
import '../../../../../../../res/assets/assets.dart';
import '../../../../../../../res/style/app_colors.dart';
import '../../../../../../../res/style/styles.dart';
import '../../../../../../../routes/routes.dart';
import '../../../../../../RideFeature/presentation/pages/loading_dashboard/loading_dashboard_details_screen.dart';
import '../../../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../../domain/entities/available_trip_join_entity.dart';
import '../../../cubits/view_all_trip_join_cubit/view_all_trip_join_cubit.dart';
import '../../widgets/trip_join/request_log_widget.dart';
import '../trip_join_card.dart';
import '../trip_join_card_button.dart';
import '../trip_join_dialog/dialog_content.dart';
import '../trip_join_dialog/show_dialog_trip_join.dart';
import '../trip_join_floating_action_button.dart';
import 'trip_contacts_buttons.dart';

String formatViews(num views, BuildContext context) {
  if (views < 1000) {
    return '$views';
  } else if (views < 1000000) {
    double kViews = views / 1000;
    return context.isArabic
        ? '${kViews.toStringAsFixed(1)} ألف' // Arabic style: ألف
        : '${kViews.toStringAsFixed(1)}k';
  } else {
    double mViews = views / 1000000;
    return context.isArabic
        ? '${mViews.toStringAsFixed(1)} مليون' // Arabic style: مليون
        : '${mViews.toStringAsFixed(1)}M';
  }
}

class AvailableTripsCard extends StatefulWidget {
  const AvailableTripsCard({
    super.key,
  });

  @override
  State<AvailableTripsCard> createState() => _AvailableTripsCardState();
}

class _AvailableTripsCardState extends State<AvailableTripsCard> {
  late ScrollController _scrollController;
  bool _isVisible = true;
  String convertDigits(String input, {bool toArabic = false}) {
    const western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const eastern = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    final from = toArabic ? western : eastern;
    final to = toArabic ? eastern : western;

    for (int i = 0; i < from.length; i++) {
      input = input.replaceAll(from[i], to[i]);
    }

    return input;
  }
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  bool _hasSearchText = false;

  final Map<String, DateTime> _lastTapTimes = {};

  Widget _buildSearchField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              style: TextStyle(
                color: AppColors.getTextColor(context),
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: context.isArabic
                    ? 'ابحث عن عروض الرحلات...'
                    : 'Search offers...',
                hintStyle: TextStyle(
                  color: AppColors.getTextColor(context).withOpacity(0.6),
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.SECONDARY_COLOR,
                  size: 20,
                ),
              ),
              textInputAction: TextInputAction.search,
              onChanged: (value) => setState(() => _hasSearchText = value.isNotEmpty),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  // _performSearch(value);
                }
              },
            ),
          ),
          if(_hasSearchText)...[
            Sizer(width: 8.w),
            Padding(
              padding: const EdgeInsets.only(right: 8,left: 8),
              child: GestureDetector(
                onTap: () {
                  ManageVibration.vibrate();
                  if(context.read<ViewAllTripJoinCubit>().state.offersFromSearch==true)context.read<ViewAllTripJoinCubit>().loadInitialTripJoin(false,'');
                  _searchController.clear();
                  setState(() {
                    _hasSearchText=false;
                  });
                  // _performSearch(_searchController.text);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.GREY_DARK_COLOR,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
            Sizer(width: 8.w),
            Padding(
              padding: const EdgeInsets.only(right: 8,left: 8),
              child: GestureDetector(
                onTap: () {
                  ManageVibration.vibrate();
                  context.read<ViewAllTripJoinCubit>().loadInitialTripJoin(true,_searchController.text);
                  // _performSearch(_searchController.text);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.SECONDARY_COLOR,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<ViewAllTripJoinCubit, ViewAllTripJoinState>(
          builder: (context, state) {
            if (context.read<ViewAllTripJoinCubit>().isLoadingTripJoin ==
                true) {
              return const Center(
                child: CustomLoadingSearchWidget(),
              );
            }
            if (context.read<ViewAllTripJoinCubit>().tripJoinData.isEmpty) {
              return Center(child: Text(LocaleKeys.noData.localize));
            }
            return GlowingOverscrollIndicator(
              color: AppColors.SECONDARY_COLOR,
              axisDirection: AxisDirection.down,
              child: Column(
                children: [
                  _buildSearchField(),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemCount:
                            context.read<ViewAllTripJoinCubit>().tripJoinData.length,
                        itemBuilder: (context, index) {
                          var data = context
                              .read<ViewAllTripJoinCubit>()
                              .tripJoinData[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    ManageVibration.vibrate();
                                    // context.read<ViewAllTripJoinCubit>().applyViewTrip(data.id!);
                                    // print("Hi");
                                    if(data.isView==true||((UserCubit.to.state.data?.id??'')==data.creatorId)){return;}
                                    context.read<ViewAllTripJoinCubit>().applyViewTrip(data.id??'');

                                    // _handleTap(data.id!);
                                  },
                                  child: Stack(
                                    children: [
                                      CustomCard(
                                        color: ((data.isView==true||((UserCubit.to.state.data?.id??'')==data.creatorId))?AppColors.whiteColor:AppColors.BG_GRAY_COLOR),
                                        radius: 20,
                                        children: [
                                          const Sizer(height: 8,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 32.0.h),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.remove_red_eye_sharp,
                                                        color: context.isDarkMode
                                                            ? AppColors.whiteColor
                                                            : AppColors
                                                                .DARK_GRAY_COLOR,
                                                      ),
                                                      const Sizer(),
                                                      Label(
                                                        text:
                                                            '${formatPrice(formatViews(data.viewerIds ?? 0, context).toInt, context)} ${LocaleKeys.views.localize}',
                                                        style: Styles.mediumText(
                                                          fontSize: 24,
                                                          color: context.isDarkMode
                                                              ? AppColors.whiteColor
                                                              : AppColors
                                                                  .DARK_GRAY_COLOR,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  data.formattedOfferType,
                                                  style: Styles.headerText(
                                                      color: AppColors.getRedColor(
                                                          context),
                                                      fontSize: 32),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(),
                                          const Sizer(),
                                          TripCardInfoWidget(
                                              title: context.isArabic
                                                  ? data.vehicleDetails?.brandAr ?? ""
                                                  : data.vehicleDetails?.brandEn ??
                                                      "",
                                              model: context.isArabic
                                                  ? data.vehicleDetails?.modelAr ?? ""
                                                  : data.vehicleDetails?.modelEn ??
                                                      "",
                                              icon: Assets.tripJoinCarIcon,
                                              price: formatPrice(
                                                  data.pricePerSeat?.round() ?? 0,
                                                  context),
                                              seats: LocaleKeys.eachSeat.localize),
                                          const Sizer(
                                            height: 30,
                                          ),
                                          _locationWidget(
                                              title:
                                                  data.location?.start?.address ?? "",
                                              iconColor: AppColors.LIGHT_BLUE),
                                          const Sizer(),
                                          _locationWidget(
                                              title: data.location?.target?.address ??
                                                  "",
                                              iconColor: AppColors.CHECK_MARK_COLOR),
                                          const Sizer(),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 32.0.h,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  formatTimestamp(
                                                      data.startDate!, context),
                                                  style: Styles.headerText(
                                                      fontSize: 32,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                Text(
                                                  // data.passengers == 1
                                                  //     ? '${data.passengers} ${LocaleKeys.seat.localize}'
                                                  //     : ''
                                                  '${formatPrice(data.passengers ?? 1, context)} ${LocaleKeys.seat.localize}',
                                                  style: Styles.headerText(
                                                      fontSize: 32,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                Text(
                                                  data.isRepeat == true
                                                      ? LocaleKeys.repeated.localize
                                                      : LocaleKeys.oneTime.localize,
                                                  style: Styles.headerText(
                                                      fontSize: 32,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(),
                                          Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 32.0.h,
                                              ),
                                              child: Row(
                                                spacing: 15,
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 8.h, bottom: 8.h),
                                                      child: TripJoinCardButton(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 15,
                                                            vertical: 5),
                                                        title: LocaleKeys
                                                            .request.localize,
                                                        color: AppColors.getRedColor(
                                                            context),
                                                        onTap: () {
                                                          ManageVibration.vibrate();
                                                          showModalBottomSheet(
                                                            backgroundColor: Colors.white,
                                                            context: context,
                                                            shape: const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.only(
                                                                topLeft: Radius.circular(32.0),
                                                                topRight: Radius.circular(32.0),
                                                              ),
                                                            ),
                                                            isDismissible: true,
                                                            isScrollControlled: true,
                                                            builder: (BuildContext context) {
                                                              return BlocProvider.value(
                                                                value: serviceLocator<ViewAllTripJoinCubit>(),
                                                                child: BlocBuilder<ViewAllTripJoinCubit,ViewAllTripJoinState>(
                                                                    builder: (context,state) {
                                                                      return AnimatedPadding(
                                                                        padding:
                                                                        MediaQuery.of(context).viewInsets,
                                                                        duration:
                                                                        const Duration(milliseconds: 50),
                                                                        child: Container(
                                                                          height: 400.h,
                                                                          padding: EdgeInsets.symmetric(
                                                                            vertical: 10.h,
                                                                            horizontal: 10,
                                                                          ),
                                                                          child: Form(
                                                                            key: formKey,
                                                                            child: Column(
                                                                              children: [
                                                                                Label(
                                                                                  text: context.isArabic
                                                                                      ? "ادخل رقم هاتفك"
                                                                                      : "Enter your phone number",
                                                                                  style: Styles.headerText(),
                                                                                ),
                                                                                Sizer(
                                                                                  height: 30.h,
                                                                                ),
                                                                                CustomPhoneTextFormField(
                                                                                  currentFocusNode: FocusNode(),
                                                                                  nextFocusNode: FocusNode(),
                                                                                  currentController:
                                                                                  phoneController,
                                                                                  onInputChanged: (value) =>
                                                                                      formKey.currentState!
                                                                                          .validate(),
                                                                                  inputFormatters: [
                                                                                    FilteringTextInputFormatter
                                                                                        .digitsOnly,
                                                                                    LengthLimitingTextInputFormatter(
                                                                                        11),
                                                                                  ],
                                                                                  validator: (value) {
                                                                                    final input =
                                                                                        value?.trim() ?? '';

                                                                                    if (input.isEmpty) {
                                                                                      return LocaleKeys
                                                                                          .required.localize;
                                                                                    }

                                                                                    final numericValue =
                                                                                    convertDigits(input,
                                                                                        toArabic: false)
                                                                                        .replaceAll(
                                                                                        RegExp(r'[^0-9]'),
                                                                                        '');

                                                                                    if (numericValue.length !=
                                                                                        11) {
                                                                                      return context.isArabic
                                                                                          ? 'يجب أن يحتوي رقم الهاتف على 11 رقمًا'
                                                                                          : 'Phone number must be exactly 11 digits.';
                                                                                    }

                                                                                    if (![
                                                                                      '010',
                                                                                      '011',
                                                                                      '012',
                                                                                      '015'
                                                                                    ].any(numericValue
                                                                                        .startsWith)) {
                                                                                      return context.isArabic
                                                                                          ? 'رقم الهاتف يجب أن يبدأ بـ 010 أو 011 أو 012 أو 015'
                                                                                          : 'Phone number must start with 010, 011, 012, or 015.';
                                                                                    }

                                                                                    return null;
                                                                                  },
                                                                                ),
                                                                                Expanded(
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Expanded(
                                                                                        child: InkWell(
                                                                                          onTap: () async {
                                                                                            if (formKey
                                                                                                .currentState!
                                                                                                .validate()) {
                                                                                              context.read<ViewAllTripJoinCubit>().createTripJoinRequest(
                                                                                                  data.id??'',
                                                                                                  false,
                                                                                                  phoneController.text
                                                                                              );
                                                                                            }
                                                                                          },
                                                                                          child: Container(
                                                                                            width: 100,
                                                                                            height: 80.h,
                                                                                            padding:
                                                                                            const EdgeInsets
                                                                                                .all(5),
                                                                                            decoration: BoxDecoration(
                                                                                                color: AppColors
                                                                                                    .PRIMARY_COLOR,
                                                                                                borderRadius:
                                                                                                BorderRadius
                                                                                                    .circular(
                                                                                                    15)),
                                                                                            alignment:
                                                                                            Alignment.center,
                                                                                            child: Label(
                                                                                              text: LocaleKeys
                                                                                                  .request.localize,
                                                                                              style: Styles
                                                                                                  .headerText(
                                                                                                  color: Colors
                                                                                                      .white),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Sizer(),
                                                                                      Expanded(
                                                                                        child: InkWell(
                                                                                          onTap: () async {
                                                                                            if (formKey
                                                                                                .currentState!
                                                                                                .validate()) {
                                                                                              context.read<ViewAllTripJoinCubit>().createTripJoinRequest(
                                                                                                  data.id??'',
                                                                                                  true,
                                                                                                  phoneController.text
                                                                                              );
                                                                                              // context.read<ViewAllTripJoinCubit>().createPickMeRequest();
                                                                                            }
                                                                                          },
                                                                                          child: Container(
                                                                                            width: 100,
                                                                                            height: 80.h,
                                                                                            padding:
                                                                                            const EdgeInsets
                                                                                                .all(5),
                                                                                            decoration: BoxDecoration(
                                                                                                color: AppColors
                                                                                                    .SECONDARY_COLOR,
                                                                                                borderRadius:
                                                                                                BorderRadius
                                                                                                    .circular(
                                                                                                    15)),
                                                                                            alignment:
                                                                                            Alignment.center,
                                                                                            child: Label(
                                                                                              text: LocaleKeys
                                                                                                  .premium_request.localize,
                                                                                              style: Styles
                                                                                                  .headerText(
                                                                                                  color: Colors
                                                                                                      .white),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                        radius: 15,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: ContactsTripButtons(
                                                      // isPremium: false,
                                                      isPremium: data.isPremium,
                                                      isButtonEnabled: data.isButtonEnabled!.state,
                                                      otherUserId: '2',
                                                      subcategoryId:
                                                          '62ea00e269ea29c91dfc390c',
                                                      phone:
                                                          data.phoneNumber ?? "1234",
                                                      id: context
                                                          .read<UserCubit>()
                                                          .state
                                                          .data!
                                                          .id,
                                                      hasReport: true,
                                                    ),
                                                  ),
                                                ],
                                              )

                                              // TripJoinButtonsSection(
                                              //   isContactInfo: data.isPremium == true || data.isButtonEnabled!.state == true ? true : false,
                                              //   isRequestButton: true,
                                              //   buttonTitle:LocaleKeys.requests.localize,
                                              //   // buttonTitle:" buttonTitle",
                                              //   onTap: (){},
                                              // ),
                                              ),
                                          const Sizer(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                data.isPremium == true ||
                                        data.isButtonEnabled!.state == true
                                    ? SizedBox()
                                    : TripCardSubscribeText(),
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              ),
            );
          },
        ),
        PositionedDirectional(
          bottom: 0.h,
          start: 0,
          end: 0,
          child: AnimatedSlide(
              duration: const Duration(milliseconds: 300),
              offset: _isVisible ? Offset.zero : const Offset(0, 2),
              child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _isVisible ? 1 : 0,
                  child: Padding(
                      padding: EdgeInsets.only(bottom: 30.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              ManageVibration.vibrate();
                              context.push(Routes.tripJoinInfoScreen);
                            },
                            child: Container(
                              height: 48.h,
                              width: 48.h,
                              decoration: BoxDecoration(
                                  color:
                                      AppColors.getButtonPrimaryColor(context),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Icon(
                                size: 19,
                                Icons.question_mark,
                                color: context.isDarkMode
                                    ? AppColors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            key: const ValueKey(1),
                            child: TripJoinFloatingActionButton(
                              title: context.isArabic
                                  ? "أعلن عن سيارتك"
                                  : "Advertise your car",
                              onTap: () {
                                ManageVibration.vibrate();
                                context.push(Routes.TRIP_JOIN,extra: false);
                              },
                            ),
                          ),
                        ],
                      )))),
        )
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _scrollController.addListener(_scrollListener);
  }

  TripCardInfoWidget({
    required String title,
    required String model,
    required String icon,
    required String price,
    required String seats,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 32.0.h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            icon,
            width: 48.h,
            fit: BoxFit.cover,
            color: AppColors.getTextColor(context),
          ),
          const Sizer(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: Styles.mediumText(),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                Label(
                  text: model,
                  style: Styles.mediumText(),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Sizer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: "$price  ",
                    style: Styles.headerText(
                        color: AppColors.getTextColor(context),
                        fontWeight: FontWeight.bold)),
                TextSpan(
                  text: context.isArabic ? 'ج.م' : 'EGP',
                  style: Styles.mediumText(
                      fontSize: context.locale.languageCode == "ar" ? 35 : 28,
                      fontWeight: FontWeight.w500,
                      color: AppColors.getRedColor(context)),
                )
              ])),
              Row(
                spacing: 5,
                children: [
                  Label(
                    text: seats,
                    style: Styles.mediumText(
                        fontWeight: FontWeight.bold,
                        color: AppColors.getTextColor(context)),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  TripCardSubscribeText() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.h, 10.h, 20.h, 0),
      child: InkWell(
        onTap: () => showDialogTripJoin(
            context,
            DialogContent(
              subTitle: LocaleKeys.pleaseSubscribeToContactTheClient.localize,
              leftButtonTitle: LocaleKeys.close.localize,
              rightButtonTitle: LocaleKeys.subscribe.localize,
            )),
        child: Text(
          LocaleKeys.subscribeToContactClient.localize,
          style: Styles.headerText(
            color: AppColors.getRedColor(context),
            fontSize: 30,
          ),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }

  void _handleTap(String id) {
    final now = DateTime.now();

    if (_lastTapTimes.containsKey(id)) {
      final lastTap = _lastTapTimes[id]!;
      final difference = now.difference(lastTap);

      if (difference.inMinutes < 5) {
        print("You need to wait before clicking again.");
        return; // Block the tap
      }
    }

    // Allow tap and update timestamp
    _lastTapTimes[id] = now;

    context.read<ViewAllTripJoinCubit>().applyViewTrip(id);
    // print("Hi");
  }

  _locationWidget({required String title, required Color iconColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 32.0.h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.trip_origin, color: iconColor, size: 14),
          const Sizer(width: 13),
          Flexible(
            child: Text(
              title,
              style: Styles.headerText(fontSize: 26),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ViewAllTripJoinCubit>().getTripJoin();
    }
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_isVisible) {
        setState(() => _isVisible = false);
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_isVisible) {
        setState(() => _isVisible = true);
      }
    }
  }
}

extension OfferTypeFormatter on AvailableTripJoinEntity {
  String get formattedOfferType {
    switch (offerType) {
      case 'premium':
        return LocaleKeys.premium2.tr();
      case 'notSubscribed':
        return LocaleKeys.notSubscribed.tr();
      case 'regular':
        return LocaleKeys.regular.tr(); // if you have one
      default:
        return offerType ?? '';
    }
  }
}
