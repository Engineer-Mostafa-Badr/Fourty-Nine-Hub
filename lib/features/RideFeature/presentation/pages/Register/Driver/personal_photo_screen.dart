import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/ride_register/ride_register_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/Register/Driver/upload_rider_images.dart';
import 'package:go_router/go_router.dart';

import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import '../widgets/upload_file_widget.dart';

class PersonalPhotoScreen extends StatelessWidget {
  const PersonalPhotoScreen({super.key, required this.params});
  final UploadRiderImagesParams params;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(30),
        child: HomeAppbar(),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: BlocBuilder<RideRegisterCubit, RideRegisterState>(
                builder: (context,state) {
                  var cubit = context.read<RideRegisterCubit>();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 32,left: 16,right: 16,),
                    child: Form(
                      key: cubit.personalPhotoFormKey,
                      child: Column(
                        spacing: 4,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // closeWidget(context),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Label(
                                text: LocaleKeys.personalPhoto.localize,
                                style: Styles.headerText(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              IconButton(
                                onPressed: () => context.pop(),
                                icon: Icon(
                                  Icons.close,
                                  color: context.isDarkMode ? Colors.white : AppColors.GREY_DARK_COLOR,
                                ),
                              )
                            ],
                          ),
                          const Sizer(),
                          UploadFileWidget(
                            title: LocaleKeys.personalPhoto.localize,
                            onTap: (){
                              cubit.onUploadPersonalPicture(context);

                            },
                            imageUrl:state.personalPicture,
                          ),
                          // const Sizer(),
                          // DefaultTextFormField(
                          //   currentController: cubit.rideDriverLicenseNumController,
                          //   fillColor: AppColors.GREYBG,
                          //   borderColor: Colors.transparent,
                          //   hint: LocaleKeys.licenseNumber.localize,
                          // ),
                        ],
                      ),
                    ),
                  );
                }
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 32,top: 8.0,right: 12,left: 12,),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: AppColors.GREYBG,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.PRIMARY_COLOR,
                    ),
                  ),
                ),
                const Sizer(),
                InkWell(
                  onTap: () {
                    print("object");
                    if(context.read<RideRegisterCubit>().state.personalPicture==null){
                      showErrorMessage(context, "Please select technical examination");
                    }else{
                      context.read<RideRegisterCubit>().onSubmitUploadingPersonalPhoto(context,params);
                    }
                  },
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.PRIMARY_COLOR,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Label(
                          text: LocaleKeys.submit.localize,
                          style: Styles.headerText(
                            fontWeight: FontWeight.w400,
                            color: AppColors.AUTH_CONTAINER_COLOR,
                          ),
                        ),
                        const Sizer(),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.AUTH_CONTAINER_COLOR,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
