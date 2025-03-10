import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/main_category_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_dropdown.dart';

class MainCategorySubscription extends StatelessWidget {
  const MainCategorySubscription(
      {super.key, required this.mainCategories, required this.onItemClick});

  final List<MainCategoryWalletEntity> mainCategories;
  final Function(MainCategoryWalletEntity item) onItemClick;

  @override
  Widget build(BuildContext context) {
    return CustomDropdown(
      items: mainCategories,
      onItemSelected: (value) {
        onItemClick(value);
      },
    );
  }
}
