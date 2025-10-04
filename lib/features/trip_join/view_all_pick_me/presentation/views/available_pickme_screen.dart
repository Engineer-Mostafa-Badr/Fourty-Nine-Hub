import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dialogs/please_login_dialog.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/phone_number_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/core/widget/common/global_card.dart';
import 'package:fourtyninehub/core/widget/custom_loading_search_widget.dart';
import 'package:fourtyninehub/core/widget/olx_pagination/banner.dart';
import 'package:fourtyninehub/core/widget/olx_pagination/olx_pagination_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/loading_dashboard/loading_dashboard_details_screen.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/edit_page.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/subcategories/presentation/widgets/floating_add_button.dart';
import 'package:fourtyninehub/features/trip_join/view_all_pick_me/presentation/widgets/available_pick_me_body.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/cubits/view_all_trip_join_cubit/view_all_trip_join_cubit.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/cards/available_trips_card.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/cards/trip_contacts_buttons.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_card.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_card_button.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_dialog/dialog_content.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_dialog/show_dialog_trip_join.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_floating_action_button.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/trip_join/request_log_widget.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

class AvailablePickMeCard extends StatefulWidget {
  const AvailablePickMeCard({
    super.key,
  });

  @override
  State<AvailablePickMeCard> createState() => _AvailablePickMeCardState();
}

class _AvailablePickMeCardState extends State<AvailablePickMeCard> with TickerProviderStateMixin{
  late ScrollController _scrollController;
  final TextEditingController _searchController = TextEditingController();
  bool _hasSearchText = false;

