import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/search_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class SearchRestaurantView extends StatelessWidget {
  const SearchRestaurantView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${LocaleKeys.search.tr()} ${LocaleKeys.restaurants.tr()}"),
      ),
      body: BlocBuilder<SearchRestaurantsCubit, SearchRestaurantState>(
        builder: (context, state) {
          if (state.status == SearchRestaurantStates.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.status == SearchRestaurantStates.error) {
            return Center(
              child: Text(
                LocaleKeys.somethingWentWrong.tr(),
                style: Styles.headerText(),
              ),
            );
          } else if (state.status ==
              SearchRestaurantStates.loadingSubCategories) {
            return ListView.builder(
              itemCount: state.mealCategories?.length,
              itemBuilder: (context, index) {
                return Container();
              },
            );
          } else if (state.status ==
              SearchRestaurantStates.loadingGovernorates) {
            return ListView.builder(
              itemCount: state.governorates?.length,
              itemBuilder: (context, index) {
                return Container();
              },
            );
          } else if (state.status == SearchRestaurantStates.loadingCities) {
            return ListView.builder(
              itemCount: state.cities?.length,
              itemBuilder: (context, index) {
                return Container();
              },
            );
          } else if (state.status == SearchRestaurantStates.loadingResult) {
            return ListView.builder(
              itemCount: state.allRestaurant?.length,
              itemBuilder: (context, index) {
                return Container();
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
