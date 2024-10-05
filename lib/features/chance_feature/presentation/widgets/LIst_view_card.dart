import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/widgets/chance_card_widget.dart';


class ListViewCard extends StatelessWidget {
  const ListViewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return  ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => const ChanceCardWidget(),
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: 10,
    );
  }
}
