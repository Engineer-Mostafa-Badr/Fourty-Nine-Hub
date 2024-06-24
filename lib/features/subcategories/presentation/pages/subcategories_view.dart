import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/google_ads_banner.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/dynamic/wallet_widget.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/features/subcategories/presentation/widgets/subcategory_card.dart';

import '../../../../res/style/app_colors.dart';
import '../cubit/subcategories_cubit.dart';

class SubCategoriesView extends StatelessWidget {
  const SubCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        backColor: AppColors.PRIMARY_COLOR,
        iconColor: Colors.white,
        label: 'Ride',
      ),
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
          return GridView.builder(
              itemCount: state.subCategories?.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
              itemBuilder: (context, index) =>  SubCategoryCard(item: state.subCategories![index],));
        },
        listener: (context, state) {});
  }
}
