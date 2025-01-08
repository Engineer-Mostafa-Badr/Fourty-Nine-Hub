import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
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
        appBar: BackAppBar(
          label: LocaleKeys.shareApp.localize,
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
                        text: LocaleKeys.recommendUs.localize,
                        style: Styles.headerText(),
                      ),
                      const Sizer(),
                      Label(
                        text: LocaleKeys.shareFodeFriends.localize,
                        maxLines: 5,
                      ),
                      const Sizer(),
                      _buildLinkWidget(
                          context: context,
                          referralGift: state.shareApp?.referralGift ?? 0),
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
              height: 50,
              width: double.infinity,
              color: AppColors.PRIMARY_COLOR,
              style: Styles.mediumText(
                  color: Theme.of(context).scaffoldBackgroundColor),
              label: '${LocaleKeys.yourReferralID.localize} $referralId'),
        ),
        const Sizer(),
        AppButton(
          color: AppColors.AUTH_CONTAINER_COLOR,
          label: LocaleKeys.shareTheApp.localize,
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
                title: LocaleKeys.userShare.localize,
                subTitle: '$user ${LocaleKeys.users.localize}'),
          ),
          const Sizer(),
          Expanded(
            child: _buildStatisticsItem(
                color: AppColors.PRIMARY_COLOR,
                title: LocaleKeys.balance.localize,
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

  // void initDynamicLinks() async {
  //   FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
  //     final Uri deepLink = dynamicLinkData.link;
  //     final referralId = deepLink.queryParameters['referralId'];
  //     if (referralId != null) {
  //       // Save the referral ID for later use
  //       await saveReferralId(referralId);
  //     }
  //   }).onError((error) {
  //     print('Error handling dynamic link: $error');
  //   });
  //
  //   // Handle deep link when app is launched from a terminated state
  //   final PendingDynamicLinkData? initialLink =
  //   await FirebaseDynamicLinks.instance.getInitialLink();
  //   if (initialLink != null) {
  //     final Uri deepLink = initialLink.link;
  //     final referralId = deepLink.queryParameters['referralId'];
  //     if (referralId != null) {
  //       await saveReferralId(referralId);
  //     }
  //   }
  // }
  //
  // Future<void> saveReferralId(String referralId) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('referralId', referralId);
  // }
  //
  // Future<String?> getReferralId() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('referralId');
  // }
}
