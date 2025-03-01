import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/global/upload_image.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';
import 'package:go_router/go_router.dart';

import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import '../widgets/close_widget.dart';
import '../widgets/register_floating_action_button.dart';
import '../widgets/upload_file_widget.dart';

class PersonalInformationScreen extends StatelessWidget {
  const PersonalInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const HomeAppbar(),
      floatingActionButton: registerFloatingActionButton(
        context,
        index: 1,
        onTap: () => context.push(Routes.driversLicenseScreen),
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<RideCubit, RideState>(
          builder: (context,state) {
            var cubit = context.read<RideCubit>();
            return Padding(
              padding: const EdgeInsets.only(bottom: 32,left: 16,right: 16,),
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  closeWidget(context),
                  Label(
                    text: LocaleKeys.personalInformation.localize,
                    style: Styles.headerText(
                        fontWeight: FontWeight.w500,
                        ),
                  ),
                  const Sizer(),
                  UploadFileWidget(title: LocaleKeys.personalPicture.localize,
                  onTap: (){
                    cubit.onUploadPersonalPicture(context);
                  }, imageUrl: state.personalPicture,
                  ),
                  const Sizer(),
                  DefaultTextFormField(
                    currentController: cubit.rideNameController,
                    fillColor: AppColors.GREYBG,
                    borderColor: Colors.transparent,
                    hint: LocaleKeys.firstName.localize,
                  ),
                  const Sizer(),
                  DefaultTextFormField(
                    currentController: cubit.rideSurNameController,
                    fillColor: AppColors.GREYBG,
                    borderColor: Colors.transparent,
                    hint: LocaleKeys.surname.localize,
                  ),
                  const Sizer(),
                  DefaultTextFormField(
                    currentController: cubit.rideDateOfBirthController,
                    fillColor: AppColors.GREYBG,
                    borderColor: Colors.transparent,
                    hint: LocaleKeys.user_info_date_of_birth.localize,
                  ),
                  const Sizer(),
                  DefaultTextFormField(
                    currentController: cubit.ridePhoneNumberController,
                    fillColor: AppColors.GREYBG,
                    borderColor: Colors.transparent,
                    hint: LocaleKeys.phoneNumber.localize,
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}
