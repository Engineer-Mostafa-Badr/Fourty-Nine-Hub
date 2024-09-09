import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/cubit/create_company_ad_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import '../../../../../../common/widgets/stateful/dynamic/pagination_view.dart';
import '../../../domain/entities/company_ad_entity.dart';
import 'build_item_photo_text_post.dart';

class PhotoAndTextPostContent extends StatelessWidget {
  const PhotoAndTextPostContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateCompanyAdCubit, CreateCompanyAdState>(
      listener: (BuildContext context, CreateCompanyAdState state) {
        // if (state is DeletePostSuccess) {
        //   showSuccessMessage(context, LocaleKeys.deleteSuccessfully.localize);
        // }
      },
      builder: (BuildContext context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: PaginationView<CompanyAdEntity>(
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
                  .read<CreateCompanyAdCubit>()
                  .getCompanyAdPosts('photo_written',);
            },
          ),
        );
      },
    );
  }
}
