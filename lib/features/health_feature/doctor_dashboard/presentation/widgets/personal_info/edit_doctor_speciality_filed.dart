import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';

class EditDoctorSpecialityField extends StatelessWidget {
  const EditDoctorSpecialityField({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<SubCategoryEntity>(
      width: MediaQuery.of(context).size.width * 0.9,
      hintText: "Spiciality",
      dropdownMenuEntries: const [],
      onSelected: (value) {
        if (value != null) {}
      },
    );
  }
}
