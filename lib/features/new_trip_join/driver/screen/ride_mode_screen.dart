import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/main_categories_cubit/main_categories_cubit.dart';
import 'package:fourtyninehub/features/new_trip_join/controllers/captain_share_dashboard_cubit/captain_share_dashboard_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import '../../../../res/assets/assets.dart';
import '../../../../routes/routes.dart';
import '../../presentation/view/widget/trip_option_widget.dart';

class NewRideModeScreen extends StatefulWidget {
  const NewRideModeScreen({super.key});

  @override
  State<NewRideModeScreen> createState() => _NewRideModeScreenState();
}

class _NewRideModeScreenState extends State<NewRideModeScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: HomeAppbar(
          isWithBackArrow: true,
          language: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
        ),),
      body: const NewRideModeBody(),
    );
  }
}

class NewRideModeBody extends StatelessWidget {
  const NewRideModeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<CaptainShareDashboardCubit>()..getSettings(context),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(15.w),
        child: BlocBuilder<CaptainShareDashboardCubit, CaptainShareDashboardState>(
          builder: (context, state) {
            var  cubit = context.read<CaptainShareDashboardCubit>();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row(
                //   children: [
                //     IconButton(
                //       onPressed: () {
                //         context.pop();
                //       },
                //       icon: const Icon(Icons.arrow_back),
                //     ),
                //     Text(
                //       context.isArabic ? 'وضع الركوب' : 'Ride Mode',
                //       style: TextStyle(
                //         fontSize: 35.sp,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ],
                // ),
                RideModeButton(
                  onTap: () {
                    context.push(Routes.runningAndPastTripsScreen);
                  },
                  isCaptain: state.isCaptain??false,
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TripOptionWidget(
                      imagePath: Assets.locationTripIcon,
                      title: context.isArabic ? 'مشاركة كابتن' : 'Captain\nShare',
                      onTap: () {
                        context.push(Routes.captainShareScreen);
                      },
                      iconColor: AppColors.getButtonPrimaryColor(context),
                    ),
                    TripOptionWidget(
                      icon: Assets.car,
                      imagePath: Assets.locationTripIcon,
                      title: context.isArabic ? "جاي معاك" : "Trip Join",
                      onTap: () {
                        context.push(Routes.AVAILABLE_TRIPS);
                      },
                      iconColor: AppColors.getButtonPrimaryColor(context),
                    ),
                    TripOptionWidget(
                      icon: Assets.pickMeIcon,
                      imagePath: Assets.locationTripIcon,
                      title: context.isArabic ? "وصلني معاك" : "Pick me",
                      onTap: () {
                        context.push(Routes.All_PickMe_View);
                      },
                      iconColor: AppColors.getButtonPrimaryColor(context),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class RideModeButton extends StatelessWidget {
  final void Function()? onTap;
  final bool isCaptain;

  const RideModeButton({
    super.key,
    this.onTap,
    required this.isCaptain,
  });

  // bool isServiceAvailable() {
  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        GestureDetector(
          onTap:  isCaptain==false ? null :onTap,
          child: Container(
            margin: EdgeInsets.all(5.w),
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              gradient:  isCaptain==false ? null :LinearGradient(
                colors: [
                  Color(0xffF33D49),
                  Color(0xffC0303A),
                  Color(0xffA72A32),
                  Color(0xff9A272E),
                  Color(0xff93252C),
                  Color(0xff90242B),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15), // حواف دائرية مثل الصورة
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withAlpha(55),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      context.isArabic ? 'وضع السائق' : 'Ride Mode',
                      style: TextStyle(
                        color: isCaptain==false ? AppColors.PRIMARY_COLOR : Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        isCaptain==false ? Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(context.isArabic?'يجب التسجيل في توصيله كابتن او سيدة اولا ':'You must register as a captain or lady first (From Ride).',
            style: Styles.mediumText(color: AppColors.SECONDARY_COLOR),
          ),
        ):SizedBox.shrink()
      ],
    );
  }
}
