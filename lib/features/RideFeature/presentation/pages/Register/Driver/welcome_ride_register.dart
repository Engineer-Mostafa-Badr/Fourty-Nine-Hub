import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import '../widgets/register_floating_action_button.dart';

class WelcomeRideRegister extends StatefulWidget {
  const WelcomeRideRegister({super.key});

  @override
  State<WelcomeRideRegister> createState() => _WelcomeRideRegisterState();
}

class _WelcomeRideRegisterState extends State<WelcomeRideRegister> {

  @override
  void initState() {
    context.read<RideCubit>().loadRegisterData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return CustomScaffold(
      appBar: const HomeAppbar(),
      floatingActionButton: registerFloatingActionButton(
        context,
        onTap: () {
            context.push(Routes.personalInformationScreen);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 32,left: 16,right: 16,),
        child: BlocBuilder<RideCubit, RideState>(
          builder: (context,state) {
            var cubit = context.read<RideCubit>();
            if(state.isLoading){
              return const Center(child: CircularProgressIndicator(),);
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(
                  text: LocaleKeys.welcomeToRideRegister.localize,
                  style: Styles.headerText(
                      fontWeight: FontWeight.w500,
                      color: AppColors.SECONDARY_COLOR),
                ),
                const Sizer(),
                const Sizer(),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio: 1.3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: List.generate(
                      state.rideSubCategories?.where((e)=>e.isEnabled==true).toList().length??0,
                      (index) {
                        var list = state.rideSubCategories?.where((e)=>e.isEnabled==true).toList();
                        var subCategory = list?[index];
                        return  InkWell(
                          onTap: () {
                            cubit.onSelectSubCategory(subCategory?.subCategoryId??'');
                            // bottomSheet(
                            //   context: context,
                            //   widget: Column(
                            //     mainAxisSize: MainAxisSize.min,
                            //     children: [
                            //       Row(
                            //
                            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //
                            //         children: [
                            //           Container(
                            //             decoration: const BoxDecoration(
                            //               shape: BoxShape.circle,
                            //             ),
                            //             width: 50,
                            //             height: 50,
                            //             clipBehavior: Clip.antiAliasWithSaveLayer,
                            //             child: Image.asset(
                            //               Assets.maleImagePlaceholder,
                            //             ),
                            //           ),
                            //           Container(
                            //             decoration: const BoxDecoration(
                            //               shape: BoxShape.circle,
                            //               color: AppColors.PRIMARY_COLOR,
                            //             ),
                            //             width: 50,
                            //             height: 50,
                            //             padding: EdgeInsets.all(12),
                            //             clipBehavior: Clip.antiAliasWithSaveLayer,
                            //             child: Image.asset(
                            //               Assets.phone,
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //     ],
                            //   ),
                            // );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: subCategory?.isSelected==true
                                    ? AppColors.GREYBG
                                    : Colors.transparent),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // ImageFromInternet(image: subCategory?.picture??'',height: 50,width: 50,fit: BoxFit.cover,),
                                Image.network(
                                  subCategory?.picture??'',
                                  width: 50,
                                ),
                                const Sizer(),
                                Label(
                                  text: context.isArabic?subCategory?.subCategoryNameAr??'':subCategory?.subCategoryNameEn??'',
                                  style: Styles.mediumText(
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}
