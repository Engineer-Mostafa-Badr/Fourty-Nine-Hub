import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/competition/data/models/competion_model.dart';

import '../../../../../res/style/styles.dart';
import 'donut_chart_painter.dart';

class BuildItemListView extends StatelessWidget {
  const BuildItemListView({super.key, required this.model});
 final CompetitionData model;

  @override
  Widget build(BuildContext context) {
     int count = model.amount!; // Replace with dynamic value if needed
     int max = model.competitionId!.withdrawLimit!;  // Replace with dynamic value if needed
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          model.competitionId!.name!,
          style: Styles.headerText(),
        ),
        const SizedBox(
          height: 15, // Space between the text and the row
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Count: $count',
                    style: Styles.mediumText(color: Theme.of(context).scaffoldBackgroundColor),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5), // Adjust spacing between containers
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Max: $max',
                    style: Styles.mediumText(color: Theme.of(context).scaffoldBackgroundColor),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20), // Adjust spacing between containers
            CustomPaint(
              size: const Size(20, 20), // Adjust the size as needed
              painter: DonutChartPainter(
                context: context,
                count: count,
                max: max,
              ),
            ),
            const SizedBox(width: 15),
          ],
        ),
      ],
    );
  }
}
