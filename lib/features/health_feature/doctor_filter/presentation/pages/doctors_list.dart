import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_empty_widget.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/pages/DoctorDetails.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:async';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/controllers/doctors_list_cubit/doctors_list_cubit.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/widget/custom_loading_search_widget.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../helpers/subscription_method.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import '../../../../social_media/instagram/presentation/widgets/comment_widget_insta.dart';
import '../../../../social_media/twitter/presentation/widgets/report_view.dart';
import '../../../health/domain/entities/most_booking_entity.dart';
import '../../../health/domain/entities/appointment_booking_entity.dart';
import '../../../health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class DoctorsListParams {
  final bool fromHome;
  final String subCategoryId;
  final String? type;
  final bool? fromSearch;
  final String? name;
  final BookingTypes? bookingType;

  DoctorsListParams(
      {required this.fromHome,
      required this.subCategoryId,
      this.type = '',
      this.name = '',
      this.fromSearch = false,
      this.bookingType});
}

class DoctorsListView extends StatefulWidget {
  const DoctorsListView({super.key, required this.params});
  final DoctorsListParams params;
  @override
  State<DoctorsListView> createState() => _DoctorsListViewState();
}

class _DoctorsListViewState extends State<DoctorsListView> {
  late ScrollController _scrollController;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String? _specialtySearchQuery;
  Timer? _searchDebounce;
  bool _isFastBookingBaseFiltered = false;

  @override
  void initState() {
    print("widget.params.name ${widget.params.name}");
    _scrollController = ScrollController()..addListener(_onScroll);

    final healthSharedData = serviceLocator<HealthSharedData>();

    // Use the new specialty-based loading for subcategory navigation
    if (widget.params.fromSearch == true) {
      context
          .read<DoctorsListCubit>()
          .loadInitialData(widget.params.name ?? '', true);
    } else if (widget.params.bookingType != null) {
      // Use booking type search if booking type is provided
      final bookingType = widget.params.bookingType ??
          healthSharedData.doctorSearchParams.bookingType;
      if (bookingType != null) {
        // Get specialty ID - prioritize params, fallback to shared data
        final specialtyId = widget.params.subCategoryId.isNotEmpty
            ? widget.params.subCategoryId
            : healthSharedData.doctorSearchParams.subCategory.id;

        // Get governorate and city from shared data
        final governorateId =
            healthSharedData.doctorSearchParams.governorate.id.isNotEmpty
                ? healthSharedData.doctorSearchParams.governorate.id
                : null;
        final cityId = healthSharedData.doctorSearchParams.city.id.isNotEmpty
            ? healthSharedData.doctorSearchParams.city.id
            : null;

        context.read<DoctorsListCubit>().loadInitialDataByBookingType(
              bookingType: bookingType,
              specialtyId: specialtyId,
              governorateId: governorateId,
              cityId: cityId,
            );
      } else {
        // Fallback to specialty-based search
        context
            .read<DoctorsListCubit>()
            .loadInitialDataBySpecialty(widget.params.subCategoryId);
      }
    } else {
      // Use the new specialty-based method for subcategory
      context
          .read<DoctorsListCubit>()
          .loadInitialDataBySpecialty(widget.params.subCategoryId);
    }
    super.initState();
  }

