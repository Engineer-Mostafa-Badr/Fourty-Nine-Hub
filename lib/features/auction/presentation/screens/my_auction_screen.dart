// AVAILABLE TAB
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/auction/presentation/screens/widgets/auction_card.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enums/base_status_enum.dart';
import '../../../../core/widget/custom_circular_progress_indicator.dart';
import '../../../../core/widget/olx_pagination/banner.dart';
import '../../../../core/widget/olx_pagination/olx_pagination_widget.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';
import '../cubit/auction_cubit.dart';
import 'create_auction_screen.dart';
class MyAuctionScreen extends StatefulWidget {
  const MyAuctionScreen({super.key});

  @override
  State<MyAuctionScreen> createState() => _MyAuctionScreenState();
}
class _MyAuctionScreenState extends State<MyAuctionScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();


  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _addAuction() async {
    final result = await context.push(Routes.createAuctionScreen);
    if (result == true) {
      context.read<AuctionCubit>().loadInitialMyAuction();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuctionCubit, AuctionState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == StateStatus.error) {
          final errorMessage =
              getFailureMessage(state.failure!, context) ?? "Something went wrong";
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<AuctionCubit>();
        final auctions = cubit.myAuctionNonSocketData;

        if (state.status == StateStatus.loading && auctions.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (auctions.isEmpty) {
          return const Center(child: Text("No auctions my"));
        }

        return Stack(
          children: [
            OlxPaginationWidget(
              itemsPerPage: 3,
              scrollController: _scrollController,
              banners: bannersList, // 👉 add banner list if needed
              loadPage: (page) {
                return context.read<AuctionCubit>().getMyAuction();
              },

              items: List.generate(
                auctions.length,
                    (index) {
                  final auction = auctions[index];
                  return AuctionCard(auction: auction,);
                },
              ),
            ),
            // ListView.separated(
            //   controller: _scrollController, // ✅ attach controller
            //   padding: const EdgeInsets.all(16),
            //   // ✅ add +1 to show loader at bottom if more pages available
            //   itemCount: auctions.length + (cubit.hasMoreMyAuction ? 1 : 0),
            //   separatorBuilder: (_, __) => const SizedBox(height: 16),
            //   itemBuilder: (context, index) {
            //     if (index < auctions.length) {
            //       final auction = auctions[index];
            //       return AuctionCard(auction: auction);
            //     } else {
            //       // ✅ loader at bottom while fetching more
            //       return const Center(
            //         child: Padding(
            //           padding: EdgeInsets.all(16),
            //           child: CircularProgressIndicator(),
            //         ),
            //       );
            //     }
            //   },
            // ),
            PositionedDirectional(
              end: 16,
              top: MediaQuery.of(context).size.height * 0.50,
              child: FloatingActionButton.extended(
                onPressed: () => _addAuction(),
                backgroundColor: AppColors.PRIMARY_COLOR,
                icon: const Icon(Icons.add, color: Colors.white),
                label: Text(
                  "${LocaleKeys.addAuction.localize}",
                  style: Styles.mediumText(color: Colors.white),
                ),
              ),
            ),
          ],
        );

      },
    );
  }
}

