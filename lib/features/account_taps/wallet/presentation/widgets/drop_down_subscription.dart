import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/dynamic/list_view_pagination.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/main_category_entity.dart';

import '../../../../../common/models/public/pagination_params.dart';
import '../../../../../core/localization/locales.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../subscripe/presentation/controllers/subscription_controller.dart';
import '../cubit/wallet_cubit.dart';

class DropDownSubscription extends StatefulWidget {
  @override
  _DropDownSubscriptionState createState() => _DropDownSubscriptionState();
}

class _DropDownSubscriptionState extends State<DropDownSubscription> {
  String? selectedCategory;
  String? selectedSubCategory;
  int? selectedIndex; // Track the selected index

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          _showCategoryDialog();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              'Add Subcategory To Subscribe',
              style: TextStyle(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

void _showCategoryDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Select Category"),
        content: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 300.0, // Limits height to show only 4 items
          ),
          child: SizedBox(
            height: 200,
            child: PaginationView<MainCategoryWalletEntity>(
              build: (ScrollController scrollController,
                  List<MainCategoryWalletEntity> data) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: data.isNotEmpty
                        ? data.map((category) {
                      String categoryName =
                      context.locale == Locales.english
                          ? category.nameEn
                          : category.nameAr;
                      return ListTile(
                        title: Text(categoryName),
                        onTap: () {

                          Navigator.pop(
                            context,
                          ); // Close category dialog
                          _showSubCategoryDialog(category.id);
                        },
                      );
                    }).toList()
                        : [const Text("No categories available")],
                  ),
                );
              },
              fetchData: (PaginationParams paginationParams) {
                return context
                    .read<WalletCubit>()
                    .fetchMainCategoryWallet(
                    paginationParams: paginationParams);
              },
            ),
          ),
        ),
      );
    },
  );
}

void _showSubCategoryDialog(String id) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Select Category"),
        content: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 300.0, // Limits height to show only 4 items
          ),
          child: SizedBox(
            height: 200,
            child: PaginationView<MainCategoryWalletEntity>(
              build: (ScrollController scrollController,
                  List<MainCategoryWalletEntity> data) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: data.isNotEmpty
                        ? data.map((category) {
                      String categoryName =
                      context.locale == Locales.english
                          ? category.nameEn
                          : category.nameAr;
                      return ListTile(
                        title: Text(categoryName),
                        onTap: () {

                          Navigator.pop(
                            context,
                          ); // Close category dialog
                          serviceLocator<SubscriptionController>().showSubscriptionPlans(
                          subCategoryId: category.id, wallets: [],);
                        },
                      );
                    }).toList()
                        : [const Text("No categories available")],
                  ),
                );
              },
              fetchData: (PaginationParams paginationParams) {
                return context
                    .read<WalletCubit>()
                    .fetchSubCategoryWallet(
                  id: id,
                    paginationParams: paginationParams);
              },
            ),
          ),
        ),
      );
    },
  );
}


  // serviceLocator<SubscriptionController>().showSubscriptionPlans(
  // subCategoryId: '62c8ba9f8e28a58a3edf57eb', wallets: [],);
// void _showBottomSheet(String subCategory) {
//   showModalBottomSheet(
//     backgroundColor: Theme.of(context).primaryColor,
//     context: context,
//     builder: (BuildContext context) {
//       return StatefulBuilder( // Use StatefulBuilder for dynamic UI updates in bottom sheet
//         builder: (BuildContext context, StateSetter setModalState) {
//           return Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(16),
//             decoration: const BoxDecoration(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(50),
//                 topRight: Radius.circular(50),
//               ),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Label(
//                   text: 'Subscription List',
//                   style: TextStyle(
//                       color: Theme.of(context).scaffoldBackgroundColor,
//                       fontSize: 28),
//                 ),
//                 const SizedBox(height: 10),
//                 Expanded(
//                   child: GridView.builder(
//                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         crossAxisSpacing: 10,
//                         mainAxisSpacing: 10,
//                         childAspectRatio: 1 / 0.22),
//                     itemCount: 10,
//                     itemBuilder: (context, index) => GestureDetector(
//                       onTap: () {
//                         // Use setModalState to update the color in bottom sheet
//                         setModalState(() {
//                           selectedIndex = index;
//                         });
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(vertical: 6),
//                         decoration: BoxDecoration(
//                           color: selectedIndex == index
//                               ? Colors.red // Change to red if selected
//                               : Theme.of(context).scaffoldBackgroundColor, // Default color
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Center(
//                           child: Label(
//                             text: '1000',
//                             color:selectedIndex == index? AppColors.AUTH_CONTAINER_COLOR:Theme.of(context).primaryColor,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(context); // Close the bottom sheet
//                   },
//                   child: const Label(
//                     text: 'Subscribe',
//                     color: AppColors.AUTH_CONTAINER_COLOR,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//     },
//   );
// }
}
