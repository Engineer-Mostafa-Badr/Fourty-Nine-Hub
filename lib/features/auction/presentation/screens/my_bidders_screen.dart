// AVAILABLE TAB
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/auction/presentation/screens/widgets/auction_card.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/enums/base_status_enum.dart';
import '../../../../core/utils/format_numbers.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';
import '../../../ads_feature/ads/presentation/widgets/marriage_call_message_buttons.dart';
import '../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../cubit/auction_cubit.dart';
import 'create_auction_screen.dart';

class MyBiddersScreen extends StatelessWidget {
  const MyBiddersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print("🏗️ MyBiddersScreen: Building widget");

    return BlocBuilder<AuctionCubit, AuctionState>(
      builder: (context, state) {
        print("🔄 BlocBuilder: State changed - Status: ${state.status}");

        final cubit = context.read<AuctionCubit>();
        final auctions = cubit.myBiddersData;

        print("📋 Current auctions list:");
        print("   - Length: ${auctions.length}");
        print("   - Is Empty: ${auctions.isEmpty}");
        print("   - State Status: ${state.status}");

        if (state.status == StateStatus.error) {
          return const Center(
            child: Text(
              "Something went wrong",
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        if (state.status == StateStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (auctions.isEmpty) {
          return const Center(child: Text("No Bidders available"));
        }

        return ListView.separated(
          // padding: const EdgeInsets.all(16),
          itemCount: auctions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final auction = auctions[index];
            print("🎯 Rendering auction at index $index: ${auction.toString()}");

            return Container(
              margin: EdgeInsets.all(32.w),
              decoration: BoxDecoration(
                // color: AppColors.getFillColor(context),
                border: Border.all(
                  color: context.isDarkMode
                      ? AppColors.LIGHT_COLOR
                      : const Color(0xB20B1035),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xfff2f1f7),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: _buildHeader(
                      status: auction.subscriptionType,
                      views: auction.views ?? 0,
                    ),
                  ),
                  Divider(
                    color: context.isDarkMode
                        ? AppColors.LIGHT_COLOR
                        : const Color(0xB20B1035),
                    thickness: 1,
                    height: 0,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: 15.w, vertical: 10.h),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.asset(
                                auction.gender == 'male'
                                    ? Assets.maleImagePlaceholder
                                    : Assets.femaleImagePlacehlder,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Label(
                              text: auction.username ?? "Unknown",
                              style: Styles.headerText(
                                color: context.isDarkMode
                                    ? AppColors.whiteColor
                                    : AppColors.black,
                                fontSize: 36,
                                height: 1.60,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Label(
                          text: "${LocaleKeys.wonTheAuction.localize}"
                              " ${auction.auctionTitle ?? "No title"} ${LocaleKeys.forAuction.localize} ${auction.price} ${LocaleKeys.EGP.localize}",
                          style: Styles.mediumText(
                            color: context.isDarkMode
                                ? AppColors.whiteColor
                                : AppColors.black,
                            fontSize: 24,
                            height: 1.40,
                          ),
                        ),
                        // Align(
                        //   alignment: AlignmentDirectional.centerStart,
                        //   child: Label(
                        //     text: auction.auctionTitle ?? "No title",
                        //     style: Styles.mediumText(
                        //       color: context.isDarkMode
                        //           ? AppColors.whiteColor
                        //           : AppColors.black,
                        //       fontSize: 24,
                        //       height: 1.40,
                        //     ),
                        //   ),
                        // ),
                        // Align(
                        //   alignment: AlignmentDirectional.centerEnd,
                        //   child: Text(
                        //     auction.subscriptionType ?? "N/A",
                        //     style: Styles.mediumText(
                        //       color: context.isDarkMode
                        //           ? AppColors.whiteColor
                        //           : AppColors.black,
                        //       fontWeight: FontWeight.w600,
                        //       fontSize: 24,
                        //       height: 1.60,
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                  Divider(
                    color: context.isDarkMode
                        ? AppColors.LIGHT_COLOR
                        : AppColors.black.withValues(alpha: 0.7),
                    thickness: 1,
                    height: 0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 24),
                    child: MarriageCallMessageButtons(
                      otherUserId: auction.winnerId ?? "",
                      subcategoryId: auction.auctionId ?? "",
                      phone: auction.phone ?? "",
                      id: UserCubit.to.state.data?.id ?? '',
                      hasReport: true,
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
  Widget _buildHeader({required num views,
    required String? status,
  }) {
    String label;
    Color color;

    switch (status) {
      case "Premium":
        label = LocaleKeys.premium2.localize;
        color = AppColors.SECONDARY_COLOR; // ده ممكن تغيره للون اللي تحبه
        break;
      case "Regular":
        label = LocaleKeys.regular.localize;
        color = AppColors.PRIMARY_COLOR;
        break;
      case "Not subscribe":
      default:
        label = LocaleKeys.notSubscribed.localize;
        color = Colors.grey;
        break;
    }

    return Container(
      // width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      // color: status == SubscriptionStatus.premium.status
      //     ? Colors.amber
      //     : Colors.grey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // if (status != SubscriptionStatus.notSubscribed.status) ...[
          //   Icon(
          //     Icons.workspace_premium_outlined,
          //     size: 55.w,
          //     color: status == SubscriptionStatus.premium.status
          //         ? AppColors.SECONDARY_COLOR
          //         : status == SubscriptionStatus.regular.status
          //             ? AppColors.PRIMARY_COLOR
          //             : null,
          //   ),
          //   const Sizer(width: 5)
          // ],
          SvgPicture.asset(
            Assets.adsEyeIcon,
          ),
          const SizedBox(width: 6),
          if (views == 0) ...[
            Label(
              text: LocaleKeys.noViews.localize,
              style: Styles.mediumText(
                color: const Color(0xFF6C6C6C),
                fontSize: 24,
                height: 1.60,
              ),
            ),
          ] else if (views == 1) ...[
            Label(
              text: LocaleKeys.oneView.localize,
              style: Styles.mediumText(
                color: const Color(0xFF6C6C6C),
                fontSize: 24,
                height: 1.60,
              ),
            ),
          ] else if (views == 2) ...[
            Label(
              text: LocaleKeys.twoViews.localize,
              style: Styles.mediumText(
                color: const Color(0xFF6C6C6C),
                fontSize: 24,
                height: 1.60,
              ),
            ),
          ] else if (views >= 3 && views <= 10) ...[
            Label(
              text: '$views ${LocaleKeys.views.localize}',
              style: Styles.mediumText(
                color: const Color(0xFF6C6C6C),
                fontSize: 24,
                height: 1.60,
              ),
            ),
          ] else ...[
            Label(
              text:
              '${FormatNumbers().formatNumber(views)} ${LocaleKeys.view.localize}',
              style: Styles.mediumText(
                color: const Color(0xFF6C6C6C),
                fontSize: 24,
                height: 1.60,
              ),
            ),
          ],
          const Spacer(),
          Label(
            text: label,
            style: Styles.mediumText(
              color: color,
              fontSize: 32,
              fontWeight: FontWeight.w700,
              height: 1.60,
            ),
            maxLines: 1,
          ),
          // Label(
          //   text: status
          //       ? LocaleKeys.premium2.localize
          //       : LocaleKeys.regular.localize,
          //   style: Styles.mediumText(
          //     color: const Color(0xFFF33D49),
          //     fontSize: 32,
          //     fontWeight: FontWeight.w700,
          //     height: 1.60,
          //   ),
          //   maxLines: 1,
          // ),
        ],
      ),
    );
  }
}

/*
class MyBiddersScreen extends StatelessWidget {
  const ExpiredAuctionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print("🏗️ ExpiredAuctionScreen: Building widget");

    return BlocBuilder<AuctionCubit, AuctionState>(
      builder: (context, state) {
        print("🔄 BlocBuilder: State changed - Status: ${state.status}");

        final cubit = context.read<AuctionCubit>();
        final auctions = cubit.myBiddersData;

        print("📋 Current auctions list:");
        print("   - Length: ${auctions.length}");
        print("   - Is Empty: ${auctions.isEmpty}");
        print("   - State Status: ${state.status}");

        // Show error if state is error
        if (state.status == StateStatus.error) {
          print("❌ Showing error state");
          return const Center(
            child: Text(
              "Something went wrong",
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        // Show loading only if state is loading AND auctions list is not yet fetched (null or empty initially)
        if (state.status == StateStatus.loading && auctions.isEmpty) {
          print("⏳ Showing loading indicator");
          return const Center(child: CircularProgressIndicator());
        }

        if (auctions.isEmpty) {
          print("📭 Showing 'No auctions available' message");
          return const Center(child: Text("No auctions available"));
        }

        // If the list is empty, show "No auctions available"
        if (auctions.isEmpty) {
          print("📭 Showing 'No auctions available' message (duplicate check)");
          return const Center(child: Text("No auctions available"));
        }

        // Otherwise, show the auction list
        print("📊 Rendering auction list with ${auctions.length} items");
        return  ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: auctions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final auction = auctions[index];
            print("🎯 Rendering auction at index $index: ${auction.toString()}");
            return   Container(
              margin: EdgeInsets.all(32.w),
              decoration: BoxDecoration(
                color: AppColors.getFillColor(context),
                border: Border.all(
                    color: context.isDarkMode
                        ? AppColors.LIGHT_COLOR
                        : const Color(0xB20B1035),
                    width: 1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  // Container(
                  //   margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: [
                  //       Expanded(
                  //           child: Row(
                  //         children: [
                  //           SvgPicture.asset(
                  //             Assets.viewsIcon,
                  //             color: context.isDarkMode ? AppColors.LIGHT_COLOR : null,
                  //           ),
                  //           SizedBox(
                  //             width: 10.w,
                  //           ),
                  //           Text(
                  //             '437K views',
                  //             style: TextStyle(
                  //                 color: context.isDarkMode
                  //                     ? AppColors.LIGHT_COLOR
                  //                     : AppColors.black,
                  //                 fontSize: FontSize.s12,
                  //                 fontWeight: FontWeight.w400),
                  //           ),
                  //         ],
                  //       )),
                  //       SizedBox(
                  //         width: 10.w,
                  //       ),
                  //       const Label(
                  //         text: 'Premium',
                  //         style: TextStyle(
                  //             color: AppColors.SECONDARY_COLOR,
                  //             fontSize: FontSize.s16,
                  //             fontWeight: FontWeight.w700),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xfff2f1f7),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: _buildHeader(
                      status: true,
                      views: 10,
                    ),
                  ),
                  Divider(
                    color: context.isDarkMode
                        ? AppColors.LIGHT_COLOR
                        : const Color(0xB20B1035),
                    thickness: 1,
                    height: 0,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: 15.w, vertical: 10.h),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.asset(
                                auctions.gender == 'male'
                                    ? Assets.maleImagePlaceholder
                                    : Assets.femaleImagePlacehlder,
                              ),
                            ),
                            SizedBox(
                              width: 16.w,
                            ),
                            Label(
                              text: "name",
                              style: Styles.headerText(
                                color: context.isDarkMode
                                    ? AppColors.whiteColor
                                    : AppColors.black,
                                fontSize: 36,
                                height: 1.60,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Label(
                            text: "title",
                            style: Styles.mediumText(
                              color: context.isDarkMode
                                  ? AppColors.whiteColor
                                  : AppColors.black,
                              fontSize: 24,
                              height: 1.40,
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Text(
                            "category",
                            style: Styles.mediumText(
                              color: context.isDarkMode
                                  ? AppColors.whiteColor
                                  : AppColors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                              height: 1.60,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: context.isDarkMode
                        ? AppColors.LIGHT_COLOR
                        : AppColors.black.withValues(alpha: 0.7),
                    thickness: 1,
                    height: 0,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 24),
                    child: MarriageCallMessageButtons(
                      otherUserId: "widget.requestLog.userId",
                      subcategoryId: "widget.requestLog.subCategoryId",
                      phone: "widget.requestLog.phone",
                      id: "UserCubit.to.state.data?.id ?? ''",
                      hasReport: true,
                    ),
                  ),
                  /*CallMessageButtons(
            otherUserId: widget.requestLog.userId,
            subcategoryId: widget.requestLog.subCategoryId,
            phone: widget.requestLog.phone,
            id: UserCubit.to.state.data?.id ?? '',
            hasReport: true,
            flex: 1,
          )*/
                ],
              ),
            );
          },
        );


        //   Stack(
        //   children: [
        //     ListView.separated(
        //       padding: const EdgeInsets.all(16),
        //       itemCount: auctions.length,
        //       separatorBuilder: (_, __) => const SizedBox(height: 16),
        //       itemBuilder: (context, index) {
        //         final auction = auctions[index];
        //         print("🎯 Rendering auction at index $index: ${auction.toString()}");
        //         return AuctionCard(auction: auction);
        //       },
        //     ),
        //     PositionedDirectional(
        //       end: 16,
        //       top: MediaQuery.of(context).size.height * 0.50,
        //       child: FloatingActionButton.extended(
        //         onPressed: () {
        //           context.push(Routes.createAuctionScreen);
        //         },
        //         backgroundColor: AppColors.PRIMARY_COLOR,
        //         icon: const Icon(Icons.add, color: Colors.white),
        //         label:  Text(
        //           "${LocaleKeys.addAuction.localize}",
        //           style:Styles.mediumText(
        //               color: Colors.white
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // );
      },
    );
  }
}
*/