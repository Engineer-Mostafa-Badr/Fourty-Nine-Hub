import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

import '../../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../core/enums/wallet_types_enums.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../core/messages/messages.dart';
import '../../../../../../core/utils/format_numbers.dart';
import '../../../../../../helpers/subscription_method.dart';
import '../../../../../../res/assets/assets.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../service_locator/service_locator.dart';
import '../../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../../../subscripe/presentation/controllers/subscription_controller.dart';
import '../image_text_row.dart';

class CustomReserveRideBottomSheet extends StatefulWidget {
  final RideCubit rideCubit;
  final bool isPremium;
  final String selectedCategoryId;

  const CustomReserveRideBottomSheet(
      {super.key,
      required this.rideCubit,
      required this.selectedCategoryId,
      required this.isPremium});

  @override
  State<CustomReserveRideBottomSheet> createState() =>
      _CustomReserveRideBottomSheetState();
}

class _CustomReserveRideBottomSheetState
    extends State<CustomReserveRideBottomSheet> {
  String selectedCategoryId = '';
  ValueNotifier<double> sheetHeightNotifier = ValueNotifier(0.5);
  int selectedContainerIndex = 0;
  int? selectedGridIndex;

  @override
  void initState() {
    selectedCategoryId = widget.selectedCategoryId;
    if(serviceLocator<RideCubit>().isComfort && (!serviceLocator<RideCubit>().isNonSmoker && !serviceLocator<RideCubit>().isAutoAccept)) selectedGridIndex = 1;
    if(serviceLocator<RideCubit>().isNonSmoker && (!serviceLocator<RideCubit>().isAutoAccept && !serviceLocator<RideCubit>().isComfort)) selectedGridIndex = 2;
    if(serviceLocator<RideCubit>().isAutoAccept && (!serviceLocator<RideCubit>().isNonSmoker && !serviceLocator<RideCubit>().isComfort)) selectedGridIndex = 3;
    if(serviceLocator<RideCubit>().isNonSmoker == false && serviceLocator<RideCubit>().isComfort == false && serviceLocator<RideCubit>().isAutoAccept == false) selectedGridIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.95,
      child: BlocProvider.value(
        value: widget.rideCubit,
        child: BlocBuilder<RideCubit, RideState>(
          builder: (context, state) {
            return Stack(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  behavior: HitTestBehavior.opaque,
                  child: Container(color: Colors.transparent),
                ),
                DraggableScrollableSheet(
                  initialChildSize: 0.95,
                  minChildSize: 0.3,
                  maxChildSize: 1.0,
                  builder: (context, scrollController) {
                    return ValueListenableBuilder<double>(
                      valueListenable: sheetHeightNotifier,
                      builder: (context, value, child) {
                        return Container(
                          decoration: BoxDecoration(
                            color: context.isDarkMode
                                ? AppColors.QUANTITY_COLOR
                                : Colors.white,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                 horizontal: 16),
                            child: SingleChildScrollView(
                              controller: scrollController,

                              child: Column(
                                children: [
                                  Label(
                                    text: context.isArabic ? "احجز رحلة" : "Reserve a ride",
                                    style: const TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.w500),
                                  ),
                                  _buildSelectedItem(state),
                                  const SizedBox(height: 8),
                                if(state.rideExpectedPrice!.subcategoryModel.where((e) => e.id == selectedCategoryId).first.nameEn.toLowerCase() != 'scooter')
                                  /// ✅ GridView داخل Column مع shrinkWrap
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 6,
                                      mainAxisSpacing: 6,
                                      childAspectRatio: 2.8,
                                    ),
                                    itemCount: 4,
                                    itemBuilder: (context, index) {
                                      int price = 0;
                                      if(index == 0){
                                        price = state.rideExpectedPrice!.subcategoryModel.where((e) => e.id == selectedCategoryId).first.price.toInt();
                                      }
                                      if(index == 1){
                                        price = state.rideExpectedPrice!.subcategoryModel.where((e) => e.id == selectedCategoryId).first.price.toInt() + state.rideExpectedPrice!.comfort.toInt();
                                      }
                                      if(index == 2){
                                        price = state.rideExpectedPrice!.subcategoryModel.where((e) => e.id == selectedCategoryId).first.price.toInt() + state.rideExpectedPrice!.nonSmoking.toInt();
                                      }
                                      if(index == 3){
                                        price = state.rideExpectedPrice!.subcategoryModel.where((e) => e.id == selectedCategoryId).first.price.toInt() + state.rideExpectedPrice!.autoAccept.toInt();
                                      }
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedGridIndex = index;
                                            if(index == 0){
                                              serviceLocator<RideCubit>().isComfort = false;
                                              serviceLocator<RideCubit>().isNonSmoker = false;
                                              serviceLocator<RideCubit>().isAutoAccept = false;
                                            }
                                            if(index == 1){
                                              serviceLocator<RideCubit>().isComfort = true;
                                              serviceLocator<RideCubit>().isNonSmoker = false;
                                              serviceLocator<RideCubit>().isAutoAccept = false;
                                            }
                                            if(index == 2){
                                              serviceLocator<RideCubit>().isComfort = false;
                                              serviceLocator<RideCubit>().isNonSmoker = true;
                                              serviceLocator<RideCubit>().isAutoAccept = false;
                                            }
                                            if(index == 3){
                                              serviceLocator<RideCubit>().isComfort = false;
                                              serviceLocator<RideCubit>().isNonSmoker = false;
                                              serviceLocator<RideCubit>().isAutoAccept = true;
                                            }
                                          });
                                        },
                                        child: Container(
                                          // padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            color: selectedGridIndex == index
                                                ? AppColors.PRIMARY_COLOR.withValues(alpha:  0.1)
                                                : Colors.grey.shade200,
                                            border: Border.all(
                                              color: selectedGridIndex == index
                                                  ? AppColors.PRIMARY_COLOR
                                                  : Colors.transparent,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 30,
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Image.network(
                                                      state.rideExpectedPrice?.subcategoryModel
                                                          .where((e) => e.id == selectedCategoryId)
                                                          .first.picture ?? '',
                                                      height: 30,
                                                      width: 40,
                                                      errorBuilder: (_, __, ___) =>
                                                      const Icon(Icons.directions_car),
                                                    ),
                                                    if(index != 0)
                                                    SizedBox(width: 10,),
                                                    if(index != 0)
                                                    Text(
                                                      '+',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                        color: selectedGridIndex == index
                                                            ? Colors.white
                                                            : Colors.black,
                                                      ),
                                                    ),
                                                    if(index == 1)
                                                    Image.asset(Assets.airConditioner,
                                                      height: 20,
                                                      width: 40,),
                                                    if(index == 2)
                                                    Image.asset(Assets.noSmokingIcon,
                                                      height: 20,
                                                      width: 40,),
                                                    if(index == 3)
                                                      SizedBox(width: 6,),
                                                    if(index == 3)
                                                    Icon(Icons.autorenew, size: 20,color: selectedGridIndex == index
                                                        ? Colors.white
                                                        : Colors.black,),
                                                  ],
                                                ),
                                              ),
                                               Text(
                                                "${FormatNumbers().convertNumberToLocalizedString(price.toString(), isArabic: context.isArabic)} ${context.isArabic ? "ج.م" : "EGP"}",
                                                style: TextStyle(fontWeight: FontWeight.bold, color: selectedGridIndex == index
                                                    ? context.isDarkMode? Colors.white : Colors.black
                                                    : Colors.black,),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  // const SizedBox(height: 8),

                                  /// ✅ ListView داخل Column مع shrinkWrap
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: (state.rideExpectedPrice?.subcategoryModel.length ?? 0) + 3,
                                    itemBuilder: (context, index) {

                                      if (index <
                                          (state.rideExpectedPrice?.subcategoryModel.length ?? 0)) {
                                        if(state.rideExpectedPrice?.subcategoryModel[index].id == selectedCategoryId) return SizedBox();
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (context.isUserLoggedIn &&
                                                  serviceLocator<UserCubit>().state.data?.gender != null) {
                                                if (serviceLocator<UserCubit>().state.data?.gender == "male") {
                                                  if (state.rideExpectedPrice?.subcategoryModel[index].nameEn
                                                      .trim()
                                                      .toLowerCase() ==
                                                      "lady") {
                                                    toastification.show(
                                                      title: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(context.isArabic?"تنبيه!":"Alert!",
                                                            style: TextStyle(color: context.isDarkMode?AppColors.whiteColor:AppColors.PRIMARY_COLOR,
                                                              fontSize: 32.sp,
                                                              fontWeight: FontWeight.w700,
                                                            ),
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                          Text(context.isArabic
                                                              ? "أنت رجل, لا يمكنك استخدام هذه الخدمة"
                                                              : "You are a man, you can't use this service",
                                                            style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color,
                                                                fontSize: 22.sp,
                                                                fontWeight: FontWeight.w400
                                                            ),
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                      autoCloseDuration: const Duration(seconds: 5),
                                                      progressBarTheme: ProgressIndicatorThemeData(
                                                          color: AppColors.SECONDARY_COLOR
                                                      ),
                                                      primaryColor: AppColors.SECONDARY_COLOR,
                                                      backgroundColor: Theme.of(context).dialogBackgroundColor,
                                                      showProgressBar: true,

                                                    );
                                                    showErrorMessage(
                                                        context,
                                                        context.isArabic
                                                            ? "أنت رجل, لا يمكنك استخدام هذه الخدمة"
                                                            : "You are a man, you can't use this service");
                                                    return;
                                                  }
                                                }
                                              }
                                              selectedCategoryId =
                                                  state.rideExpectedPrice?.subcategoryModel[index].id ?? '';
                                            });
                                          },
                                          child: _buildListItem(index, state),
                                        );
                                      } else {
                                        return ImageTextRow(
                                          imagePath: Assets.logo,
                                          text: [
                                            LocaleKeys.theApplicationDoesNotDeductAnyPercentage.localize,
                                            LocaleKeys.premiumPackageCashBack.localize,
                                            LocaleKeys.freeCancellation.localize
                                          ][index - (state.rideExpectedPrice?.subcategoryModel.length ?? 0)],
                                        );
                                      }
                                    },
                                  ),
                                  Column(
                                    children: [
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                              child: _buildSelectableContainer(
                                                  0,
                                                  LocaleKeys.cash.localize,
                                                  true)),
                                          const SizedBox(width: 18),
                                          Expanded(
                                              child: _buildSelectableContainer(
                                                  1, context.isArabic ? "بطاقة بنكية" : "Visa", false)),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      AppButton(
                                        height: 44,
                                        color: AppColors.whiteColor,
                                        backColor: context.isDarkMode
                                            ? AppColors.PRIMARY_COLOR_DARK
                                            : AppColors.PRIMARY_COLOR,
                                        label: context.isArabic? "تأكيد" : "Confirm",
                                        onPressed: () async {
                                          if (widget.isPremium) {
                                            bool isSubscribed = await context
                                                .read<RideCubit>()
                                                .isSubscribed(
                                                    userId: UserCubit
                                                            .to.state.data?.id ??
                                                        '',
                                                    subcategoryId:
                                                        selectedCategoryId);
                                            if (!isSubscribed) {
                                              SubscriptionMethod().subscribe(
                                                  subscribeId: selectedCategoryId,
                                                  // onSubscribe: (success) {
                                                    // context.pop();
                                                    // context.pop();
                                                  // },
                                                  showRegular: false,
                                                  title: LocaleKeys
                                                      .premiumRequest.localize);
                                            }else {
                                              if (selectedContainerIndex == 1) {
                                                bool isEnough = await widget.rideCubit.checkRealAmountIsEnough(
                                                  price: state.rideExpectedPrice?.subcategoryModel.where((e) => e.id == selectedCategoryId).first.price ?? 0.0,
                                                );
                                                log('isEnough: $isEnough');
                                                if (!isEnough) {
                                                  serviceLocator<SubscriptionController>().showActiveSubscriptionAmounts(
                                                    walletType: WalletTypes.balance,
                                                    price: state.rideExpectedPrice?.highestFare,
                                                  );
                                                }else{
                                                  // context.pop();
                                                  await widget.rideCubit.requestTrip(
                                                    context: context,
                                                    price: widget.rideCubit.getTotalPrice(state.rideExpectedPrice!.subcategoryModel.where((e) => e.id == selectedCategoryId).first.price,),
                                                    comfort: widget.rideCubit.isComfort,
                                                    autoAccept: widget.rideCubit.isAutoAccept,
                                                    nonSmoker: widget.rideCubit.isNonSmoker,
                                                    passengers: 2,
                                                    paymentMethod: selectedContainerIndex == 0 ? PaymentMethods.cash : PaymentMethods.visa,
                                                    subcategoryId: selectedCategoryId,
                                                    fromTitle: state.rideExpectedPrice?.from ?? '',
                                                    toTitle: state.rideExpectedPrice?.to ?? '',
                                                    distance: state.rideExpectedPrice?.distance ?? 0,
                                                    duration: state.rideExpectedPrice?.duration.toInt() ?? 0,
                                                    startLocation: state.rideExpectedPrice?.startLocation ?? [],
                                                    targetLocation: state.rideExpectedPrice?.targetLocation ?? [],
                                                    wayPointOne: state.wayPointOne != null ? [state.wayPointOne?.lat ?? 0, state.wayPointOne?.lng ?? 0] : null,
                                                    wayPointTwo: state.wayPointTwo != null ? [state.wayPointTwo?.lat ?? 0, state.wayPointTwo?.lng ?? 0] : null,
                                                    calculateB: 0,
                                                    isPremium: widget.isPremium,
                                                    polyline: widget.rideCubit.state.rideExpectedPrice?.polyline ?? [],
                                                    wayPointOneTitle: widget.rideCubit.state.wayPointOne?.address,
                                                    wayPointTwoTitle: widget.rideCubit.state.wayPointTwo?.address,
                                                  );

                                                }
                                              }
                                              else {
                                                // context.pop();
                                                await widget.rideCubit.requestTrip(
                                                  context: context,
                                                  price: widget.rideCubit.getTotalPrice(state.rideExpectedPrice!.subcategoryModel.where((e) => e.id == selectedCategoryId).first.price,),
                                                  comfort: widget.rideCubit.isComfort,
                                                  autoAccept: widget.rideCubit.isAutoAccept,
                                                  nonSmoker: widget.rideCubit.isNonSmoker,
                                                  passengers: 2,
                                                  paymentMethod: selectedContainerIndex == 0 ? PaymentMethods.cash : PaymentMethods.visa,
                                                  subcategoryId: selectedCategoryId,
                                                  fromTitle: state.rideExpectedPrice?.from ?? '',
                                                  toTitle: state.rideExpectedPrice?.to ?? '',
                                                  distance: state.rideExpectedPrice?.distance ?? 0,
                                                  duration: state.rideExpectedPrice?.duration.toInt() ?? 0,
                                                  startLocation: state.rideExpectedPrice?.startLocation ?? [],
                                                  targetLocation: state.rideExpectedPrice?.targetLocation ?? [],
                                                  wayPointOne: state.wayPointOne != null ? [state.wayPointOne?.lat ?? 0, state.wayPointOne?.lng ?? 0] : null,
                                                  wayPointTwo: state.wayPointTwo != null ? [state.wayPointTwo?.lat ?? 0, state.wayPointTwo?.lng ?? 0] : null,
                                                  calculateB: 0,
                                                  isPremium: widget.isPremium,
                                                  polyline: widget.rideCubit.state.rideExpectedPrice?.polyline ?? [],
                                                  wayPointOneTitle: widget.rideCubit.state.wayPointOne?.address,
                                                  wayPointTwoTitle: widget.rideCubit.state.wayPointTwo?.address,
                                                );
                                              }
                                            }
                                          } else {
                                            if (selectedContainerIndex == 1) {
                                              bool isEnough = await widget
                                                  .rideCubit
                                                  .checkRealAmountIsEnough(
                                                price: state.rideExpectedPrice
                                                        ?.subcategoryModel
                                                        .where((e) =>
                                                            e.id ==
                                                            selectedCategoryId)
                                                        .first
                                                        .price ??
                                                    0.0,
                                              );
                                              log('isEnough: $isEnough');
                                              if (!isEnough) {
                                                serviceLocator<
                                                        SubscriptionController>()
                                                    .showActiveSubscriptionAmounts(
                                                  walletType: WalletTypes.balance,
                                                  price: state.rideExpectedPrice
                                                      ?.highestFare,
                                                );
                                              } else {
                                                // context.pop();
                                                await widget.rideCubit
                                                    .requestTrip(
                                                  context: context,
                                                  price: widget.rideCubit
                                                      .getTotalPrice(
                                                    state.rideExpectedPrice!
                                                        .subcategoryModel
                                                        .where((e) =>
                                                            e.id ==
                                                            selectedCategoryId)
                                                        .first
                                                        .price,
                                                  ),
                                                  comfort:
                                                      widget.rideCubit.isComfort,
                                                  autoAccept: widget
                                                      .rideCubit.isAutoAccept,
                                                  nonSmoker: widget
                                                      .rideCubit.isNonSmoker,
                                                  passengers: 2,
                                                  paymentMethod:
                                                      selectedContainerIndex == 0
                                                          ? PaymentMethods.cash
                                                          : PaymentMethods.visa,
                                                  subcategoryId:
                                                      selectedCategoryId,
                                                  fromTitle: state
                                                          .rideExpectedPrice
                                                          ?.from ??
                                                      '',
                                                  toTitle: state.rideExpectedPrice
                                                          ?.to ??
                                                      '',
                                                  distance: state
                                                          .rideExpectedPrice
                                                          ?.distance ??
                                                      0,
                                                  duration: state
                                                          .rideExpectedPrice
                                                          ?.duration
                                                          .toInt() ??
                                                      0,
                                                  startLocation: state
                                                          .rideExpectedPrice
                                                          ?.startLocation ??
                                                      [],
                                                  targetLocation: state
                                                          .rideExpectedPrice
                                                          ?.targetLocation ??
                                                      [],
                                                  wayPointOne:
                                                      state.wayPointOne != null
                                                          ? [
                                                              state.wayPointOne
                                                                      ?.lat ??
                                                                  0,
                                                              state.wayPointOne
                                                                      ?.lng ??
                                                                  0
                                                            ]
                                                          : null,
                                                  wayPointTwo:
                                                      state.wayPointTwo != null
                                                          ? [
                                                              state.wayPointTwo
                                                                      ?.lat ??
                                                                  0,
                                                              state.wayPointTwo
                                                                      ?.lng ??
                                                                  0
                                                            ]
                                                          : null,
                                                  calculateB: 0,
                                                  isPremium: widget.isPremium,
                                                  polyline: widget
                                                          .rideCubit
                                                          .state
                                                          .rideExpectedPrice
                                                          ?.polyline ??
                                                      [],
                                                  wayPointOneTitle: widget
                                                      .rideCubit
                                                      .state
                                                      .wayPointOne
                                                      ?.address,
                                                  wayPointTwoTitle: widget
                                                      .rideCubit
                                                      .state
                                                      .wayPointTwo
                                                      ?.address,
                                                );
                                              }
                                            } else {
                                              // context.pop();
                                              await widget.rideCubit.requestTrip(
                                                context: context,
                                                price: widget.rideCubit
                                                    .getTotalPrice(
                                                  state.rideExpectedPrice!
                                                      .subcategoryModel
                                                      .where((e) =>
                                                          e.id ==
                                                          selectedCategoryId)
                                                      .first
                                                      .price,
                                                ),
                                                comfort:
                                                    widget.rideCubit.isComfort,
                                                autoAccept:
                                                    widget.rideCubit.isAutoAccept,
                                                nonSmoker:
                                                    widget.rideCubit.isNonSmoker,
                                                passengers: 2,
                                                paymentMethod:
                                                    selectedContainerIndex == 0
                                                        ? PaymentMethods.cash
                                                        : PaymentMethods.visa,
                                                subcategoryId: selectedCategoryId,
                                                fromTitle: state.rideExpectedPrice
                                                        ?.from ??
                                                    '',
                                                toTitle:
                                                    state.rideExpectedPrice?.to ??
                                                        '',
                                                distance: state.rideExpectedPrice
                                                        ?.distance ??
                                                    0,
                                                duration: state.rideExpectedPrice
                                                        ?.duration
                                                        .toInt() ??
                                                    0,
                                                startLocation: state
                                                        .rideExpectedPrice
                                                        ?.startLocation ??
                                                    [],
                                                targetLocation: state
                                                        .rideExpectedPrice
                                                        ?.targetLocation ??
                                                    [],
                                                wayPointOne: state.wayPointOne !=
                                                        null
                                                    ? [
                                                        state.wayPointOne?.lat ??
                                                            0,
                                                        state.wayPointOne?.lng ??
                                                            0
                                                      ]
                                                    : null,
                                                wayPointTwo: state.wayPointTwo !=
                                                        null
                                                    ? [
                                                        state.wayPointTwo?.lat ??
                                                            0,
                                                        state.wayPointTwo?.lng ??
                                                            0
                                                      ]
                                                    : null,
                                                calculateB: 0,
                                                isPremium: widget.isPremium,
                                                polyline: widget
                                                        .rideCubit
                                                        .state
                                                        .rideExpectedPrice
                                                        ?.polyline ??
                                                    [],
                                                wayPointOneTitle: widget.rideCubit
                                                    .state.wayPointOne?.address,
                                                wayPointTwoTitle: widget.rideCubit
                                                    .state.wayPointTwo?.address,
                                              );
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSelectableContainer(int index, String text, bool hasImage, {bool hasVisa = false}) {
    bool isSelected = selectedContainerIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedContainerIndex = index;
        });
      },
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.cF5F5F5,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.transparent,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: hasImage
            ? Row(
                spacing: 4,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(Assets.cash, height: 18, width: 16),
                  Label(
                    text: text,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.black : Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              )
            :

        Row(
          spacing: 4,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(Assets.visaIcon, height: 12, width: 12),
            Label(
              text: text,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.black : Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        )



      ),
    );
  }

  Widget _buildSelectedItem(RideState state) {
    return Container(
      width: double.infinity,
      // padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // color: Colors.grey[200],
        border: Border.all(
          color: context.isDarkMode ? AppColors.whiteColor : AppColors.black,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              // spacing: 30,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(
                  text: context.isArabic ? "اختيارك" : "Your Choice",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: context.isDarkMode
                        ? AppColors.whiteColor
                        : AppColors.black.withValues(alpha:  0.7),
                  ),
                ),
                Spacer(),
                Image.network(
                  state.rideExpectedPrice?.subcategoryModel
                          .where((e) => e.id == selectedCategoryId)
                          .first
                          .picture ??
                      "",
                  width: 80,
                ),
                Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Label(
                      text: context.isArabic
                          ? state.rideExpectedPrice?.subcategoryModel
                          .where((e) => e.id == selectedCategoryId)
                          .first
                          .nameAr ??
                          ''
                          : state.rideExpectedPrice?.subcategoryModel
                          .where((e) => e.id == selectedCategoryId)
                          .first
                          .nameEn ??
                          '',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Label(
                      text: context.isArabic
                          ? '${FormatNumbers().convertNumberToLocalizedString(widget.rideCubit.getTotalPrice(state.rideExpectedPrice!.subcategoryModel.where((e) => e.id == selectedCategoryId).first.price, isScooter: state.rideExpectedPrice!.subcategoryModel.where((e) => e.id == selectedCategoryId).first.nameEn.toLowerCase() == 'scooter').toInt().toString(), isArabic: context.isArabic)} ج.م'
                          : 'EGP ${FormatNumbers().convertNumberToLocalizedString(widget.rideCubit.getTotalPrice(state.rideExpectedPrice!.subcategoryModel.where((e) => e.id == selectedCategoryId).first.price, isScooter: state.rideExpectedPrice!.subcategoryModel.where((e) => e.id == selectedCategoryId).first.nameEn.toLowerCase() == 'scooter').toInt().toString(), isArabic: context.isArabic)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if(widget.rideCubit.isComfort || widget.rideCubit.isNonSmoker || widget.rideCubit.isAutoAccept)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.rideCubit.isComfort && state.rideExpectedPrice!.subcategoryModel.where((e) => e.id == selectedCategoryId).first.nameEn.toLowerCase() != 'scooter')
                  Row(
                    children: [
                      Label(
                        text: LocaleKeys.comfort.localize,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: context.isDarkMode
                                ? AppColors.whiteColor
                                : AppColors.black.withValues(alpha:  0.7)),
                      ),
                      Image.asset(Assets.airConditioner,
                        height: 20,
                        width: 40,),
                    ],
                  ),
                if (widget.rideCubit.isNonSmoker && state.rideExpectedPrice!.subcategoryModel.where((e) => e.id == selectedCategoryId).first.nameEn.toLowerCase() != 'scooter')
                  Row(
                    children: [
                      Label(
                        text: context.isArabic ? "غير مدخن" : "Nonsmoker",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: context.isDarkMode
                                ? AppColors.whiteColor
                                : AppColors.black.withValues(alpha:  0.7)),
                      ),
                      Image.asset(Assets.noSmokingIcon,
                        height: 20,
                        width: 40,),
                    ],
                  ),
                if (widget.rideCubit.isAutoAccept)
                  Row(
                    children: [
                      Label(
                        text: LocaleKeys.autoAccept.localize,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: context.isDarkMode
                                ? AppColors.whiteColor
                                : AppColors.black.withValues(alpha:  0.7)),
                      ),
                      Icon(Icons.autorenew, size: 20,),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(int index, RideState state) {
    final subcategory = state.rideExpectedPrice?.subcategoryModel[index];

    return Container(
      decoration: BoxDecoration(
        // color: selectedCategoryId == subcategory?.id ? Colors.blue[100] : Colors.transparent,
        border: Border.all(
          color: selectedCategoryId == subcategory?.id
              ? context.isDarkMode ? Colors.white : Colors.black
              : Colors.transparent,
          width: selectedCategoryId == subcategory?.id ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Image.network(subcategory?.picture ?? "",  height: 24,),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Label(
                      text: context.isArabic
                          ? (subcategory?.nameAr ?? '')
                          : (subcategory?.nameEn ?? ''),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    Label(
                      text: context.isArabic
                          ? '${FormatNumbers().convertNumberToLocalizedString(subcategory?.price.toInt().toString() ?? '0', isArabic: context.isArabic)} ج.م'
                          : 'EGP ${FormatNumbers().convertNumberToLocalizedString(subcategory?.price.toInt().toString() ?? '0', isArabic: context.isArabic)}',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentMethods {
  static String cash = 'cash';
  static String visa = 'wallet';
}
