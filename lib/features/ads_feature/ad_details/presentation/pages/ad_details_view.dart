import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/global/button_availability.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';

import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/presentation/cubit/ad_details_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/detail_entity.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/ad_card.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trip_button.dart';

import 'package:go_router/go_router.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class AdDetailsView extends StatefulWidget {
  final String id;
  const AdDetailsView({super.key, required this.id});

  @override
  State<AdDetailsView> createState() => _AdDetailsViewState();
}

class _AdDetailsViewState extends State<AdDetailsView> {
  @override
  void initState() {
    context.read<AdDetailsCubit>().loadData(adId: widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: const BackAppBar(),
        body: BlocConsumer<AdDetailsCubit, AdDetailsState>(
            listener: (contex, state) {
          if (state.isError) {
            showErrorMessage(
              context,
              getFailureMessage(
                state.failure!,
                context,
              ),
            );
          } else if (state.isSuccess) {
            showSuccessMessage(context, Labels.success);
          }
        }, builder: (context, state) {
          if (state.ad == null) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          List<DetailEntiy>? details = state.ad?.details.where((e) => e.label!='المرتب'&&e.label!='Salary'&&e.label!='price'&&e.label!='Price '&&e.label!='السعر ').toList();

          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    _buildAdInfoWidget(ad: state.ad!),
                    const Sizer(),
                    const Sizer(),
                    if(details!.isNotEmpty)_buildDetailsWidget(ad: state.ad!),
                    const Sizer(),
                    _buildRelevantAdsWidget(),
                  ],
                ),
              ),
              _buildActionsWidget(),
            ],
          );
        }));
  }

  Widget _buildRelevantAdsWidget() {
    return BlocBuilder<AdDetailsCubit, AdDetailsState>(
        builder: (context, state) {
      if (state.relevantAds?.isEmpty ?? true) {
        return const SizedBox();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(
            text: 'Relevant Ads',
            style: Styles.mediumText(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: kToolbarHeight * 3.5,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) =>
                    AdCard(item: state.relevantAds![index], onFav: (String ) {  }, onRemoveFav: (String ) {  },),
                separatorBuilder: (context, index) => const Sizer(),
                itemCount: state.relevantAds?.length ?? 0),
          ),
        ],
      );
    });
  }

  Widget _buildActionsWidget() {
    return BlocBuilder<AdDetailsCubit, AdDetailsState>(
        builder: (context, state) {
      final controller = context.read<AdDetailsCubit>();
      return Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Sizer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: AvaialbleTripsButton(
                    title: 'Premium Request',
                    color: AppColors.SECONDARY_COLOR,
                    onTap: (){},
                  ),
                ),
                const Sizer(width: 5),
                Expanded(
                  flex: 3,
                  child: AvaialbleTripsButton(
                    title: 'Request',
                    color: AppColors.PRIMARY_COLOR,
                    onTap: (){},
                  ),
                )
              ],
            ),
            const Sizer(),
            FutureBuilder(
                future: ButtonAvailability().isShowButton(
                    otherUserId: state.ad?.user?.id ?? '',
                    subcategoryId: state.ad?.subCategoryId ?? ''),
                builder: (context,snap) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: AvaialbleTripsButton(
                          title: 'Call',
                          color:  snap.data==true?AppColors.SECONDARY_COLOR:AppColors.DARK_GRAY_COLOR,
                          icon: Icons.call,
                          onTap: snap.data==true?(){}:(){},
                        ),
                      ),
                      const Sizer(width: 5),
                      Expanded(
                        flex: 3,
                        child: AvaialbleTripsButton(
                          title: 'Message',
                          color: snap.data==true?AppColors.SECONDARY_COLOR:AppColors.DARK_GRAY_COLOR,
                          icon: Icons.email,
                          onTap: snap.data==true?(){}:(){},
                        ),
                      ),

                      const Sizer(width: 5),
                      Expanded(
                        flex: 3,
                        child: AvaialbleTripsButton(
                          title: 'Report',
                          color: AppColors.SECONDARY_COLOR,
                          icon: Icons.report,
                          onTap: (){},
                        ),
                      ),
                    ],
                  );
                }
            ),
          ],
        ),
      );
    });
  }


  Widget _buildAdInfoWidget({required AdModel ad}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: kToolbarHeight * 4,
          child: Stack(
            children: [
              Swiper(
                itemCount: ad.images.length,
                onIndexChanged: (i) {},
                outer: false,
                physics:ad.images.length>1?null:const NeverScrollableScrollPhysics() ,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(bottom: 5.h),
                  child: ImageFromInternet(image: ad.images[index],defaultLogo: true,),
                ),
                pagination: SwiperPagination(
                    builder: SwiperCustomPagination(builder: (context, config) {
                      return const DotSwiperPaginationBuilder(color: AppColors.GREY_DARK_COLOR, activeColor: AppColors.SECONDARY_COLOR, size: 10.0, activeSize: 10.0)
                          .build(context, config);
                    })),
              ),
              PositionedDirectional(
                top: 10.h,
                start: 10.w,
                child: InkWell(
                  onTap: ()=>context.pop(),
                  child: Icon(Icons.arrow_back,color: Colors.white,size: 60.w,),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(
                    text:
                    '${NumbersHelper.formatThousands(number: ad.price??0)} ${LocaleKeys.currency.localize}',
                    style: Styles.mediumText(
                        fontWeight: FontWeight.bold,
                        color: AppColors.SECONDARY_COLOR),
                    maxLines: 1,
                  ),
                  Label(text: ad.formatedDate)
                ],
              ),

              Sizer(height: 8.h,),
              Row(
                children: [

                  Label(
                    text: "${LocaleKeys.title.localize} : ",
                    style: Styles.mediumText(fontWeight: FontWeight.bold,color: AppColors.SECONDARY_COLOR),
                  ),
                  Label(
                    text: ad.title,
                    style: Styles.mediumText(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Sizer(height: 5.h,),
              Label(
                text: "${LocaleKeys.desc.localize} : ",
                style: Styles.mediumText(fontWeight: FontWeight.bold,color: AppColors.SECONDARY_COLOR),
              ),
              Label(text: ad.description),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsWidget({required AdModel ad}) {
    List<DetailEntiy> details = ad.details.where((e) => e.label!='المرتب'&&e.label!='Salary'&&e.label!='price'&&e.label!='Price '&&e.label!='السعر ').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          text: LocaleKeys.details.localize,
          style: Styles.mediumText(fontWeight: FontWeight.bold),
        ),
        ListView.builder(
            itemCount: details.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final detail = details[index];
              return Container(
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                decoration: BoxDecoration(
                    color: index.isEven
                        ? AppColors.LIGHT_GRAY_COLOR
                        : Colors.white),
                child: Row(
                  children: [
                    Expanded(child: Label(text: "${detail.label} : ",style: Styles.mediumText(fontWeight: FontWeight.bold,color: AppColors.SECONDARY_COLOR))),
                    Expanded(child: Label(text: detail.value)),
                  ],
                ),
              );
            }),
      ],
    );
  }
}