  @override
  void initState() {
    context.read<ViewAllTripJoinCubit>().loadInitialPickMe(false, '');
    _scrollController = ScrollController()..addListener(_scrollListener);

    super.initState();
  }
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  final Map<String, DateTime> _lastTapTimes = {};

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
                TextSpan(text: "$price  ", style: Styles.headerText(color: AppColors.getTextColor(context), fontWeight: FontWeight.bold)),
                TextSpan(
                  text: context.isArabic ? 'ج.م' : 'EGP',
                  style: Styles.mediumText(fontSize: context.locale.languageCode == "ar" ? 35 : 28, fontWeight: FontWeight.w500, color: AppColors.getRedColor(context)),
                )
              ])),
              Row(
                spacing: 5,
                children: [
                  Label(
                    text: seats,
                    style: Styles.mediumText(fontWeight: FontWeight.bold, color: AppColors.getTextColor(context)),
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
                hintText: context.isArabic ? 'ابحث عن عروض الرحلات...' : 'Search offers...',
                hintStyle: TextStyle(
                  color: AppColors.getTextColor(context).withOpacity(0.6),
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
              onChanged: (value) {
                if (value.isEmpty) {
                  context.read<ViewAllTripJoinCubit>().loadInitialPickMe(false, '');
                }
                setState(() => _hasSearchText = value.isNotEmpty);
              },
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
                  if (context.read<ViewAllTripJoinCubit>().state.offersFromSearch == true) context.read<ViewAllTripJoinCubit>().loadInitialPickMe(false, '');
                  _searchController.clear();
                  setState(() {
                    _hasSearchText = false;
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
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: GestureDetector(
                onTap: () {
                  ManageVibration.vibrate();
                  context.read<ViewAllTripJoinCubit>().loadInitialPickMe(true, _searchController.text);
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
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isFloatingButtonVisible
          ? buildFloatingAction(context,child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 0),
            child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
            GestureDetector(
              onTap: () {
                context.push(Routes.pickMeInfoScreen);
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
                          onPressed: () {
                            ManageVibration.vibrate();
                            context.push(Routes.TRIP_JOIN, extra: true);
                          },
                          backgoundColor: AppColors.getButtonPrimaryColor(context),
                          child: Label(
                            text: context.isArabic ? "انشر رحلتك +" : "Post your ride +",
                            style: Styles.mediumText(
                              fontWeight: FontWeight.bold,
                              color: AppColors.getReversedTextColor(context),
                            ),
                          ))
                    ],
                  ),
          ), () {
        ManageVibration.vibrate();
        context.push(Routes.TRIP_JOIN, extra: true);
      })
          : null,
      body: BlocBuilder<ViewAllTripJoinCubit, ViewAllTripJoinState>(builder: (context, state) {
        return Stack(
          children: [
            Column(
              children: [
                _buildSearchField(),
                Expanded(
                    child: context.read<ViewAllTripJoinCubit>().isLoadingPickMe == true?const Center(
                      child: CustomLoadingSearchWidget(),
                    ):context.read<ViewAllTripJoinCubit>().pickMeData.isEmpty?
                    Center(child: Text(LocaleKeys.noData.localize))
                        :OlxPaginationWidget(
                      scrollController: _scrollController,
                      itemsPerPage: 3,
                      loadPage: (page) async {
                        context.read<ViewAllTripJoinCubit>().getPickMe();
                      },
                      banners: bannersList,
                      items: List.generate(
                        context.read<ViewAllTripJoinCubit>().pickMeData.length,
                            (index) {
                          var data = context.read<ViewAllTripJoinCubit>().pickMeData[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    GlobalCard(
                                      subcategoryId: '62ea00e269ea29c91dfc390c',
                                      phone: data.phoneNumber ?? "1234",
                                      reportId: context.read<UserCubit>().state.data?.id??'',
                                      otherUserId: '',
                                      onTap: (){
                                        if (data.isView == true || ((UserCubit.to.state.data?.id ?? '') == data.creatorId)) {
                                          return;
                                        }
                                        ManageVibration.vibrate();
                                        context.read<ViewAllTripJoinCubit>().applyPickMe(data.id!);
                                      },
                                      isButtonEnabled: data.isButtonEnabled?.state??false,
                                      isPremium: data.isPremium,
                                      hasReport: true,
                                      hasTopSide: true,
                                      hasBottomSide: true,
                                      isView: data.isView,
                                      subscriptionType: data.formattedOfferType,
                                      views: data.viewerIds??0,
                                      onRequest: (){
                                        if (!context.read<UserCubit>().isLoggedIn) {
                                          ManageVibration.vibrate();
                                          pleaseLoginDialog(context);
                                          return;
                                        }
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
                                              child: BlocBuilder<ViewAllTripJoinCubit, ViewAllTripJoinState>(builder: (context, state) {
                                                return AnimatedPadding(
                                                  padding: MediaQuery.of(context).viewInsets,
                                                  duration: const Duration(milliseconds: 50),
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
                                                            text: context.isArabic ? "ادخل رقم هاتفك" : "Enter your phone number",
                                                            style: Styles.headerText(),
                                                          ),
                                                          Sizer(
                                                            height: 30.h,
                                                          ),
                                                          CustomPhoneTextFormField(
                                                            currentFocusNode: FocusNode(),
                                                            nextFocusNode: FocusNode(),
                                                            currentController: phoneController,
                                                            onInputChanged: (value) => formKey.currentState!.validate(),
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter.digitsOnly,
                                                              LengthLimitingTextInputFormatter(11),
                                                            ],
                                                            validator: (value) {
                                                              final input = value?.trim() ?? '';

                                                              if (input.isEmpty) {
                                                                return LocaleKeys.required.localize;
                                                              }

                                                              final numericValue = convertDigits(input, toArabic: false).replaceAll(RegExp(r'[^0-9]'), '');

                                                              if (numericValue.length != 11) {
                                                                return context.isArabic
                                                                    ? 'يجب أن يحتوي رقم الهاتف على 11 رقمًا'
                                                                    : 'Phone number must be exactly 11 digits.';
                                                              }

                                                              if (!['010', '011', '012', '015'].any(numericValue.startsWith)) {
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
                                                                      if (data.isNormalRequested == true) {
                                                                        context.pop();
                                                                        showErrorMessage(context,
                                                                            context.isArabic ? 'لقد تم ارسال الطلب من قبل' : 'This trip has already been requested');
                                                                        return;
                                                                      }
                                                                      if (formKey.currentState!.validate()) {
                                                                        bool result = await context
                                                                            .read<ViewAllTripJoinCubit>()
                                                                            .createPickMeRequest(data.id ?? '', false, phoneController.text);
                                                                        if (result == true) {
                                                                          data.isNormalRequested = true;
                                                                        }
                                                                      }
                                                                    },
                                                                    child: Container(
                                                                      width: 100,
                                                                      height: 80.h,
                                                                      padding: const EdgeInsets.all(5),
                                                                      decoration: BoxDecoration(
                                                                          color: data.isNormalRequested == true ? AppColors.GREY_DARK_COLOR : AppColors.PRIMARY_COLOR,
                                                                          borderRadius: BorderRadius.circular(15)),
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
                                                                      if (data.isPremiumRequested == true) {
                                                                        return;
                                                                      }
                                                                      if (formKey.currentState!.validate()) {
                                                                        bool result = await context
                                                                            .read<ViewAllTripJoinCubit>()
                                                                            .createPickMeRequest(data.id ?? '', true, phoneController.text);
                                                                        if (result == true) {
                                                                          data.isPremiumRequested = true;
                                                                        }
                                                                        // context.read<ViewAllTripJoinCubit>().createPickMeRequest();
                                                                      }
                                                                    },
                                                                    child: Container(
                                                                      width: 100,
                                                                      height: 80.h,
                                                                      padding: const EdgeInsets.all(5),
                                                                      decoration: BoxDecoration(
                                                                          color:
                                                                          data.isPremiumRequested == true ? AppColors.GREY_DARK_COLOR : AppColors.SECONDARY_COLOR,
                                                                          borderRadius: BorderRadius.circular(15)),
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
                                      onShowViewers: (){
                                        if((data.lastViewers?.length??0)>0) {
                                          ManageVibration.vibrate();
                                          showModalBottomSheet(
                                            backgroundColor: context.isDarkMode
                                                ? AppColors.DARK_BLUE_COLOR
                                                .withOpacity(0.95)
                                                : AppColors.LIGHT_COLOR,
                                            constraints: BoxConstraints(
                                              maxHeight: MediaQuery.of(context).size.height * 0.3,
                                            ),
                                            context: context,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(32.0),
                                                topRight: Radius.circular(32.0),
                                              ),
                                            ),
                                            isDismissible: true,
                                            // isScrollControlled: true,
                                            builder: (BuildContext context) {
                                              return Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Text(context.isArabic?'المشاهدون':'Viewers',style: Styles.headerText(color: context.isDarkMode?Colors.white:AppColors.PRIMARY_COLOR),),
                                                    Expanded(
                                                      child: ListView(
                                                        shrinkWrap: true,
                                                        children: List.generate(data.lastViewers?.length??0, (i)=>Container(
                                                          padding: EdgeInsets.only(bottom: 10),
                                                          child: Row(
                                                            children: [
                                                              ImageFromInternet(
                                                                  image: '',
                                                                  isCircle: true,
                                                                  defaultLogo: false,
                                                                  isMale: data.lastViewers?[i].gender=='male',
                                                                  width: 40,
                                                                  height: 40,
                                                                  firstChar: data.lastViewers?[i].firstName?[0].toUpperCase(),
                                                                  charPadding: 0),
                                                              const Sizer(),
                                                              Text(data.lastViewers?[i].firstName??'',style: Styles.mediumText(color: context.isDarkMode?Colors.white:AppColors.PRIMARY_COLOR),),
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
                                      body:AvailablePickMeBody(data:data),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
