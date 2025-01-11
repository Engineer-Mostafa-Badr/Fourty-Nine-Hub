import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/image_picker_placeholder.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/ten_percent/presentation/cubit/ten_percent_cubit.dart';
import 'package:fourtyninehub/features/ten_percent/presentation/pages/widget/bill_value_field.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class TenPercentView extends StatefulWidget {
  const TenPercentView({super.key,});

  @override
  State<TenPercentView> createState() => _TenPercentViewState();
}

class _TenPercentViewState extends State<TenPercentView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(label: LocaleKeys.billCashback.localize),
      body: BlocBuilder<TenPercentCubit,TenPercentState>(
        builder: (context,state) {
          var cubit = context.read<TenPercentCubit>();
          return Form(
            key: cubit.formKey,
            child: ListView(
              padding: EdgeInsets.all(16.w),
              children: [
                Label(text: 'Upload At Least One Bill To Enjoy Getting Cashback As A Gift On The App.',style: Styles.headerText(

                  color: AppColors.SECONDARY_COLOR
                ),maxLines: 3,),
                const Sizer(),
                Label(text: LocaleKeys.trafficViolation.localize,style: Styles.headerText(),),
                const Sizer(),
                InkWell(
                  onTap: () async {
                    await context.read<TenPercentCubit>().uploadTrafficBill(context: context);
                  },
                  child: BlocBuilder<TenPercentCubit, TenPercentState>(
                    builder: (context, state) {
                      if (state.trafficFile!=null&&state.trafficFile!.isNotEmpty) {
                        return SizedBox(
                          width: double.infinity,
                          height: 300.h,
                          child: ImagePickerPlaceholder(
                            width: double.infinity,
                            height: 300.h,
                            image: Image.file(
                              File(state.trafficFile??''),
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      }
                      return SizedBox(
                        width: double.infinity,
                        height: 300.h,
                        child: ImagePickerPlaceholder(
                          title: LocaleKeys.selectBill.localize,
                        ),
                      );
                    },
                  ),
                ),
                const Sizer(),
                BillValueTextFormField(currentController: cubit.trafficController,validator: (p0) {
                  if (p0!.isEmpty&&(state.trafficId!=null&&state.trafficId!.isNotEmpty)) {
                    return LocaleKeys.enterBillValue.localize;
                  }
                  return null;
                },),
                const Sizer(),
                Label(text: LocaleKeys.electricityBill.localize,style: Styles.headerText(),),
                const Sizer(),
                InkWell(
                  onTap: () async {
                    await context.read<TenPercentCubit>().uploadElectricityBill(context: context);
                  },
                  child: BlocBuilder<TenPercentCubit, TenPercentState>(
                    builder: (context, state) {
                      if (state.electricityFile!=null&&state.electricityFile!.isNotEmpty) {
                        return SizedBox(
                          width: double.infinity,
                          height: 300.h,
                          child: ImagePickerPlaceholder(
                            width: double.infinity,
                            height: 300.h,
                            image: Image.file(
                              File(state.electricityFile??''),
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      }
                      return SizedBox(
                        width: double.infinity,
                        height: 300.h,
                        child: ImagePickerPlaceholder(
                          title: LocaleKeys.selectBill.localize,
                        ),
                      );
                    },
                  ),
                ),
                const Sizer(),
                BillValueTextFormField(currentController: cubit.electricityController, validator: (p0) {
                  if (p0!.isEmpty&&(state.electricityId!=null&&state.electricityId!.isNotEmpty)) {
                    return LocaleKeys.enterBillValue.localize;
                  }
                  return null;
                },),
                const Sizer(),
                Label(text: LocaleKeys.mobileBill.localize,style: Styles.headerText(),),
                const Sizer(),
                InkWell(
                  onTap: () async {
                    await context.read<TenPercentCubit>().uploadMobileBill(context: context);
                  },
                  child: BlocBuilder<TenPercentCubit, TenPercentState>(
                    builder: (context, state) {
                      if (state.mobileFile!=null&&state.mobileFile!.isNotEmpty) {
                        return SizedBox(
                          width: double.infinity,
                          height: 300.h,
                          child: ImagePickerPlaceholder(
                            width: double.infinity,
                            height: 300.h,
                            image: Image.file(
                              File(state.mobileFile??''),
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      }
                      return SizedBox(
                        width: double.infinity,
                        height: 300.h,
                        child: ImagePickerPlaceholder(
                          title: LocaleKeys.selectBill.localize,
                        ),
                      );
                    },
                  ),
                ),
                const Sizer(),
                BillValueTextFormField(currentController: cubit.mobileController, validator: (p0) {
                  if (p0!.isEmpty&&(state.mobileId!=null&&state.mobileId!.isNotEmpty)) {
                    return LocaleKeys.enterBillValue.localize;
                  }
                  return null;
                },),
                const Sizer(),
                SizedBox(
                  height: 80.h,
                  width: double.infinity,
                  child: state.isLoading?const Center(child: CircularProgressIndicator()):ElevatedButton(onPressed: (){
                   if(cubit.formKey.currentState!.validate()) {
                     if ((state.mobileId == null || state.mobileId == '') &&
                         (state.electricityId == null || state.electricityId == '') &&
                         (state.trafficId == null || state.trafficId == '')) {
                       showErrorMessage(context, LocaleKeys.uploadAtLeastOneBill.localize);
                     }else{
                       cubit.fetchAdRequests(context);
                     }
                   }
                  },
                            style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.SECONDARY_COLOR,
                            textStyle: TextStyle(color: Colors.white, fontSize: 20.sp)), child: Label(text: LocaleKeys.sendRequest.localize,style: Styles.headerText(color: Colors.white ),),
                            ),
                ),

              ],
            ),
          );
        }
      ),
    );
  }
}
