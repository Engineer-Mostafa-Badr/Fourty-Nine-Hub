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
// import '../../../../service_locator/service_locator.dart';
// import '../../domain/entity/chance_entity.dart';
// import '../../domain/entity/image_chance_entity.dart';
// import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

// import '../widgets/counter_money_widget.dart';
// import '../widgets/subscribe_button_widget.dart';
// import 'package:carousel_slider/carousel_slider.dart';

// class ChanceDetailsView extends StatelessWidget {
//   const ChanceDetailsView({
//     super.key,
//     required this.chance,
//     required this.image,
//     required this.subCategoryEntity,
//     required this.mainCategoryEntity,
//   });

//   final ChanceEntity chance;

//   final ImageChanceEntity image;

//   final String subCategoryEntity;

//   final String mainCategoryEntity;

//   @override
//   Widget build(BuildContext context) {
//     return CustomScaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(30),
//         child: BackAppBar(
//           label: LocaleKeys.ChanceDetails.localize,
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: BlocProvider<ChanceCubit>(
//           create: (context) => serviceLocator()..getChanceRate(id: chance.id),
//           child: BlocConsumer<ChanceCubit, ChanceState>(
//             listener: (context, state) {},
//             builder: (context, state) {
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Container(
//                       padding: const EdgeInsets.all(16.0),
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).scaffoldBackgroundColor,
//                         borderRadius: BorderRadius.circular(15),
//                         boxShadow: AppColors.SHADOW_LIGHT,
//                       ),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(children: [
//                             Text(
//                               subCategoryEntity,
//                               style: Styles.mediumText(
//                                   color: Theme.of(context).primaryColor),
//                             ),
//                             const Spacer(),
//                             Text(
//                               mainCategoryEntity,
//                               style: Styles.mediumText(
//                                   color: Theme.of(context).primaryColor),
//                             ),
//                           ]),
//                           Center(
//                             child: CarouselSlider.builder(
//                               itemCount: image.photo.length,
//                               itemBuilder: (
//                                 BuildContext context,
//                                 int itemIndex,
//                                 int pageViewIndex,
//                               ) =>
//                                   Container(
//                                 height: 250.h,
//                                 width: 330.w,
//                                 decoration: const BoxDecoration(
//                                     color: Colors.white,
//                                     boxShadow: AppColors.SHADOW_LIGHT),
//                                 child: Image.network(
//                                   image.photo,
//                                   fit: BoxFit.fill,
//                                 ),
//                               ),
//                               options: CarouselOptions(
//                                 autoPlay: true,
//                                 enlargeCenterPage: true,
//                                 aspectRatio: 2.0,
//                                 viewportFraction: 0.8,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 20,
//                           ),
//                           Text(
//                             LocaleKeys.SubscriberCompletionRate.localize,
//                             style: const TextStyle(
//                               fontSize: 16,
//                             ),
//                           ),
//                           SizedBox(height: 30.h),
//                           Container(
//                             height: 20.h,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(12),
//                               child: LinearProgressIndicator(
//                                 value: state.rate?.contributionPercentage,
//                                 color: AppColors.SECONDARY_COLOR,
//                                 backgroundColor: Colors.grey.shade300,
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 30.h),
//                           Text(
//                             LocaleKeys.ProductDescription.localize,
//                             style: const TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           Text(
//                             chance.description,
//                             style: Styles.mediumText(),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20.h),
//                   SizedBox(height: 10.h),
//                   Text(LocaleKeys.Typethevalueyouwanttoparticipation.localize,
//                       style: Styles.mediumText(
//                         color: Theme.of(context).primaryColor,
//                         fontSize: 50.sp,
//                       )),
//                   SizedBox(height: 15.h),
//                   const CounterMoneyWidget(),
//                   SizedBox(height: 80.h),
//                   const SubscribeButtonWidget(),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
