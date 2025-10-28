import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/tube/presentation/cubit/tube_cubit.dart';
import 'package:fourtyninehub/features/tube/presentation/screens/add_talent_widget.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class CreateTubeScreen extends StatefulWidget {
  const CreateTubeScreen({super.key});

  @override
  State<CreateTubeScreen> createState() => _CreateTubeScreenState();
}

class _CreateTubeScreenState extends State<CreateTubeScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      enableCustomAppBar: true,
      appBar: BackAppBar(
        label: LocaleKeys.addStar.localize,
      ),
      body: BlocProvider(
        create: (context) => serviceLocator<TubeCubit>(),
        child: BlocBuilder<TubeCubit, TubeState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: AddTubeWidget(
                titleController: titleController,
                descController: descController,
                formKey: formKey,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.getTextColor(context),
            ),
          ),
          TextFormField(
            maxLines: null,
            controller: controller,
            style: Styles.headerText(fontSize: 55.sp),
            decoration: InputDecoration(
              fillColor: context.isDarkMode
                  ? AppColors.GREY_DARK_COLOR
                  : AppColors.LIGHT_COLOR,
              contentPadding: const EdgeInsets.all(5),
              hintText: label,
              hintStyle: Styles.mediumText(),
              prefix: Sizer(width: 20.w),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return LocaleKeys.required.localize;
              }
              return null;
            },
          ),
        ],
      );
}