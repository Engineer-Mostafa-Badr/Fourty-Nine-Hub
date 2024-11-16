import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/search/domain/entity/trip_come_with_you_entity.dart';
import 'package:fourtyninehub/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:fourtyninehub/features/search/presentation/pages/widget/build_Item_trip_come.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/usecases/request_trip_join_usecase.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/cubits/request_trip_join_cubit/request_trip_join_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ComeWithMeSearchView extends StatefulWidget {
  const ComeWithMeSearchView({
    super.key,
  });

  @override
  State<ComeWithMeSearchView> createState() =>
      _ViewAllTripJoinCardBuilderState();
}

class _ViewAllTripJoinCardBuilderState
    extends State<ComeWithMeSearchView> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 10.w),
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          final controller = context.read<SearchCubit>();
          if (controller.searchController.text.isNotEmpty) {
            return PagedListView<int, TripComeWithYouEntity>(
              pagingController: controller.searchPagingTripComeController,
              builderDelegate: PagedChildBuilderDelegate<TripComeWithYouEntity>(
                noItemsFoundIndicatorBuilder: (context) {
                  return Center(
                    child: Text(
                      LocaleKeys.noData.localize,
                      style: Styles.mediumText(),
                    ),
                  );
                },

                itemBuilder: (context, item, index) {
                  return BuildItemTripCome(
                    tripJoinCardEntity: state.tripCome![index],
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
                noMoreItemsIndicatorBuilder: (context) => Container(),
                firstPageProgressIndicatorBuilder: (context) =>
                const CupertinoActivityIndicator(),
                newPageProgressIndicatorBuilder: (context) =>
                const CupertinoActivityIndicator(),
              ),
            );
          }

          return Center(
            child: Text(LocaleKeys.noResultsFound.localize),
          );
        },
      ),
    );
  }

  // Future<bool> _isPremuim(TripComeWithYouEntity tripJoinCardEntity,
  //     String subCategoryId, String title) async {
  //   if (tripJoinCardEntity.subscribedPremium == null ||
  //       tripJoinCardEntity.subscribedPremium == false) {
  //     await serviceLocator<SubscriptionController>().showSubscriptionPlans(
  //       // wallets: [
  //       //   tripJoinCardEntity.paymentMethod?.toWalletType ?? WalletTypes.balance
  //       // ],
  //       subCategoryId: subCategoryId,
  //       title: title,
  //     );
  //     return false;
  //   }
  //    return true;
  // }
  // void _reportOnTap(BuildContext context, int index) {
  //   bottomSheet(
  //       context: context,
  //       widget: ReportViewTripJoin(
  //         id: viewAllTripJoinCubit.tripJoinCards[index].userId ?? '',
  //         cardId: viewAllTripJoinCubit.tripJoinCards[index].id ?? '',
  //         categoryId:
  //         viewAllTripJoinCubit.tripJoinCards[index].categoryId ?? '',
  //       ));
  // }
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
                    );
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
                                    child: const CircularProgressIndicator(
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
