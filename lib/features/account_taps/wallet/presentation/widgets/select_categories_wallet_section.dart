import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/main_category_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/fetch_sub_category_wallet/fetch_sub_category_wallet_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/main_category_subscription.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/sub_category_subscription_bloc.dart';

class SelectCategoriesWalletSection extends StatelessWidget {
  const SelectCategoriesWalletSection({
    super.key,
    required this.mainCategories,
  });

  final List<MainCategoryWalletEntity> mainCategories;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main Category Subscription
        MainCategorySubscription(
          mainCategories: mainCategories,
          onItemClick: (item) {
            context.read<FetchSubCategoryWalletCubit>().fetchSubCategoryWallet(
                  paginationParams: PaginationParams(page: 1),
                  id: item.id,
                );
          },
        ),
        const SizedBox(
          height: 8,
        ),
        // Sub Category Subscription
        const SubCategorySubscriptionBloc(),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
