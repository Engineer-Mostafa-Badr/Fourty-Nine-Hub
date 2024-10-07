import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/pages/ads_view.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/user_ads.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/user_filter_ads.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/categorization_entity.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class UserAdsView extends StatelessWidget {
  const UserAdsView({super.key, required this.params, required this.userType});
  final AdsViewParams params;
  final String userType;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvertisementCubit, AdsState>(
        builder: (context,state) {
          final controller = context.read<AdvertisementCubit>();
          return Column(
            children: [
              Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Container(
                      margin: EdgeInsetsDirectional.all(10.w),
                      child: BadgedLabel(label: LocaleKeys.filter.localize,
                          onTap: () async{
                            dynamic data = await context.push(Routes.FILTERADS,extra:CategorizationEntity(mainCategory: params.mainCategory,subCategory: params.subCategory) );
                            if(state.hasFilter==true){
                              Future.delayed(const Duration(seconds: 1),()=>controller.changeState(data,data!=null));
                              context.read<AdvertisementCubit>().loadFilterData(
                                  model: data,
                                  filter:userType);
                            }else{
                              Future.delayed(const Duration(seconds: 1),()=>controller.changeState(data,data!=null));
                            }
                          }
                      ))),
              Expanded(
                  child: state.hasFilter==false?UserAds(params: params, userType: userType,):
                  UserFilterAds(userType: userType,params: params, model: state.filterModel!,)
              )            ],
          );
        }
    );
  }
}
