import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/account_taps/share_app/presentation/cubit/share_app_state.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../routes/routes.dart';
import '../cubit/share_app_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShareTheApp extends StatelessWidget {
  const ShareTheApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BackAppBar(
          label: 'Share App',
        ),
        body: BlocProvider<ShareAppCubit>(
          create: (BuildContext context) => serviceLocator()..shareApp(),
          child: BlocBuilder<ShareAppCubit, ShareAppState>(
            builder: (BuildContext context, state) {
              if (state.status == ShareAppStates.success) {
                return Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatisticsWidget(
                        context: context,
                        user: state.shareApp?.userCount ?? 0,
                        balance: state.shareApp?.shareBalance ?? 0,
                      ),
                      const Sizer(),
                      Expanded(child: Image.asset(Assets.share)),
                      const Sizer(),
                      Label(
                        text: 'Recommend Us',
                        style: Styles.headerText(),
                      ),
                      const Sizer(),
                      const Label(
                        text:
                            'Share code with your friends and get 50 EGP for every one',
                        maxLines: 5,
                      ),
                      const Sizer(),
                      _buildLinkWidget(context: context,referralGift:state.shareApp?.referralGift ?? 0),
                      const Sizer(),
                    ],
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ));
  }

  Widget _buildLinkWidget({required BuildContext context,required num referralGift,}) {
    final controller = context.read<ShareAppCubit>();
    final referralId = controller.state.shareApp?.referralId ?? '';

    return Column(
      children: [
        InkWell(
          onLongPress: () {
            Clipboard.setData(ClipboardData(text: referralId)).then((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Referral ID copied to clipboard!')),
              );
            });
          },
          child: BadgedLabel(
            height: 50,
            width: double.infinity,
            color: AppColors.PRIMARY_COLOR,
            style: Styles.mediumText(),
            label: referralId.isNotEmpty
                ? 'Your Referral ID: $referralId'
                : 'Fetching Referral ID...',
          ),
        ),
        const Sizer(),
        AppButton(
          color: AppColors.AUTH_CONTAINER_COLOR,
          label: 'Share The App',
          onPressed: () async {
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
                  const SnackBar(
                      content:
                          Text('Referral was successful! Statistics updated.')),
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

  Widget _buildStatisticsWidget({
    required BuildContext context,
    required num user,
    required num balance,
  }) {
    return InkWell(
      onTap: () => context.push(Routes.WALLET),
      child: Row(
        children: [
          Expanded(
            child: _buildStatisticsItem(
                color: AppColors.PRIMARY_COLOR,
                title: 'Users',
                subTitle: '$user user'),
          ),
          const Sizer(),
          Expanded(
            child: _buildStatisticsItem(
                color: AppColors.PRIMARY_COLOR,
                title: 'Balance',
                subTitle: '$balance'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsItem({
    required Color color,
    required String title,
    required String subTitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Label(
            text: title,
            style: Styles.mediumText(color: Colors.white),
          ),
          Label(
            text: subTitle,
            style: Styles.mediumText(color: Colors.white),
          ),
        ],
      ),
    );
  }

}
