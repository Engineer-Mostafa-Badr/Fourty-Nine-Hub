// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fourtyninehub/core/extensions/context_extension.dart';
// import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/categorization_entity.dart';
// import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
// import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
// import 'package:fourtyninehub/features/subcategories/presentation/widgets/subcategory_card.dart';
// import 'package:fourtyninehub/routes/routes.dart';
// import 'package:go_router/go_router.dart';
//
// import '../../../../common/widgets/stateful/banners/back_appbar.dart';
// import '../../../../common/widgets/stateless/labels/label.dart';
// import '../../../../core/widget/custom_scaffold.dart';
// import '../../../../res/style/styles.dart';
// import '../cubit/subcategories_cubit.dart';
// import '../widgets/floating_add_button.dart';
//
// class CustomPageSubCategoriesView extends StatefulWidget {
//   final MainCategoryEntity mainCategory;
//
//   const CustomPageSubCategoriesView({super.key, required this.mainCategory});
//
//   @override
//   State<CustomPageSubCategoriesView> createState() =>
//       _CustomPageSubCategoriesViewState();
// }
//
// class _CustomPageSubCategoriesViewState
//     extends State<CustomPageSubCategoriesView> {
//   late ScrollController scrollController;
//   bool isFloatingButtonVisible = true;
//
//   @override
//   void initState() {
//     print('widget.mainCategory.id ${widget.mainCategory.id}');
//     context
//         .read<SubcategoriesCubit>()
//         .init(mainCategoryId: widget.mainCategory.id);
//     context
//         .read<SubcategoriesCubit>()
//         .init(mainCategoryId: widget.mainCategory.id);
//     // context
//     //     .read<SubcategoriesCubit>()
//     //     .getCustomPageSubcategories(widget.mainCategory.id);
//
//     _fetchSubcategories();
//     scrollController = ScrollController();
//     scrollController.addListener(() {
//       if (scrollController.position.userScrollDirection ==
//           ScrollDirection.reverse) {
//         isFloatingButtonVisible = false;
//       } else {
//         isFloatingButtonVisible = true;
//       }
//       setState(() {});
//     });
//     super.initState();
//   }
//
//   List<SubCategoryEntity> customPageSubCategories = [];
//   String? selectedValue;
//
//   void _fetchSubcategories() async {
//     print('mainCategory.id ${widget.mainCategory.id}');
//     final customPageSubCategoriesList = await context
//         .read<SubcategoriesCubit>()
//         .getCustomPageSubcategories();
//     setState(() {
//       customPageSubCategories = customPageSubCategoriesList;
//     });
//   }
//
//   void _showDropdownMenu(BuildContext context,
//       List<SubCategoryEntity> customPageSubCategories) async {
//     if (customPageSubCategories.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('No subcategories available')),
//       );
//       return;
//     }
//     final RenderBox overlay =
//         Overlay.of(context).context.findRenderObject() as RenderBox;
//     final double bottomPadding =
//         MediaQuery.of(context).viewInsets.bottom + 200.0;
//
//     final RelativeRect position = RelativeRect.fromLTRB(
//       overlay.size.width - 300,
//       overlay.size.height - 300,
//       50,
//       bottomPadding,
//     );
//
//     final String? selected = await showMenu<String>(
//         color: Colors.white,
//         menuPadding: EdgeInsets.zero,
//         shadowColor: Colors.grey.shade300,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         context: context,
//         position: position,
//         items: [
//           PopupMenuItem<String>(
//             child: ConstrainedBox(
//               constraints: const BoxConstraints(
//                 maxHeight: 600,
//               ),
//               child: SingleChildScrollView(
//                 child: Column(
//                   children:
//                       customPageSubCategories.map((SubCategoryEntity item) {
//                     return Column(
//                       children: [
//                         ListTile(
//                           contentPadding: const EdgeInsets.all(0),
//                           dense: true,
//                           title: Label(
//                               text:
//                                   context.isArabic ? item.nameAr : item.nameEn,
//                               style: Styles.mediumText(
//                                   fontWeight: FontWeight.bold)),
//                           onTap: () {
//                             if (context.isUserLoggedIn) {
//                               Navigator.pop(context);
//                               context.push(Routes.CREATEAD,
//                                   extra: CategorizationEntity(
//                                       mainCategory: widget.mainCategory,
//                                       subCategory: item));
//                             } else {
//                               context.push(Routes.LOGIN);
//                             }
//                           },
//                         ),
//                         Divider(
//                           height: 1,
//                           thickness: 1,
//                           color: Colors.grey.shade300,
//                         )
//                       ],
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),
//           ),
//         ]);
//
//     if (selected != null) {
//       setState(() {
//         selectedValue = selected;
//       });
//     }
//     print(selectedValue.toString());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomScaffold(
//       backgroundColor: Theme.of(context).primaryColor,
//       appBar: BackAppBar(
//         label: widget.mainCategory.name,
//         textColor: Colors.white,
//         iconColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(top: 8.0),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Theme.of(context).scaffoldBackgroundColor,
//             borderRadius: BorderRadius.vertical(
//               top: Radius.circular(50.r),
//             ),
//           ),
//           clipBehavior: Clip.antiAliasWithSaveLayer,
//           child: BlocConsumer<SubcategoriesCubit, SubcategoriesState>(
//             listener: (context, state) {
//               if (state.status == SubcategoriesStates.error) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('state.failure!.message')),
//                 );
//               }
//               if (state.status == SubcategoriesStates.loading) {
//                 _fetchSubcategories();
//               }
//             },
//               builder: (context, state) {
//               if (state.status == SubcategoriesStates.loading) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//               if (state.status == SubcategoriesStates.error) {
//                 return Center(child: Text('state.failure!.message'));
//               }
//             final cubit = context.read<SubcategoriesCubit>();
//             print("cu``bit ${cubit.state.customPageSubCategories!.length}");
//             final controller = context.read<SubcategoriesCubit>();
//             return GridView.builder(
//               padding: EdgeInsets.all(24.w),
//               itemCount: state.customPageSubCategories?.length ?? 2,
//               controller: scrollController,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3,
//                 childAspectRatio: .65,
//                 mainAxisSpacing: 16,
//                 crossAxisSpacing: 16,
//               ),
//               itemBuilder: (context, index) => SubCategoryCard(
//                 mainCategory: widget.mainCategory,
//                 item: state.customPageSubCategories![index],
//                 onFav: () async {
//                   var result = await controller.toggleSubCategoryToFavorites(
//                       state.customPageSubCategories![index].id);
//                   return result;
//                 },
//               ),
//             );
//           }),
//         ),
//       ),
//       floatingActionButton: isFloatingButtonVisible
//           ? buildFloatingAction(context, () {
//               // _showDropdownMenu(context);
//             })
//           : null,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/common/widgets/stateful/dynamic/pagination_view.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/categorization_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/presentation/widgets/subcategory_card.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/widget/custom_notification_badge.dart';
import '../../../../core/widget/custom_scaffold.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../ads_feature/ads/presentation/widgets/header_button_widget.dart';
import '../cubit/subcategories_cubit.dart';
import '../widgets/floating_add_button.dart';
import 'package:fourtyninehub/common/widgets/dialogs/please_login_dialog.dart';

