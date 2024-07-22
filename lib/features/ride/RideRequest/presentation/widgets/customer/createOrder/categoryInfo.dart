// import 'package:flutter/material.dart';
// import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
// import '../../../../../../../common/widgets/stateless/labels/label.dart';
// import '../../../../../../../res/style/styles.dart';

// import 'package:go_router/go_router.dart';


// import '../../../../../../../common/widgets/dynamic/sizer.dart';

// class CategoryInfoWidget extends StatelessWidget {
//   final SubCategoryEntity item;
//   const CategoryInfoWidget({super.key, required this.item});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(10),
//       decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//               topRight: Radius.circular(15), topLeft: Radius.circular(15))),
//       child: ListView(
//         shrinkWrap: true,
//         children: [
//           Image.network(
//             item.picture,
//             height: kToolbarHeight,
//           ),
//           Label(
//             text: item.name,
//             style: Styles.mediumText(fontSize: 20),
//           ),
//           Label(
//               text: item.description ??
//                   '49 Hub provides several services! You can now increase your income with 49Hub',
//               style: Styles.mediumText()),
//           const Sizer(),
//           InkWell(
//             onTap: () {
//               context.pop();
//             },
//             child: Container(
//               height: kToolbarHeight * .7,
//               decoration: BoxDecoration(
//                   color: Colors.grey[100],
//                   borderRadius: BorderRadius.circular(5)),
//               child: Center(
//                   child: Label(
//                       text: 'Close',
//                       style: Styles.mediumText(fontWeight: FontWeight.bold))),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
