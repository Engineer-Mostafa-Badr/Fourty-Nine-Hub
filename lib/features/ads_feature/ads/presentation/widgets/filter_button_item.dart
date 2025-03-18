import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/categorization_entity.dart';
import 'package:fourtyninehub/features/subcategories/presentation/cubit/subcategories_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class FilterButtonItem extends StatelessWidget {
  const FilterButtonItem({
    super.key,
    required this.onTap,
    required this.title,
  });

  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return BadgedLabel(
      label: title,
      style: Styles.mediumText(
        color: Colors.white,
        fontSize: 32,
      ),
      height: 42,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // width: 170.h,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      // icon: Icons.filter_alt_rounded,
      iconLeading: Icons.keyboard_arrow_down_rounded,
      onTap: onTap,
    );
  }
}
