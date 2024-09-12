import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/common/widgets/stateful/dynamic/pagination_view.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_uikit/src/components/screen_util/core/size_extension.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
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
      appBar: BackAppBar(
        label: widget.mainCategory.name,
        centerTitle: false,
      ),
      body: BlocBuilder<SubcategoriesCubit,SubcategoriesState>(
        builder: (context,state) {
          final controller = context.read<SubcategoriesCubit>();
          return Padding(
            padding: EdgeInsets.all(16.0.zW),
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
                    item: data[index], onFav: () async{
                      var result = await controller.toggleSubCategoryToFavorites(data[index].id);
                      return result;
                    },
                  ),
                );
              },
              fetchData: (PaginationParams paginationParams) => context
                  .read<SubcategoriesCubit>()
                  .getSubcategories(paginationParams: paginationParams),
            ),
          );
        }
      ),
    );
  }
}
