import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_support_details_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/dashboards_cubit/dashboards_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/support_screen/support_widget/custom_support_text_form_field.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

class SupportRideParams{
  final String tripId;
  final String tripType;
  final String userType;
  final String driverId;
  final String clientId;

  SupportRideParams({required this.tripId,required this.driverId,required this.clientId, required this.tripType, required this.userType});

}
class SupportRideScreen extends StatefulWidget {
  const SupportRideScreen({super.key, required this.params});
  final SupportRideParams params;
  @override
  State<SupportRideScreen> createState() => _SupportRideScreenState();
}

class _SupportRideScreenState extends State<SupportRideScreen> {
  final TextEditingController problemController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  @override
  initState() {

    context.read<DashboardsCubit>().getEmergencyDetails(context,widget.params);
    super.initState();
  }

  bool is_sent_request = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.support.localize),
        leadingWidth: 50.w,
      ),
      body: BlocBuilder<DashboardsCubit, DashboardsState>(builder: (context, state) {
        var cubit = context.read<DashboardsCubit>();
        if(state.isLoading){
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              CustomSupportTextField(hintText: LocaleKeys.writeYourProblem.localize, controller: problemController),
              SizedBox(height: 16.h),
              CustomSupportTextField(hintText: LocaleKeys.writeYourPhoneNumber.localize, controller: phoneController),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    is_sent_request = !is_sent_request;
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: is_sent_request ? AppColors.PRIMARY_COLOR.withOpacity(.7) : AppColors.PRIMARY_COLOR,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    is_sent_request ? LocaleKeys.requestSent.localize : LocaleKeys.requestEmergencySupport.localize,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              if (is_sent_request)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        LocaleKeys.waitingApproval.localize,
                        style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              // const SizedBox(
              //   height: 30,
              // ),
              // GestureDetector(
              //   onTap: () {
              //     context.push(Routes.supportClientDetailsScreen);
              //   },
              //   child: const Text(
              //     "go to client screen",
              //     style: TextStyle(
              //       color: Colors.red,
              //     ),
              //   ),
              // )
            ],
          ),
        );
      }),
    );
  }
}
