import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/main_services_enum.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/registable_sub_categories_cubit/registable_subcategories_cubit.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/stateless/images/square_image.dart';
import '../../../../core/states/basic_state.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/styles.dart';

class RegisterOptions extends StatelessWidget {
  const RegisterOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(
            text: 'Join Us As',
            style: Styles.mediumText(fontWeight: FontWeight.w700),
          ),
          const Sizer(
            height: 3,
          ),
          BlocBuilder<RegistableSubCategoriesCubit,
              BasicState<List<SubCategoryEntity>>>(builder: (context, state) {
            return SizedBox(
              height: kToolbarHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                // scrollDirection: Axis.horizontal,
                children: [
                  _buildRegisterOptionItem(context,
                      isSvg: true,
                      label: 'Ride',
                      service: MainServicesEnum.ride,
                      image: Assets.ride),
                  _buildRegisterOptionItem(context,
                      isSvg: true,
                      label: 'Shipping',
                      service: MainServicesEnum.shipping,
                      image: Assets.shipping),
                  _buildRegisterOptionItem(context,
                      isSvg: true,
                      label: 'Restaurant',
                      service: MainServicesEnum.food,
                      image: Assets.food),
                  _buildRegisterOptionItem(context,
                      isSvg: true,
                      label: 'Doctor',
                      service: MainServicesEnum.health,
                      image: Assets.health),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRegisterOptionItem(BuildContext context,
      {required String label,
      bool isSvg = false,
      required String image,
      required MainServicesEnum service}) {
    return InkWell(
      onTap: () => context.go(Routes.REGISTERDRIVER, extra: service.id),
      child: Container(
        width: kToolbarHeight,
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey, width: .5)),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: isSvg
                    ? SvgPicture.asset(image)
                    : SquareImage(
                        url: image,
                      )),
            Label(
              text: label,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
