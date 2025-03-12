import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/riderequest_cubit.dart';

import '../../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../../core/error/failure.dart';
import '../../../../../../../core/messages/messages.dart';
import '../../../../../../../core/widget/custom_switch_button.dart';
import '../../../../../../../res/strings/labels.dart';
import '../../../../../../../res/style/app_colors.dart';
import '../../../../../../../res/style/styles.dart';
import 'changePhoneNumber.dart';
import 'giveOffer.dart';
import 'ride_options.dart';
import 'selectDropOffPoints.dart';

class RideOptionsBottomSheet extends StatefulWidget {
  const RideOptionsBottomSheet({super.key});

  @override
  State<RideOptionsBottomSheet> createState() => _RideOptionsBottomSheetState();
}

class _RideOptionsBottomSheetState extends State<RideOptionsBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final rideCubit = context.read<RiderequestCubit>();

    return BlocConsumer<RiderequestCubit, RiderequestState>(
      listener: (context, state) {
        if (state.error) {
          showErrorMessage(
            context,
            getFailureMessage(
              state.failure ?? UnknownFailure(''),
              context,
            ),
          );
        } else if (state.isRequestSent) {
          showSuccessMessage(context, Labels.success);
        }
      },
      builder: (context, state) {
        return Container(
          width: double.infinity,
          padding:
              const EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 20),
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sizer(),
              // AppButton(
              //     label: 'Requests History',
              //     icon: Icons.history,
              //     onPressed: () => context.go(Routes.REQUESTSHISTORY)),

              const Sizer(),

              // Text('${state.subCategories?.length ?? 0}'),
              // if (state.subCategories?.isNotEmpty ?? false)
              // BlocBuilder<GetCateogryRiderCubit, RiderState>(
              //   builder: (context, state) {
              //     log(state.toString());
              //     if (state is SuccessGetCateogyRider) {
              //       return SizedBox(
              //         height: kTextTabBarHeight * 1,
              //         child: ListView.separated(
              //             scrollDirection: Axis.horizontal,
              //             shrinkWrap: true,
              //             itemBuilder: (context, index) {
              //               final subCategory =
              //                   state.model.subCategories![index];
              //               log(subCategory.subCategoryNameEn ?? "",
              //                   name: "lskdjflskdjfskldjf");
              //               return InkWell(
              //                 // onTap: () => rideCubit.changeSubCategorySelection(
              //                 //     item: subCategory),
              //                 onDoubleTap: () {},
              //                 child: Container(
              //                   padding: const EdgeInsets.all(5),
              //                   decoration: BoxDecoration(
              //                     border: Border.all(
              //                       color:
              //                           state.model.subCategories == subCategory
              //                               ? AppColors.SECONDARY_COLOR
              //                               : Theme.of(context).primaryColor,
              //                     ),
              //                     borderRadius: BorderRadius.circular(10),
              //                   ),
              //                   child: Row(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       Column(
              //                         crossAxisAlignment:
              //                             CrossAxisAlignment.start,
              //                         children: [
              //                           Expanded(
              //                               child: SquareImage(
              //                             fit: BoxFit.fitHeight,
              //                             width: 50,
              //                             url: subCategory.picture,
              //                           )),
              //                           Label(
              //                               text:
              //                                   subCategory.subCategoryNameEn ??
              //                                       "",
              //                               style: Styles.mediumText()),
              //                         ],
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               );
              //             },
              //             separatorBuilder: (context, index) => const Sizer(),
              //             itemCount: state.model.subCategories?.length ?? 0),
              //       );
              //     }
              //     return Container();
              //   },
              // ),
              const Sizer(),
              if (state.fromAddress != null)
                InkWell(
                  onTap: () {
                    bottomSheet(
                      //backColor: Theme.of(context).scaffoldBackgroundColor,
                      widget: const SelectDropOffPoints(),
                      isScrollControlled: true,
                      context: context,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: kToolbarHeight * .7,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: AppColors.PRIMARY_COLOR,
                          radius: 8,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 4,
                          ),
                        ),
                        const Sizer(),
                        Expanded(
                            child: Text(
                          state.fromAddress?.address ??
                              'Select Pickup location',
                          maxLines: 1,
                        )),
                      ],
                    ),
                  ),
                ),
              const Sizer(),
              // if (state.isFromAndToLocationSelected)
              InkWell(
                onTap: () {
                  bottomSheet(
                    widget: const SelectDropOffPoints(),
                    isScrollControlled: true,
                    context: context,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: kTextTabBarHeight * .7,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search,
                        color: AppColors.QUANTITY_COLOR,
                      ),
                      const Sizer(),
                      Expanded(
                          child: Label(
                        text: state.toAddress?.address ??
                            'Select drop off location',
                        style:
                            Styles.mediumText(color: AppColors.QUANTITY_COLOR),
                        maxLines: 1,
                      )),
                    ],
                  ),
                ),
              ),

              const Sizer(),
              if (state.time != null)
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        bottomSheet(
                            widget: RideContactPhoneNumber(
                              onChanged: (String v) =>
                                  rideCubit.changePhoneNumber(v),
                            ),
                            isScrollControlled: true,
                            context: context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: kTextTabBarHeight * .7,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Label(
                              text: state.phone ?? 'Phone',
                              style: Styles.mediumText(color: Colors.grey),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.phone,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Sizer(),
                    InkWell(
                      onTap: () {
                        bottomSheet(
                            widget: GiveOffer(),
                            isScrollControlled: true,
                            context: context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: kTextTabBarHeight * .7,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Label(
                                text: 'EGP',
                                style: Styles.mediumText(
                                    fontWeight: FontWeight.bold)),
                            const Sizer(
                              width: 20,
                            ),
                            Label(
                              text: '${state.offerPrice ?? 'Offer Your Fare'}',
                              style: Styles.mediumText(color: Colors.grey),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.money,
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.rocket_launch,
                          size: 14,
                        ),
                        const Sizer(),
                        Expanded(
                            child: Label(
                                text: 'Auto Accept offer of EGP',
                                style: Styles.mediumText(color: Colors.grey))),
                        CustomSwitchButton(
                            value: state.autoAccept,
                            onChanged: (v) =>
                                rideCubit.changeAutoAcceptStatus(v: v))
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.PRIMARY_COLOR.withOpacity(.1),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: AppColors.PRIMARY_COLOR,
                          ),
                          const Sizer(),
                          Label(
                              text:
                                  'Travel time ~ ${state.time ?? ''} - ${state.distance ?? ''}',
                              style: Styles.mediumText()),
                        ],
                      ),
                    ),
                    const Sizer(),
                  ],
                ),
              if (state.reqestIsReady)
                Row(
                  children: [
                    Expanded(
                        child: InkWell(
                      onTap: () => rideCubit.addNormalRequest(context: context),
                      child: Container(
                        height: kToolbarHeight * .7,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red),
                        child: Center(
                            child: Label(
                          text: 'Premium Request',
                          style: Styles.mediumText(color: Colors.white),
                        )),
                      ),
                    )),
                    const Sizer(),
                    InkWell(
                      onTap: () {
                        bottomSheet(
                          widget: const RideOptions(),
                          // isScrollControlled: true,
                          context: context,
                        );
                      },
                      child: Container(
                        height: kToolbarHeight * .7,
                        width: kToolbarHeight * .7,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.PRIMARY_COLOR),
                        child: const Icon(
                          Icons.sort,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