  void _onScroll() async {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      print("object");
      final healthSharedData = serviceLocator<HealthSharedData>();

      // If specialty search is active, paginate on it
      if ((_specialtySearchQuery != null &&
          _specialtySearchQuery!.trim().isNotEmpty)) {
        final hasLocation = serviceLocator<HealthSharedData>()
                .doctorSearchParams
                .governorate
                .id
                .isNotEmpty ||
            serviceLocator<HealthSharedData>()
                .doctorSearchParams
                .city
                .id
                .isNotEmpty ||
            _isFastBookingBaseFiltered;
        if (hasLocation) {
          context
              .read<DoctorsListCubit>()
              .getDoctorsBySpecialtySearchFastBooking(
                specialtyId: widget.params.subCategoryId,
                name: _specialtySearchQuery!,
              );
        } else {
          context.read<DoctorsListCubit>().getDoctorsBySpecialtySearch(
                specialtyId: widget.params.subCategoryId,
                name: _specialtySearchQuery!,
              );
        }
        return;
      }

      if (_isFastBookingBaseFiltered) {
        context
            .read<DoctorsListCubit>()
            .getDoctorsBySpecialtyFastBooking(widget.params.subCategoryId);
      } else if (widget.params.fromSearch == true) {
        context
            .read<DoctorsListCubit>()
            .getDoctorsFromSearch(widget.params.name ?? '');
      } else if (widget.params.bookingType != null) {
        // Use booking type search for pagination
        final bookingType = widget.params.bookingType ??
            healthSharedData.doctorSearchParams.bookingType;
        if (bookingType != null) {
          context.read<DoctorsListCubit>().getDoctorsByBookingType(
                bookingType: bookingType,
                specialtyId: widget.params.subCategoryId.isNotEmpty
                    ? widget.params.subCategoryId
                    : healthSharedData.doctorSearchParams.subCategory.id,
                governorateId: healthSharedData
                        .doctorSearchParams.governorate.id.isNotEmpty
                    ? healthSharedData.doctorSearchParams.governorate.id
                    : null,
                cityId: healthSharedData.doctorSearchParams.city.id.isNotEmpty
                    ? healthSharedData.doctorSearchParams.city.id
                    : null,
              );
        } else {
          context
              .read<DoctorsListCubit>()
              .getDoctorsBySpecialty(widget.params.subCategoryId);
        }
      } else {
        context
            .read<DoctorsListCubit>()
            .getDoctorsBySpecialty(widget.params.subCategoryId);
      }
      print("object");
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchDebounce?.cancel();
    _searchFocusNode.dispose();
    super.dispose();
  }

  String _getEmptyMessage(BuildContext context) {
    final healthSharedData = serviceLocator<HealthSharedData>();
    final isArabic = context.isArabic;

    // If it's a search, show search-specific message
    if (widget.params.fromSearch == true) {
      return isArabic ? 'لا توجد نتائج للبحث' : 'No search results found';
    }

    // Get specialty, governorate, city, and booking type information
    final specialty = healthSharedData.doctorSearchParams.subCategory;
    final governorate = healthSharedData.doctorSearchParams.governorate;
    final city = healthSharedData.doctorSearchParams.city;
    final bookingType = widget.params.bookingType ??
        healthSharedData.doctorSearchParams.bookingType;

    // Build the personalized message based on available data
    String specialtyName = '';
    String locationInfo = '';
    String bookingTypeName = '';

    // Get specialty name
    if (specialty.id.isNotEmpty) {
      specialtyName = isArabic ? specialty.nameAr : specialty.nameEn;
    }

    // Get booking type name
    if (bookingType != null) {
      switch (bookingType) {
        case BookingTypes.videoCall:
          bookingTypeName = isArabic ? 'مكالمة فيديو' : 'video call';
          break;
        case BookingTypes.clinic:
          bookingTypeName = isArabic ? 'زيارة عيادة' : 'clinic visit';
          break;
        case BookingTypes.home:
          bookingTypeName = isArabic ? 'زيارة منزل' : 'home visit';
          break;
        case BookingTypes.emergency:
          bookingTypeName = isArabic ? 'طوارئ' : 'emergency';
          break;
      }
    }

    // Build location string
    List<String> locationParts = [];
    if (governorate.id.isNotEmpty && governorate.nameAr.isNotEmpty) {
      locationParts.add(isArabic ? governorate.nameAr : governorate.nameEn);
    }
    if (city.id.isNotEmpty && city.nameAr.isNotEmpty) {
      locationParts.add(isArabic ? city.nameAr : city.nameEn);
    }

    if (locationParts.isNotEmpty) {
      locationInfo = locationParts.join(' - ');
    }

    // Build the final message
    if (specialtyName.isNotEmpty &&
        locationInfo.isNotEmpty &&
        bookingTypeName.isNotEmpty) {
      return isArabic
          ? 'لا يوجد دكتور $specialtyName متاح لـ $bookingTypeName في $locationInfo حالياً'
          : 'No $specialtyName doctor available for $bookingTypeName in $locationInfo right now';
    } else if (specialtyName.isNotEmpty && bookingTypeName.isNotEmpty) {
      return isArabic
          ? 'لا يوجد دكتور $specialtyName متاح لـ $bookingTypeName حالياً'
          : 'No $specialtyName doctor available for $bookingTypeName right now';
    } else if (specialtyName.isNotEmpty && locationInfo.isNotEmpty) {
      return isArabic
          ? 'لا يوجد دكتور $specialtyName متاح في $locationInfo حالياً'
          : 'No $specialtyName doctor available in $locationInfo right now';
    } else if (specialtyName.isNotEmpty) {
      return isArabic
          ? 'لا يوجد دكتور $specialtyName متاح حالياً'
          : 'No $specialtyName doctor available right now';
    } else {
      // Fallback to default message
      return isArabic ? 'لا يوجد حجوزات سابقة' : 'No booking history';
    }
  }

