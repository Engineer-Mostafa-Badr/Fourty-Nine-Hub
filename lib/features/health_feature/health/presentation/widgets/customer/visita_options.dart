import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/subcategories/data/models/sub_category_model.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../../../routes/routes.dart';


class VisitaOptions extends StatelessWidget {
  final List<SubCategoryModel> options;
  const VisitaOptions({super.key, required this.options});
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1,
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10),
        shrinkWrap: true,
        itemCount: options.length,
        itemBuilder: (context, index) {
          return _buildVisitaOptionItem(context: context, item: options[index]);
        });
  }

  Widget _buildVisitaOptionItem(
      {required BuildContext context, required SubCategoryModel item}) {
    return InkWell(
      onTap: () => context.push(Routes.VISITADOCTORLIST),
      child: Container(
        // margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: AppColors.LIGHT_COLOR,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(item.image),
            ),
            const Sizer(),
            Label(text: item.name, style: Styles.mediumText())
          ],
        ),
      ),
    );
  }
}
