import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/main_category_banner.dart';

import 'package:fourtyninehub/features/account_taps/account/domain/entities/favourite_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import '../../../../../core/states/basic_state.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../fourty_nine/presentation/widgets/main_category_card.dart';
import '../cubit/managers/favourite_categories_cubit.dart';

class FavouriteCategoryView extends StatelessWidget {
  const FavouriteCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<FavouriteCategoryCubit>();
    return Scaffold(
        appBar: const BackAppBar(
          label: Labels.favouriteCategories,
        ),
        body: BlocBuilder<FavouriteCategoryCubit,
                BasicState<List<FavouriteCategoryEntity>>>(
            builder: (context, state) {
          log("kljjjjjjjjjjjjjjjjjjjjjjjjj ${state.data?.length ?? 0}");
          if (state.isLoading) {
            return const CircularProgressIndicator.adaptive();
          }
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: RefreshIndicator(
              onRefresh: () async => controller.loadData(),
              child: ListView.builder(
                itemCount: state.data?.length ?? 0,
                // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //     crossAxisSpacing: 10,
                //     mainAxisSpacing: 10,
                //     crossAxisCount: 2,
                //     childAspectRatio: 2.5),
                itemBuilder: (context, index) {
                  return Container(
                    // ignore: prefer_const_constructors
                    margin: EdgeInsets.only(bottom: 8),
                    child: MainCategoryBanner(
                      category: MainCategoryEntity(
                          id: state.data![index].categoryId?.id ?? "",
                          name: state.data![index].categoryId?.nameEn ?? "",
                          image: state.data![index].categoryId?.banner ?? "",
                          banner: state.data![index].categoryId?.banner ?? "",
                          cover: state.data![index].categoryId?.cover ?? "",
                          isFavorite: true,
                          total: state.data![index].numberOfAds ?? 0
                          // total: 23
                          ),
                    ),
                  );
                },
              ),
            ),
          );
        }));
  }
}
