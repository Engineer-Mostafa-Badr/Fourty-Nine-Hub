import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/common/widgets/stateful/dynamic/list_view_pagination.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/presentation/widgets/subcategory_card.dart';

import '../cubit/subcategories_cubit.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PaginationView<SubCategoryEntity>(
          build: (ScrollController scrollController,
              List<SubCategoryEntity> data) {
            return GridView.builder(
              itemCount: data.length,
              controller: scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 1),
              itemBuilder: (context, index) => SubCategoryCard(
                mainCategory: widget.mainCategory,
                item: data[index],
              ),
            );
          },
          fetchData: (PaginationParams paginationParams) => context
              .read<SubcategoriesCubit>()
              .getSubcategories(paginationParams: paginationParams),
        ),
      ),
    );
  }
}
