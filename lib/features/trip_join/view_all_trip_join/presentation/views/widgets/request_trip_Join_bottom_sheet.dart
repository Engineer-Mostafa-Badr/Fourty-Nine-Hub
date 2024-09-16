import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/entities/trip_join_card_entity.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/cubits/request_trip_join_cubit/request_trip_join_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';

class RequstTripJoinBottomSheet extends StatefulWidget {
  const RequstTripJoinBottomSheet({
    super.key,
    required this.tripJoinCardEntity,
  });
  final TripJoinCardEntity tripJoinCardEntity;
  @override
  State<RequstTripJoinBottomSheet> createState() => _RequstTripJoinBottomSheetState();
}

class _RequstTripJoinBottomSheetState extends State<RequstTripJoinBottomSheet> {
  String phoneNumber = '';
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Form(
        key: formKey,
        child: Container(
          width: double.infinity,
          height: 300.h,
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
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  fillColor: Colors.transparent,
                  label: const Text('Mobile'),
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
                          addId: widget.tripJoinCardEntity.id ?? '',
                          mobile: phoneNumber,
                        );
                    Future.delayed(const Duration(seconds: 2)).then((value) => context.pop());
                  }
                },
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.PRIMARY_COLOR,
                      ),
                      alignment: Alignment.center,
                      child: Text('Send Request', style: Styles.headerText(color: Colors.white)),
                    ),
                    Positioned(
                      top: 5,
                      right: 20,
                      child: SizedBox(
                        height: 40.h,
                        child: BlocBuilder<RequestTripJoinCubit, RequestTripJoinState>(
                          builder: (context, state) {
                            if (state is RequestTripJoinLoading) {
                              return const Center(
                                child: CircularProgressIndicator(color: Colors.white),
                              );
                            }
                            if (state is RequestTripJoinSuccess) {
                              return Center(
                                child: Icon(Icons.check, color: Colors.green[400], size: 30),
                              );
                            }
                            if (state is RequestTripJoinFailed) {
                              return Center(
                                child: Icon(Icons.error, color: Colors.red[400], size: 30),
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
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }
}
