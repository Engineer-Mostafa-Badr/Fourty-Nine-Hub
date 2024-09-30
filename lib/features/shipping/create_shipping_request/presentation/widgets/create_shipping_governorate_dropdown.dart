// import 'package:flutter/material.dart';

// class CreateShippingGovernorateDropdown extends StatelessWidget {
//   const CreateShippingGovernorateDropdown({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
//       buildWhen: (previous, current) =>
//           current is CreateDoctorGovernoratesLoaded,
//       builder: (context, state) {
//         if (state is CreateDoctorGovernoratesLoaded) {
//           return DropdownMenu(
//               width: MediaQuery.of(context).size.width * 0.9,
//               hintText: "Governorate",
//               dropdownMenuEntries: state.governorates
//                   .map((e) => DropdownMenuEntry(value: e, label: e.nameEn))
//                   .toList(),
//               onSelected: (value) {
//                 if (value != null) {
//                   createDoctorCubit.selectGovernorate(value);
//                 }
//               });
//         } else {
//           return SizedBox.shrink();
//         }
//       },
//     );
//   }
// }
