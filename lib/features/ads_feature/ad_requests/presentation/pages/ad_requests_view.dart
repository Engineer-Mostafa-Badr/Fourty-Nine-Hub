import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/call_message_buttons.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/presentation/cubit/ad_details_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/presentation/cubit/ad_requests_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_details_prop_entity.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/ad_card.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
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
    // context.read<AdDetailsCubit>().loadData(adId: widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userId = serviceLocator<UserCubit>().state.data?.id ?? '';
    print("userId#{$userId");

    return Scaffold(
      appBar: BackAppBar(label: LocaleKeys.adRequests.localize,),
        body: BlocConsumer<AdRequestsCubit, AdRequestsState>(
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
          // if (state.ad == null) {
          //   return const Center(
          //     child: CircularProgressIndicator.adaptive(),
          //   );
          // }
          List<AdDetailsPropEntity>? details = state.ad?.details
              .where((e) => e.nameAr != 'الراتب' && e.nameAr != 'السعر')
              .toList();
          // print("state.ad?.user${context.read<AdDetailsCubit>().state.ad?.user?.id}");

          return Column(
            children: [
              // Expanded(
              //   child: ListView(
              //     children: [
              //       _buildTag(status: state.ad?.subscriptionStatus??''),
              //       const Sizer(),
              //       _buildRelevantAdsWidget(),
              //     ],
              //   ),
              // ),
              // CallMessageButtons(otherUserId: state.ad?.userId??'', subcategoryId: state.ad?.subCategoryId??'', phone: state.ad?.phone??'', id: state.ad?.id??'',hasReport: true,),
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

  Widget _buildActionsWidget() {
    return BlocBuilder<AdDetailsCubit, AdDetailsState>(
        builder: (context, state) {
          return Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                // const Sizer(),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     Expanded(
                //       flex: 3,
                //       child: BlocProvider(
                //           create: (_)=>serviceLocator<AdvertisementCubit>(),
                //           child: PremiumRequestButton(adId: state.ad?.id??'',subCategoryId: state.ad?.subCategoryId??'',subscriptionStatus: state.ad?.subscriptionStatus??'',)),
                //     ),
                //     const Sizer(width: 5),
                //     Expanded(
                //       flex: 3,
                //       child: BlocProvider(
                //           create: (_)=>serviceLocator<AdvertisementCubit>(),
                //           child: RequestButton(adId: state.ad?.id??'',subscriptionStatus: state.ad?.subscriptionStatus??''))
                //
                //     )
                //   ],
                // ),
                // const Sizer(),
                CallMessageButtons(otherUserId: state.ad?.userId??'', subcategoryId: state.ad?.subCategoryId??'', phone: state.ad?.phone??'', id: state.ad?.id??'',hasReport: true,),
              ],
            ),
          );
        });
  }

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
