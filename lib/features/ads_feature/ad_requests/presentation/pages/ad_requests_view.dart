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
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/ad_card.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class AdRequestsView extends StatefulWidget {
  var id;

  AdRequestsView({super.key, payload}) {
    print("objectitemId$payload");
    if (payload is String) {
      id = payload;
    } else {
      print("payloadpayloadpayload $payload");
      // print(id);
      // print('itemId${payload['itemId']}');
      id = payload['itemId'];
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
    _cubit.loadInitialData(widget.id, '');

    _cubit.searchController.addListener(() {
      if (isFirstSearchListenerCall) {
        isFirstSearchListenerCall = false;
        return;
      }
      _cubit.loadInitialData(widget.id, _cubit.searchController.text);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _cubit.fetchAdRequests(widget.id, _cubit.searchController.text);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _cubit.searchController.dispose(); // Don't forget to dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(label: LocaleKeys.adRequests.localize),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0.w),
            child: TextFormField(
              controller: _cubit.searchController,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                hintStyle: Styles.mediumText(),
                hintText: LocaleKeys.searchWithName.localize,
              ),
            ),
          ),
          const Sizer(),
          Expanded(
            child: BlocBuilder<AdRequestsCubit, AdRequestsState>(
              builder: (context, state) {
                if (state.isLoading && _cubit.adRequests.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount:
                      _cubit.adRequests.length + (_cubit.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _cubit.adRequests.length) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final adRequest = _cubit.adRequests[index];
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
                                    Text(adRequest.userName ?? '',
                                        style: Styles.headerText()),
                                    Text(adRequest.sinceTime ?? '',
                                        style: Styles.mediumText()),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Sizer(height: 50.h),
                          CallMessageButtons(
                            otherUserId: adRequest.adUserId ?? '',
                            clientId: adRequest.requestId,
                            subcategoryId: adRequest.subCategoryId ?? '',
                            phone: adRequest.phone ?? '',
                            id: adRequest.requestUserId ?? '',
                            hasReport: true,
                          ),
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

Widget _buildRelevantAdsWidget() {
  return BlocBuilder<AdDetailsCubit, AdDetailsState>(builder: (context, state) {
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
