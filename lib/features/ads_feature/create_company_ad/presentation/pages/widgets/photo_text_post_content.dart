import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/dynamic/list_view_pagination.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/data/models/company_advertise_model.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/cubit/company_advertise/company_advertise_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/cubit/company_advertise/company_advertise_state.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import '../../../../../../core/messages/messages.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../../../service_locator/service_locator.dart';
import '../../../data/repositories/company_advertise_repo/company_advertise_repo_impl.dart';
import 'build_item_photo_text_post.dart';

class PhotoAndTextPostContent extends StatelessWidget {
  const PhotoAndTextPostContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CompanyAdvertiseCubit, CompanyAdvertiseState>(
      listener: (BuildContext context, CompanyAdvertiseState state) {
        if (state is DeletePostSuccess) {
          showSuccessMessage(context, LocaleKeys.deleteSuccessfully.localize);
        }
      },
      builder: (BuildContext context, state) {
        var data=CompanyAdvertiseCubit.get(context).data;
        if(data.isNotEmpty) {
          return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: PaginationView<Advertises>(
            build: (scrollController, data) {
              return ListView.separated(
                itemBuilder: (context, index) => BuildItemPhotoTextPost(
                  length: data[index].media!.length,
                  advertises:data[index],
                ),
                separatorBuilder: (context, index) => const Divider(
                  color: AppColors.GREY_LIGHT_COLOR,
                  height: 30,
                  endIndent: 30,
                ),
                itemCount: data.length,
              );
            },
            fetchData: (paginationParams) {
              return context
                  .read<CompanyAdvertiseCubit>()
                  .fetchAdvertiseCompany(context,'photo_written', params: paginationParams);
            },
          ),
        );
        }
        return Center(
          child: Text(
            LocaleKeys.noPosts.localize,
            style: Styles.mediumText(fontSize: 34),
          ),
        );
      },
    );
  }
}
