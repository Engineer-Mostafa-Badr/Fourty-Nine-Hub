import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/features/account_taps/account/domain/entities/favourite_subcategory_entity.dart';
import 'package:fourtyninehub/features/account_taps/account/presentation/cubit/managers/favourite_subcategories_cubit.dart';
import '../../../../../core/states/basic_state.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../subcategories/presentation/widgets/subcategory_card.dart';

class FavouriteSubCategoryView extends StatefulWidget {
  const FavouriteSubCategoryView({super.key});

  @override
  State<FavouriteSubCategoryView> createState() =>
      _FavouriteSubCategoryViewState();
}

class _FavouriteSubCategoryViewState extends State<FavouriteSubCategoryView> {
  @override
  Widget build(BuildContext context) {
    final controller = context.read<FavouriteSubCategoryCubit>();

    return Scaffold(
      appBar: const BackAppBar(
        label: Labels.favouriteSubcategories,
      ),
      body: BlocBuilder<FavouriteSubCategoryCubit,
              BasicState<List<FavouriteSubcategoryEntity>>>(
          builder: (context, state) {
        if (state.isLoading) {
          return const CircularProgressIndicator.adaptive();
        }
        return RefreshIndicator(
          onRefresh: () async => controller.loadData(),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView.builder(
                itemCount: state.data?.length ?? 0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                itemBuilder: (context, index) => SubCategoryCard(
                      item: state.data![index].item,
                    )),
          ),
        );
      }),
    );
  }
}
