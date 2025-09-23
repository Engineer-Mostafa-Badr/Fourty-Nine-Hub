// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
// import 'package:fourtyninehub/core/extensions/string_extension.dart';
// import 'package:fourtyninehub/features/chance_feature/presentation/controller/cubit/chance_cubit.dart';
// import 'package:fourtyninehub/features/chance_feature/presentation/controller/cubit/chance_states.dart';
// import '../../../../core/widget/custom_scaffold.dart';
// import '../../../../res/style/app_colors.dart';
// import '../../../../res/style/styles.dart';
// import '../../../../core/loading/custom_loading.dart';
// import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
// import '../widgets/join_chance_dialog.dart';
// import 'package:carousel_slider/carousel_slider.dart';

// class ChanceAdDetailsView extends StatelessWidget {
//   const ChanceAdDetailsView({
//     super.key,
//     required this.chanceAdId,
//   });

//   final String chanceAdId;

//   @override
//   Widget build(BuildContext context) {
//     return CustomScaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(30),
//         child: BackAppBar(
//           label: LocaleKeys.ChanceDetails.localize,
//         ),
//       ),
//       body: BlocBuilder<ChanceCubit, ChanceState>(
//         builder: (context, state) {
//           if (state.status == ChanceStates.loading) {
//             return const CustomLoading();
//           }

//           if (state.status == ChanceStates.error) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text('Error loading chance ad details'),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () => context.read<ChanceCubit>().getChanceAdDetails(chanceAdId),
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             );
//           }

//           final chanceAd = state.chanceAdDetails;
//           if (chanceAd == null) {
//             return const Center(child: Text('No details available'));
//           }

//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(16.0),
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).scaffoldBackgroundColor,
//                       borderRadius: BorderRadius.circular(15),
//                       boxShadow: AppColors.SHADOW_LIGHT,
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Title and Favorite
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 chanceAd.title,
//                                 style: Styles.headerText(),
//                               ),
//                             ),
//                             IconButton(
//                               onPressed: () {
//                                 context.read<ChanceCubit>().toggleChanceAdFavorite(chanceAd.id);
//                               },
//                               icon: const Icon(Icons.favorite_border),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),

//                         // Images Carousel
//                         if (chanceAd.images.isNotEmpty)
//                           CarouselSlider.builder(
//                             itemCount: chanceAd.images.length,
//                             itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
//                                 Container(
//                               height: 250.h,
//                               width: 330.w,
//                               decoration: const BoxDecoration(
//                                 color: Colors.white,
//                                 boxShadow: AppColors.SHADOW_LIGHT,
//                               ),
//                               child: Image.network(
//                                 chanceAd.images[itemIndex].photo,
//                                 fit: BoxFit.fill,
//                                 errorBuilder: (context, error, stackTrace) => Container(
//                                   color: AppColors.GREY_LIGHT_COLOR,
//                                   child: const Icon(Icons.image_not_supported),
//                                 ),
//                               ),
//                             ),
//                             options: CarouselOptions(
//                               autoPlay: true,
//                               enlargeCenterPage: true,
//                               aspectRatio: 2.0,
//                               viewportFraction: 0.8,
//                             ),
//                           ),

//                         const SizedBox(height: 20),

//                         // Price
//                         Row(
//                           children: [
//                             Text(
//                               chanceAd.price.toStringAsFixed(0),
//                               style: TextStyle(
//                                 fontSize: 48.sp,
//                                 fontWeight: FontWeight.bold,
//                                 color: Theme.of(context).primaryColor,
//                               ),
//                             ),
//                             Text(
//                               ' EGP',
//                               style: TextStyle(
//                                 fontSize: 32.sp,
//                                 fontWeight: FontWeight.bold,
//                                 color: AppColors.SECONDARY_COLOR,
//                               ),
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 20),

//                         // Status and Contributors
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               chanceAd.isComplete ? 'Completed' : 'Active',
//                               style: TextStyle(
//                                 color: chanceAd.isComplete ? Colors.green : Colors.orange,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 18.sp,
//                               ),
//                             ),
//                             if (chanceAd.contributors > 0)
//                               Text(
//                                 '${chanceAd.contributors} contributors',
//                                 style: TextStyle(
//                                   color: AppColors.GREY_NORMAL_COLOR,
//                                   fontSize: 16.sp,
//                                 ),
//                               ),
//                           ],
//                         ),

//                         const SizedBox(height: 20),

//                         // Progress
//                         Text(
//                           'Progress: ${chanceAd.adPercentage.toStringAsFixed(1)}%',
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 10),

//                         LinearProgressIndicator(
//                           value: chanceAd.adPercentage / 100,
//                           backgroundColor: AppColors.GREY_LIGHT_COLOR,
//                           valueColor: AlwaysStoppedAnimation<Color>(
//                             chanceAd.adPercentage >= 100 ? Colors.green : AppColors.SECONDARY_COLOR,
//                           ),
//                         ),

//                         const SizedBox(height: 30),

//                         // Description
//                         Text(
//                           LocaleKeys.ProductDescription.localize,
//                           style: const TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         Text(
//                           chanceAd.description,
//                           style: Styles.mediumText(),
//                         ),

//                         // Category info if available
//                         if (chanceAd.subCategoryId != null || chanceAd.mainCategoryId != null)
//                           Padding(
//                             padding: const EdgeInsets.only(top: 20),
//                             child: Text(
//                               'Category ID: ${chanceAd.subCategoryId ?? chanceAd.mainCategoryId}',
//                               style: TextStyle(
//                                 color: Theme.of(context).primaryColor,
//                                 fontSize: 16.sp,
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 30),

//                   // Join Button (only if not complete)
//                   if (!chanceAd.isComplete)
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           showDialog(
//                             context: context,
//                             builder: (context) => BlocProvider.value(
//                               value: context.read<ChanceCubit>(),
//                               child: JoinChanceDialog(chanceAd: chanceAd),
//                             ),
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.SECONDARY_COLOR,
//                           padding: EdgeInsets.symmetric(vertical: 16.h),
//                         ),
//                         child: Text(
//                           'Join this Chance',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18.sp,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }