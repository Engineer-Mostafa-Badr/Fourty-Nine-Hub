import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import '../widgets/register_floating_action_button.dart';

class WelcomeRideRegister extends StatefulWidget {
  const WelcomeRideRegister({super.key});
  @override
  State<WelcomeRideRegister> createState() => _WelcomeRideRegisterState();
}

class _WelcomeRideRegisterState extends State<WelcomeRideRegister> {

  @override
  void initState() {
    context.read<RideCubit>().loadRegisterData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return CustomScaffold(
      appBar: const HomeAppbar(),
      body: BlocBuilder<RideCubit, RideState>(
        builder: (context,state) {
          var cubit = context.read<RideCubit>();
          return Column(
            children: [
              Expanded(
                child: Padding(
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
                                state.isShipping==true?state.shippingSubCategories?.where((e)=>e.isEnabled==true).toList().length??0:state.rideSubCategories?.where((e)=>e.isEnabled==true).toList().length??0,
                                (index) {
                                  var list = state.isShipping==true?state.shippingSubCategories?.where((e)=>e.isEnabled==true).toList():state.rideSubCategories?.where((e)=>e.isEnabled==true).toList();
                                  var subCategory = list?[index];
                                  return  InkWell(
                                    onTap: () {
                                      if(state.isShipping==true){
                                        cubit.onSelectShippingSubCategory(subCategory?.subCategoryId??'',context);
                                      }else{
                                        cubit.onSelectSubCategory(subCategory?.subCategoryId??'',context);
                                      }
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
              ),
              RegisterNextRow(
                onTap: () {
                  if(state.isShipping==true){
                    if(state.shippingSubCategories?.where((e)=>e.isSelected==true).toList().isEmpty??false){
                      showErrorMessage(context, context.isArabic?'يجب اختيار صنف واحد على الاقل':'Please select at least one category');
                      return;
                    }else{
                      cubit.onSubmitSelectShippingSubCategories(context);
                    }
                  }else{
                    if(state.rideSubCategories?.where((e)=>e.isSelected==true).toList().isEmpty??false){
                      showErrorMessage(context, context.isArabic?'يجب اختيار صنف واحد على الاقل':'Please select at least one category');
                      return;
                    }else{
                      cubit.onSubmitSelectSubCategories(context);
                    }
                  }
                },
              )
            ],
          );
        }
      ),
    );
  }
}
