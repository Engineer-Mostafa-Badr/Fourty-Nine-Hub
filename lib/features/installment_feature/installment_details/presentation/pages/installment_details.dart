import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/auth_helper.dart';
import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_entity.dart';
import 'package:fourtyninehub/features/installment_feature/installment_details/presentation/cubit/installment_details_cubit.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/functions/helper/launch_url.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';

import '../../../../../common/widgets/stateless/dynamic/carousel_slider.dart';
import '../../../../../common/widgets/stateless/images/square_image.dart';
import '../../../../../common/widgets/stateless/labels/read_more_label.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../res/style/const.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';

class InstallmentsDetails extends StatefulWidget {
  final String installmentId;
  const InstallmentsDetails({super.key, required this.installmentId});

  @override
  State<InstallmentsDetails> createState() => _InstallmentsDetailsState();
}

class _InstallmentsDetailsState extends State<InstallmentsDetails> {
  @override
  void initState() {
    context
        .read<InstallmentDetailsCubit>()
        .loadData(installmentId: widget.installmentId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<InstallmentDetailsCubit>();
    return BlocConsumer<InstallmentDetailsCubit, InstallmentDetailsState>(
      listener: (context, state) {
        if (state.isError && state.failure != null) {
          showErrorMessage(
            context,
            getFailureMessage(
              state.failure!,
              context,
            ),
          );
        } else if (state.isSuccess && state.successMessage != null) {
          showSuccessMessage(context, state.successMessage ?? '');
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: const BackAppBar(),
          body: state.isLoading
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ListView(
                    children: [
                      _buildAdInfoWidget(ad: state.installment!.ad!),
                      _buildPlansWidget(context: context),
                      AppButton(
                          label:
                              '${Labels.buyWithInstallment} ${NumbersHelper.formatThousands(number: state.selectedPlan?.installment ?? 0)} ${Labels.currency} / ${Labels.month}',
                          onPressed: () {
                            if (AuthHelper().isLoggedIn()) {
                              controller.buyWithInstallment(
                                  installmentId: widget.installmentId);
                            } else {
                              context.push(Routes.LOGIN);
                            }
                          }),
                      _buildDetailsWidget(ad: state.installment!.ad!),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildAdInfoWidget({required AdEntity ad}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CarouselSliderWidget(
          height: kToolbarHeight * 2,
          widgets: ad.images.map((e) {
            return SquareImage(
              source: NetworkImage(e),
              fit: BoxFit.cover,
            );
          }).toList(),
        ),
        Label(
          text: ad.title,
          style: Styles.mediumText(fontWeight: FontWeight.bold),
        ),
        InkWell(
          onTap: () => LaunchURLHelper().openLocation(
              lat: ad.address?.coordinates[0] ?? 0,
              lng: ad.address?.coordinates[1] ?? 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined),
              Sizer(),
              Expanded(child: Label(text: ad.address?.address ?? '')),
              Sizer(),
              Label(text: ad.formatedDate)
            ],
          ),
        ),
        Sizer(),
        Label(
          text: 'Description',
          style: Styles.mediumText(fontWeight: FontWeight.bold),
        ),
        Label(text: ad.description),
      ],
    );
  }

  Widget _buildDetailsWidget({required AdEntity ad}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          text: Labels.details,
          style: Styles.mediumText(fontWeight: FontWeight.bold),
        ),
        ListView.builder(
            itemCount: ad.details.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final detail = ad.details[index];
              return Container(
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5),
                decoration: BoxDecoration(
                    color: index.isEven
                        ? AppColors.LIGHT_GRAY_COLOR
                        : Colors.white),
                child: Row(
                  children: [
                    Expanded(child: Label(text: getLang()=='ar'?detail.value.nameAr:detail.value.nameEn)),
                    Expanded(child: Label(text: getLang()=='ar'?detail.value.nameAr:detail.value.nameEn)),
                  ],
                ),
              );
            }),
      ],
    );
  }

  Widget info() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        infoItem(icon: Icons.delivery_dining, label: 'Free Delivery'),
        Label(
            text: Labels.description,
            style: Styles.mediumText(fontWeight: FontWeight.bold)),
        Sizer(),
        const ReadMoreLabel(text: UIConst.placeholderText),
      ],
    );
  }

  Widget infoItem({
    required IconData icon,
    required String label,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.PRIMARY_COLOR,
          size: 20,
        ),
        Sizer(),
        Expanded(child: Label(text: label, style: Styles.mediumText()))
      ],
    );
  }

  Widget _buildPlansWidget({required BuildContext context}) {
    final controller = context.read<InstallmentDetailsCubit>();
    return BlocBuilder<InstallmentDetailsCubit, InstallmentDetailsState>(
      builder: (BuildContext context, InstallmentDetailsState state) {
        return RichText(
            text: TextSpan(
                children: state.installment?.plans?.map((e) {
                      return WidgetSpan(
                          child: InkWell(
                        onTap: () => controller.changeInstallmentPlan(v: e),
                        child: Container(
                          margin: EdgeInsets.all(3),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2.h),
                          decoration: BoxDecoration(
                              color: e == state.selectedPlan
                                  ? AppColors.SECONDARY_COLOR
                                  : null,
                              borderRadius: BorderRadius.circular(5),
                              border: e == state.selectedPlan
                                  ? null
                                  : Border.all(color: Colors.grey)),
                          child: Label(
                              text: '${e.duration} ${Labels.months}',
                              style: Styles.mediumText(
                                  color: e == state.selectedPlan
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ));
                    }).toList() ??
                    []));
      },
    );
  }

  Widget _buildHeaderWidget() {
    return Column(
      children: [
        const SquareImage(
            height: kToolbarHeight * 3,
            width: double.infinity,
            fit: BoxFit.cover,
            source: NetworkImage(UIConst.productImage)),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Label(
                      text: '100 EGP/month',
                      style: Styles.headerText(color: AppColors.PRIMARY_COLOR)),
                  Label(
                      text: 'Nike',
                      style: Styles.headerText(color: AppColors.PRIMARY_COLOR)),
                ],
              ),
              RichText(
                  text: TextSpan(
                      children: [0, 1, 2, 3, 4, 5].map((e) {
                return WidgetSpan(
                    child: Container(
                  margin: EdgeInsets.all(3),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2.h),
                  decoration: BoxDecoration(
                      color: e == 0 ? AppColors.SECONDARY_COLOR : null,
                      borderRadius: BorderRadius.circular(5),
                      border: e == 0 ? null : Border.all(color: Colors.grey)),
                  child: Label(
                      text: '${(6 + e * 3)} Months',
                      style: Styles.mediumText(
                          color: e == 0 ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold)),
                ));
              }).toList())),
              Label(
                  text: 'Nike Shoes',
                  style: Styles.mediumText(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}
