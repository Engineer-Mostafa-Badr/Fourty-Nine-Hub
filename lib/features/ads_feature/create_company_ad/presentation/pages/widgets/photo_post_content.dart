import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/cubit/company_advertise/company_advertise_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/cubit/company_advertise/company_advertise_state.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/pages/widgets/build_item_text_post.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import '../../../../../../core/error/custom_error.dart';
import '../../../../../../core/loading/custom_loading.dart';
import '../../../../../../service_locator/service_locator.dart';
import '../../../data/repositories/company_advertise_repo/company_advertise_repo_impl.dart';
import 'build_item_photo_post.dart';

class PhotoPostContent extends StatelessWidget {
  const PhotoPostContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
      CompanyAdvertiseCubit(serviceLocator.get<CompanyAdvertiseRepoImpl>())
        ..fetchAdvertiseCompany(context, 'photo'),
      child: BlocBuilder<CompanyAdvertiseCubit, CompanyAdvertiseState>(
        builder: (BuildContext context, state) {
          if (state is FetchAllCompanyAdvertiseSuccess) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ListView.separated(
                itemBuilder: (context, index) => BuildItemPhotoPost(
                  media: state.advertiseCompanyModel.data!.advertises![index].media![0],
                  length: state.advertiseCompanyModel.data!.advertises![index].media!.length,
                ),
                separatorBuilder: (context, index) => const Divider(
                  color: AppColors.GREY_LIGHT_COLOR,
                  height: 30,
                  endIndent: 30,
                ),
                itemCount: state.advertiseCompanyModel.data!.advertises!.length,
              ),
            );
          } else if (state is FetchAllCompanyAdvertiseError) {
            return CustomError(
              errMessage: state.errMessage,
            );
          }
          return const CustomLoading();
        },
      ),
    );
  }
}