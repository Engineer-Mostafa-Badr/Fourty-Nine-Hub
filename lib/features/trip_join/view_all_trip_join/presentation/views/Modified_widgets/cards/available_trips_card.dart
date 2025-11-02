import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/phone_number_text_field.dart';
import 'package:fourtyninehub/core/widget/common/global_card.dart';
import 'package:fourtyninehub/core/widget/olx_pagination/banner.dart';
import 'package:fourtyninehub/core/widget/olx_pagination/olx_pagination_widget.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_empty_widget.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/edit_page.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/subcategories/presentation/widgets/floating_add_button.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trip_join_body.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../../core/extensions/context_extension.dart';
import '../../../../../../../core/extensions/string_extension.dart';
import '../../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../../core/widget/custom_loading_search_widget.dart';
import '../../../../../../../helpers/manage_vibration.dart';
import '../../../../../../../res/style/app_colors.dart';
import '../../../../../../../res/style/styles.dart';
import '../../../../../../../routes/routes.dart';
import '../../../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../../domain/entities/available_trip_join_entity.dart';
import '../../../cubits/view_all_trip_join_cubit/view_all_trip_join_cubit.dart';
import '../trip_join_dialog/dialog_content.dart';
import '../trip_join_dialog/show_dialog_trip_join.dart';

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
                hintText: context.isArabic ? 'ابحث عن الرحلات' : 'Search Trips',
                hintStyle: TextStyle(
                  color: AppColors.getTextColor(context).withValues(alpha: 0.6),
                  fontSize: 16,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.GREYFIELD,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.PRIMARY_COLOR,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.PRIMARY_COLOR,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.PRIMARY_COLOR,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.PRIMARY_COLOR,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.PRIMARY_COLOR,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
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
              onChanged: (value) =>
                  setState(() => _hasSearchText = value.isNotEmpty),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  // _performSearch(value);
                }
              },
            ),
          ),
          if (_hasSearchText) ...[
            Sizer(width: 8.w),
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: GestureDetector(
                onTap: () {
                  ManageVibration.vibrate();
                  if (context
                          .read<ViewAllTripJoinCubit>()
                          .state
                          .offersFromSearch ==
                      true) {
                    context
                        .read<ViewAllTripJoinCubit>()
                        .loadInitialTripJoin(false, '');
                  }
                  _searchController.clear();
                  setState(() {
                    _hasSearchText = false;
                  });
                  context
                      .read<ViewAllTripJoinCubit>()
                      .loadInitialTripJoin(false, '');
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
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: GestureDetector(
                onTap: () {
                  ManageVibration.vibrate();
                  context
                      .read<ViewAllTripJoinCubit>()
                      .loadInitialTripJoin(true, _searchController.text);
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
    return RefreshIndicator(
      color: AppColors.whiteColor,
      backgroundColor: AppColors.PRIMARY_COLOR,
      onRefresh: () async {
        context.read<ViewAllTripJoinCubit>().loadInitialTripJoin(
            _searchController.text.isNotEmpty, _searchController.text);
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: isFloatingButtonVisible
            ? buildFloatingAction(context,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.push(Routes.tripJoinInfoScreen);
                        },
                        child: Container(
                          height: 48.h,
                          width: 48.h,
                          decoration: BoxDecoration(
                              color: AppColors.getButtonPrimaryColor(context),
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
                      CustomElevatedButton(
                          onPressed: () async {
                            ManageVibration.vibrate();
                            var data = await context.push(Routes.TRIP_JOIN,
                                extra: false);
                            if (data == true) {
                              context
                                  .read<ViewAllTripJoinCubit>()
                                  .loadInitialTripJoin(
                                      _searchController.text.isNotEmpty,
                                      _searchController.text);
                            }
                          },
                          backgoundColor:
                              AppColors.getButtonPrimaryColor(context),
                          child: Label(
                            text: context.isArabic
                                ? "أعلن عن سيارنك +"
                                : "Advertise your car +",
                            style: Styles.mediumText(
                              fontWeight: FontWeight.bold,
                              color: AppColors.getReversedTextColor(context),
                            ),
                          ))
                    ],
                  ),
                ), () {
                ManageVibration.vibrate();
                context.push(Routes.TRIP_JOIN, extra: false);
              })
            : null,
        body: BlocBuilder<ViewAllTripJoinCubit, ViewAllTripJoinState>(
          builder: (context, state) {
            return Column(
              children: [
                _buildSearchField(),
                Sizer(),
                Expanded(
                    child: context
                                .read<ViewAllTripJoinCubit>()
                                .isLoadingTripJoin ==
                            true
                        ? Center(
                            child: CustomLoadingSearchWidget(),
                          )
                        : context
                                .read<ViewAllTripJoinCubit>()
                                .tripJoinData
                                .isEmpty
                            ? Center(
                                child: CustomEmptyWidget(
                                    label:
                                        LocaleKeys.noTripsAvailable.localize))
                            : OlxPaginationWidget(
                                scrollController: _scrollController,
                                itemsPerPage: 3,
                                loadPage: (page) async {
                                  context
                                      .read<ViewAllTripJoinCubit>()
                                      .getTripJoin();
                                },
                                banners: bannersList,
                                items: List.generate(
                                  context
                                      .read<ViewAllTripJoinCubit>()
                                      .tripJoinData
                                      .length,
                                  (index) {
                                    var data = context
                                        .read<ViewAllTripJoinCubit>()
                                        .tripJoinData[index];
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 16.0),
                                      child: GlobalCard(
                                        subCategoryTitle:
                                            LocaleKeys.tripJoin.localize,
                                        isPremium: data.isPremium,
                                        isButtonEnabled:
                                            data.isButtonEnabled?.state ??
                                                false,
                                        otherUserId: '2',
                                        subcategoryId:
                                            '62ea00e269ea29c91dfc390c',
                                        phone: data.phoneNumber ?? "1234",
                                        hasReport: true,
                                        onSubscribe: (bool success) {
                                          context.pop();
                                          if (success) {
                                            // data.isButtonEnabled?.state = true;
                                            for (var item in context
                                                .read<ViewAllTripJoinCubit>()
                                                .tripJoinData) {
                                              item.isButtonEnabled?.state =
                                                  true;
                                            }
                                            setState(() {});
                                          }
                                        },
                                        reportId: context
                                                .read<UserCubit>()
                                                .state
                                                .data
                                                ?.id ??
                                            '',
                                        onTap: () {
                                          ManageVibration.vibrate();
                                          // context.read<ViewAllTripJoinCubit>().applyViewTrip(data.id!);
                                          // debugPrint("Hi");
                                          if (data.isView == true ||
                                              ((UserCubit.to.state.data?.id ??
                                                      '') ==
                                                  data.creatorId)) {
                                            return;
                                          }
                                          context
                                              .read<ViewAllTripJoinCubit>()
                                              .applyViewTrip(data.id ?? '');

                                          // _handleTap(data.id!);
                                        },
                                        hasTopSide: true,
                                        hasBottomSide: true,
                                        isView: ((data.isView == true) ||
                                                (data.creatorId ==
                                                    UserCubit
                                                        .to.state.data?.id))
                                            ? true
                                            : false,
                                        subscriptionType:
                                            data.formattedOfferType,
                                        views: data.viewerIds ?? 0,
                                        onRequest:
                                            ((data.creatorId ==
                                                    UserCubit
                                                        .to.state.data?.id))
                                                ? null
                                                : () {
                                                    ManageVibration.vibrate();
                                                    showModalBottomSheet(
                                                      backgroundColor:
                                                          Colors.white,
                                                      context: context,
                                                      shape:
                                                          const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  32.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  32.0),
                                                        ),
                                                      ),
                                                      isDismissible: true,
                                                      isScrollControlled: true,
                                                      builder: (BuildContext
                                                          context) {
                                                        return BlocProvider
                                                            .value(
                                                          value: serviceLocator<
                                                              ViewAllTripJoinCubit>(),
                                                          child: BlocBuilder<
                                                                  ViewAllTripJoinCubit,
                                                                  ViewAllTripJoinState>(
                                                              builder: (context,
                                                                  state) {
                                                            return AnimatedPadding(
                                                              padding: MediaQuery
                                                                      .of(context)
                                                                  .viewInsets,
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          50),
                                                              child: Container(
                                                                height: 400.h,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                  vertical:
                                                                      10.h,
                                                                  horizontal:
                                                                      10,
                                                                ),
                                                                child: Form(
                                                                  key: formKey,
                                                                  child: Column(
                                                                    children: [
                                                                      Label(
                                                                        text: context.isArabic
                                                                            ? "ادخل رقم هاتفك"
                                                                            : "Enter your phone number",
                                                                        style: Styles
                                                                            .headerText(),
                                                                      ),
                                                                      Sizer(
                                                                        height:
                                                                            30.h,
                                                                      ),
                                                                      CustomPhoneTextFormField(
                                                                        currentFocusNode:
                                                                            FocusNode(),
                                                                        nextFocusNode:
                                                                            FocusNode(),
                                                                        currentController:
                                                                            phoneController,
                                                                        onInputChanged: (value) => formKey
                                                                            .currentState!
                                                                            .validate(),
                                                                        inputFormatters: [
                                                                          FilteringTextInputFormatter
                                                                              .digitsOnly,
                                                                          LengthLimitingTextInputFormatter(
                                                                              11),
                                                                        ],
                                                                        validator:
                                                                            (value) {
                                                                          final input =
                                                                              value?.trim() ?? '';

                                                                          if (input
                                                                              .isEmpty) {
                                                                            return LocaleKeys.required.localize;
                                                                          }

                                                                          final numericValue = convertDigits(input, toArabic: false).replaceAll(
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
                                                                          ].any(
                                                                              numericValue.startsWith)) {
                                                                            return context.isArabic
                                                                                ? 'رقم الهاتف يجب أن يبدأ بـ 010 أو 011 أو 012 أو 015'
                                                                                : 'Phone number must start with 010, 011, 012, or 015.';
                                                                          }

                                                                          return null;
                                                                        },
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: InkWell(
                                                                                onTap: () async {
                                                                                  if (formKey.currentState!.validate()) {
                                                                                    context.read<ViewAllTripJoinCubit>().createTripJoinRequest(data.id ?? '', false, phoneController.text);
                                                                                  }
                                                                                },
                                                                                child: Container(
                                                                                  width: 100,
                                                                                  height: 80.h,
                                                                                  padding: const EdgeInsets.all(5),
                                                                                  decoration: BoxDecoration(color: AppColors.PRIMARY_COLOR, borderRadius: BorderRadius.circular(15)),
                                                                                  alignment: Alignment.center,
                                                                                  child: Label(
                                                                                    text: LocaleKeys.request.localize,
                                                                                    style: Styles.headerText(color: Colors.white),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Sizer(),
                                                                            Expanded(
                                                                              child: InkWell(
                                                                                onTap: () async {
                                                                                  if (formKey.currentState!.validate()) {
                                                                                    context.read<ViewAllTripJoinCubit>().createTripJoinRequest(data.id ?? '', true, phoneController.text);
                                                                                    // context.read<ViewAllTripJoinCubit>().createPickMeRequest();
                                                                                  }
                                                                                },
                                                                                child: Container(
                                                                                  width: 100,
                                                                                  height: 80.h,
                                                                                  padding: const EdgeInsets.all(5),
                                                                                  decoration: BoxDecoration(color: AppColors.SECONDARY_COLOR, borderRadius: BorderRadius.circular(15)),
                                                                                  alignment: Alignment.center,
                                                                                  child: Label(
                                                                                    text: LocaleKeys.premium_request.localize,
                                                                                    style: Styles.headerText(color: Colors.white),
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
                                                          }),
                                                        );
                                                      },
                                                    );
                                                  },
                                        onShowViewers: () {
                                          if ((data.lastViewers?.length ?? 0) >
                                              0) {
                                            ManageVibration.vibrate();
                                            showModalBottomSheet(
                                              backgroundColor: context
                                                      .isDarkMode
                                                  ? AppColors.DARK_BLUE_COLOR
                                                      .withValues(alpha: 0.95)
                                                  : AppColors.LIGHT_COLOR,
                                              constraints: BoxConstraints(
                                                maxHeight:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.3,
                                              ),
                                              context: context,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(32.0),
                                                  topRight:
                                                      Radius.circular(32.0),
                                                ),
                                              ),
                                              isDismissible: true,
                                              builder: (BuildContext context) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        context.isArabic
                                                            ? 'المشاهدون'
                                                            : 'Viewers',
                                                        style: Styles.headerText(
                                                            color: context
                                                                    .isDarkMode
                                                                ? Colors.white
                                                                : AppColors
                                                                    .PRIMARY_COLOR),
                                                      ),
                                                      Expanded(
                                                        child: ListView(
                                                          shrinkWrap: true,
                                                          children:
                                                              List.generate(
                                                                  data.lastViewers
                                                                          ?.length ??
                                                                      0,
                                                                  (i) =>
                                                                      Container(
                                                                        padding:
                                                                            EdgeInsets.only(bottom: 10),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            ImageFromInternet(
                                                                                image: '',
                                                                                isCircle: true,
                                                                                defaultLogo: false,
                                                                                isMale: data.lastViewers?[i].gender == 'male',
                                                                                width: 40,
                                                                                height: 40,
                                                                                firstChar: data.lastViewers?[i].firstName?[0].toUpperCase(),
                                                                                charPadding: 0),
                                                                            const Sizer(),
                                                                            Text(
                                                                              data.lastViewers?[i].firstName ?? '',
                                                                              style: Styles.mediumText(color: context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                        },
                                        body: AvailableTripJoinBody(data: data),
                                      ),
                                    );

                                    // return Padding(
                                    //   padding: EdgeInsets.symmetric(
                                    //     vertical: 10.h,
                                    //   ),
                                    //   child: Column(
                                    //     crossAxisAlignment: CrossAxisAlignment.start,
                                    //     children: [
                                    //       InkWell(
                                    //         onTap: () {
                                    //           ManageVibration.vibrate();
                                    //           // context.read<ViewAllTripJoinCubit>().applyViewTrip(data.id!);
                                    //           // debugPrint("Hi");
                                    //           if (data.isView == true || ((UserCubit.to.state.data?.id ?? '') == data.creatorId)) {
                                    //             return;
                                    //           }
                                    //           context.read<ViewAllTripJoinCubit>().applyViewTrip(data.id ?? '');
                                    //
                                    //           // _handleTap(data.id!);
                                    //         },
                                    //         child: Stack(
                                    //           children: [
                                    //             CustomCard(
                                    //               color: ((data.isView == true || ((UserCubit.to.state.data?.id ?? '') == data.creatorId))
                                    //                   ? AppColors.whiteColor
                                    //                   : AppColors.BG_GRAY_COLOR),
                                    //               radius: 20,
                                    //               children: [
                                    //                 const Sizer(
                                    //                   height: 8,
                                    //                 ),
                                    //                 Padding(
                                    //                   padding: EdgeInsets.symmetric(horizontal: 32.0.h),
                                    //                   child: Row(
                                    //                     children: [
                                    //                       Expanded(
                                    //                         child: ClickableWidget(
                                    //                           onTap: () {
                                    //                             if((data.lastViewers?.length??0)>0) {
                                    //                               ManageVibration.vibrate();
                                    //                               showModalBottomSheet(
                                    //                                 backgroundColor: context.isDarkMode
                                    //                                     ? AppColors.DARK_BLUE_COLOR
                                    //                                     .withValues(alpha: 0.95)
                                    //                                     : AppColors.LIGHT_COLOR,
                                    //                                 constraints: BoxConstraints(
                                    //                                   maxHeight: MediaQuery.of(context).size.height * 0.3,
                                    //                                 ),
                                    //                                 context: context,
                                    //                                 shape: const RoundedRectangleBorder(
                                    //                                   borderRadius: BorderRadius.only(
                                    //                                     topLeft: Radius.circular(32.0),
                                    //                                     topRight: Radius.circular(32.0),
                                    //                                   ),
                                    //                                 ),
                                    //                                 isDismissible: true,
                                    //                                 builder: (BuildContext context) {
                                    //                                   return Padding(
                                    //                                     padding: const EdgeInsets.all(8.0),
                                    //                                     child: Column(
                                    //                                       children: [
                                    //                                         Text(context.isArabic?'المشاهدون':'Viewers',style: Styles.headerText(color: context.isDarkMode?Colors.white:AppColors.PRIMARY_COLOR),),
                                    //                                         Expanded(
                                    //                                           child: ListView(
                                    //                                             shrinkWrap: true,
                                    //                                             children: List.generate(data.lastViewers?.length??0, (i)=>Container(
                                    //                                               padding: EdgeInsets.only(bottom: 10),
                                    //                                               child: Row(
                                    //                                                 children: [
                                    //                                                   ImageFromInternet(
                                    //                                                       image: '',
                                    //                                                       isCircle: true,
                                    //                                                       defaultLogo: false,
                                    //                                                       isMale: data.lastViewers?[i].gender=='male',
                                    //                                                       width: 40,
                                    //                                                       height: 40,
                                    //                                                       firstChar: data.lastViewers?[i].firstName?[0].toUpperCase(),
                                    //                                                       charPadding: 0),
                                    //                                                   const Sizer(),
                                    //                                                   Text(data.lastViewers?[i].firstName??'',style: Styles.mediumText(color: context.isDarkMode?Colors.white:AppColors.PRIMARY_COLOR),),
                                    //                                                 ],
                                    //                                               ),
                                    //                                             )),
                                    //                                           ),
                                    //                                         ),
                                    //                                       ],
                                    //                                     ),
                                    //                                   );
                                    //                                 },
                                    //                               );
                                    //                             }
                                    //                           },
                                    //                           child: Row(
                                    //                             children: [
                                    //                               Icon(
                                    //                                 Icons.remove_red_eye_sharp,
                                    //                                 color: context.isDarkMode ? AppColors.whiteColor : AppColors.DARK_GRAY_COLOR,
                                    //                               ),
                                    //                               const Sizer(),
                                    //                               Label(
                                    //                                 text: '${formatPrice(formatViews(data.viewerIds ?? 0, context).toInt, context)} ${LocaleKeys.views.localize}',
                                    //                                 style: Styles.mediumText(
                                    //                                   fontSize: 24,
                                    //                                   color: context.isDarkMode ? AppColors.whiteColor : AppColors.DARK_GRAY_COLOR,
                                    //                                 ),
                                    //                               ),
                                    //                             ],
                                    //                           ),
                                    //                         ),
                                    //                       ),
                                    //                       Text(
                                    //                         data.formattedOfferType,
                                    //                         style: Styles.headerText(color: AppColors.getRedColor(context), fontSize: 32),
                                    //                       ),
                                    //                     ],
                                    //                   ),
                                    //                 ),
                                    //                 const Divider(),
                                    //                 const Sizer(),
                                    //                 tripCardInfoWidget(
                                    //                     title: context.isArabic ? data.vehicleDetails?.brandAr ?? "" : data.vehicleDetails?.brandEn ?? "",
                                    //                     model: context.isArabic ? data.vehicleDetails?.modelAr ?? "" : data.vehicleDetails?.modelEn ?? "",
                                    //                     icon: Assets.tripJoinCarIcon,
                                    //                     price: formatPrice(data.pricePerSeat?.round() ?? 0, context),
                                    //                     seats: LocaleKeys.eachSeat.localize),
                                    //                 const Sizer(
                                    //                   height: 30,
                                    //                 ),
                                    //                 TripLocationWidget(title: data.location?.start?.address ?? "", isFrom: true),
                                    //                 const Sizer(),
                                    //                 TripLocationWidget(title: data.location?.target?.address ?? "", isFrom: false),
                                    //                 const Sizer(),
                                    //                 Padding(
                                    //                   padding: EdgeInsets.symmetric(
                                    //                     horizontal: 32.0.h,
                                    //                   ),
                                    //                   child: Row(
                                    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //                     children: [
                                    //                       Text(
                                    //                         formatTimestamp(data.startDate!, context),
                                    //                         style: Styles.headerText(fontSize: 32, fontWeight: FontWeight.bold),
                                    //                       ),
                                    //                       Text(
                                    //                         // data.passengers == 1
                                    //                         //     ? '${data.passengers} ${LocaleKeys.seat.localize}'
                                    //                         //     : ''
                                    //                         '${formatPrice(data.passengers ?? 1, context)} ${LocaleKeys.seat.localize}',
                                    //                         style: Styles.headerText(fontSize: 32, fontWeight: FontWeight.bold),
                                    //                       ),
                                    //                       Text(
                                    //                         data.isRepeat == true ? LocaleKeys.repeated.localize : LocaleKeys.oneTime.localize,
                                    //                         style: Styles.headerText(fontSize: 32, fontWeight: FontWeight.bold),
                                    //                       ),
                                    //                     ],
                                    //                   ),
                                    //                 ),
                                    //                 const Divider(),
                                    //                 Padding(
                                    //                     padding: EdgeInsets.symmetric(
                                    //                       horizontal: 32.0.h,
                                    //                     ),
                                    //                     child: Row(
                                    //                       spacing: 15,
                                    //                       children: [
                                    //                         if ((data.isView == true || ((UserCubit.to.state.data?.id ?? '') == data.creatorId)))
                                    //                           Expanded(
                                    //                             child: Padding(
                                    //                               padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                                    //                               child: TripJoinCardButton(
                                    //                                 padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                    //                                 title: LocaleKeys.request.localize,
                                    //                                 color: AppColors.getRedColor(context),
                                    //                                 onTap: () {
                                    //                                   ManageVibration.vibrate();
                                    //                                   showModalBottomSheet(
                                    //                                     backgroundColor: Colors.white,
                                    //                                     context: context,
                                    //                                     shape: const RoundedRectangleBorder(
                                    //                                       borderRadius: BorderRadius.only(
                                    //                                         topLeft: Radius.circular(32.0),
                                    //                                         topRight: Radius.circular(32.0),
                                    //                                       ),
                                    //                                     ),
                                    //                                     isDismissible: true,
                                    //                                     isScrollControlled: true,
                                    //                                     builder: (BuildContext context) {
                                    //                                       return BlocProvider.value(
                                    //                                         value: serviceLocator<ViewAllTripJoinCubit>(),
                                    //                                         child: BlocBuilder<ViewAllTripJoinCubit, ViewAllTripJoinState>(builder: (context, state) {
                                    //                                           return AnimatedPadding(
                                    //                                             padding: MediaQuery.of(context).viewInsets,
                                    //                                             duration: const Duration(milliseconds: 50),
                                    //                                             child: Container(
                                    //                                               height: 400.h,
                                    //                                               padding: EdgeInsets.symmetric(
                                    //                                                 vertical: 10.h,
                                    //                                                 horizontal: 10,
                                    //                                               ),
                                    //                                               child: Form(
                                    //                                                 key: formKey,
                                    //                                                 child: Column(
                                    //                                                   children: [
                                    //                                                     Label(
                                    //                                                       text: context.isArabic ? "ادخل رقم هاتفك" : "Enter your phone number",
                                    //                                                       style: Styles.headerText(),
                                    //                                                     ),
                                    //                                                     Sizer(
                                    //                                                       height: 30.h,
                                    //                                                     ),
                                    //                                                     CustomPhoneTextFormField(
                                    //                                                       currentFocusNode: FocusNode(),
                                    //                                                       nextFocusNode: FocusNode(),
                                    //                                                       currentController: phoneController,
                                    //                                                       onInputChanged: (value) => formKey.currentState!.validate(),
                                    //                                                       inputFormatters: [
                                    //                                                         FilteringTextInputFormatter.digitsOnly,
                                    //                                                         LengthLimitingTextInputFormatter(11),
                                    //                                                       ],
                                    //                                                       validator: (value) {
                                    //                                                         final input = value?.trim() ?? '';
                                    //
                                    //                                                         if (input.isEmpty) {
                                    //                                                           return LocaleKeys.required.localize;
                                    //                                                         }
                                    //
                                    //                                                         final numericValue =
                                    //                                                         convertDigits(input, toArabic: false).replaceAll(RegExp(r'[^0-9]'), '');
                                    //
                                    //                                                         if (numericValue.length != 11) {
                                    //                                                           return context.isArabic
                                    //                                                               ? 'يجب أن يحتوي رقم الهاتف على 11 رقمًا'
                                    //                                                               : 'Phone number must be exactly 11 digits.';
                                    //                                                         }
                                    //
                                    //                                                         if (!['010', '011', '012', '015'].any(numericValue.startsWith)) {
                                    //                                                           return context.isArabic
                                    //                                                               ? 'رقم الهاتف يجب أن يبدأ بـ 010 أو 011 أو 012 أو 015'
                                    //                                                               : 'Phone number must start with 010, 011, 012, or 015.';
                                    //                                                         }
                                    //
                                    //                                                         return null;
                                    //                                                       },
                                    //                                                     ),
                                    //                                                     Expanded(
                                    //                                                       child: Row(
                                    //                                                         children: [
                                    //                                                           Expanded(
                                    //                                                             child: InkWell(
                                    //                                                               onTap: () async {
                                    //                                                                 if (formKey.currentState!.validate()) {
                                    //                                                                   context
                                    //                                                                       .read<ViewAllTripJoinCubit>()
                                    //                                                                       .createTripJoinRequest(data.id ?? '', false, phoneController.text);
                                    //                                                                 }
                                    //                                                               },
                                    //                                                               child: Container(
                                    //                                                                 width: 100,
                                    //                                                                 height: 80.h,
                                    //                                                                 padding: const EdgeInsets.all(5),
                                    //                                                                 decoration: BoxDecoration(
                                    //                                                                     color: AppColors.PRIMARY_COLOR, borderRadius: BorderRadius.circular(15)),
                                    //                                                                 alignment: Alignment.center,
                                    //                                                                 child: Label(
                                    //                                                                   text: LocaleKeys.request.localize,
                                    //                                                                   style: Styles.headerText(color: Colors.white),
                                    //                                                                 ),
                                    //                                                               ),
                                    //                                                             ),
                                    //                                                           ),
                                    //                                                           Sizer(),
                                    //                                                           Expanded(
                                    //                                                             child: InkWell(
                                    //                                                               onTap: () async {
                                    //                                                                 if (formKey.currentState!.validate()) {
                                    //                                                                   context
                                    //                                                                       .read<ViewAllTripJoinCubit>()
                                    //                                                                       .createTripJoinRequest(data.id ?? '', true, phoneController.text);
                                    //                                                                   // context.read<ViewAllTripJoinCubit>().createPickMeRequest();
                                    //                                                                 }
                                    //                                                               },
                                    //                                                               child: Container(
                                    //                                                                 width: 100,
                                    //                                                                 height: 80.h,
                                    //                                                                 padding: const EdgeInsets.all(5),
                                    //                                                                 decoration: BoxDecoration(
                                    //                                                                     color: AppColors.SECONDARY_COLOR, borderRadius: BorderRadius.circular(15)),
                                    //                                                                 alignment: Alignment.center,
                                    //                                                                 child: Label(
                                    //                                                                   text: LocaleKeys.premium_request.localize,
                                    //                                                                   style: Styles.headerText(color: Colors.white),
                                    //                                                                 ),
                                    //                                                               ),
                                    //                                                             ),
                                    //                                                           ),
                                    //                                                         ],
                                    //                                                       ),
                                    //                                                     ),
                                    //                                                   ],
                                    //                                                 ),
                                    //                                               ),
                                    //                                             ),
                                    //                                           );
                                    //                                         }),
                                    //                                       );
                                    //                                     },
                                    //                                   );
                                    //                                 },
                                    //                                 radius: 15,
                                    //                               ),
                                    //                             ),
                                    //                           ),
                                    //                         Expanded(
                                    //                           child: ContactsTripButtons(
                                    //                             // isPremium: false,
                                    //                             subscriptionTitle:LocaleKeys.tripJoin.localize,
                                    //                             isPremium: data.isPremium,
                                    //                             isButtonEnabled: data.isButtonEnabled!.state,
                                    //                             otherUserId: '2',
                                    //                             subcategoryId: '62ea00e269ea29c91dfc390c',
                                    //                             phone: data.phoneNumber ?? "1234",
                                    //                             id: context.read<UserCubit>().state.data!.id,
                                    //                             hasReport: true,
                                    //                           ),
                                    //                         ),
                                    //                       ],
                                    //                     )
                                    //
                                    //                   // TripJoinButtonsSection(
                                    //                   //   isContactInfo: data.isPremium == true || data.isButtonEnabled!.state == true ? true : false,
                                    //                   //   isRequestButton: true,
                                    //                   //   buttonTitle:LocaleKeys.requests.localize,
                                    //                   //   // buttonTitle:" buttonTitle",
                                    //                   //   onTap: (){},
                                    //                   // ),
                                    //                 ),
                                    //                 const Sizer(),
                                    //               ],
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       data.isPremium == true || data.isButtonEnabled!.state == true ? SizedBox() : TripCardSubscribeText(),
                                    //     ],
                                    //   ),
                                    // );
                                  },
                                ),
                              )),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    // _scrollController.removeListener(_onScroll);
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // _scrollController.addListener(_onScroll);
    _scrollController.addListener(_scrollListener);
  }

  tripCardInfoWidget({
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

  // void _onScroll() {
  //   if (_scrollController.position.pixels >=
  //       _scrollController.position.maxScrollExtent - 200) {
  //     context.read<ViewAllTripJoinCubit>().getTripJoin();
  //   }
  // }

  bool isFloatingButtonVisible = true;
  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      isFloatingButtonVisible = false;
    } else {
      isFloatingButtonVisible = true;
    }
    setState(() {});
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
