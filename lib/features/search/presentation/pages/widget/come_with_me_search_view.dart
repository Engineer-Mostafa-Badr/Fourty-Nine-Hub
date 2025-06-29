import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/search/domain/entity/trip_come_with_you_entity.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_search_use_case.dart';
import 'package:fourtyninehub/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:fourtyninehub/features/search/presentation/pages/widget/build_Item_trip_come.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/usecases/request_trip_join_usecase.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/cubits/request_trip_join_cubit/request_trip_join_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

class ComeWithMeSearchView extends StatefulWidget {
  const ComeWithMeSearchView({
    super.key,
    required this.params
  });
  final SearchParams params;

  @override
  State<ComeWithMeSearchView> createState() =>
      _ViewAllTripJoinCardBuilderState();
}

class _ViewAllTripJoinCardBuilderState extends State<ComeWithMeSearchView> {


  late ScrollController _scrollController;
  late SearchCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<SearchCubit>();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() async{
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final prefs = await SharedPreferences.getInstance();
      String filter = prefs.getString('filter')??'';
      SearchParams searchParams = SearchParams(
          filter: filter,
          params: widget.params.params,
          search: widget.params.search
      );
      context.read<SearchCubit>().getPaginatedTripComeSearch(
          params:searchParams);
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 10.w),
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          // if(state.status ==SearchStates.loading){
          //   return const Center(child: CustomCircularProgressIndicator());
          // }
          final controller = context.read<SearchCubit>();
          if (controller.searchController.text.isNotEmpty) {
            return ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: controller.tripComeSearch.length,
              itemBuilder: (context, index) {
                return BuildItemTripCome(
                  tripJoinCardEntity: controller.tripComeSearch[index],
                  requestOnTap: () async {
                    await showModalBottomSheet(
                      context: context,
                      isDismissible: true,
                      isScrollControlled: true,
                      builder: (_) {
                        return BlocProvider(
                          create: (_) => RequestTripJoinCubit(
                            requestTripJoinUseCase:
                            serviceLocator<RequstTripJoinUseCase>(),
                          ),
                          child: RequstTripJoinBottomSheet(
                              tripJoinCardEntity: state.tripCome![index]),
                        );
                      },
                    );
                  },
                  subscribeMessageOnTap: () async {
                    // if (await _isPremuim(
                    //   tripJoinCardEntity,
                    //   tripJoinCardEntity.categoryId ?? '',
                    //   LocaleKeys.tripjoinPremuimSubscription.localize,
                    // )) {}
                  },
                );
              },
            );
          }

          return Center(
            child: Text(
              LocaleKeys.noData.localize,
              style: Styles.mediumText(),
            ),
          );
        },
      ),
    );
  }
}

class RequstTripJoinBottomSheet extends StatefulWidget {
  const RequstTripJoinBottomSheet({
    super.key,
    required this.tripJoinCardEntity,
    this.isPremium = false,
  });
  final TripComeWithYouEntity tripJoinCardEntity;
  final bool isPremium;
  @override
  State<RequstTripJoinBottomSheet> createState() =>
      _RequstTripJoinBottomSheetState();
}

class _RequstTripJoinBottomSheetState extends State<RequstTripJoinBottomSheet> {
  String phoneNumber = '';
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Form(
        key: formKey,
        child: Container(
          width: double.infinity,
          height: 330.h,
          padding: const EdgeInsets.all(30),
          // margin: EdgeInsets.all(kToolbarHeight),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Theme.of(context).dialogBackgroundColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  fillColor: Colors.transparent,
                  label: Text(LocaleKeys.phone.localize),
                  isDense: true,
                  contentPadding: const EdgeInsets.all(14),
                ),
                onChanged: (String phone) {
                  phoneNumber = phone;
                },
                validator: (value) {
                  return _validateMobile(value);
                },
              ),
              const Sizer(),
              InkWell(
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    context.read<RequestTripJoinCubit>().makeTripJoinRequest(
                        addId: widget.tripJoinCardEntity.id,
                        mobile: phoneNumber,
                        premuimRequest: widget.isPremium,
                        subCategory: widget.tripJoinCardEntity.categoryId,
                        url: '/ride/pick-me/request/');
                    Future.delayed(const Duration(seconds: 2))
                        .then((value) => context.pop());
                  }
                },
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: widget.isPremium
                            ? AppColors.SECONDARY_COLOR
                            : AppColors.PRIMARY_COLOR,
                      ),
                      alignment: Alignment.center,
                      child: Text(LocaleKeys.sendRequest.localize,
                          style: Styles.headerText(color: Colors.white)),
                    ),
                    Positioned(
                      top: 5,
                      right: 20,
                      child: SizedBox(
                        height: 40.h,
                        child: BlocBuilder<RequestTripJoinCubit,
                            RequestTripJoinState>(
                          builder: (context, state) {
                            if (state is RequestTripJoinLoading) {
                              return Center(
                                child: SizedBox(
                                    height: 35.w,
                                    width: 35.w,
                                    child: const CustomCircularProgressIndicator(
                                        color: Colors.white)),
                              );
                            }
                            if (state is RequestTripJoinSuccess) {
                              return Center(
                                child: Icon(Icons.check,
                                    color: Colors.green[400], size: 35.w),
                              );
                            }
                            if (state is RequestTripJoinFailed) {
                              return Center(
                                child: Icon(Icons.error,
                                    color: Colors.red[400], size: 35.w),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String? _validateMobile(String? value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return LocaleKeys.enterPhoneNumber.localize;
    } else if (!regExp.hasMatch(value)) {
      return LocaleKeys.enterValidPhoneNumber.localize;
    }
    return null;
  }
}
