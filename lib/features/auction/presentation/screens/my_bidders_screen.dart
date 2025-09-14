// AVAILABLE TAB
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/auction/presentation/screens/widgets/auction_card.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enums/base_status_enum.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';
import '../cubit/auction_cubit.dart';
import 'create_auction_screen.dart';

class ExpiredAuctionScreen extends StatelessWidget {
  const ExpiredAuctionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print("🏗️ ExpiredAuctionScreen: Building widget");

    return BlocBuilder<AuctionCubit, AuctionState>(
      builder: (context, state) {
        print("🔄 BlocBuilder: State changed - Status: ${state.status}");

        final cubit = context.read<AuctionCubit>();
        final auctions = cubit.expiredAuctionNonSocketData;

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
        // return  Container(
        //   margin: EdgeInsets.all(32.w),
        //   decoration: BoxDecoration(
        //     color: AppColors.getFillColor(context),
        //     border: Border.all(
        //         color: context.isDarkMode
        //             ? AppColors.LIGHT_COLOR
        //             : const Color(0xB20B1035),
        //         width: 1),
        //     borderRadius: BorderRadius.circular(15),
        //   ),
        //   child: Column(
        //     children: [
        //       // Container(
        //       //   margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h),
        //       //   child: Row(
        //       //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       //     crossAxisAlignment: CrossAxisAlignment.center,
        //       //     children: [
        //       //       Expanded(
        //       //           child: Row(
        //       //         children: [
        //       //           SvgPicture.asset(
        //       //             Assets.viewsIcon,
        //       //             color: context.isDarkMode ? AppColors.LIGHT_COLOR : null,
        //       //           ),
        //       //           SizedBox(
        //       //             width: 10.w,
        //       //           ),
        //       //           Text(
        //       //             '437K views',
        //       //             style: TextStyle(
        //       //                 color: context.isDarkMode
        //       //                     ? AppColors.LIGHT_COLOR
        //       //                     : AppColors.black,
        //       //                 fontSize: FontSize.s12,
        //       //                 fontWeight: FontWeight.w400),
        //       //           ),
        //       //         ],
        //       //       )),
        //       //       SizedBox(
        //       //         width: 10.w,
        //       //       ),
        //       //       const Label(
        //       //         text: 'Premium',
        //       //         style: TextStyle(
        //       //             color: AppColors.SECONDARY_COLOR,
        //       //             fontSize: FontSize.s16,
        //       //             fontWeight: FontWeight.w700),
        //       //       ),
        //       //     ],
        //       //   ),
        //       // ),
        //       Container(
        //         decoration: const BoxDecoration(
        //           color: Color(0xfff2f1f7),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(15),
        //             topRight: Radius.circular(15),
        //           ),
        //         ),
        //         child: _buildHeader(
        //           status: true,
        //           views: 10,
        //         ),
        //       ),
        //       Divider(
        //         color: context.isDarkMode
        //             ? AppColors.LIGHT_COLOR
        //             : const Color(0xB20B1035),
        //         thickness: 1,
        //         height: 0,
        //       ),
        //       Container(
        //         margin: EdgeInsets.symmetric(
        //             horizontal: 15.w, vertical: 10.h),
        //         child: Column(
        //           children: [
        //             Row(
        //               children: [
        //                 Container(
        //                   height: 40,
        //                   width: 40,
        //                   decoration: BoxDecoration(
        //                     shape: BoxShape.circle,
        //                   ),
        //                   clipBehavior: Clip.antiAlias,
        //                   child: Image.asset(
        //                     // widget.requestLog.gender == 'male'
        //                     //     ? Assets.maleImagePlaceholder
        //                     //     :
        //                     Assets.femaleImagePlacehlder,
        //                   ),
        //                 ),
        //                 SizedBox(
        //                   width: 16.w,
        //                 ),
        //                 Label(
        //                   text: "name",
        //                   style: Styles.headerText(
        //                     color: context.isDarkMode
        //                         ? AppColors.whiteColor
        //                         : AppColors.black,
        //                     fontSize: 36,
        //                     height: 1.60,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //             SizedBox(
        //               height: 16,
        //             ),
        //             Align(
        //               alignment: AlignmentDirectional.centerStart,
        //               child: Label(
        //                 text: "title",
        //                 style: Styles.mediumText(
        //                   color: context.isDarkMode
        //                       ? AppColors.whiteColor
        //                       : AppColors.black,
        //                   fontSize: 24,
        //                   height: 1.40,
        //                 ),
        //               ),
        //             ),
        //             Align(
        //               alignment: AlignmentDirectional.centerEnd,
        //               child: Text(
        //                 "category",
        //                 style: Styles.mediumText(
        //                   color: context.isDarkMode
        //                       ? AppColors.whiteColor
        //                       : AppColors.black,
        //                   fontWeight: FontWeight.w600,
        //                   fontSize: 24,
        //                   height: 1.60,
        //                 ),
        //               ),
        //             )
        //           ],
        //         ),
        //       ),
        //       Divider(
        //         color: context.isDarkMode
        //             ? AppColors.LIGHT_COLOR
        //             : AppColors.black.withValues(alpha: 0.7),
        //         thickness: 1,
        //         height: 0,
        //       ),
        //
        //       Padding(
        //         padding: const EdgeInsets.symmetric(
        //             vertical: 12.0, horizontal: 24),
        //         child: MarriageCallMessageButtons(
        //           otherUserId: "widget.requestLog.userId",
        //           subcategoryId: "widget.requestLog.subCategoryId",
        //           phone: "widget.requestLog.phone",
        //           id: "UserCubit.to.state.data?.id ?? ''",
        //           hasReport: true,
        //         ),
        //       ),
        //       /*CallMessageButtons(
        //     otherUserId: widget.requestLog.userId,
        //     subcategoryId: widget.requestLog.subCategoryId,
        //     phone: widget.requestLog.phone,
        //     id: UserCubit.to.state.data?.id ?? '',
        //     hasReport: true,
        //     flex: 1,
        //   )*/
        //     ],
        //   ),
        // );
        return Text("");
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
