import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/cubits/request_trip_join_cubit/request_trip_join_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';

class RequstTripJoinBottomSheet extends StatefulWidget {
  const RequstTripJoinBottomSheet({
    super.key,
    // required this.tripJoinCardEntity,
    this.isPremium = false,
    required this.subCategory,
    required this.url,
    required this.tripId,
  });
  // final TripJoinCardEntity tripJoinCardEntity;
  final String subCategory;
  final String url;
  final String tripId;
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
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
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
               Sizer(height: 40.h,),
              InkWell(
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    context.read<RequestTripJoinCubit>().makeTripJoinRequest(
                          subCategory: widget.subCategory,
                          url: widget.url,
                          addId: widget.tripId,
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
