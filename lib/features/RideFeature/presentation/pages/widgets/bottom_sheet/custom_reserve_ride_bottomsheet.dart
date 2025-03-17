import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/enums/ride_services_enum.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';

import '../../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../core/enums/wallet_types_enums.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../res/assets/assets.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../service_locator/service_locator.dart';
import '../../../../../subscripe/presentation/controllers/subscription_controller.dart';
import '../image_text_row.dart';

class CustomReserveRideBottomSheet extends StatefulWidget {
  final RideCubit rideCubit;
  final String selectedCategoryId;

  const CustomReserveRideBottomSheet({super.key, required this.rideCubit, required this.selectedCategoryId});

  @override
  State<CustomReserveRideBottomSheet> createState() => _CustomReserveRideBottomSheetState();
}

class _CustomReserveRideBottomSheetState extends State<CustomReserveRideBottomSheet> {
  String selectedCategoryId = '';
  ValueNotifier<double> sheetHeightNotifier = ValueNotifier(0.5);
  int selectedContainerIndex = 0;

  @override
  void initState() {
    selectedCategoryId = widget.selectedCategoryId;
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
                      initialChildSize: 0.6,
                      minChildSize: 0.6,
                      maxChildSize: 1.0,
                      builder: (context, scrollController) {
                        return ValueListenableBuilder<double>(
                          valueListenable: sheetHeightNotifier,
                          builder: (context, value, child) {
                            return NotificationListener<DraggableScrollableNotification>(
                              onNotification: (notification) {
                                sheetHeightNotifier.value = notification.extent;
                                return true;
                              },
                              child: Container(
                                decoration:  BoxDecoration(
                                  color: context.isDarkMode ? AppColors.black :Colors.white,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                  child: Column(
                                    spacing: 8,
                                    children: [
                                      Label(text: context.isArabic ? "احجز رحلة" : "Reserve a ride",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),
                                      _buildSelectedItem(state),
                                      Expanded(
                                        child: ListView.builder(
                                          controller: scrollController,
                                          itemCount: state.rideExpectedPrice?.subcategoryModel.length ?? 0,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedCategoryId = state.rideExpectedPrice?.subcategoryModel[index].id ?? '';
                                                });
                                              },
                                              child: _buildListItem(index, state),
                                            );
                                          },
                                        ),
                                      ),


                                      if (value > 0.7) ...[
                                        ImageTextRow(
                                            imagePath: Assets.logo,
                                            text: LocaleKeys.theApplicationDoesNotDeductAnyPercentage.localize),
                                        ImageTextRow(
                                            imagePath: Assets.logo,
                                            text: LocaleKeys.premiumPackageCashBack.localize),
                                        ImageTextRow(
                                            imagePath: Assets.logo,
                                            text: LocaleKeys.freeCancellation.localize),
                                        const SizedBox(height: 24,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Expanded(child: _buildSelectableContainer(0, LocaleKeys.cash.localize,true),),
                                            const SizedBox(width: 18),
                                            Expanded(child:  _buildSelectableContainer(1, context.isArabic ? "Visa" : "Visa",false),)
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        AppButton(
                                          height: 44,
                                          color: AppColors.whiteColor,
                                          backColor:  context.isDarkMode  ? AppColors.PRIMARY_COLOR_DARK : AppColors.PRIMARY_COLOR,
                                          label: LocaleKeys.confirm.localize,
                                          onPressed: () async {
                                            if(selectedContainerIndex == 1) {
                                              bool isEnough = await widget.rideCubit.checkRealAmountIsEnough(price: state.rideExpectedPrice?.subcategoryModel.where((e) => e.id == selectedCategoryId).first.price ?? 0.0);
                                              log('isEnough: $isEnough');
                                              if(isEnough) {
                                                log('true');
                                              }
                                              else {
                                                serviceLocator<SubscriptionController>()
                                                    .showActiveSubscriptionAmounts(
                                                    walletType: WalletTypes.balance, price: state.rideExpectedPrice?.highestFare);
                                              }
                                            }
                                          },
                                        ),
                                      ],
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
              }
          )
      ),
    );
  }


