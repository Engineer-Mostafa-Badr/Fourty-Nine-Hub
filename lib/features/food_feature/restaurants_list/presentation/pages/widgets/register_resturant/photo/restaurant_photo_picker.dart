import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/image_picker_placeholder.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/create_resturant_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:image_picker/image_picker.dart';

class CreateRestaurantProfilePhotoPicker extends StatefulWidget {
  const CreateRestaurantProfilePhotoPicker({super.key});

  @override
  State<CreateRestaurantProfilePhotoPicker> createState() =>
      _CreateRestaurantProfilePhotoPickerState();
}

class _CreateRestaurantProfilePhotoPickerState
    extends State<CreateRestaurantProfilePhotoPicker> {
  @override
  Widget build(BuildContext context) {
    final createRestaurantCubit = context.read<CreateRestaurantCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          text: "Photo For Restaurant",
          style: Styles.headerText(),
        ),
        const Sizer(),
        BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
          buildWhen: (previous, current) =>
              current is CreateRestaurantUploadProfileImage ||
              current is CreateRestaurantInitial,
          builder: (context, state) {
            return Wrap(
              runSpacing: 10,
              spacing: 10,
              children: [
                if (state is CreateRestaurantUploadProfileImage) ...[
                  ...state.files.map(
                    (e) => ImagePickerPlaceholder(
                      title: e.path.split('/').last,
                      image: XFile(e.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
                InkWell(
                  onTap: () async {
                    await createRestaurantCubit.uploadProfileImage();
                  },
                  child: const ImagePickerPlaceholder(),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
