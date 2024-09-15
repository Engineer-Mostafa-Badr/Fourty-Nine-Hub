import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateful/dynamic/pagination_view.dart';
import 'package:fourtyninehub/features/account_taps/account/domain/entities/favourite_subcategory_entity.dart';
import 'package:fourtyninehub/features/account_taps/account/presentation/cubit/managers/favourite_subcategories_cubit.dart';
import 'package:fourtyninehub/features/account_taps/account/presentation/pages/widgets/favourite_sub_category_card.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

class FavSubCategoryView extends StatelessWidget {
  const FavSubCategoryView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        label: Labels.favouriteSubcategories,
      ),
      body: BlocBuilder<FavouriteSubCategoryCubit, FavouriteSubCategoryState>(
          builder: (context, state) {
        final controller = context.read<FavouriteSubCategoryCubit>();
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: PaginationView<FavouriteSubcategoryEntity>(
            build: (ScrollController scrollController,
                List<FavouriteSubcategoryEntity> data) {
              return GridView.builder(
                itemCount: data.length,
                controller: scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 1),
                itemBuilder: (context, index) => FavouriteSubCategoryCard(
                  item: data[index],
                  onFav: () async {
                    var result = await controller
                        .toggleSubCategoryToFavorites(data[index].id);
                    if (result == true) {
                      data.removeWhere(
                          (element) => element.id == data[index].id);
                    }
                  },
                ),
              );
            },
            fetchData: (PaginationParams paginationParams) => context
                .read<FavouriteSubCategoryCubit>()
                .getSubcategories(paginationParams: paginationParams),
          ),
        );
      }),
    );
  }
}
