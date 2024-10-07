import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/widgets/drop_down_widget.dart';


class CreateChanceViewBody extends StatelessWidget {
  const CreateChanceViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropDownChance()
      ],
    );
  }
}
