import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/cubit/create_company_ad_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../../../common/widgets/stateful/dynamic/pagination_view.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../core/enums/base_status_enum.dart';
import '../../../../../../core/messages/messages.dart';
import '../../../domain/entities/company_ad_entity.dart';
import 'build_item_photo_post.dart';

class PhotoPostContent extends StatefulWidget {
  const PhotoPostContent({super.key});

  @override
  State<PhotoPostContent> createState() => _PhotoPostContentState();
}

class _PhotoPostContentState extends State<PhotoPostContent> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateCompanyAdCubit, CreateCompanyAdState>(
        listener: (BuildContext context, CreateCompanyAdState state) {
      if (state.status == StateStatus.success) {
        showSuccessMessage(context, LocaleKeys.deleteSuccessfully.localize);
      }
    }, builder: (context, state) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10.h),
        child: PaginationView<CompanyAdEntity>(
          //  loadingWidget: const SizedBox.shrink(),
          build: (scrollController, data) {
            return data.isNotEmpty
                ? ListView.separated(
                    controller: scrollController,
                    itemBuilder: (context, index) => BuildItemPhotoPost(
                      length: data[index].media!.length,
                      advertises: data[index],
                      onDeleteItem: (id) async {
                        var result = await context
                            .read<CreateCompanyAdCubit>()
                            .deleteCompanyAd(
                              id: id,
                            );
                        if (result == true) {
                          data.removeWhere((e) => e.sId == id);
                          setState(() {});
                        }
                      },
                    ),
                    separatorBuilder: (context, index) => Divider(
                      color: AppColors.GREY_LIGHT_COLOR,
                      height: 30.h,
                      endIndent: 20.w,
                      indent: 20.w,
                    ),
                    itemCount: data.length,
                  )
                : Center(child: Label(text: LocaleKeys.noPhotoPosts.localize));
          },
          fetchData: (PaginationParams paginationParams) {
            return context.read<CreateCompanyAdCubit>().getCompanyAdPosts(
                  'photo',
                  params: paginationParams,
                );
          },
        ),
      );
    });
  }
}
