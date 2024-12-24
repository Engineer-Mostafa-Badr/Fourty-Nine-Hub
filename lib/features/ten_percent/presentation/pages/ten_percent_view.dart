import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/abstract/main_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/image_picker_placeholder.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/views/widgets/mneu/name/price_text_form_field.dart';
import 'package:fourtyninehub/features/ten_percent/presentation/cubit/ten_percent_cubit.dart';
import 'package:fourtyninehub/features/ten_percent/presentation/pages/widget/bill_value_field.dart';
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
      appBar: const BackAppBar(label: 'Ten Percent Cashback'),
      body: BlocBuilder<TenPercentCubit,TenPercentState>(
        builder: (context,state) {
          return ListView(
            padding: EdgeInsets.all(16.w),
            children: [
              Label(text: "Traffic violations",style: Styles.headerText(),),
              Sizer(),
              InkWell(
                onTap: () async {
                  await context.read<TenPercentCubit>().uploadProfileImage();
                },
                child: BlocBuilder<TenPercentCubit, TenPercentState>(
                  builder: (context, state) {
                    if (state.file!=null) {
                      return SizedBox(
                        width: double.infinity,
                        height: 300.h,
                        child: ImagePickerPlaceholder(
                          width: double.infinity,
                          height: 300.h,
                          image: Image.file(
                            File(state.file?.path??''),
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    }
                    return SizedBox(
                      width: double.infinity,
                      height: 300.h,
                      child: const ImagePickerPlaceholder(
                        title: 'Select Bill',
                      ),
                    );
                  },
                ),
              ),
              Sizer(),
              BillValueTextFormField(currentController: TextEditingController(), ),
              Sizer(),
              Label(text: "Electricity bill",style: Styles.headerText(),),
              Sizer(),
              InkWell(
                onTap: () async {
                  await context.read<TenPercentCubit>().uploadProfileImage();
                },
                child: BlocBuilder<TenPercentCubit, TenPercentState>(
                  builder: (context, state) {
                    if (state.file!=null) {
                      return SizedBox(
                        width: double.infinity,
                        height: 300.h,
                        child: ImagePickerPlaceholder(
                          width: double.infinity,
                          height: 300.h,
                          image: Image.file(
                            File(state.file?.path??''),
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    }
                    return SizedBox(
                      width: double.infinity,
                      height: 300.h,
                      child: const ImagePickerPlaceholder(
                        title: 'Select Bill',
                      ),
                    );
                  },
                ),
              ),
              Sizer(),
              BillValueTextFormField(currentController: TextEditingController(), ),
              Sizer(),
              Label(text: "Mobile bill",style: Styles.headerText(),),
              Sizer(),
              InkWell(
                onTap: () async {
                  await context.read<TenPercentCubit>().uploadProfileImage();
                },
                child: BlocBuilder<TenPercentCubit, TenPercentState>(
                  builder: (context, state) {
                    if (state.file!=null) {
                      return SizedBox(
                        width: double.infinity,
                        height: 300.h,
                        child: ImagePickerPlaceholder(
                          width: double.infinity,
                          height: 300.h,
                          image: Image.file(
                            File(state.file?.path??''),
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    }
                    return SizedBox(
                      width: double.infinity,
                      height: 300.h,
                      child: const ImagePickerPlaceholder(
                        title: 'Select Bill',
                      ),
                    );
                  },
                ),
              ),
              Sizer(),
              BillValueTextFormField(currentController: TextEditingController(), ),
              Sizer(),
              SizedBox(
                height: 60.h,
                width: double.infinity,
                child: ElevatedButton(onPressed: (){},
                          style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          textStyle: TextStyle(color: Colors.white, fontSize: 20.sp)), child: Label(text: 'text',style: Styles.headerText( ),),
                          ),
              ),

            ],
          );
        }
      ),
    );
  }
}
