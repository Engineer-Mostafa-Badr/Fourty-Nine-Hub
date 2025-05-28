import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/call_message_buttons.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/entities/requests_log_by_main_category_entity.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/presentation/cubit/ad_requests_cubit.dart';
import 'package:fourtyninehub/features/subcategories/presentation/pages/ads_request_log_card.dart';
import 'package:fourtyninehub/res/assets/assets.dart';

import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class AdRequestsView extends StatefulWidget {
  var id;
  String search = '';

  AdRequestsView({super.key, payload}) {
    print("objectitemId$payload");
    if (payload is AdRequestParams) {
      id = payload.id;
      search = '';
    } else {
      print("payloadpayloadpayload $payload");
      // print(id);
      // print('itemId${payload['itemId']}');
      id = payload['itemId'];
      search = payload['username'];
    }
  }

  @override
  State<AdRequestsView> createState() => _AdRequestsViewState();
}

class _AdRequestsViewState extends State<AdRequestsView> {
  late ScrollController _scrollController;
  late AdRequestsCubit _cubit;
  bool isFirstSearchListenerCall = true;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<AdRequestsCubit>();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<AdRequestsCubit>().loadInitialData(widget.id, widget.search);

    context.read<AdRequestsCubit>().searchController.addListener(() {
      if (isFirstSearchListenerCall) {
        isFirstSearchListenerCall = false;
        return;
      }
      context.read<AdRequestsCubit>().loadInitialData(
          widget.id, context.read<AdRequestsCubit>().searchController.text);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<AdRequestsCubit>().fetchAdRequests(
          widget.id, context.read<AdRequestsCubit>().searchController.text);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: BackAppBar(label: LocaleKeys.adRequests.localize),
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(30),
      //   child: BackAppBar(
      //     label: LocaleKeys.adRequests.localize,
      //     backColor: AppColors.getTextColor(context),
      //   ),
      // ),
      body: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 15.0.w),
          //   child: TextFormField(
          //     controller: context.read<AdRequestsCubit>().searchController,
          //     decoration: InputDecoration(
          //       contentPadding:
          //           EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          //       hintStyle: Styles.mediumText(),
          //       hintText: LocaleKeys.searchWithName.localize,
          //     ),
          //   ),
          // ),
          // const Sizer(),
          Expanded(
            child: BlocBuilder<AdRequestsCubit, AdRequestsState>(
              builder: (context, state) {
                if (state.isLoading &&
                    context.read<AdRequestsCubit>().adRequests.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: context.read<AdRequestsCubit>().adRequests.length +
                      (context.read<AdRequestsCubit>().isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index ==
                        context.read<AdRequestsCubit>().adRequests.length) {
                      return const CustomLoading();
                    }

                    final adRequest =
                        context.read<AdRequestsCubit>().adRequests[index];
                    return AdsRequestLogCard(
                      requestLog: adRequest,
                      // requestLog: RequestsLogByMainCategoryEntity(
                      //   adDesc: adRequest.adDesc,
                      //   adId: adRequest.adId,
                      //   adTitle: adRequest.adTitle,
                      //   createdAt: adRequest.createdAt,
                      //   gender: adRequest.gender,
                      //   firstName: adRequest.firstName,
                      //   lastName: adRequest.lastName,
                      //   userId: adRequest.userId,
                      //   userName: adRequest.userName,
                      //   isPremium: adRequest.isPremium,
                      //   phone: adRequest.phone,
                      //   profilePictureUrl: adRequest.profilePictureUrl,
                      //   subCategoryId: adRequest.subCategoryId,
                      //   subCategoryNameAr: adRequest.subCategoryNameAr,
                      //   subCategoryNameEn: adRequest.subCategoryNameEn,
                      //   views: adRequest.views,
                      // ),
                    );
                    return Container(
                      margin: EdgeInsetsDirectional.all(10.w),
                      padding: EdgeInsetsDirectional.symmetric(
                          horizontal: 15.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.r),
                        border: Border.all(
                          color: AppColors.DARK_GRAY_COLOR.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 100.w,
                                height: 100.h,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(adRequest.gender == 'male'
                                        ? Assets.maleImagePlaceholder
                                        : Assets.femaleImagePlacehlder),
                                    fit: BoxFit.contain,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(adRequest.userName,
                                        style: Styles.headerText()),
                                    Text(adRequest.sinceTime,
                                        style: Styles.mediumText()),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Sizer(height: 50.h),
                          // CallMessageButtons(
                          //   otherUserId: adRequest.adUserId,
                          //   clientId: adRequest.requestId,
                          //   subcategoryId: adRequest.subCategoryId,
                          //   phone: adRequest.phone,
                          //   id: adRequest.requestUserId,
                          //   hasReport: true,
                          // ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AdRequestParams {
  final String id;
  final String userName;

  AdRequestParams({required this.id, required this.userName});
}
