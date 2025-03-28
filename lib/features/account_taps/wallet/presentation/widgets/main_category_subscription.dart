import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/main_category_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_dropdown.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class MainCategorySubscription extends StatefulWidget {
  const MainCategorySubscription(
      {super.key, required this.mainCategories, required this.onItemClick});

  final List<MainCategoryWalletEntity> mainCategories;
  final Function(MainCategoryWalletEntity item) onItemClick;

  @override
  State<MainCategorySubscription> createState() =>
      _MainCategorySubscriptionState();
}

class _MainCategorySubscriptionState extends State<MainCategorySubscription> {
  MainCategoryWalletEntity? selectedItem;
  @override
  Widget build(BuildContext context) {
    return CustomDropdown<MainCategoryWalletEntity>(
      items: widget.mainCategories,
      displayStringForItem: (item) =>
          context.isArabic ? item.nameAr : item.nameEn,
      onItemSelected: (value) {
        widget.onItemClick(value);
      },
      selectedItem: selectedItem,
      // selectedItem: ,
      itemBuilder: (item) => ListTile(
        title: Text(
          context.isArabic ? item.nameAr : item.nameEn,
          style: Styles.headerText(),
        ),
      ),
      dropdownDecoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black, width: 2),
      ),
      hint: LocaleKeys.selectCategory.localize,
    );
  }
}
