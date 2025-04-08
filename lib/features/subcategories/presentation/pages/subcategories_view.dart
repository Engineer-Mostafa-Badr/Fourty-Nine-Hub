import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/common/widgets/stateful/dynamic/pagination_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/categorization_entity.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/presentation/widgets/subcategory_card.dart';

import '../../../../common/widgets/stateless/images/square_image.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/widget/custom_scaffold.dart';
import '../../../../res/style/styles.dart';
import '../cubit/subcategories_cubit.dart';
import '../widgets/floating_add_button.dart';

class SubCategoriesView extends StatefulWidget {
  final MainCategoryEntity mainCategory;

  const SubCategoriesView({super.key, required this.mainCategory});

  @override
  State<SubCategoriesView> createState() => _SubCategoriesViewState();
}

class _SubCategoriesViewState extends State<SubCategoriesView> {
  @override
  late ScrollController scrollController;
  bool isFloatingButtonVisible = true;


  void initState() {
    context
        .read<SubcategoriesCubit>()
        .init(mainCategoryId: widget.mainCategory.id);
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
        await context.read<SubcategoriesCubit>().getSubcategories(
              paginationParams: PaginationParams(page: 1, limit: 200),
            );
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
        color: Colors.white,
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
                              context.push(Routes.LOGIN);
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
      backgroundColor: Theme.of(context).primaryColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: BackAppBar(
          label: widget.mainCategory.name,
          textColor: Colors.white,
          iconColor: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(50.r),
            ),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: BlocBuilder<SubcategoriesCubit, SubcategoriesState>(
              builder: (context, state) {
            final controller = context.read<SubcategoriesCubit>();
            return PaginationView<SubCategoryEntity>(
              build: (ScrollController scrollController,
                  List<SubCategoryEntity> data) {
                print("data.length${data.length}");
                return GridView.builder(
                  padding: EdgeInsets.all(24.w),
                  itemCount: data.length,
                  controller: this.scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                  .getSubcategories(
                      paginationParams: PaginationParams(limit: 200, page: 1)),
            );
          }),
        ),
      ),
      floatingActionButton: isFloatingButtonVisible
          ? buildFloatingAction(context, () {
              _showDropdownMenu(context);
            })
          : null,
    );
  }
}
