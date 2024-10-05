import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/widgets/show_model_bottom_sheet_widget.dart';

import '../../../../res/style/app_colors.dart';

class FloatingActionButtonWidget extends StatelessWidget {
  const FloatingActionButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => const ShowModelBottomSheetWidget(),
        );
      },
      backgroundColor: Colors.red,
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}
