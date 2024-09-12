import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/pages/widgets/build_item_text_post.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import '../../../../../../common/models/public/pagination_params.dart';
import '../../../../../../common/widgets/stateful/dynamic/pagination_view.dart';
import '../../../../../../core/enums/base_status_enum.dart';
import '../../../../../../core/messages/messages.dart';
import '../../../domain/entities/company_ad_entity.dart';
import '../../cubit/create_company_ad_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextPostContent extends StatefulWidget {
  const TextPostContent({super.key});

  @override
  State<TextPostContent> createState() => _TextPostContentState();
}

class _TextPostContentState extends State<TextPostContent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: BlocConsumer<CreateCompanyAdCubit, CreateCompanyAdState>(
        listener: (BuildContext context, CreateCompanyAdState state) {
          if (state.status == StateStatus.success) {
            showSuccessMessage(context, LocaleKeys.deleteSuccessfully.localize);
          }
        },
        builder: (BuildContext context, state) {
          return PaginationView<CompanyAdEntity>(
            loadingWidget: SizedBox.shrink(),
            build: (scrollController, data) {
              return data.isNotEmpty
                  ? ListView.separated(
                      controller: scrollController,
                      itemBuilder: (context, index) => BuildItemTextPost(
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
                        endIndent: 30,
                      ),
                      itemCount: data.length,
                    )
                  : Center(child: Label(text: LocaleKeys.noTextPosts.localize));
            },
            fetchData: (PaginationParams paginationParams) {
              return context.read<CreateCompanyAdCubit>().getCompanyAdPosts(
                    'written',
                    params: paginationParams,
                  );
            },
          );
        },
      ),
    );
  }
}