  @override
  Widget build(BuildContext context) {
    // return BlocListener<HealthCubit, HealthState>(
    return BlocListener<DoctorsListCubit, DoctorsListState>(
      listener: (context, state) {},
      child: CustomScaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: BackAppBar(
            label: LocaleKeys.doctorList.localize,
          ),
        ),
        body: BlocBuilder<DoctorsListCubit, DoctorsListState>(
            builder: (context, state) {
          return
              // context.read<DoctorsListCubit>().doctors.isEmpty
              //   ? Center(
              //       child: Text(
              //         LocaleKeys.noDoctorsFound.localize,
              //         style: Styles.headerText(),
              //       ),
              //     )
              //   :
              GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: DefaultTextFormField(
                    currentFocusNode: _searchFocusNode,
                    currentController: _searchController,
                    hint: context.isArabic
                        ? 'بحث باسم الطبيب'
                        : 'Search by doctor name',
                    prefixIcon: const Icon(Icons.search),
                    onChanged: (value) {
                      final query = value.trim();
                      _searchDebounce?.cancel();

                      if (query.isEmpty) {
                        setState(() {
                          _specialtySearchQuery = null;
                          _isFastBookingBaseFiltered = true;
                        });
                        context
                            .read<DoctorsListCubit>()
                            .loadInitialDataBySpecialtyFastBooking(
                              widget.params.subCategoryId,
                            );
                        return;
                      }

                      // Avoid searching on single letters; wait for 3+ chars with debounce
                      if (query.length < 3) {
                        setState(() {
                          _specialtySearchQuery = query;
                        });
                        return;
                      }

                      _searchDebounce =
                          Timer(const Duration(milliseconds: 400), () {
                        setState(() {
                          _specialtySearchQuery = query;
                        });
                        final healthSharedData =
                            serviceLocator<HealthSharedData>();
                        final hasLocation = healthSharedData
                                .doctorSearchParams.governorate.id.isNotEmpty ||
                            healthSharedData
                                .doctorSearchParams.city.id.isNotEmpty ||
                            _isFastBookingBaseFiltered;
                        if (hasLocation) {
                          context
                              .read<DoctorsListCubit>()
                              .loadInitialDataBySpecialtySearch(
                                specialtyId: widget.params.subCategoryId,
                                name: query,
                              );
                        } else {
                          context
                              .read<DoctorsListCubit>()
                              .loadInitialDataBySpecialtySearch(
                                specialtyId: widget.params.subCategoryId,
                                name: query,
                              );
                        }
                      });
                    },
                  ),
                ),
                Expanded(
                  child: state.isLoading
                      ? CustomLoadingSearchWidget()
                      : ((state.doctorsList?.isEmpty ?? true)
                          ? Center(
                              child: CustomEmptyWidget(
                                  label: _getEmptyMessage(context)))
                          : ListView.separated(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.sizeOf(context).height * 0.35),
                              controller: _scrollController,
                              itemCount: state.doctorsList?.length ?? 0,
                              itemBuilder: (context, index) {
                                final booking = state.doctorsList![index];
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: DoctorListCard(
                                    data: booking,
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const Sizer(),
                            )),
                ),
                // if (context.read<DoctorsListCubit>().isLoadingMore)
                //   const Center(
                //     child: CustomCircularProgressIndicator(),
                //   )
              ],
            ),
          );
        }),
      ),
    );
  }
}

class DoctorListCard extends StatefulWidget {
  const DoctorListCard({
    super.key,
    required this.data,
  });

  final MostBookingEntity data;

  @override
  State<DoctorListCard> createState() => _DoctorListCardState();
}

class _DoctorListCardState extends State<DoctorListCard> {
  String formatViews(int views) {
    // if (views >= 1000000) {
    //   return "${(views / 1000000).toStringAsFixed(1)}M";
    // } else if (views >= 1000) {
    //   return "${(views / 1000).toStringAsFixed(1)}K";
    // } else {
    //   return views.toString();
    // }

    return FormatNumbers()
        .formatNumber(views, useArabicNumerals: context.isArabic);
  }

