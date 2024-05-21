import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/stateless/appbar/back_appbar.dart';
import '../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import 'package:semicircle_indicator/semicircle_indicator.dart';

class WalletView extends StatelessWidget {
  Widget walletInfo() {
    return Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(top: 20, bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.PRIMARY_COLOR.withAlpha(230),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            walletInfoCell(
                icon: Icons.wallet, label: 'Balance', value: '${100}'),
            walletInfoCell(
                icon: Icons.mobile_friendly_sharp,
                label: 'Total Payment',
                value: '${50}'),
            walletInfoCell(
                icon: Icons.refresh, label: 'Cashback', value: '${2000}')
          ],
        ));
  }

  Widget walletInfoCell({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          Label(
              text: label,
              style: Styles.mediumText(color: Colors.white, fontSize: 10)),
          Label(
              text: label,
              style: Styles.mediumText(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget walletActionRow(
      {required String title,
      required String subTitle,
      required Function onTap,
      required IconData icon}) {
    return ListTile(
      title: Label(text: title, style: Styles.mediumText(fontSize: 12)),
      subtitle: Label(
        text: subTitle,
        style: Styles.mediumText(fontSize: 10),
      ),
      leading: Container(
          height: kToolbarHeight * .7,
          width: kToolbarHeight * .7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.PRIMARY_COLOR,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 14,
          )),
      onTap: () => onTap(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Sizer(
                height: 20,
              ),
              SemicircularIndicator(
                color: AppColors.PRIMARY_COLOR,
                progress: .3,
                bottomPadding: 0,
                child: Text(
                  '${(.3 * 100).toStringAsFixed(2)} %',
                  style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: AppColors.PRIMARY_COLOR),
                ),
              ),
              walletInfo(),
              MaterialButton(
                onPressed: () {},
                color: Colors.red,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minWidth: double.infinity,
                child: Label(text: 'Withdrawal', style: Styles.mediumText()),
              ),

              Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Colors.grey,
                  ),
                  const Sizer(),
                  Expanded(
                      child: Label(
                    text: 'Minimum 1002 EGP for personal transaction',
                    style: Styles.mediumText(color: Colors.grey),
                  )),
                ],
              ),
              walletActionRow(
                  title: 'Subscriptions',
                  subTitle: 'Subscripe now and get the best limited offers',
                  onTap: () {},
                  icon: Icons.subject_sharp),
              const Divider(
                color: Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Label(
                      text: 'Transactions',
                      style: Styles.mediumText(fontWeight: FontWeight.bold)),
                  TextButton(
                      onPressed: () {},
                      child: Label(
                          text: 'show all',
                          style: Styles.mediumText(
                              color: AppColors.DARK_BLUE_COLOR)))
                ],
              ),
              ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return walletActionRow(
                        title: '-10 L.E',
                        subTitle: 'Canceled ride request',
                        onTap: () {},
                        icon: FontAwesomeIcons.car);
                  },
                  separatorBuilder: (context, index) => Container(),
                  itemCount: 4),

              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       'Wallet'.tr.text.bold.size(18.sp),
              //       SvgPicture.asset(
              //         'assets/settings/wallet_icon.svg',
              //         height: 20,
              //         width: 20,
              //       ),
              //     ],
              //   ),
              // ),
              // Container(
              //   height: 1,
              //   width: double.infinity,
              //   decoration: const BoxDecoration(color: Colors.black),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              // Card(
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.end,
              //       children: [
              //         const SizedBox(
              //           height: 10,
              //         ),
              //         Row(
              //           children: [
              //             'Balance'
              //                 .tr
              //                 .text
              //                 .bold
              //                 .size(14.sp)
              //                 .color(AppColors.mainColor),
              //             const Spacer(),
              //             '${wallet?.balance ?? 0} ${'EGP'.tr}'
              //                 .text
              //                 .size(12.sp),
              //             const SizedBox(
              //               width: 30,
              //             ),
              //           ],
              //         ),
              //         const SizedBox(
              //           height: 2,
              //         ),
              //         Padding(
              //           padding: const EdgeInsetsDirectional.fromSTEB(
              //             0,
              //             0,
              //             30,
              //             0,
              //           ),
              //           child: GestureDetector(
              //             onTap: controller.withdrawal,
              //             child: 'Minimum 1002 EGP for personal transaction'
              //                 .tr
              //                 .text
              //                 .size(10.sp)
              //                 .color(
              //                   controller.isMinimum1002Error.value
              //                       ? Colors.red
              //                       : Colors.black,
              //                 ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // MaterialButton(
              //   onPressed: controller.withdrawal,
              //   color: Colors.red,
              //   textColor: Colors.white,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              //   child: 'Withdrawal'.tr.text.size(12.sp),
              // ),
              // if (wallet?.fiveYears != null) const SizedBox(height: 10),
              // if (Get.find<FortyNineTabController>()
              //         .contestInfo
              //         .value
              //         ?.isMonthlyContestAvailable ==
              //     true)
              //   SizedBox(
              //     width: double.infinity,
              //     child: GestureDetector(
              //       onTap: () => Get.toNamed(Get.find<AppService>().isLogin
              //           ? Routes.MONTHLY_CONTEST
              //           : Routes.LOGIN_OR_REGISTER),
              //       child: Card(
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //         child: Padding(
              //           padding: const EdgeInsets.all(16),
              //           child:
              //               ' اشترك في اعلان مميز بقيمة ${NumberFormat.compactLong(locale: Get.locale!.languageCode).format(Get.find<FortyNineTabController>().contestInfo.value!.monthlyContestFees)} وادخل سحب شهري علي ${NumberFormat.compactLong(locale: Get.locale!.languageCode).format(Get.find<FortyNineTabController>().contestInfo.value!.monthlyContestReward)} جنيه مصري'
              //                   .text
              //                   .size(14.sp)
              //                   .bold
              //                   .color(AppColors.mainColor),
              //         ),
              //       ),
              //     ),
              //   ),
              // const SizedBox(height: 10),
              // // MaterialButton(
              // //   onPressed: () {},
              // //   color: AppColors.mainColor,
              // //   minWidth: double.infinity,
              // //   textColor: Colors.white,
              // //   child: const Padding(
              // //     padding: EdgeInsets.all(16.0),
              // //     child: Text(
              // //         'اشترك في اعلان مميز بقيمة ١'), // number from api
              // //   ),
              // // ),
              // if (wallet?.fiveYears != null)
              //   Card(
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.end,
              //         children: [
              //           const SizedBox(
              //             height: 10,
              //           ),
              //           Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               'Gift / 5 years'
              //                   .tr
              //                   .text
              //                   .bold
              //                   .size(14.sp)
              //                   .color(AppColors.mainColor),
              //               const Spacer(),
              //               '${wallet?.fiveYears?.round() ?? 0} ${'EGP'.tr}'
              //                   .text
              //                   .size(12.sp),
              //               const SizedBox(
              //                 width: 30,
              //               ),
              //             ],
              //           ),
              //           const SizedBox(
              //             height: 2,
              //           ),
              //           if (wallet != null)
              //             GestureDetector(
              //               onTap: controller.getFiveYearsGift,
              //               child: 'Personal transaction'
              //                   .tr
              //                   .text
              //                   .size(10.sp)
              //                   .color(
              //                     controller.isMinimum5YearsError.value
              //                         ? Colors.red
              //                         : Colors.black,
              //                   ),
              //             ),
              //         ],
              //       ),
              //     ),
              //   ),
              // if (wallet != null && wallet.fiveYears != null)
              //   Row(
              //     children: [
              //       const SizedBox(width: 10),
              //       const Icon(
              //         Icons.access_time_sharp,
              //         color: Colors.red,
              //         size: 12,
              //       ),
              //       const SizedBox(width: 5),
              //       Text(
              //         'number months left'.trArgs([
              //           (wallet.createdAt
              //                       .add(const Duration(days: 1800))
              //                       .difference(DateTime.now())
              //                       .inDays /
              //                   30)
              //               .round()
              //               .toString(),
              //         ]),
              //         style: const TextStyle(fontSize: 12),
              //       ),
              //       const Spacer(),
              //       MaterialButton(
              //         onPressed: controller.getFiveYearsGift,
              //         color: Colors.red,
              //         textColor: Colors.white,
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //         child: 'Transfer'.tr.text.size(12.sp),
              //       ),
              //     ],
              //   ),
              // if (wallet?.tenYears != null)
              //   const SizedBox(
              //     height: 10,
              //   ),
              // if (wallet?.tenYears != null)
              //   Card(
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.end,
              //         children: [
              //           const SizedBox(
              //             height: 10,
              //           ),
              //           Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               'Gift / 10 years'
              //                   .tr
              //                   .text
              //                   .bold
              //                   .size(14.sp)
              //                   .color(AppColors.mainColor),
              //               const Spacer(),
              //               '${wallet?.tenYears?.round() ?? 0} ${'EGP'.tr}'
              //                   .text
              //                   .size(12.sp),
              //               const SizedBox(
              //                 width: 30,
              //               ),
              //             ],
              //           ),
              //           const SizedBox(
              //             height: 2,
              //           ),
              //           if (wallet != null)
              //             GestureDetector(
              //               onTap: controller.getTenYearsGift,
              //               child: 'Personal transaction'
              //                   .tr
              //                   .text
              //                   .size(10.sp)
              //                   .color(
              //                     controller.isMinimum10YearsError.value
              //                         ? Colors.red
              //                         : Colors.black,
              //                   ),
              //             ),
              //           const SizedBox(
              //             width: 30,
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // if (wallet != null && wallet.tenYears != null)
              //   Row(
              //     children: [
              //       const SizedBox(width: 10),
              //       const Icon(
              //         Icons.access_time_sharp,
              //         color: Colors.red,
              //         size: 12,
              //       ),
              //       const SizedBox(width: 5),
              //       Text(
              //         'number months left'.trArgs([
              //           (wallet.createdAt
              //                       .add(const Duration(days: 3600))
              //                       .difference(DateTime.now())
              //                       .inDays /
              //                   30)
              //               .round()
              //               .toString(),
              //         ]),
              //         style: const TextStyle(fontSize: 12),
              //       ),
              //       const Spacer(),
              //       MaterialButton(
              //         onPressed: controller.getTenYearsGift,
              //         color: Colors.red,
              //         textColor: Colors.white,
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //         child: 'Transfer'.tr.text.size(12.sp),
              //       ),
              //     ],
              //   ),
              // Card(
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(8),
              //   ),
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: 8,
              //       vertical: 4,
              //     ),
              //     child: Padding(
              //       padding: const EdgeInsets.symmetric(vertical: 16),
              //       child: Row(
              //         children: [
              //           'Total Payment'
              //               .tr
              //               .text
              //               .bold
              //               .size(14.sp)
              //               .color(AppColors.mainColor),
              //           const Spacer(),
              //           '${wallet?.totalPayment ?? '0'} ${'EGP'.tr}'
              //               .text
              //               .size(12.sp),
              //           const SizedBox(
              //             width: 30,
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // Card(
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(8),
              //   ),
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: 8,
              //       vertical: 4,
              //     ),
              //     child: Padding(
              //       padding: const EdgeInsets.symmetric(vertical: 16),
              //       child: Row(
              //         children: [
              //           'Get Cashback'
              //               .tr
              //               .text
              //               .bold
              //               .size(14.sp)
              //               .color(AppColors.mainColor),
              //           const Spacer(),
              //           '${wallet?.totalCashback.toString() ?? '0'} ${'EGP'.tr}'
              //               .text
              //               .size(12.sp),
              //           const SizedBox(
              //             width: 30,
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              // SizedBox(
              //   width: double.infinity,
              //   child: Card(
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //     child: InkWell(
              //       onTap: () => Get.toNamed(Routes.USER_PAYMENT_DASHBOARD),
              //       borderRadius: BorderRadius.circular(8),
              //       child: Padding(
              //         padding: const EdgeInsets.symmetric(
              //           horizontal: 8,
              //           vertical: 4,
              //         ),
              //         child: Padding(
              //           padding: const EdgeInsets.symmetric(vertical: 16),
              //           child: 'Subscriptions'
              //               .tr
              //               .text
              //               .bold
              //               .size(14.sp)
              //               .color(AppColors.mainColor),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
