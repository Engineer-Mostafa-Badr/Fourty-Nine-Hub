import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/bottom_navigator.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/riderequest_cubit.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../../core/messages/messages.dart';
import '../../../../../../../res/style/app_colors.dart';
import '../../../../../../../res/style/styles.dart';

class SelectDropOffPoints extends StatefulWidget {
  const SelectDropOffPoints({super.key});

  @override
  State<SelectDropOffPoints> createState() => _selectDropOffPointsState();
}

class _selectDropOffPointsState extends State<SelectDropOffPoints> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final rideCubit = context.read<RiderequestCubit>();

    return BlocConsumer<RiderequestCubit, RiderequestState>(
      listener: (context, state) {
        if (state.error) {
          showErrorMessage(context, state.errorMessage ?? 'Unkown error');
        }
      },
      builder: (context, state) {
        return Container(
          height: height * .7,
          padding: const EdgeInsets.all(10),
          decoration:  BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15), topLeft: Radius.circular(15))),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Label(
                    text: 'Enter Your route',
                    style: Styles.mediumText(fontWeight: FontWeight.bold),
                  )),
                  InkWell(
                    onTap: () {
                      context.pop();
                    },
                    child: const CircleAvatar(
                        child: Icon(
                          Icons.clear,
                        )),
                  )
                ],
              ),
              const Sizer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: kToolbarHeight * .7,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppColors.PRIMARY_COLOR,
                      radius: 8,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 4,
                      ),
                    ),
                    const Sizer(),
                    Expanded(
                        child: Text(
                      state.fromAddress?.address ?? 'Select Pickup location',
                      style: const TextStyle(
                        color: AppColors.QUANTITY_COLOR
                      ),
                      maxLines: 1,
                    )),
                  ],
                ),
              ),
              const Sizer(),
              DefaultTextFormField(
                maxLines: 1,
                currentFocusNode: rideCubit.toAddressFocusNode,
                currentController: rideCubit.toAddressTextController,
                prefixIcon: const Icon(Icons.location_on),
                suffixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppButton(
                        margin: 5,
                        label: LocaleKeys.search.localize,
                        color: AppColors.AUTH_CONTAINER_COLOR,
                        width: kToolbarHeight,
                        height: 30,
                        onPressed: () => rideCubit.loadNearByPlaces(
                            key: rideCubit.toAddressTextController.text)),
                  ],
                ),
                hint: 'To',
                hintColor: AppColors.QUANTITY_COLOR,
              ),
              const Sizer(),
              if (state.loading) const CircularProgressIndicator.adaptive(),
              if (state.nearByPlaces.isNotEmpty)
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        final item = state.nearByPlaces[index];
                        return InkWell(
                          onTap: () => rideCubit.selectPlace(
                              item: item, context: context),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                color: Colors.grey,
                              ),
                              const Sizer(),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Label(
                                    text: item.formattedAddress ?? '',
                                    style: Styles.mediumText(),
                                  ),
                                ],
                              )),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const Sizer(),
                      itemCount: state.nearByPlaces.length),
                )
            ],
          ),
        );
      },
    );
  }
}
