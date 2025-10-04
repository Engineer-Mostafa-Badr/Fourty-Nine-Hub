import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/main_categry_entity.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/sup_category_entity.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/widgets/image_card_widget.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/widgets/subscribe_widget_in_card.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/widgets/rate_product_widget.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../domain/entity/chance_ad_entity.dart';
import '../../domain/entity/chance_entity.dart';
import '../../domain/entity/image_chance_entity.dart';
import '../controller/cubit/chance_cubit.dart';
import '../pages/chance_detail_view.dart';
import 'join_chance_dialog.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class ChanceCardWidget extends StatefulWidget {
  const ChanceCardWidget({
    super.key,
    this.chance,
    this.image,
    this.subCategoryEntity,
    this.mainCategoryEntity,
    this.chanceAd,
  }) : assert(
            chanceAd != null ||
                (chance != null &&
                    image != null &&
                    subCategoryEntity != null &&
                    mainCategoryEntity != null),
            'Either chanceAd must be provided OR all of chance, image, subCategoryEntity, and mainCategoryEntity must be provided');

  // Old properties (for backward compatibility)
  final ChanceEntity? chance;
  final ImageChanceEntity? image;
  final SubCategoryEntity? subCategoryEntity;
  final MainCategoryEntity? mainCategoryEntity;

  // New property for new API
  final ChanceAdEntity? chanceAd;

  @override
  State<ChanceCardWidget> createState() => _ChanceCardWidgetState();
}

class _ChanceCardWidgetState extends State<ChanceCardWidget> {
  // Determine which data to use (new or old API)
  bool get useNewApi => widget.chanceAd != null;

  String get title =>
      useNewApi ? widget.chanceAd!.title : (widget.chance?.title ?? '');
  double get price => useNewApi
      ? widget.chanceAd!.price
      : (widget.chance != null ? widget.chance!.price.toDouble() : 0.0);
  String get imageUrl => useNewApi
      ? (widget.chanceAd!.images.isNotEmpty
          ? widget.chanceAd!.images.first.photo
          : '')
      : (widget.image?.photo ?? '');
  String get id => useNewApi ? widget.chanceAd!.id : (widget.chance?.id ?? '');
  double get progressPercentage =>
      useNewApi ? widget.chanceAd!.adPercentage : 0.0;
  bool get isComplete => useNewApi ? widget.chanceAd!.isComplete : false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        ManageVibration.vibrate();
        if (useNewApi) {
          // Get chance ad details and navigate
          context.read<ChanceCubit>().getChanceAdDetails(widget.chanceAd!.id);
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: context.read<ChanceCubit>(),
                // child: ChanceAdDetailsView(chanceAdId: widget.chanceAd!.id),
                child: ChanceDetailView(
                  title: title,
                  price: price.toInt(),
                  images: widget.chanceAd!.images.map((e) => e.photo).toList(),
                  progress: progressPercentage,
                  participants: widget.chanceAd!.contributors,
                  views: widget.chanceAd!.views,
                  description: widget.chanceAd!.description,
                  chanceAd: widget.chanceAd,
                ),
              ),
            ),
          );

          // Refresh data when returning from detail view
          if (context.mounted) {
            context.read<ChanceCubit>().getAllChanceAds();
          }
        } else if (widget.chance != null &&
            widget.image != null &&
            widget.subCategoryEntity != null &&
            widget.mainCategoryEntity != null) {
          // Use old navigation
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChanceDetailView(
                title: title,
                price: price.toInt(),
                images: [imageUrl],
                progress: progressPercentage,
                participants: widget.chance!.contributors,
                views: widget.chance!.views,
                description: widget.chance!.description,
              ),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppColors.SHADOW_LIGHT,
        ),
        child: Row(
          children: [
            ImageCardWidget(
              image: imageUrl,
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: Styles.mediumText(fontSize: 60.sp),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (useNewApi)
                        IconButton(
                          onPressed: () {
                            context
                                .read<ChanceCubit>()
                                .toggleChanceAdFavorite(widget.chanceAd!.id);
                          },
                          icon: const Icon(Icons.favorite_border),
                          iconSize: 20,
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        price.toStringAsFixed(0),
                        style: TextStyle(
                          fontSize: 48.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        ' EGP',
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.SECONDARY_COLOR,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  if (useNewApi)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isComplete ? 'Completed' : 'Active',
                          style: TextStyle(
                            color: isComplete ? Colors.green : Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 30.sp,
                          ),
                        ),
                        if (useNewApi && widget.chanceAd!.contributors > 0)
                          Text(
                            '${widget.chanceAd!.contributors} contributors',
                            style: TextStyle(
                              color: AppColors.GREY_NORMAL_COLOR,
                              fontSize: 28.sp,
                            ),
                          ),
                      ],
                    ),
                  SizedBox(height: 8.h),
                  if (useNewApi && !isComplete)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => BlocProvider.value(
                                value: context.read<ChanceCubit>(),
                                child: JoinChanceDialog(
                                    chanceAd: widget.chanceAd!),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.SECONDARY_COLOR,
                            minimumSize: Size(80.w, 35.h),
                          ),
                          child: Text(
                            'Join',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28.sp,
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    const NotSubscribedWidget(),
                  SizedBox(height: 24.h),
                  if (useNewApi)
                    LinearProgressIndicator(
                      value: progressPercentage / 100,
                      backgroundColor: AppColors.GREY_LIGHT_COLOR,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progressPercentage >= 100
                            ? Colors.green
                            : AppColors.SECONDARY_COLOR,
                      ),
                    )
                  else
                    const LinerProgressIndicator(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// 'assets/images/doctor.png'
