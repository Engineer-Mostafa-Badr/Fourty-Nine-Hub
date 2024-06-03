import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';

import '../../../../res/style/app_colors.dart';

import '../../../ads/presentation/widgets/ad_card.dart';

class FavouriteView extends StatefulWidget {
  const FavouriteView({super.key});

  @override
  State<FavouriteView> createState() => _FavouriteViewState();
}

class _FavouriteViewState extends State<FavouriteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        label: 'Favourite Ads',
        iconColor: Colors.white,
        backColor: AppColors.PRIMARY_COLOR,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
            itemBuilder: (context, index) => const AdCard(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: .8,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                crossAxisCount: 2),
            itemCount: 10),
      ),
    );
  }
}