// class _MyAuctionScreenState extends State<MyAuctionScreen> {
//   final ScrollController _myAuctionScrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     // Trigger initial load when screen opens
//     context.read<AuctionCubit>().loadInitialMyAuction();
//   }
//
//   @override
//   void dispose() {
//     _myAuctionScrollController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _addAuction() async {
//     final result = await context.push(Routes.createAuctionScreen);
//     if (result == true) {
//       context.read<AuctionCubit>().loadInitialMyAuction();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<AuctionCubit, AuctionState>(
//       listenWhen: (prev, curr) => prev.status != curr.status,
//       listener: (context, state) {
//         if (state.status == StateStatus.error) {
//           final errorMessage =
//               getFailureMessage(state.failure!, context) ??
//                   "Something went wrong";
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(errorMessage),
//               backgroundColor: Colors.red,
//               behavior: SnackBarBehavior.floating,
//             ),
//           );
//         }
//       },
//       builder: (context, state) {
//         final cubit = context.read<AuctionCubit>();
//         final auctions = cubit.myAuctionNonSocketData;
//
//         Widget body;
//
//         if (cubit.isAuctionMyAuction) {
//           body = const Center(child: CustomCircularProgressIndicator());
//         } else if (!cubit.isAuctionMyAuction && auctions.isEmpty) {
//           body = Center(
//             child: Text(
//                'No Auctions',
//
//             ),
//           );
//         } else if (auctions.isNotEmpty) {
//           body = OlxPaginationWidget(
//             itemsPerPage: cubit.auctionPageSize,
//             scrollController: _myAuctionScrollController,
//             banners: [],
//             loadPage: (page) {
//               return context.read<AuctionCubit>().getMyAuction();
//             },
//             items: List.generate(
//               auctions.length,
//                   (index) {
//                 final auction = auctions[index];
//                 return AuctionCard(auction: auction);
//               },
//             ),
//           );
//         } else {
//           body = const Center(child: Text("Something went wrong"));
//         }
//
//         return Scaffold(
//           body: body,
//           floatingActionButton: FloatingActionButton.extended(
//             onPressed: _addAuction,
//             backgroundColor: AppColors.PRIMARY_COLOR,
//             icon: const Icon(Icons.add, color: Colors.white),
//             label: Text(
//               LocaleKeys.addAuction.localize,
//               style: Styles.mediumText(color: Colors.white),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
/*
class MyAuctionScreen extends StatefulWidget {
  const MyAuctionScreen({super.key});

  @override
  State<MyAuctionScreen> createState() => _MyAuctionScreenState();
}

class _MyAuctionScreenState extends State<MyAuctionScreen> {
  Future<void> _addAuction() async {
    final result = await context.push(Routes.createAuctionScreen);
    if (result == true) {
      context.read<AuctionCubit>().loadInitialMyAuction();
    }
  }

  @override
  Widget build(BuildContext context) {
    print("🏗️ MyAuctionScreen: Building widget");

    return BlocConsumer<AuctionCubit, AuctionState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == StateStatus.error) {
          final errorMessage = getFailureMessage(state.failure!, context) ?? "Something went wrong";
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        print("🔄 BlocBuilder: State changed - Status: ${state.status}");

        final cubit = context.read<AuctionCubit>();
        final auctions = cubit.myAuctionNonSocketData;

        print("📋 Current auctions list:");
        print("   - Length: ${auctions.length}");
        print("   - Is Empty: ${auctions.isEmpty}");
        print("   - State Status: ${state.status}");

        // Show loading only if state is loading AND auctions list is empty
        if (state.status == StateStatus.loading && auctions.isEmpty) {
          print("⏳ Showing loading indicator");
          return const Center(child: CircularProgressIndicator());
        }

        if (auctions.isEmpty) {
          print("📭 Showing 'No auctions my' message");
          return const Center(child: Text("No auctions my"));
        }

        // Otherwise, show the auction list
        print("📊 Rendering auction list with ${auctions.length} items");
        return Stack(
          children: [
            ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: auctions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final auction = auctions[index];
                print("🎯 Rendering auction at index $index: ${auction.toString()}");
                return AuctionCard(auction: auction);
              },
            ),
            PositionedDirectional(
              end: 16,
              top: MediaQuery.of(context).size.height * 0.50,
              child: FloatingActionButton.extended(
                onPressed: ()=> _addAuction(),
                // onPressed: () {
                //   context.push(Routes.createAuctionScreen);
                // },
                backgroundColor: AppColors.PRIMARY_COLOR,
                icon: const Icon(Icons.add, color: Colors.white),
                label: Text(
                  "${LocaleKeys.addAuction.localize}",
                  style: Styles.mediumText(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

*/