  Widget _buildSelectableContainer(int index, String text,bool hasImage) {
    bool isSelected = selectedContainerIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedContainerIndex = index;
        });
      },
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color:  AppColors.cF5F5F5,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.transparent,
            width: 1 ,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child:hasImage ? Row(
          spacing: 4,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(Assets.cash),
            Label(
              text: text,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.black : Colors.grey,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ) : Label(
          text: text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.black : Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
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
        color:  context.isDarkMode  ? AppColors.whiteColor : AppColors.black,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            spacing: 50,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(
                text: context.isArabic? "اختيارك" : "Your Choice",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: context.isDarkMode  ? AppColors.whiteColor : AppColors.black.withOpacity(0.7),
                ),
              ),
              Image.network(
                state.rideExpectedPrice?.subcategoryModel.where((e) => e.id == selectedCategoryId).first.picture ?? "",width: 100,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Label(text: context.isArabic ? state.rideExpectedPrice?.subcategoryModel.where((e) => e.id == selectedCategoryId).first.nameAr ?? '' : state.rideExpectedPrice?.subcategoryModel.where((e) => e.id == selectedCategoryId).first.nameEn ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              Label(text: context.isArabic? ' ج.م${state.rideExpectedPrice!.subcategoryModel.where((e) => e.id == selectedCategoryId).first.price.toInt()}' : 'EGP ${state.rideExpectedPrice!.subcategoryModel.where((e) => e.id == selectedCategoryId).first.price.toInt()}' ?? "",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          // const Label(text:  'Drop off today at 5:00 PM',
          //   style: TextStyle(
          //     fontWeight: FontWeight.w600,
          //     fontSize: 18,
          //   ),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if(widget.rideCubit.isComfort)
              Label(text: LocaleKeys.comfort.localize,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color:  context.isDarkMode  ? AppColors.whiteColor :AppColors.black.withOpacity(0.7)
                ),
              ),
              if(widget.rideCubit.isNonSmoker)
              Label(text: context.isArabic ? "غير مدخن" : "Nonsmoker",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: context.isDarkMode  ? AppColors.whiteColor : AppColors.black.withOpacity(0.7)
                ),
              ),
              if(widget.rideCubit.isAutoAccept)
              Label(text: LocaleKeys.autoAccept.localize,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color:  context.isDarkMode  ? AppColors.whiteColor : AppColors.black.withOpacity(0.7)
                ),
              ),

            ],
          ),
        ],
      ),
    ),
  );
}

// Widget _buildListItem(int index, bool isSelected, RideState state) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 6),
//     child: Container(
//       decoration: BoxDecoration(
//         color: isSelected ? Colors.blue[100] : Colors.transparent,
//         border: Border.all(
//           color: isSelected ? Colors.blue : Colors.transparent,
//           width: isSelected ? 2 : 1,
//         ),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Row(
//         children: [
//           Image.network(state.rideExpectedPrice?.subcategoryModel.where((e) => e.id != state.rideCategory?.subCategories[index].subCategoryId).toList()[index].picture ?? "", width: 40),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Label(
//                       text: context.isArabic
//                 ? (state.rideExpectedPrice?.subcategoryModel[index].nameAr ?? '')
//                   : (state.rideExpectedPrice?.subcategoryModel[index].nameEn ?? ''),
//
//       style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//                     ),
//                     Label(
//                       text: state.rideExpectedPrice?.subcategoryModel[index].price.toString() ?? '',
//                       style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//                     ),
//                   ],
//                 ),
//                 const Label(
//                   text: 'Drop off today at 5:00 PM',
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

  Widget _buildListItem(int index, RideState state) {
    final subcategory = state.rideExpectedPrice?.subcategoryModel[index];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          // color: selectedCategoryId == subcategory?.id ? Colors.blue[100] : Colors.transparent,
          border: Border.all(
            color: selectedCategoryId == subcategory?.id ? Colors.black : Colors.transparent,
            width: selectedCategoryId == subcategory?.id ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Image.network(subcategory?.picture ?? "", width: 80),
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
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      Label(
                        text: context.isArabic? ' ج.م${subcategory?.price.toInt()}' ?? '': 'EGP ${subcategory?.price.toInt()}' ?? '',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  // const Label(
                  //   text: 'Drop off today at 5:00 PM',
                  //   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
