import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/create_shipping_request_cubit.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/images/square_image.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import 'select_shipping_destination.dart';
import 'shipping_details_widget.dart';

class FromAndToWidget extends StatelessWidget {
  const FromAndToWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      // margin: const EdgeInsets.all(kToolbarHeight),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubcategoriesWidget(context: context),
          const Sizer(),
          _buildFromWidget(context: context),
          const Sizer(),
          _buildToWidget(context: context),
          const Sizer(),
          AppButton(
              label: LocaleKeys.continueKey.tr(),
              onPressed: () {
                bottomSheet(
                    isScrollControlled: true,
                    context: context,
                    widget: const ShippingDetailsWidget());
              }),
          Sizer(
            height: 20.h,
          ),
        ],
      ),
    );
  }

  Widget _buildToWidget({required BuildContext context}) {
    return BlocBuilder<CreateShippingRequestCubit, CreateShippingRequestState>(
        builder: (context, state) {
      return InkWell(
        onTap: () {
          bottomSheet(
              context: context, widget: const SelectShippingDestination());
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: kTextTabBarHeight * .7,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.search,
                color: Colors.grey,
              ),
              const Sizer(),
              Expanded(
                  child: Label(
                text: state.toAddress?.address ??
                    LocaleKeys.selectDropOffLocation.tr(),
                style: Styles.mediumText(),
                maxLines: 1,
              )),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildFromWidget({required BuildContext context}) {
    return BlocBuilder<CreateShippingRequestCubit, CreateShippingRequestState>(
        builder: (context, state) {
      return state.fromAddress != null
          ? InkWell(
              onTap: () {},
              child: Container(
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
                      state.fromAddress?.address ??
                          LocaleKeys.selectPickupLocation.tr(),
                      maxLines: 1,
                    )),
                  ],
                ),
              ),
            )
          : const Sizer();
    });
  }

  Widget _buildSubcategoriesWidget({required BuildContext context}) {
    final controller = context.read<CreateShippingRequestCubit>();
    return BlocBuilder<CreateShippingRequestCubit, CreateShippingRequestState>(
      builder: (context, state) {
        return state.subCategories?.isNotEmpty ?? false
            ? SizedBox(
                height: kTextTabBarHeight * 1,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final subCategory = state.subCategories![index];
                      return InkWell(
                        onTap: () => controller.changeSubCategorySelection(
                            item: subCategory),
                        onDoubleTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: state.subCategory == subCategory
                                  ? AppColors.SECONDARY_COLOR
                                  : AppColors.DARK_GRAY_COLOR,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: SquareImage(
                                    fit: BoxFit.fitHeight,
                                    width: 50,
                                    source: NetworkImage(subCategory.image),
                                  )),
                                  Label(
                                      text: context.isArabic
                                          ? subCategory.nameAr
                                          : subCategory.nameEn,
                                      style: Styles.mediumText()),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const Sizer(),
                    itemCount: state.subCategories?.length ?? 0),
              )
            : const SizedBox();
      },
    );
  }
}
