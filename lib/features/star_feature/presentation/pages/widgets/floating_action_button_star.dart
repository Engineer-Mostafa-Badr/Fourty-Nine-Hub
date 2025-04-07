import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/star_feature/presentation/pages/widgets/create_star.dart';

import '../../../../../core/localization/locale_keys.g.dart';

class FloatingActionButtonStar extends StatelessWidget {
  const FloatingActionButtonStar({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CreateStar(),
          ),
        );
      },
      backgroundColor: const Color(0xff0B1035),
      icon: Text(
        LocaleKeys.addTalent.localize,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      label: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}
