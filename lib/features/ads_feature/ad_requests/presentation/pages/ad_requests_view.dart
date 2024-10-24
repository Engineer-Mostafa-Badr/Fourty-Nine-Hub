import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/search_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/call_message_buttons.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/presentation/cubit/ad_details_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/entities/ad_request_entity.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/presentation/cubit/ad_requests_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/ad_card.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class AdRequestsView extends StatefulWidget {
  var id;

  AdRequestsView({super.key, payload}){
    print("objectitemId$payload");
    if(payload is String){
      id=payload;
    }else {
      print("payloadpayloadpayload $payload");
      // print(id);
      // print('itemId${payload['itemId']}');
      id=payload['itemId'];
    }
  }

  @override
  State<AdRequestsView> createState() => _AdRequestsViewState();
}

class _AdRequestsViewState extends State<AdRequestsView> {
  @override
  void initState() {
    context.read<AdRequestsCubit>().loadGlobalData(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userId = serviceLocator<UserCubit>().state.data?.id ?? '';
    print("userId#{$userId");

    return Scaffold(
      appBar: BackAppBar(label: LocaleKeys.adRequests.localize,),
        body: BlocBuilder<AdRequestsCubit, AdRequestsState>(
             builder: (context, state) {
              final controller = context.read<AdRequestsCubit>();
          if (state.isLoading) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[100]!,
              highlightColor: Colors.white24,
              child: Column(
                children: List.generate(
                    6,
                        (index) => Padding(
                      padding: EdgeInsets.only(bottom: 15.h),
                      child: Container(
                        height: MediaQuery.of(context).size.height *
                            .15.h,
                        width: double.infinity,
                        margin:
                        EdgeInsets.symmetric(horizontal: 10.w),
                        padding:
                        EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          color: AppColors.AUTH_CONTAINER_COLOR,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: Colors.grey),
                        ),
                      ),
                    )),
              ),
            );
          }
              return Column(
                children: [
                  SearchTextFormField(currentFocusNode: FocusNode(), currentController: TextEditingController(),),
                  Expanded(
                    child: PagedListView<int, AdRequestEntity>(
                      pagingController: controller.requestsPagingController,
                      builderDelegate: PagedChildBuilderDelegate<AdRequestEntity>(
                        noItemsFoundIndicatorBuilder: (context) {
                          return Center(
                            child: Text(
                              LocaleKeys.noData.localize,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.sp,
                              ),
                            ),
                          );
                        },
                        itemBuilder: (context, item, index) {
                          return Container(
                            margin: EdgeInsetsDirectional.all(10.w),
                            padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w,vertical: 10.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.r),
                              border: Border.all(color: AppColors.DARK_GRAY_COLOR, width: 1),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 100.w,height: 100.h,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(image: AssetImage(item.gender=='male'?Assets.maleImagePlaceholder:Assets.femaleImagePlacehlder), fit: BoxFit.contain),
                                          shape: BoxShape.circle
                                      ),
                                    ),
                                    Sizer(),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(item.userName??'',style: Styles.headerText(),),
                                          Text(item.sinceTime??'',style: Styles.mediumText(),),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                                CallMessageButtons(otherUserId: item.adUserId??'',clientId: item.requestId, subcategoryId: item.subCategoryId??'', phone: item.phone??'', id: item.requestUserId??'',hasReport: true,),

                              ],
                            ),
                          );
                        },
                        noMoreItemsIndicatorBuilder: (context) => Container(),
                        firstPageProgressIndicatorBuilder: (context) =>
                        const CupertinoActivityIndicator(),
                        newPageProgressIndicatorBuilder: (context) =>
                        const CupertinoActivityIndicator(),
                      ),
                    ),
                  ),
                ],
              )
          ;
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
                    itemBuilder: (context, index) => AdCard(
                      item: state.relevantAds![index],
                      onFav: (String) {},
                      onRemoveFav: (String) {},
                    ),
                    separatorBuilder: (context, index) => const Sizer(),
                    itemCount: state.relevantAds?.length ?? 0),
              ),
            ],
          );
        });
  }

  // Widget _buildActionsWidget() {
  //   return BlocBuilder<AdDetailsCubit, AdDetailsState>(
  //       builder: (context, state) {
  //         return Container(
  //           margin: const EdgeInsets.all(10),
  //           child: Column(
  //             children: [
  //               // const Sizer(),
  //               // Row(
  //               //   crossAxisAlignment: CrossAxisAlignment.center,
  //               //   children: [
  //               //     Expanded(
  //               //       flex: 3,
  //               //       child: BlocProvider(
  //               //           create: (_)=>serviceLocator<AdvertisementCubit>(),
  //               //           child: PremiumRequestButton(adId: state.ad?.id??'',subCategoryId: state.ad?.subCategoryId??'',subscriptionStatus: state.ad?.subscriptionStatus??'',)),
  //               //     ),
  //               //     const Sizer(width: 5),
  //               //     Expanded(
  //               //       flex: 3,
  //               //       child: BlocProvider(
  //               //           create: (_)=>serviceLocator<AdvertisementCubit>(),
  //               //           child: RequestButton(adId: state.ad?.id??'',subscriptionStatus: state.ad?.subscriptionStatus??''))
  //               //
  //               //     )
  //               //   ],
  //               // ),
  //               // const Sizer(),
  //               CallMessageButtons(otherUserId: state.ad?.userId??'', subcategoryId: state.ad?.subCategoryId??'', phone: state.ad?.phone??'', id: state.ad?.id??'',hasReport: true,),
  //             ],
  //           ),
  //         );
  //       });
  // }

  Widget _buildTag({required String status}) {
    // super premium
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.w),
      color: status=='premium'?Colors.amber:status=='Regular'?Colors.grey:Colors.grey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if(status=='premium'||status=='Regular')...[
            Icon(Icons.workspace_premium_outlined,
              size: 55.w,
              color: status=='premium'?AppColors.SECONDARY_COLOR:status=='Regular'?AppColors.PRIMARY_COLOR:null,
            ),
            const Sizer(width: 5)],
          Label(
            text: status=='premium'?"Premium":status=='premium'?"Regular":'Not Subscribed',
            style: Styles.mediumText(color: Colors.white,fontSize: 35,fontWeight: FontWeight.bold),
            maxLines: 1,
          ),
        ],
      ),
    );
    // premium
    // Regular
  }



}
