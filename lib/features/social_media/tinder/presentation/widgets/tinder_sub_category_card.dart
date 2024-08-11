// import 'package:flutter/material.dart';
// import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
// import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
// import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
// import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
// import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
// import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_subcategory_model.dart';
// import 'package:fourtyninehub/features/social_media/tinder/data/shared/shared.dart';
// import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
// import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
// import 'package:fourtyninehub/res/style/app_colors.dart';
// import 'package:fourtyninehub/res/style/styles.dart';
//
// class TinderSubCategoryCard extends StatelessWidget {
//   final SubCategoryData subCategoryCardData;
//   final bool activeFav;
//
//   const TinderSubCategoryCard(
//       {super.key,
//       required this.subCategoryCardData,
//       required TinderViewCubit tinderViewCubit,
//       required this.activeFav});
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {},
//       child: Container(
//         width: 200,
//         padding: const EdgeInsets.all(0),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Card(
//           clipBehavior: Clip.hardEdge,
//           color: Colors.white,
//           elevation: 2,
//           child: Column(
//             children: [
//               Expanded(
//                   child: SizedBox(
//                 width: double.infinity,
//                 child: Stack(
//                   children: [
//                     Positioned.fill(
//                       child: SquareImage(
//                         fit: BoxFit.fitWidth,
//                         radius: 10,
//                         url: subCategoryCardData.picture,
//                       ),
//                     ),
//                     Positioned(
//                       top: 5,
//                       right: 5,
//                       child: activeFav
//                           ? IconAppButton(
//                               size: 25,
//                               icon: Icons.favorite_border,
//                               color: Colors.red,
//                               onPressed: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => DynamicGridViewPage(
//                                         subCategoryDataList: [
//                                           subCategoryCardData,
//                                           subCategoryCardData,
//                                           subCategoryCardData,
//                                           subCategoryCardData,
//                                           subCategoryCardData,
//                                           subCategoryCardData,
//                                           subCategoryCardData,
//                                           subCategoryCardData,
//                                           subCategoryCardData,
//                                           subCategoryCardData,
//                                           subCategoryCardData,
//                                           subCategoryCardData,
//                                           subCategoryCardData,
//                                           subCategoryCardData,
//
//                                           // SubCategoryData(
//                                           //     nameEn: 'Category 1',
//                                           //     dailyPrice: 100,
//                                           //     picture: 'https://via.placeholder.com/150'),
//                                           // SubCategoryData(
//                                           //     nameEn: 'Category 2',
//                                           //     dailyPrice: 200,
//                                           //     picture: 'https://via.placeholder.com/150'),
//                                           // SubCategoryData(
//                                           //     nameEn: 'Category 3',
//                                           //     dailyPrice: 300,
//                                           //     picture: 'https://via.placeholder.com/150'),
//                                           // SubCategoryData(
//                                           //     nameEn: 'Category 4',
//                                           //     dailyPrice: 400,
//                                           //     picture: 'https://via.placeholder.com/150'),
//                                           // SubCategoryData(
//                                           //     nameEn: 'Category 5',
//                                           //     dailyPrice: 500,
//                                           //     picture: 'https://via.placeholder.com/150'),
//                                           // SubCategoryData(
//                                           //     nameEn: 'Category 6',
//                                           //     dailyPrice: 600,
//                                           //     picture: 'https://via.placeholder.com/150'),
//                                         ],
//                                       ),
//                                     ));
//                               })
//                           : const Icon(
//                               size: 25,
//                               Icons.favorite,
//                               color: Colors.red,
//                             ),
//                     )
//                   ],
//                 ),
//               )),
//               const Sizer(),
//               Padding(
//                 padding: const EdgeInsets.only(left: 8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Label(
//                           text: subCategoryCardData.nameEn ?? '',
//                           style: Styles.headerText(
//                               fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                         Label(
//                           text: '${9355.toShortScale} ads',
//                           style: Styles.mediumText(fontSize: 14),
//                         ),
//                       ],
//                     ),
//                     IconAppButton(
//                       icon: Icons.add,
//                       isCircle: true,
//                       color: Colors.white,
//                       backColor: AppColors.PRIMARY_COLOR,
//                       onPressed: () {},
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//refactored
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/account_taps/account/presentation/pages/favourite_subcategory_view.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_subcategory_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/shared/shared.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/shared/tinder_shared_utils.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class TinderSubCategoryCard extends StatelessWidget {
  final SubCategoryData subCategoryCardData;
  final bool activeFav;
  final TinderViewCubit tinderViewCubit;

  const TinderSubCategoryCard({
    super.key,
    required this.subCategoryCardData,
    required this.tinderViewCubit,
    required this.activeFav,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Card(
          clipBehavior: Clip.hardEdge,
          color: Colors.white,
          elevation: 2,
          child: Column(
            children: [
              _buildImageSection(context),
              const Sizer(),
              _buildInfoSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: SquareImage(
                fit: BoxFit.fitWidth,
                radius: 10,
                url: subCategoryCardData.picture,
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: activeFav
                  ? IconAppButton(
                      size: 25,
                      icon: Icons.favorite_border,
                      color: Colors.red,
                      onPressed: () => _navigateToDynamicGridView(context),
                    )
                  : const Icon(
                      size: 25,
                      Icons.favorite,
                      color: Colors.red,
                    ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(
                text: subCategoryCardData.nameEn ?? '',
                style: Styles.headerText(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Label(
                text: '${9355.toShortScale} ads',
                style: Styles.mediumText(fontSize: 14),
              ),
            ],
          ),
          IconAppButton(
            icon: Icons.add,
            isCircle: true,
            color: Colors.white,
            backColor: AppColors.PRIMARY_COLOR,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  void _navigateToDynamicGridView(BuildContext context) {
    // context.push(Routes.FAVOURITESUBCATEGORIES);
    context
        .read<TinderViewCubit>()
        .fetchFavorites(TinderSharedUtils.token)
        .then((value) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FavSubCategoryView(),
              ),
            ));
  }
}
// subCategoryDataList: List.generate(
//   7,
//   (index) => subCategoryCardData,
// ),
