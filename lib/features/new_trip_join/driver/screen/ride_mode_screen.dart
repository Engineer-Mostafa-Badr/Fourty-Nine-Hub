import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/ride_mode_screen.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/main_categories_cubit/main_categories_cubit.dart';
import 'package:fourtyninehub/features/new_trip_join/controllers/captain_share_dashboard_cubit/captain_share_dashboard_cubit.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
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
      ManageVibration.vibrate();
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
        ),
      ),
      body: const NewRideModeBody(),
    );
  }
}

class NewRideModeBody extends StatelessWidget {
  const NewRideModeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          serviceLocator<CaptainShareDashboardCubit>()..getSettings(context),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(15.w),
        child:
            BlocBuilder<CaptainShareDashboardCubit, CaptainShareDashboardState>(
          builder: (context, state) {
            var cubit = context.read<CaptainShareDashboardCubit>();
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
      ManageVibration.vibrate();
                      context.push(Routes.runningAndPastTripsScreen);
                    },
                    onRefreshSettings: () {
                      cubit.getSettings(context);
                    },
                    isCaptain:
                        state.setting?.data.isCaptainShareEnabled ?? false,
                    isReady: state.setting?.data.isReady ?? false,
                    isRegistered: state.setting != null,
                    isApproved: state.setting?.data.isApproved ?? false),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TripOptionWidget(
                      imagePath: Assets.locationTripIcon,
                      title:
                          context.isArabic ? 'مشاركة كابتن' : 'Captain\nShare',
                      onTap: () {
      ManageVibration.vibrate();
                        context.push(Routes.captainShareScreen);
                      },
                      iconColor: AppColors.getButtonPrimaryColor(context),
                    ),
                    TripOptionWidget(
                      icon: Assets.car,
                      imagePath: Assets.locationTripIcon,
                      title: context.isArabic ? "جاي معاك" : "Trip Join",
                      onTap: () {
      ManageVibration.vibrate();
                        context.push(Routes.AVAILABLE_TRIPS);
                      },
                      iconColor: AppColors.getButtonPrimaryColor(context),
                    ),
                    TripOptionWidget(
                      icon: Assets.pickMeIcon,
                      imagePath: Assets.locationTripIcon,
                      title: context.isArabic ? "وصلني معاك" : "Pick me",
                      onTap: () {
      ManageVibration.vibrate();
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
  final Function()? onRefreshSettings;
  final bool isCaptain;
  final bool isReady;
  final bool isRegistered;
  final bool isApproved;

  const RideModeButton({
    super.key,
    this.onTap,
    this.onRefreshSettings,
    required this.isCaptain,
    required this.isReady,
    required this.isRegistered,
    required this.isApproved,
  });

  // bool isServiceAvailable() {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: isRegistered == false
    ? () async {
        ManageVibration.vibrate();
        await context.push(Routes.welcomeRideRegister, extra: false);
        if (onRefreshSettings != null) onRefreshSettings!();
      }
    : (isApproved == false)
        ? () async {
            ManageVibration.vibrate();
            await context.push(Routes.RIDE_HOME);
            if (onRefreshSettings != null) onRefreshSettings!();
          }
        : (isReady == false || isCaptain == false)
            ? () async {
                ManageVibration.vibrate();
                await context.push(Routes.rideModeScreen,
                    extra: const RideModeParams(
                        modeType: 'ride',
                        isSocket: true,
                        currentIndex: 3));

                if (onRefreshSettings != null) onRefreshSettings!();
              }
            : () {
                ManageVibration.vibrate();
                onTap?.call();
              },
          child: Container(
            margin: EdgeInsets.all(5.w),
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              gradient: isCaptain == false
                  ? null
                  : LinearGradient(
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
                        color: isCaptain == false
                            ? AppColors.PRIMARY_COLOR
                            : Colors.white,
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
        if (isCaptain == false || isReady == false || isRegistered == false)
          ClickableWidget(
            onTap: () async {
              ManageVibration.vibrate();
              if (isRegistered == false) {
                await context.push(Routes.welcomeRideRegister, extra: false);
                if (onRefreshSettings != null) onRefreshSettings!();
              } else if (isApproved == false) {
                await context.push(Routes.RIDE_HOME);
                if (onRefreshSettings != null) onRefreshSettings!();
              } else if (isReady == false || isCaptain == false) {
                await context.push(Routes.rideModeScreen,
                    extra: const RideModeParams(
                        modeType: 'ride', isSocket: true, currentIndex: 3));

                if (onRefreshSettings != null) onRefreshSettings!();
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                (isRegistered == false
                    ? context.isArabic
                        ? 'يجب التسجيل في توصيله'
                        : 'You need to register as a Rider'
                    : isApproved == false
                        ? context.isArabic
                            ? 'في انتظار موافقة التسجيل.'
                            : 'Waiting for registration approval.'
                        : isReady == false
                            ? context.isArabic
                                ? "أنت لست مستعدًا!\n إذا كنت مستعدًا، يرجى الانتقال إلى الإعدادات وتغيير حالتك."
                                : "you are not ready!\nif you are ready, please go to settings and change your status."
                            : context.isArabic
                                ? "عليك تفعيل ميزة مشاركة كابتن من الاعدادات."
                                : "You need to enable the Captain sharing feature from the settings."),
                textAlign: TextAlign.center,
                style: Styles.mediumText(color: AppColors.SECONDARY_COLOR),
              ),
            ),
          )
        else
          SizedBox.shrink()
      ],
    );
  }
}
