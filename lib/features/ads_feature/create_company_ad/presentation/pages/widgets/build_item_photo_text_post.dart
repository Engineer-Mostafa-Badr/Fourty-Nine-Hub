import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/pages/widgets/build_item_photo_post.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/pages/widgets/build_item_text_post.dart';

import '../../../../../../core/enums/base_status_enum.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../core/messages/messages.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../domain/entities/company_ad_entity.dart';
import '../../cubit/create_company_ad_cubit.dart';

class BuildItemPhotoTextPost extends StatelessWidget {
  const BuildItemPhotoTextPost({super.key, required this.length, required this.advertises, required this.onDeleteItem});
  final int length;
  final CompanyAdEntity advertises;
  final Function(String) onDeleteItem;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateCompanyAdCubit,CreateCompanyAdState>(
      listener: (BuildContext context, state) {
        if (state.status == StateStatus.success) {
          showSuccessMessage(context, LocaleKeys.deleteSuccessfully.localize);
        }
      },
      builder: (BuildContext context, Object? state) {
        return Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            Column(
              children: [
                BuildItemPhotoPost(length: length, advertises: advertises,isPhoto: false, onDeleteItem: (String ) {  },),
                BuildItemTextPost(advertises: advertises,isScalable: false, onDeleteItem: (String ) {  },),
              ],
            ),
            IconButton(
              onPressed: () {
                onDeleteItem(advertises.sId!);
              },
              icon: const Icon(
                Icons.close,
                color: AppColors.SECONDARY_COLOR,
                size: 25,
              ),
            ),
          ],
        );
      },
    );
  }
}
