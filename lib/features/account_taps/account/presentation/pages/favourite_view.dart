import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/account_taps/account/domain/entities/favourite_ad_entity.dart';
import 'package:fourtyninehub/features/account_taps/account/presentation/cubit/cubit/favourite_drawer_state.dart';
import 'package:fourtyninehub/features/account_taps/account/presentation/cubit/managers/favourite_ads_cubit.dart';
import 'package:fourtyninehub/features/account_taps/account/presentation/pages/widgets/ad_card_drawer_favourite.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../../../../core/states/basic_state.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../ads_feature/ads/presentation/widgets/ad_card.dart';
import '../cubit/cubit/favourite_drawer_cubit.dart';

class FavouriteView extends StatefulWidget {
  const FavouriteView({super.key});

  @override
  State<FavouriteView> createState() => _FavouriteViewState();
}

class _FavouriteViewState extends State<FavouriteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        label: LocaleKeys.favouriteAds.localize,
      ),
      body: BlocProvider<FavouriteDrawerCubit>(
        create: (BuildContext context) =>serviceLocator()..fetchFavourite(),
        child: BlocBuilder<FavouriteDrawerCubit, FavouriteDrawerState>(
            builder: (context, state) {
          if (state.status ==FavouriteDrawerStates.loading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          return Padding(
            padding: EdgeInsets.all(10.0.w),
            child: ListView.builder(
                itemBuilder: (context, index) => AdCardDrawerFavourite(
                      item: state.favourite![index],
                      onFav: (String) {},
                      onRemoveFav: (String) {},
                    ),
                // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //     childAspectRatio: .8,
                //     mainAxisSpacing: 10,
                //     crossAxisSpacing: 10,
                //     crossAxisCount: 2),
                itemCount: state.favourite?.length ?? 0),
          );
        }),
      ),
    );
  }
}
