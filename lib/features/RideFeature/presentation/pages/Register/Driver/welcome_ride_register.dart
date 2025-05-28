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
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/ride_register/ride_register_cubit.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import '../widgets/register_floating_action_button.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

class WelcomeRideRegister extends StatefulWidget {
  const WelcomeRideRegister({super.key, required this.isShipping});
  final bool isShipping;
  @override
  State<WelcomeRideRegister> createState() => _WelcomeRideRegisterState();
}

class _WelcomeRideRegisterState extends State<WelcomeRideRegister> {
  @override
  void initState() {
    if(widget.isShipping) {
      context.read<RideRegisterCubit>().fetchShippingCategories(UserCubit.to.state.data?.id ?? "",false);
      context.read<RideRegisterCubit>().fetchShippingCategories(UserCubit.to.state.data?.id ?? "",true);
    }else{
      context.read<RideRegisterCubit>().fetchRideCategories(UserCubit.to.state.data?.id ?? "",false);
      context.read<RideRegisterCubit>().fetchRideCategories(UserCubit.to.state.data?.id ?? "",true);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(30),
        child: HomeAppbar(),
      ),
      body: BlocBuilder<RideRegisterCubit, RideRegisterState>(
        builder: (context,state) {
          var cubit = context.read<RideRegisterCubit>();
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32,left: 16,right: 16,),
                  child: BlocBuilder<RideRegisterCubit, RideRegisterState>(
                    builder: (context,state) {
                      var cubit = context.read<RideRegisterCubit>();
                      if(state.isLoading){
                        return const Center(child: CustomCircularProgressIndicator(),);
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
                                widget.isShipping==true?state.shippingSubCategories?.where((e)=>e.isEnabled==true).toList().length??0:state.rideSubCategories?.where((e)=>e.isEnabled==true).toList().length??0,
                                (index) {
                                  var list = widget.isShipping==true?state.shippingSubCategories?.where((e)=>e.isEnabled==true).toList():state.rideSubCategories?.where((e)=>e.isEnabled==true).toList();
                                  var subCategory = list?[index];
                                  return  InkWell(
                                    onTap: () {
                                      if(widget.isShipping==true){
                                        cubit.onSelectShippingSubCategory(subCategory?.subCategoryId??'',context);
                                      }else{
                                        cubit.onSelectSubCategory(subCategory?.subCategoryId??'',context);
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: subCategory?.isSelected==true
                                              ?context.isDarkMode?AppColors.GREY_DARK_COLOR: AppColors.GREYBG
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
                                              color: context.isDarkMode?Colors.white:Colors.black,
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
                  if(widget.isShipping==true){
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
