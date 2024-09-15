import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/competition/data/models/competion_model.dart';

import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/localization/locales.dart';
import '../../../../../res/style/styles.dart';
import 'donut_chart_painter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildItemListView extends StatelessWidget {
  BuildItemListView({super.key, required this.model, required this.icon});

  final CompetitionData model;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    int count = model.countOfRequest!; // Replace with dynamic value if needed
    int max = model
        .competitionId!.maxRequests!; // Replace with dynamic value if needed

    // List of different icons to be displayed

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              context.locale == Locales.english
                  ? model.competitionId!.nameEn!
                  : model.competitionId!.nameAr!,
              style: Styles.headerText(),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(icon, color: Colors.grey, size: 26),
            ),
          ],
        ),
        SizedBox(
          height: 10.h, // Space between the text and the row
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '${LocaleKeys.count.localize}$count',
                    style: Styles.mediumText(
                        color: Theme.of(context).scaffoldBackgroundColor),
                  ),
                ),
              ),
            ),
            SizedBox(width: 5), // Adjust spacing between containers
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '${LocaleKeys.max.localize}$max',
                    style: Styles.mediumText(
                        color: Theme.of(context).scaffoldBackgroundColor),
                  ),
                ),
              ),
            ),
            SizedBox(width: 20), // Adjust spacing between containers
            CustomPaint(
              size: const Size(20, 20), // Adjust the size as needed
              painter: DonutChartPainter(
                context: context,
                count: count,
                max: max,
              ),
            ),
            SizedBox(width: 20),
          ],
        ),
        SizedBox(
          height: 10.h, // Space between the text and the row
        ),
        Padding(
          padding: EdgeInsets.only(left: 5),
          child: Text(
            context.locale == Locales.english
                ? model.competitionId!.descriptionEn!
                : model.competitionId!.descriptionAr!,
            style: Styles.mediumText(),
          ),
        ),
      ],
    );
  }
}

// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:fourtyninehub/core/extensions/string_extension.dart';
// import 'package:fourtyninehub/features/competition/data/models/competion_model.dart';
//
// import '../../../../../core/localization/locale_keys.g.dart';
// import '../../../../../core/localization/locales.dart';
// import '../../../../../res/style/styles.dart';
// import 'donut_chart_painter.dart';
//
// class BuildItemListView extends StatelessWidget {
//    BuildItemListView({super.key, required this.model});
//
//   final CompetitionData model;
//
//   @override
//   Widget build(BuildContext context) {
//     int count = model.countOfRequest!; // Replace with dynamic value if needed
//     int max = model
//         .competitionId!.maxRequests!; // Replace with dynamic value if needed
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Text(
//               context.locale == Locales.english
//                   ? model.competitionId!.nameEn!
//                   : model.competitionId!.nameAr!,
//               style: Styles.headerText(),
//             ),
//
//              Icon(Icons.ac_unit_sharp)
//           ],
//         ),
//          SizedBox(
//           height: 10.h, // Space between the text and the row
//         ),
//         Row(
//           children: [
//             Expanded(
//               child: Container(
//                 padding:
//                      EdgeInsets.symmetric(vertical: 6.h, horizontal: 20),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).primaryColor,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Center(
//                   child: Text(
//                     '${LocaleKeys.count.localize}$count',
//                     style: Styles.mediumText(
//                         color: Theme.of(context).scaffoldBackgroundColor),
//                   ),
//                 ),
//               ),
//             ),
//              SizedBox(width: 5), // Adjust spacing between containers
//             Expanded(
//               child: Container(
//                 padding:
//                      EdgeInsets.symmetric(vertical: 6.h, horizontal: 20),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).primaryColor,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Center(
//                   child: Text(
//                     '${LocaleKeys.max.localize}$max',
//                     style: Styles.mediumText(
//                         color: Theme.of(context).scaffoldBackgroundColor),
//                   ),
//                 ),
//               ),
//             ),
//              SizedBox(width: 20), // Adjust spacing between containers
//             CustomPaint(
//               size:  Size(20, 20), // Adjust the size as needed
//               painter: DonutChartPainter(
//                 context: context,
//                 count: count,
//                 max: max,
//               ),
//             ),
//              SizedBox(width: 20),
//           ],
//         ),
//          SizedBox(
//           height: 10.h, // Space between the text and the row
//         ),
//         Padding(
//           padding:  EdgeInsets.only(left: 5),
//           child: Text(
//             context.locale == Locales.english
//                 ? model.competitionId!.descriptionEn!
//                 : model.competitionId!.descriptionAr!,
//             style: Styles.mediumText(),
//           ),
//         ),
//       ],
//     );
//   }
// }
