import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/presentation/cubit/my_adds_cubit.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../common/functions/global/button_availability.dart';
import '../../../../../common/widgets/stateless/pages/empty.dart';
import '../../../../../core/enums/wallet_types_enums.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../../social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../../subscripe/presentation/controllers/subscription_controller.dart';
import '../../../../trip_join/view_all_trip_join/presentation/views/widgets/available_trip_button.dart';
import '../../domain/entity/get_all_counts_trip_join_entity.dart';
import '../../domain/usecases/get_all_counts_usecase.dart';

class CustomButtonCount extends StatelessWidget {
  const CustomButtonCount({super.key, required this.id, required this.status});

  final String id;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        label: 'Request Trip Join',
      ),
      body: BlocProvider<MyAddsCubit>(
        create: (BuildContext context) => serviceLocator()
          ..getAllCount(params: Params(id: id, status: status))..getMyTripJoin(),
        child: BlocConsumer<MyAddsCubit, MyAddsState>(
          listener: (BuildContext context, MyAddsState state) {
            if (state.status == MyAddsStates.success) {
              showSuccessMessage(context, 'Please subscribe to connect!');
            }
          },
          builder: (BuildContext context, state) {
            if (state.status == MyAddsStates.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == MyAddsStates.initState) {
              if (state.allCounts == null || state.allCounts!.isEmpty) {
                return const EmptyPage();
              }
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return buildItem(
                        context, state.allCounts![index], state, index,
                        messageButton: () {

                          // print('????????????????????');
                          // print(state.tripJoin?.docs[index].categoryId.id);
                      //     print(state.allCounts![index].userIdId);
                      //     print(state.allCounts![index].id);
                      //   //  print(state.myAds![index].subCategoryId!);
                      // context.read<MyAddsCubit>().click(
                      //         params: ClickParams(
                      //       clientId: user,
                      //       ownerId: state.allCounts![index].userIdId,
                      //       subcategoryId: state.allCounts![index].id,
                      //     ));
                    });
                  },
                  separatorBuilder: (context, index) => const Sizer(),
                  itemCount: state.allCounts?.length ?? 0,
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget buildItem(context, GetAllCountsTripJoinEntity model, state, index,
          {required Function messageButton}) =>
      Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Theme.of(context).primaryColor, width: 1),
        ),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  height: kToolbarHeight * 2.5.h,
                  width: kToolbarHeight * 2.5.w,
                  child: ImageFromInternet(
                    isCircle: true,
                    image: model.gender == 'male'
                        ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQwC-ZR1TdJ7VIAMeqhjm-u29-HB0PyAuSFFQ&s'
                        : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKc-oaCL6lH4WNLuY-A6H7UyEJmZQ5HdN6Os89NNXXANez6DAEM9SJdKu-Drj6L2LSfpM&usqp=CAU',
                  ),
                ),
                const Sizer(),
                Label(
                  text: model.firstName,
                  style: Styles.headerText(),
                ),
              ],
            ),
            Sizer(
              height: 10.h,
            ),
            FutureBuilder(
                future: ButtonAvailability().isShowButton(
                    otherUserId: state.allCounts![index].userIdId,
                    subcategoryId: state.tripJoin?.docs[index].categoryId.id),
                builder: (context, snap) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: AvaialbleTripsButton(
                          title: 'Call',
                          color: snap.data == true
                              ? AppColors.SECONDARY_COLOR
                              : AppColors.DARK_GRAY_COLOR,
                          icon: Icons.call,
                          onTap: snap.data == true ? () {
                            launchUrlString("tel://01023765247");
                          } : () {
                            launchUrlString("tel://01023765247");
                            // serviceLocator<SubscriptionController>()
                            //     .showSubscriptionPlans(
                            //   wallets: [
                            //     WalletTypes.mainWallet,
                            //     WalletTypes.giftWallet,
                            //     WalletTypes.balance,
                            //   ],
                            //   subCategoryId: state.tripJoin?.docs[index].categoryId.id,
                            //   title: 'Ads',
                            // );
                          },
                        ),
                      ),
                      const Sizer(width: 5),
                      Expanded(
                        flex: 3,
                        child: AvaialbleTripsButton(
                          title: 'Message',
                          color: snap.data == true
                              ? AppColors.SECONDARY_COLOR
                              : AppColors.DARK_GRAY_COLOR,
                          icon: Icons.email,
                          onTap: snap.data == true ? () {} : () {},
                        ),
                      ),
                      const Sizer(width: 5),
                      Expanded(
                        flex: 3,
                        child: AvaialbleTripsButton(
                          title: 'Report',
                          color: AppColors.SECONDARY_COLOR,
                          icon: Icons.report,
                          onTap: () {
                            print("jskdnajksdnjkadn");
                            // bottomSheet(
                            //     context: context,
                            //     widget: ReportView(
                            //       id: widget.item.id,
                            //       categoryId: '66b77e77bb35968b535dc944',
                            //     ));
                          },
                        ),
                      ),
                    ],
                  );
                })
            // Row(
            //   children: [
            //     FutureBuilder(
            //         future: ButtonAvailability().isShowButton(
            //             otherUserId: state.allCounts![index].userIdId,
            //             subcategoryId: state.allCounts![index].id),
            //         builder: (context, snap) {
            //           return Row(
            //             crossAxisAlignment: CrossAxisAlignment.center,
            //             children: [
            //               Expanded(
            //                 flex: 3,
            //                 child: AvaialbleTripsButton(
            //                   title: 'Call',
            //                   color: snap.data == true
            //                       ? AppColors.SECONDARY_COLOR
            //                       : AppColors.DARK_GRAY_COLOR,
            //                   icon: Icons.call,
            //                   onTap: snap.data == true ? () {} : () {},
            //                 ),
            //               ),
            //               const Sizer(width: 5),
            //               Expanded(
            //                 flex: 3,
            //                 child: AvaialbleTripsButton(
            //                   title: 'Message',
            //                   color: snap.data == true
            //                       ? AppColors.SECONDARY_COLOR
            //                       : AppColors.DARK_GRAY_COLOR,
            //                   icon: Icons.email,
            //                   onTap: snap.data == true ? () {} : () {},
            //                 ),
            //               ),
            //               const Sizer(width: 5),
            //               Expanded(
            //                 flex: 3,
            //                 child: AvaialbleTripsButton(
            //                   title: 'Report',
            //                   color: AppColors.SECONDARY_COLOR,
            //                   icon: Icons.report,
            //                   onTap: () {
            //                     print("jskdnajksdnjkadn");
            //                     // bottomSheet(
            //                     //     context: context,
            //                     //     widget: ReportView(
            //                     //       id: widget.item.id,
            //                     //       categoryId: '66b77e77bb35968b535dc944',
            //                     //     ));
            //                   },
            //                 ),
            //               ),
            //             ],
            //           );
            //         }),
            //     // Expanded(
            //     //   flex: 3,
            //     //   child: AvaialbleTripsButton(
            //     //     title: LocaleKeys.call.localize,
            //     //     icon: Icons.phone,
            //     //     color: AppColors.PRIMARY_COLOR,
            //     //     onTap: () async {
            //     //       launchUrlString("tel://01023765247");
            //     //       // if (await _isPremuim(
            //     //       // tripJoinCardEntity,
            //     //       // UIConst.chatNormalId,
            //     //       // LocaleKeys.chatSubscription.localize,
            //     //       // )) {
            //     //       //
            //     //       // }
            //     //     },
            //     //   ),
            //     // ),
            //     // Sizer(width: 10.w),
            //     // Expanded(
            //     //   flex: 3,
            //     //   child: AvaialbleTripsButton(
            //     //     title: LocaleKeys.message.localize,
            //     //     icon: Icons.mail,
            //     //     color: AppColors.PRIMARY_COLOR,
            //     //     onTap: () {
            //     //       messageButton();
            //     //     },
            //     //   ),
            //     // ),
            //     Sizer(width: 10.w),
            //     Expanded(
            //       flex: 3,
            //       child: AvaialbleTripsButton(
            //         title: LocaleKeys.report.localize,
            //         icon: Icons.report,
            //         color: AppColors.SECONDARY_COLOR,
            //         onTap: () {
            //           bottomSheet(
            //               context: context,
            //               widget: ReportView(
            //                 id: model.userId,
            //                 categoryId: model.tripId,
            //               ));
            //         },
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      );
}