  String getSubscriptionType(int subscriptionRank) {
    // 'Premium subscription': 2
    // 'Regular subscription': 1
    // 'No subscription': 0
    switch (subscriptionRank) {
      case 0:
        return LocaleKeys.notSubscribed.localize;
      case 1:
        return LocaleKeys.regularSubscription.localize;
      case 2:
        return LocaleKeys.premium2.localize;
      default:
        return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClickableWidget(
      onTap: () {
        context.push(Routes.VISITADOCTORDETAILS,
            extra: DoctorDetailsParams(
                doctorId: widget.data.id ?? '', fromSearch: false));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 10.h,
          horizontal: 10.w,
        ),
        child: Container(
          // padding:const EdgeInsets.all(10) ,
          decoration: BoxDecoration(
              border: Border.all(
                  color: context.isDarkMode
                      ? AppColors.whiteColor
                      : AppColors.black.withOpacity(0.7),
                  width: 1),
              borderRadius: BorderRadius.circular(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(
                    vertical: 8, horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      spacing: 2,
                      children: [
                        SvgPicture.asset(
                          Assets.eyeIcon,
                          color: context.isDarkMode
                              ? AppColors.whiteColor
                              : Colors.grey,
                        ),
                        const Sizer(
                          width: 8,
                        ),
                        if ((widget.data.viewCount ?? 0) == 0) ...[
                          Label(
                            text: LocaleKeys.noViews.localize,
                            style: Styles.mediumText(
                                // fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: context.isDarkMode
                                    ? AppColors.whiteColor
                                    : AppColors.c6C6C6C),
                          ),
                        ] else if (widget.data.viewCount == 1) ...[
                          // Label(
                          //     text:
                          //         ' ${formatViews(widget.data.viewCount?.toInt() ?? 0)} ',
                          //     style: Styles.mediumText(
                          //       color: context.isDarkMode
                          //           ? Colors.white
                          //           : AppColors.c6C6C6C,
                          //       // fontSize: 12
                          //     )),
                          Label(
                            text: LocaleKeys.oneView.localize,
                            style: Styles.mediumText(
                                // fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: context.isDarkMode
                                    ? AppColors.whiteColor
                                    : AppColors.c6C6C6C),
                          ),
                        ] else if (widget.data.viewCount == 2) ...[
                          // Label(
                          //     text:
                          //         ' ${formatViews(widget.data.viewCount?.toInt() ?? 0)} ',
                          //     style: Styles.mediumText(
                          //       color: context.isDarkMode
                          //           ? Colors.white
                          //           : AppColors.c6C6C6C,
                          //       // fontSize: 12
                          //     )),
                          Label(
                            text: LocaleKeys.twoViews.localize,
                            style: Styles.mediumText(
                                // fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: context.isDarkMode
                                    ? AppColors.whiteColor
                                    : AppColors.c6C6C6C),
                          ),
                        ] else if (widget.data.viewCount! >= 3 &&
                            widget.data.viewCount! <= 10) ...[
                          Label(
                              text:
                                  ' ${FormatNumbers().formatNumber(widget.data.viewCount ?? 0, useArabicNumerals: context.isArabic)} '
                                      .toArabicNumbers(context),
                              // ' ${formatViews(widget.data.viewCount ?? 0)} ',
                              style: Styles.mediumText(
                                color: context.isDarkMode
                                    ? Colors.white
                                    : AppColors.c6C6C6C,
                                // fontSize: 12
                              )),
                          Label(
                            text: LocaleKeys.views.localize,
                            style: Styles.mediumText(
                                // fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: context.isDarkMode
                                    ? AppColors.whiteColor
                                    : AppColors.c6C6C6C),
                          ),
                        ] else ...[
                          Label(
                              text:
                                  ' ${FormatNumbers().formatNumber(widget.data.viewCount ?? 0, useArabicNumerals: context.isArabic)} '
                                      .toArabicNumbers(context),
                              // ' ${formatViews(widget.data.viewCount?.toInt() ?? 0)} ',
                              style: Styles.mediumText(
                                color: context.isDarkMode
                                    ? Colors.white
                                    : AppColors.c6C6C6C,
                                // fontSize: 12
                              )),
                          Label(
                            text: context.isArabic ? 'مشاهدة' : 'Views',
                            style: Styles.mediumText(
                                // fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: context.isDarkMode
                                    ? AppColors.whiteColor
                                    : AppColors.c6C6C6C),
                          ),
                        ],
                        // Label(
                        //     text:
                        //         formatViews(widget.data.viewCount?.toInt() ?? 0),
                        //     style: Styles.mediumText(
                        //         fontWeight: FontWeight.w400,
                        //         color: context.isDarkMode
                        //             ? AppColors.whiteColor
                        //             : AppColors.c6C6C6C)),
                        // Label(
                        //   text: LocaleKeys.views.localize,
                        //   style: Styles.mediumText(
                        //       // fontSize: 12,
                        //       fontWeight: FontWeight.w400,
                        //       color: context.isDarkMode
                        //           ? AppColors.whiteColor
                        //           : AppColors.c6C6C6C),
                        // ),
                      ],
                    ),
                    Label(
                      text: getSubscriptionType(
                          widget.data.subscriptionRank ?? 0),
                      textAlign: TextAlign.right,
                      style: Styles.mediumText(
                        color: AppColors.getRedColor(context),
                        fontWeight: FontWeight.w700,
                        // fontSize: 16
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 1,
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  spacing: 8,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: ImageFromInternet(
                                image: widget.data.profilePicture ?? '',
                                width: 56,
                                height: 56,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: -6,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.cF5F5F5,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.star,
                                        color: Colors.amber, size: 12),
                                    const SizedBox(width: 2),
                                    Text(
                                      "${widget.data.averageRating ?? 0}"
                                          .toArabicNumbers(context),
                                      style: Styles.smallText(
                                        color: Colors.black,
                                        // fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                            width: 16), // spacing between image and text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${widget.data.firstName ?? "N/A"} ${widget.data.lastName ?? ""}",
                                style: Styles.mediumText(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.getTextColor(context)
                                    // fontSize: 16,
                                    ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                context.isArabic
                                    ? widget.data.subCategory?.nameAr ?? "N/A"
                                    : widget.data.subCategory?.nameEn ?? "N/A",
                                style: Styles.mediumText(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.getTextColor(context)
                                    // fontSize: 14,
                                    ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 8,
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          color: AppColors.getButtonPrimaryWhiteColor(context),
                        ),
                        Expanded(
                          child: Label(
                            style: Styles.mediumText(
                                fontSize: 32,
                                color: AppColors.getTextColor(context)),
                            text: context.isArabic
                                ? "${widget.data.address?.governorate?.governorateNameAr ?? "N/A"} , ${widget.data.address?.city?.cityNameAr ?? "N/A"}"
                                : "${widget.data.address?.governorate?.governorateNameEn ?? "N/A"} , ${widget.data.address?.city?.cityNameEn ?? "N/A"}",
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          Assets.cash,
                          fit: BoxFit.cover,
                          height: 48.h,
                          width: 48.h,
                        ),
                        const Sizer(),
                        Expanded(
                          child: Label(
                            text: context.isArabic ? 'خدمة' : 'Fees',
                            style: Styles.mediumText(
                                fontSize: 32,
                                color: AppColors.getTextColor(context),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Label(
                          text:
                              '${FormatNumbers().formatNumberByComma(widget.data.price.toString()).toArabicNumbers(context)} ${context.isArabic ? widget.data.currencyAr ?? '' : widget.data.currencyEn ?? ''}',
                          style: Styles.mediumText(
                              fontSize: 32,
                              color: AppColors.getTextColor(context),
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    // if(widget.data.isPremium == true)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.watch_later_outlined,
                                color: AppColors.getTextColor(context),
                                size: 48.h),
                            const Sizer(),
                            Label(
                              text:
                                  '${context.isArabic ? 'وقت الانتظار' : 'Waiting time'}: ${context.isArabic ? widget.data.waitingTimeAr : widget.data.waitingTimeEn}'
                                      .toArabicNumbers(context),
                              style: Styles.mediumText(
                                  fontSize: 32,
                                  color: AppColors.getTextColor(context),
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        Label(
                          text:
                              '${FormatNumbers().formatNumber(widget.data.bookingCount ?? 0, useArabicNumerals: context.isArabic)}/${LocaleKeys.book.localize}'
                                  .toArabicNumbers(context),
                          style: Styles.mediumText(
                              fontSize: 32,
                              fontWeight: FontWeight.w500,
                              color: AppColors.getRedColor(context)),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 5,
                            child: PremiumAndRequestButtons(item: widget.data)),
                        CallMessageReportButtons(item: widget.data),
                      ],
                    ),
                    // HealthCardButtonsSection(
                    //   isButton: true,
                    //   isSubscribed: widget.data.isPremium == true,
                    //   buttonTitle: '${LocaleKeys.book.localize}',
                    //   onTap: () {},
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PremiumAndRequestButtons extends StatelessWidget {
  final MostBookingEntity item;

  const PremiumAndRequestButtons({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
      child: Row(
        children: [
          _buildButton(
            context,
            label: LocaleKeys.book.localize,
            color: AppColors.getRedColor(context),
            onPressed: () {
              ManageVibration.vibrate();
              _showBookingBottomSheet(context, item);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Flexible(
      child: AppButton(
        radius: 15,
        height: 35,
        padding: 0,
        margin: 0,
        label: label,
        backColor: color,
        style: Styles.mediumText(
          color: AppColors.getReversedTextColor(context),
          fontSize: 32,
        ),
        onPressed: onPressed,
      ),
    );
  }

  void _showBookingBottomSheet(BuildContext context, MostBookingEntity item) {
    final TextEditingController patientNameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController noteController = TextEditingController();
    String selectedGender = 'Male'; // Default gender
    bool hasNameError = false;
    bool hasPhoneError = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.getFindFillColor(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Clear errors when user starts typing
            patientNameController.addListener(() {
              if (hasNameError && patientNameController.text.isNotEmpty) {
                setState(() {
                  hasNameError = false;
                });
              }
            });

            phoneController.addListener(() {
              if (hasPhoneError && phoneController.text.isNotEmpty) {
                setState(() {
                  hasPhoneError = false;
                });
              }
            });

            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                top: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.getButtonPrimaryColor(context)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.calendar_today,
                            color: AppColors.getButtonPrimaryColor(context),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            LocaleKeys.book.localize,
                            style: Styles.headerText(
                              fontSize: 48,
                              fontWeight: FontWeight.w700,
                              color: AppColors.getTextColor(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Patient Name Field
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: patientNameController,
                      style: TextStyle(
                        color: AppColors.getTextColor(context),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.getButtonPrimaryColor(context)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.person_outline,
                            color: AppColors.getButtonPrimaryColor(context),
                            size: 20,
                          ),
                        ),
                        hintText:
                            context.isArabic ? 'اسم المريض' : 'Patient Name',
                        hintStyle: TextStyle(
                          color:
                              AppColors.getTextColor(context).withOpacity(0.6),
                          fontSize: 16,
                        ),
                        errorText: hasNameError
                            ? context.isArabic
                                ? 'ادخل اسم المريض'
                                : 'Enter Patient Name'
                            : null,
                        errorStyle: TextStyle(
                          color: AppColors.getRedColor(context),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        filled: true,
                        fillColor: AppColors.getFillColor(context),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: AppColors.getTextColor(context)
                                .withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: AppColors.getButtonPrimaryColor(context),
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: AppColors.getRedColor(context),
                            width: 1,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: AppColors.getRedColor(context),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Phone Number Field
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(
                        color: AppColors.getTextColor(context),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.getButtonPrimaryColor(context)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SvgPicture.asset(
                            Assets.phoneIconRed,
                            width: 18,
                            height: 18,
                            fit: BoxFit.contain,
                            color: AppColors.getButtonPrimaryColor(context),
                          ),
                        ),
                        hintText: LocaleKeys.phone.localize,
                        hintStyle: TextStyle(
                          color:
                              AppColors.getTextColor(context).withOpacity(0.6),
                          fontSize: 16,
                        ),
                        errorText: hasPhoneError
                            ? LocaleKeys.enterPhoneNumber.localize
                            : null,
                        errorStyle: TextStyle(
                          color: AppColors.getRedColor(context),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        filled: true,
                        fillColor: AppColors.getFillColor(context),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: AppColors.getTextColor(context)
                                .withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: AppColors.getButtonPrimaryColor(context),
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: AppColors.getRedColor(context),
                            width: 1,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: AppColors.getRedColor(context),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Gender Selection
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.getFillColor(context),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color:
                              AppColors.getTextColor(context).withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.getButtonPrimaryColor(context)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.person_outline,
                              color: AppColors.getButtonPrimaryColor(context),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            LocaleKeys.gender.localize,
                            style: TextStyle(
                              color: AppColors.getTextColor(context),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.getButtonPrimaryColor(context)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButton<String>(
                              value: selectedGender,
                              underline: Container(),
                              dropdownColor: AppColors.getFillColor(context),
                              style: TextStyle(
                                color: AppColors.getTextColor(context),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.getButtonPrimaryColor(context),
                              ),
                              items: [
                                DropdownMenuItem(
                                  value: 'Male',
                                  child: Text(LocaleKeys.maleUser.localize),
                                ),
                                DropdownMenuItem(
                                  value: 'Female',
                                  child: Text(LocaleKeys.femaleUser.localize),
                                ),
                              ],
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    selectedGender = newValue;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Note Field
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: noteController,
                      maxLines: 3,
                      minLines: 3,
                      style: TextStyle(
                        color: AppColors.getTextColor(context),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.getButtonPrimaryColor(context)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.note_outlined,
                            color: AppColors.getButtonPrimaryColor(context),
                            size: 20,
                          ),
                        ),
                        hintText: LocaleKeys.notes.localize,
                        hintStyle: TextStyle(
                          color:
                              AppColors.getTextColor(context).withOpacity(0.6),
                          fontSize: 16,
                        ),
                        filled: true,
                        fillColor: AppColors.getFillColor(context),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: AppColors.getTextColor(context)
                                .withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: AppColors.getButtonPrimaryColor(context),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        alignLabelWithHint: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      // Book Button
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.getButtonPrimaryColor(context)
                                    .withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: AppButton(
                            radius: 16,
                            height: 50,
                            backColor: AppColors.getButtonPrimaryColor(context),
                            color: AppColors.getReversedTextColor(context),
                            label: LocaleKeys.book.localize,
                            style: Styles.mediumText(
                              color: AppColors.getReversedTextColor(context),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            onPressed: () {
                              ManageVibration.vibrate();
                              _handleBooking(
                                context,
                                patientNameController.text.trim(),
                                phoneController.text.trim(),
                                noteController.text.trim(),
                                selectedGender,
                                false, // isPremium = false
                                setState,
                                hasNameError,
                                hasPhoneError,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Premium Book Button
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.getRedColor(context)
                                    .withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: AppButton(
                            radius: 16,
                            height: 50,
                            backColor: AppColors.getRedColor(context),
                            color: AppColors.getReversedTextColor(context),
                            label: LocaleKeys.premiumBook.localize,
                            style: Styles.mediumText(
                              color: AppColors.getReversedTextColor(context),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            onPressed: () {
                              ManageVibration.vibrate();
                              if (item.isPremium == false) {
                                SubscriptionMethod().subscribe(
                                  subscribeId: item.subCategory?.id ?? '',
                                  title: item.firstName ?? '',
                                );
                              } else {
                                _handleBooking(
                                  context,
                                  patientNameController.text.trim(),
                                  phoneController.text.trim(),
                                  noteController.text.trim(),
                                  selectedGender,
                                  true, // isPremium = true
                                  setState,
                                  hasNameError,
                                  hasPhoneError,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _handleBooking(
    BuildContext context,
    String patientName,
    String phone,
    String note,
    String gender,
    bool isPremium,
    StateSetter setState,
    bool hasNameError,
    bool hasPhoneError,
  ) {
    // Validation
    if (patientName.isEmpty) {
      setState(() {
        hasNameError = true;
      });
      return;
    }

    if (phone.isEmpty) {
      setState(() {
        hasPhoneError = true;
      });
      return;
    }

    // Here you can implement the actual booking logic
    // For now, we'll just show a success message and close the sheet
    Navigator.pop(context);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isPremium
              ? context.isArabic
                  ? "تم الحجز المميز بنجاح"
                  : "Booking premium successful"
              : context.isArabic
                  ? "تم الحجز بنجاح"
                  : "Booking successful",
        ),
        backgroundColor: AppColors.getButtonPrimaryColor(context),
      ),
    );

    // TODO: Implement actual booking API call
    print('Booking Details:');
    print('Patient Name: $patientName');
    print('Phone: $phone');
    print('Gender: $gender');
    print('Note: $note');
    print('Is Premium: $isPremium');
  }
}

class CallMessageReportButtons extends StatelessWidget {
  final MostBookingEntity item;

  const CallMessageReportButtons({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isChatEnabled = item.isPremium;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
      child: Row(
        children: [
          IconButton(
            icon: SvgPicture.asset(
              Assets.phoneIconRed,
              width: 22,
              height: 22,
              color: isChatEnabled == true
                  ? AppColors.getRedColor(context)
                  : AppColors.GREY_DARK_COLOR,
            ),
            color: isChatEnabled == true
                ? AppColors.PRIMARY_COLOR
                : AppColors.GREY_DARK_COLOR,
            onPressed: isChatEnabled == true
                ? () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: AppColors.getFindFillColor(context),
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      builder: (_) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            spacing: 16,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppButton(
                                backColor:
                                    AppColors.getButtonPrimaryColor(context),
                                color: AppColors.getReversedTextColor(context),
                                onPressed: () {
                                  ManageVibration.vibrate();
                                  Navigator.pop(context); // Close first sheet
                                  // _showFreeCallBottomSheet(context, item);
                                },
                                label: LocaleKeys.freeCall.localize,
                              ),
                              AppButton(
                                backColor: AppColors.cD9D9D9,
                                color: AppColors.black,
                                onPressed: () {
                                  ManageVibration.vibrate();
                                  Navigator.pop(context); // Close first sheet
                                  _showRegularCallBottomSheet(
                                      context, item); // Open second
                                },
                                label: LocaleKeys.regularCall.localize,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                : () {
                    SubscriptionMethod().subscribe(
                      subscribeId: item.subCategory?.id ?? '',
                      title: item.firstName ?? '',
                    );
                  },
          ),

          // const SizedBox(width: 4),
          IconButton(
            icon: SvgPicture.asset(
              Assets.mailIconRed,
              width: 18,
              height: 18,
              color: isChatEnabled == true
                  ? AppColors.getRedColor(context)
                  : AppColors.GREY_DARK_COLOR,
            ),
            color: isChatEnabled == true
                ? AppColors.getRedColor(context)
                : AppColors.GREY_DARK_COLOR,
            onPressed: isChatEnabled == true
                ? () {
                    // BlocProvider.of<RestaurantsCubit>(context)
                    //     .getExpiredOrders();
                    // Implement message functionality here
                  }
                : () {
                    SubscriptionMethod().subscribe(
                        subscribeId: item.subCategory?.id ?? '',
                        title: item.firstName ?? '');
                  },
          ),
          // const SizedBox(width: 4),
          IconButton(
            icon: const Icon(
              Icons.report,
              size: 26,
            ),
            color: AppColors.getRedColor(context),
            onPressed: () async {
              ManageVibration.vibrate();
              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: AppColors.getFindFillColor(context),
                builder: (context) {
                  return SizedBox(
                    height: isKeyboardVisible(context) ? 0.8.sh : 0.6.sh,
                    child: ReportView(
                      id: item.id!,
                      categoryId: item.subCategory?.id ?? '',
                    ),
                  );
                },
              );

              // Implement report functionality here
            },
          ),
        ],
      ),
    );
  }

  void _showRegularCallBottomSheet(
      BuildContext context, MostBookingEntity item) {
    bool isBookingForAnotherClient = false;
    bool hasPhoneError = false;
    final TextEditingController phoneController =
        TextEditingController(text: "phone");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.getFindFillColor(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            phoneController.addListener(() {
              if (hasPhoneError && phoneController.text.isNotEmpty) {
                setState(() {
                  hasPhoneError = false;
                });
              }
            });

            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                top: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CheckboxListTile(
                    activeColor: AppColors.getButtonPrimaryWhiteColor(context),
                    contentPadding: EdgeInsets.zero,
                    checkColor: AppColors.getPrimaryTextColor(context),
                    value: isBookingForAnotherClient,
                    onChanged: (value) {
                      setState(() {
                        isBookingForAnotherClient = value!;
                        hasPhoneError = false;
                        if (isBookingForAnotherClient) {
                          phoneController.clear();
                        } else {
                          // phoneController.text = item.number ?? '';
                        }
                      });
                    },
                    title: Text(
                      LocaleKeys.imBookingOfAnotherClient.localize,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.c717171,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    dense: true,
                    visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -4),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    // enabled: isBookingForAnotherClient,
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(
                      color: AppColors.getTextColor(context),
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset(
                          color: AppColors.getButtonPrimaryWhiteColor(context),
                          Assets.phoneIconRed,
                          width: 18,
                          height: 18,
                          fit: BoxFit.contain,
                        ),
                      ),
                      hintText: LocaleKeys.phone.localize,
                      errorText: hasPhoneError
                          ? LocaleKeys.enterPhoneNumber.localize
                          : null,
                      filled: true,
                      fillColor: AppColors.getFillColor(context),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      backColor: AppColors.getButtonPrimaryColor(context),
                      color: AppColors.getReversedTextColor(context),
                      label: LocaleKeys.submit.localize,
                      onPressed: () {
                        ManageVibration.vibrate();
                        final enteredNumber = phoneController.text.trim();
                        if (isBookingForAnotherClient) {
                          if (enteredNumber.isEmpty) {
                            setState(() {
                              hasPhoneError = true;
                            });
                            return;
                          }
                          launchUrlString("tel://$enteredNumber");
                        } else {
                          // launchUrlString("tel://${item.number}");
                        }

                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
