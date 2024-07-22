import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/features/account_taps/account/domain/entities/favourite_ad_entity.dart';
import 'package:fourtyninehub/features/account_taps/account/presentation/cubit/managers/favourite_ads_cubit.dart';

import '../../../../../core/states/basic_state.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../ads_feature/ads/presentation/widgets/ad_card.dart';

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
        label: Labels.favouriteAds,
      ),
      body: BlocBuilder<FavouriteAdsCubit, BasicState<List<FavouriteAdEntity>>>(
          builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: GridView.builder(
              itemBuilder: (context, index) => AdCard(
                    item: state.data![index].item,
                  ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: .8,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  crossAxisCount: 2),
              itemCount: state.data?.length ?? 0),
        );
      }),
      
    );
  }
}
