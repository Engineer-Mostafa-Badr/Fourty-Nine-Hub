import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/google_ads_banner.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/dynamic/wallet_widget.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/features/subcategories/presentation/widgets/subcategory_card.dart';

import '../cubit/subcategories_cubit.dart';

class SubCategoriesView extends StatefulWidget {
  final String mainCategoryId;
  const SubCategoriesView({super.key, required this.mainCategoryId});

  @override
  State<SubCategoriesView> createState() => _SubCategoriesViewState();
}

class _SubCategoriesViewState extends State<SubCategoriesView> {
  @override
  void initState() {
    context
        .read<SubcategoriesCubit>()
        .loadData(mainCategoryId: widget.mainCategoryId);
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            const GoogleAddsBanner(
              margin: 0,
            ),
            const Sizer(),
            const WalletWidget(),
            _buildSubCategories(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubCategories() {
    return BlocConsumer<SubcategoriesCubit, SubcategoriesState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          return GridView.builder(
              itemCount: state.subCategories?.length ?? 0,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
              itemBuilder: (context, index) => SubCategoryCard(
                    item: state.subCategories![index],
                  ));
        },
        listener: (context, state) {});
  }
}
