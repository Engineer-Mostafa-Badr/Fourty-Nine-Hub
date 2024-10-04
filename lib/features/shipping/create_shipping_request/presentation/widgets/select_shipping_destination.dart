import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/create_shipping_request_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/form/text_fields/default_text_form_field.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class SelectShippingDestination extends StatelessWidget {
  const SelectShippingDestination({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final rideCubit = context.read<CreateShippingRequestCubit>();

    return BlocBuilder<CreateShippingRequestCubit, CreateShippingRequestState>(
      builder: (context, state) {
        return Container(
          height: height * .7,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15), topLeft: Radius.circular(15))),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Label(
                    text: 'Enter Your route'.tr(),
                    style: Styles.mediumText(fontWeight: FontWeight.bold),
                  )),
                  InkWell(
                    onTap: () {
                      context.pop();
                    },
                    child: CircleAvatar(
                        backgroundColor: Colors.grey[50],
                        child: const Icon(
                          Icons.clear,
                        )),
                  )
                ],
              ),
              const Sizer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: kToolbarHeight * .7,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppColors.PRIMARY_COLOR,
                      radius: 8,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 4,
                      ),
                    ),
                    const Sizer(),
                    Expanded(
                        child: Text(
                      state.fromAddress?.address ?? 'Select Pickup location'.tr(),
                      maxLines: 1,
                    )),
                  ],
                ),
              ),
              const Sizer(),
              DefaultTextFormField(
                maxLines: 1,
                currentFocusNode: rideCubit.toAddressFocusNode,
                currentController: rideCubit.toAddressTextController,
                prefixIcon: const Icon(Icons.location_on),
                suffixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppButton(
                        margin: 5,
                        label: 'Search'.tr(),
                        width: kToolbarHeight,
                        height: 30.h,
                        onPressed: () => rideCubit.loadNearByPlaces(
                            key: rideCubit.toAddressTextController.text)),
                  ],
                ),
                hint: 'To'.tr(),
              ),
              const Sizer(),
              if (state.nearByPlaces.isNotEmpty)
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        final item = state.nearByPlaces[index];
                        return InkWell(
                          onTap: () => rideCubit.selectPlace(
                              item: item, context: context),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                color: Colors.grey,
                              ),
                              const Sizer(),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Label(
                                    text: item.formattedAddress ?? '',
                                    style: Styles.mediumText(),
                                  ),
                                ],
                              )),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const Sizer(),
                      itemCount: state.nearByPlaces.length),
                )
            ],
          ),
        );
      },
    );
  }
}
