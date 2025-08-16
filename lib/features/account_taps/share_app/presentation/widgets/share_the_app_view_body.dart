import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/account_taps/share_app/presentation/cubit/share_app_cubit.dart';
import 'package:fourtyninehub/features/account_taps/share_app/presentation/cubit/share_app_state.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

class ShareTheAppViewBody extends StatelessWidget {
  const ShareTheAppViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShareAppCubit, ShareAppState>(
      builder: (BuildContext context, state) {
        if (state.status == ShareAppStates.success) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatisticsWidget(
                    context: context,
                    user: state.shareApp?.userCount ?? 0,
                    balance: state.shareApp?.shareBalance ?? 0,
                    gift: state.shareApp?.referralGift ?? 0,
                  ),
                  const Sizer(
                    height: 64,
                  ),
                  Image.asset(
                    Assets.share,
                    width: double.infinity,
                    height: 300,
                  ),
                  const Sizer(
                    height: 48,
                  ),
                  Center(
                    child: Label(
                      text: LocaleKeys.recommendUs.localize,
                      style: Styles.headerText(
                        color: context.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  Label(
                    text: LocaleKeys.shareFodeFriends.localize,
                    style: Styles.mediumText(
                      color: context.isDarkMode ? Colors.white : Colors.black,
                    ),
                    maxLines: 5,
                  ),
                  const Sizer(
                    height: 32,
                  ),
                  _buildLinkWidget(
                      context: context,
                      referralGift: state.shareApp?.referralGift ?? 0),
                  const Sizer(),
                ],
              ),
            ),
          );
        }
        return const Center(child: CustomCircularProgressIndicator());
      },
    );
  }

  Widget _buildStatisticsWidget({
    required BuildContext context,
    required num user,
    required num balance,
    required num gift,
  }) {
    return InkWell(
      onTap: () {
        ManageVibration.vibrate();
        context.pushNamed(Routes.WALLET);
      },
      child: Row(
        children: [
          Expanded(
            child: _buildStatisticsItem(
              context,
              color: AppColors.getButtonPrimaryColor(context),
              title: LocaleKeys.userShare.localize,
              subTitle: '$user',
            ),
          ),
          const Sizer(),
          Expanded(
            child: _buildStatisticsItem(
              context,
              color: AppColors.getButtonPrimaryColor(context),
              title: LocaleKeys.balance.localize,
              subTitle: '$balance',
            ),
          ),
          const Sizer(),
          Expanded(
            child: _buildStatisticsItem(context,
                color: AppColors.getButtonPrimaryColor(context),
                title: LocaleKeys.gift.localize,
                subTitle: '$gift'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsItem(
    BuildContext context, {
    required Color color,
    required String title,
    required String subTitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(5),
      height: 62,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Label(
            text: title,
            style: Styles.mediumText(
              color: AppColors.getReversedTextColor(context),
              fontSize: 32,
            ),
          ),
          Label(
            text: subTitle,
            style: Styles.mediumText(
              color: AppColors.getReversedTextColor(context),
              fontSize: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkWidget({
    required BuildContext context,
    required num referralGift,
  }) {
    final controller = context.read<ShareAppCubit>();
    final referralId = controller.state.shareApp?.referralId ?? '';

    return Column(
      children: [
        InkWell(
          onLongPress: () {
            Clipboard.setData(ClipboardData(text: referralId)).then((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(LocaleKeys.referralClipboard.localize)),
              );
            });
          },
          child: BadgedLabel(
              height: 52,
              width: double.infinity,
              color: AppColors.getButtonPrimaryColor(context),
              radius: 15,
              style: Styles.mediumText(
                color:
                    context.isDarkMode ? AppColors.PRIMARY_COLOR : Colors.white,
              ),
              label: '${LocaleKeys.yourReferralID.localize} $referralId'),
        ),
        const Sizer(
          height: 32,
        ),
        AppButton(
          color: AppColors.getRedColor(context),
          label: LocaleKeys.shareTheApp.localize,
          style: Styles.mediumText(
            color: AppColors.getReversedTextColor(context),
          ),
          radius: 15,
          height: 52,
          onPressed: () async {
            ManageVibration.vibrate();
            if (referralId.isNotEmpty) {
              await Share.share("""
سجل للحصول على $referralGift جنيه مصرى كهدية ترحيبية واستخدم التطبيق واحصل على استرداد نقدي فى معاملاتك وعندما تحصل على 1000 جنية مصرى سوف تحصل عليها نقداً

استخدم رمز الإحالة الخاص بي $referralId

إذا لم يكن لديك تطبيق 49 في هاتفك المحمول ، فقم بتحميله من المتجر

اندرويد

https://example.com/download
ايفون


https://example.com/download
""", subject: '49Hub');

              // Simulate backend call to fetch updated user count and balance
              bool isReferredUserDownloaded = await simulateReferralDownload();
              if (isReferredUserDownloaded) {
                // controller.updateShareStatistics(); // Call your cubit method to update statistics
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(LocaleKeys.referralSuccessful.localize)),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Referral ID not available.')),
              );
            }
          },
        ),
      ],
    );
  }

// Example simulated backend call (replace with your actual API call)
  Future<bool> simulateReferralDownload() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    return true; // Simulate successful referral
  }
}
