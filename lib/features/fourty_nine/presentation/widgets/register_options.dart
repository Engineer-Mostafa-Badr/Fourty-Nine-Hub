import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/registable_sub_categories_cubit/registable_subcategories_cubit.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/states/basic_state.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/styles.dart';
import '../controllers/parent_main_categories_cubit/main_categories_cubit.dart';

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
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...state.data?.map((e) {
                        return _buildRegisterOptionItem(context,
                            label: e.name, image: e.image);
                      }).toList() ??
                      [],
                   _buildRegisterOptionItem(context,
                      isSvg: true, label: 'Restaurant', image: Assets.food),
                  _buildRegisterOptionItem(context,
                      isSvg: true, label: 'Doctor', image: Assets.health),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRegisterOptionItem(BuildContext context,
      {required String label, bool isSvg = false, required String image}) {
    return InkWell(
      onTap: () => context.go(Routes.REGISTERDRIVER),
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
                child: isSvg ? SvgPicture.asset(image) : Image.network(image)),
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
