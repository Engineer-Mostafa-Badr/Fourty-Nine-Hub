import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/register/driver_register/presentation/cubit/driver_register_cubit.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';

import '../../../../../core/widget/custom_scaffold.dart';
import 'taps/choose_register_subcategories.dart';
import 'taps/enter_personal_info.dart';

class DriverRegister extends StatefulWidget {
  final String subCategoryId;

  const DriverRegister({super.key, required this.subCategoryId});

  @override
  State<DriverRegister> createState() => _DriverRegisterState();
}

class _DriverRegisterState extends State<DriverRegister> {
  @override
  void initState() {
    context.read<DriverRegisterCubit>().loadData(id: widget.subCategoryId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<DriverRegisterCubit>();
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        return (await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Are you sure?'),
                content: const Text('Do you want to close register'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Yes'),
                  ),
                ],
              ),
            )) ??
            false;
      },
      child: BlocBuilder<DriverRegisterCubit, DriverRegisterState>(
        builder: (context, state) {
          if (state.subCategory == null) {
            return ChooseRegisterSubcategories(
              subCategories: state.subCategories ?? [],
              onSelection: (SubCategoryEntity item) =>
                  controller.changeSubCategorySelection(item: item),
            );
          } else if (state.riderInfo == null) {
            return const EnterPersonalInfo(
              length: 5,
              index: 0,
              label: 'Enter Personal Info',
            );
          }
          return CustomScaffold(
            body: Container(),
          );
        },
      ),
    );
  }
}