class CustomPageSubCategoriesView extends StatefulWidget {
  final MainCategoryEntity mainCategory;

  const CustomPageSubCategoriesView({super.key, required this.mainCategory});

  @override
  State<CustomPageSubCategoriesView> createState() =>
      _CustomPageSubCategoriesViewState();
}

class _CustomPageSubCategoriesViewState
    extends State<CustomPageSubCategoriesView> {
  late ScrollController scrollController;
  bool isFloatingButtonVisible = true;

  @override
  void initState() {
    print('widget.mainCategory.id ${widget.mainCategory.id}');
    // context
    //     .read<SubcategoriesCubit>()
    //     .init(mainCategoryId: widget.mainCategory.id);
    context
        .read<SubcategoriesCubit>()
        .init(mainCategoryId: widget.mainCategory.id);
    _fetchSubcategories();
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        isFloatingButtonVisible = false;
      } else {
        isFloatingButtonVisible = true;
      }
      setState(() {});
    });
    super.initState();
  }

  List<SubCategoryEntity> subCategories = [];
  String? selectedValue;

  void _fetchSubcategories() async {
    final subCategoriesList =
        await context.read<SubcategoriesCubit>().getCustomPageSubcategories();
    setState(() {
      subCategories = subCategoriesList;
    });
  }

  void _showDropdownMenu(BuildContext context) async {
    if (subCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No subcategories available')),
      );
      return;
    }
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final double bottomPadding =
        MediaQuery.of(context).viewInsets.bottom + 200.0;

    final RelativeRect position = RelativeRect.fromLTRB(
      overlay.size.width - 300,
      overlay.size.height - 300,
      50,
      bottomPadding,
    );

    final String? selected = await showMenu<String>(
        color: context.isDarkMode ? AppColors.QUANTITY_COLOR : Colors.white,
        menuPadding: EdgeInsets.zero,
        shadowColor: Colors.grey.shade300,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        context: context,
        position: position,
        items: [
          PopupMenuItem<String>(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 600,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: subCategories.map((SubCategoryEntity item) {
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          dense: true,
                          title: Label(
                              text:
                                  context.isArabic ? item.nameAr : item.nameEn,
                              style: Styles.mediumText(
                                  fontWeight: FontWeight.bold)),
                          onTap: () {
                            if (context.isUserLoggedIn) {
                              Navigator.pop(context);
                              context.push(Routes.CREATEAD,
                                  extra: CategorizationEntity(
                                      mainCategory: widget.mainCategory,
                                      subCategory: item));
                            } else {
                              return pleaseLoginDialog(context);

                              // context.push(Routes.LOGIN);
                            }
                          },
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey.shade300,
                        )
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ]);

    if (selected != null) {
      setState(() {
        selectedValue = selected;
      });
    }
    print(selectedValue.toString());
  }

  // void _showDropdownMenu(BuildContext context) async {
  //   if (subCategories.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('No subcategories available')),
  //     );
  //     return;
  //   }
  //   final RenderBox button = context.findRenderObject() as RenderBox;
  //   final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
  //   final RelativeRect position = RelativeRect.fromLTRB(
  //     overlay.size.width - 20,
  //     overlay.size.height - 250,
  //     200,
  //     100,
  //   );
  //
  //   final String? selected = await showMenu<String>(
  //     color: Colors.white,
  //     menuPadding: const EdgeInsets.all(10),
  //      shadowColor: Colors.grey.shade300,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //     context: context,
  //     position: position,
  //     items: subCategories.map((SubCategoryEntity item) {
  //       return PopupMenuItem<String>(
  //         value: item.id,
  //         child: Row(
  //           children: [
  //             Label(text: item.nameAr  ?? '', style: Styles.mediumText())
  //
  //           ],
  //         ),
  //       );
  //     }).toList(),
  //   );
  //
  //   if (selected != null) {
  //     setState(() {
  //       selectedValue = selected;
  //     });
  //   }
  //   print(selectedValue.toString());
  // }
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      enableCustomAppBar: true,
      appBar: BackAppBar(
        label: widget.mainCategory.name,
        textColor: Colors.white,
        iconColor: Colors.white,
        enableCustomAppBar: true,
      ),
      body: BlocBuilder<SubcategoriesCubit, SubcategoriesState>(
          builder: (context, state) {
        final controller = context.read<SubcategoriesCubit>();

        return Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: context.isDarkMode
                        ? Colors.white
                        : AppColors.PRIMARY_COLOR,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: CustomNotificationBadge(
                      count: 0,
                      child: HeaderButtonWidget(
                        title: LocaleKeys.favouriteAds.localize,
                        isOpened: context
                            .read<SubcategoriesCubit>()
                            .isFavouriteAdsOpen,
                        onPressed: () {
                          context
                              .read<SubcategoriesCubit>()
                              .getRequestsLog(widget.mainCategory.id);

                          context
                              .read<SubcategoriesCubit>()
                              .toggleMyAds('isFavouriteAdsOpen');
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: CustomNotificationBadge(
                      count: 0,
                      child: HeaderButtonWidget(
                        title: LocaleKeys.requestLog.localize,
                        isOpened:
                            context.read<SubcategoriesCubit>().isRequestLogOpen,
                        onPressed: () {
                          context
                              .read<SubcategoriesCubit>()
                              .getRequestsLog(widget.mainCategory.id);
                          context
                              .read<SubcategoriesCubit>()
                              .toggleMyAds('isRequestLogOpen');

                          // context.read<SubcategoriesCubit>().toggleRequestLog();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: HeaderButtonWidget(
                      title: LocaleKeys.myAds.localize,
                      isOpened: context.read<SubcategoriesCubit>().isMyAdsOpen,
                      onPressed: () {
                        // TODO: EDIT THIS
                        context.read<SubcategoriesCubit>().getMarriageMyAds(widget.mainCategory.id);
                        context
                            .read<SubcategoriesCubit>()
                            .toggleMyAds('isMyAdsOpen');
                        // context.push(Routes.MYADDS);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            if (controller.isFavouriteAdsOpen) Container(),
            if (controller.isRequestLogOpen) Container(),
            if (controller.isMyAdsOpen) Container(),
            if (!controller.isMyAdsOpen &&
                !controller.isFavouriteAdsOpen &&
                !controller.isRequestLogOpen)
              Expanded(
                child: PaginationView<SubCategoryEntity>(
                  build: (ScrollController scrollController,
                      List<SubCategoryEntity> data) {
                    print("data.length${data.length}");
                    return GridView.builder(
                      padding: EdgeInsets.all(24.w),
                      itemCount: data.length,
                      controller: this.scrollController,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: .65,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                      ),
                      itemBuilder: (context, index) => SubCategoryCard(
                        mainCategory: widget.mainCategory,
                        item: data[index],
                        onFav: () async {
                          var result = await controller
                              .toggleSubCategoryToFavorites(data[index].id);
                          return result;
                        },
                      ),
                    );
                  },
                  fetchData: (PaginationParams paginationParams) => context
                      .read<SubcategoriesCubit>()
                      .getCustomPageSubcategories(),
                ),
              ),
          ],
        );
      }),
      floatingActionButton: isFloatingButtonVisible
          ? buildFloatingAction(context, () {
              _showDropdownMenu(context);
            })
          : null,
    );
  }
}
