import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/pages/widgets/build_item_photo_post.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/pages/widgets/build_item_text_post.dart';

import '../../../../../../res/style/app_colors.dart';
import '../../../data/models/company_advertise_model.dart';
import '../../cubit/company_advertise/company_advertise_cubit.dart';
import '../../cubit/company_advertise/company_advertise_state.dart';
import '../../cubit/create_company_ad_cubit.dart';

class BuildItemPhotoTextPost extends StatelessWidget {
  const BuildItemPhotoTextPost({super.key, required this.length, required this.advertises});
  final int length;
  final Advertises advertises;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CompanyAdvertiseCubit,CompanyAdvertiseState>(
      listener: (BuildContext context, state) {  },
      builder: (BuildContext context, Object? state) {
        return Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            Column(
              children: [
                BuildItemPhotoPost(length: length, advertises: advertises,isPhoto: false,),
                BuildItemTextPost(advertises: advertises,isScalable: false,),
              ],
            ),
            IconButton(
              onPressed: () {
                context.read<CreateCompanyAdCubit>().deleteCompanyAd(id: advertises.sId!);
               // context
                    // .read<CompanyAdvertiseCubit>()
                    // .deletePost(context, advertises.sId!, 'photo_witten');
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
