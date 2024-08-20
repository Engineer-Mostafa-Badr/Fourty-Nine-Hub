import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/image_picker_placeholder.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/create_resturant_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:image_picker/image_picker.dart';

class CreateRestaurantLicensePhotoPicker extends StatelessWidget {
  const CreateRestaurantLicensePhotoPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final createRestaurantCubit = context.read<CreateRestaurantCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          text: "The commercial register",
          style: Styles.headerText(),
        ),
        const Sizer(),
        Row(
          children: [
            InkWell(
              onTap: () async {
                await createRestaurantCubit.uploadLicenseFirstPageImage();
              },
              child: BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
                buildWhen: (previous, current) =>
                    current is CreateRestaurantUploadLicenseFirstPageImage ||
                    current is CreateRestaurantInitial,
                builder: (context, state) {
                  if (state is CreateRestaurantUploadLicenseFirstPageImage) {
                    return ImagePickerPlaceholder(
                      image: XFile(state.file.path),
                    );
                  }
                  return const ImagePickerPlaceholder(
                    title: 'First Page',
                  );
                },
              ),
            ),
            const Sizer(),
            InkWell(
              onTap: () async {
                await createRestaurantCubit.uploadLicenseSecondPageImage();
              },
              child: BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
                buildWhen: (previous, current) =>
                    current is CreateRestaurantUploadLicenseSecondPageImage ||
                    current is CreateRestaurantInitial,
                builder: (context, state) {
                  if (state is CreateRestaurantUploadLicenseSecondPageImage) {
                    return ImagePickerPlaceholder(
                      fit: BoxFit.cover,
                      image: XFile(
                        state.file.path,
                      ),
                    );
                  }
                  return const ImagePickerPlaceholder(
                    title: 'Second Page',
                  );
                },
              ),
            ),
            const Sizer(),
            InkWell(
              onTap: () async {
                await createRestaurantCubit.uploadLicenseThiredPageImage();
              },
              child: BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
                buildWhen: (previous, current) =>
                    current is CreateRestaurantUploadLicenseThiredPageImage ||
                    current is CreateRestaurantInitial,
                builder: (context, state) {
                  if (state is CreateRestaurantUploadLicenseThiredPageImage) {
                    return ImagePickerPlaceholder(
                      image: XFile(state.file.path),
                    );
                  }
                  return const ImagePickerPlaceholder(
                    title: 'Thired Page',
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
