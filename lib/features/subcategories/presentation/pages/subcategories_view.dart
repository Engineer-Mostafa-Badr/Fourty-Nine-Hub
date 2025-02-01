import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/common/widgets/stateful/dynamic/pagination_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/presentation/widgets/subcategory_card.dart';


import '../../../../common/widgets/stateless/labels/label.dart';
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
  void initState() {
    context
        .read<SubcategoriesCubit>()
        .init(mainCategoryId: widget.mainCategory.id);
    context.read<SubcategoriesCubit>().init(mainCategoryId: widget.mainCategory.id);
    _fetchSubcategories();
    super.initState();
  }

  List<SubCategoryEntity> subCategories = [];
  String? selectedValue;


  void _fetchSubcategories() async {
    final subCategoriesList = await context.read<SubcategoriesCubit>().getSubcategories(
      paginationParams: PaginationParams(page: 1, limit: 60),
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
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final double bottomPadding = MediaQuery.of(context).viewInsets.bottom + 200.0;

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
        items:  [
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
                        ListTile(contentPadding: const EdgeInsets.all(0),
                          dense: true,
                          title: Label(text: item.nameAr ?? '', style: Styles.mediumText(fontWeight: FontWeight.bold)),
                          onTap: () {
                            Navigator.pop(context, item.id);
                          },
                        ),
                        Divider(height: 1,thickness: 1,color: Colors.grey.shade300,)
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ]
    );

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
    return Scaffold(
      appBar: BackAppBar(
        label: widget.mainCategory.name,
        centerTitle: false,
      ),
      body: BlocBuilder<SubcategoriesCubit, SubcategoriesState>(
          builder: (context, state) {
            final controller = context.read<SubcategoriesCubit>();
            return Padding(
              padding: EdgeInsets.all(16.0.w),
              child: PaginationView<SubCategoryEntity>(
                build: (ScrollController scrollController,
                    List<SubCategoryEntity> data) {
                  return GridView.builder(
                    itemCount: data.length,
                    controller: scrollController,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, childAspectRatio: 1),
                    itemBuilder: (context, index) =>
                        SubCategoryCard(
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
                fetchData: (PaginationParams paginationParams) =>
                    context
                        .read<SubcategoriesCubit>()
                        .getSubcategories(paginationParams: paginationParams),
              ),
            );
          }),
      floatingActionButton: buildFloatingAction(context, () {
        _showDropdownMenu(context);
      }),
    );
  }

}
