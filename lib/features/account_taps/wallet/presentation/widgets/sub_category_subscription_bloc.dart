import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/localization/locales.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/fetch_sub_category_wallet/fetch_sub_category_wallet_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/main_category_subscription.dart';

class SubCategorySubscriptionBloc extends StatelessWidget {
  const SubCategorySubscriptionBloc({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchSubCategoryWalletCubit,
        FetchSubCategoryWalletState>(
      builder: (context, state) {
        if (state is FetchSubCategoryWalletLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is FetchSubCategoryWalletSuccess) {
          return MainCategorySubscription(
            mainCategories: state.subCategory,
            onItemClick: (item) {
              context.read<FetchSubCategoryWalletCubit>().showSubscriptionPlans(
                    name: context.locale == Locales.english
                        ? item.nameEn
                        : item.nameAr,
                    id: item.id,
                  );
            },
          );
        } else if (state is FetchSubCategoryWalletError) {
          return Center(
            child: Text(
              LocaleKeys.somethingWentWrong.localize,
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
