import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/cubit/create_company_ad_cubit.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_audio_streaming/zego_uikit_prebuilt_live_audio_room.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../common/widgets/stateful/dynamic/pagination_view.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';
import '../../../domain/entities/company_ad_entity.dart';
import 'build_item_photo_post.dart';

class PhotoPostContent extends StatelessWidget {
  const PhotoPostContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: PaginationView<CompanyAdEntity>(
        loadingWidget: const SizedBox.shrink(),
        build: (scrollController, data) {
          return data.isNotEmpty
              ? ListView.separated(
            controller: scrollController,
            itemBuilder: (context, index) => BuildItemPhotoPost(
              // media: state.advertiseCompanyModel.data!.advertises![index].media![index],
              length: data[index].media!.length,
              advertises: data[index],
            ),
            separatorBuilder: (context, index) => const Divider(
              color: AppColors.GREY_LIGHT_COLOR,
              height: 30,
              endIndent: 30,
            ),
            itemCount: data.length,
          )
              : Center(
              child: Label(text: LocaleKeys.noPhotoPosts.localize));
        },
        fetchData: (PaginationParams paginationParams) {
          return context.read<CreateCompanyAdCubit>().getCompanyAdPosts(
            'photo',
            params: paginationParams,
          );
        },
      ),
    );
  }
}
