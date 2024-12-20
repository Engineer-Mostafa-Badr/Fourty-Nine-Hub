import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/labels/info_text.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../res/style/styles.dart';
import '../cubit/create_trip_rider_cubit.dart';

class CreateTripRider extends StatelessWidget {
  CreateTripRider({super.key});

  // Controllers for each field
  final TextEditingController pickupLocation = TextEditingController();
  final FocusNode pickupLocationFocusNode = FocusNode();
  final TextEditingController destinationLocation = TextEditingController();
  final FocusNode destinationLocationFocusNode = FocusNode();
  final TextEditingController distance = TextEditingController();
  final FocusNode distanceFocusNode = FocusNode();
  final TextEditingController duration = TextEditingController();
  final FocusNode durationFocusNode = FocusNode();
  final TextEditingController passengers = TextEditingController();
  final FocusNode passengersFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateTripRiderCubit(),
      child: BlocBuilder<CreateTripRiderCubit, CreateTripRiderState>(
        builder: (context, state) {
          return Column(
            children: [
              Form(
                key: context.read<CreateTripRiderCubit>().formKey,
                child: Column(
                  children: [
                    DefaultTextFormField(
                      currentController: pickupLocation,
                      hint: 'Pickup Location',
                      currentFocusNode: pickupLocationFocusNode,
                      suffixIcon: const Icon(Icons.location_on),
                      validator: (value) {
                        return context
                            .read<CreateTripRiderCubit>()
                            .validateForm(
                              message: 'Pickup Location is required',
                              condition: value == null || value.isEmpty,
                            );
                      },
                    ),
                    DefaultTextFormField(
                      currentController: destinationLocation,
                      hint: 'Destination Location',
                      currentFocusNode: destinationLocationFocusNode,
                      validator: (value) {
                        return context
                            .read<CreateTripRiderCubit>()
                            .validateForm(
                              message: 'Destination Location is required',
                              condition: value == null || value.isEmpty,
                            );
                      },
                    ),
                    DefaultTextFormField(
                      currentController: distance,
                      hint: 'Distance',
                      currentFocusNode: distanceFocusNode,
                      validator: (value) {
                        return context
                            .read<CreateTripRiderCubit>()
                            .validateForm(
                              message: 'Distance is required',
                              condition: value == null || value.isEmpty,
                            );
                      },
                    ),
                    DefaultTextFormField(
                      currentController: duration,
                      hint: 'Duration',
                      currentFocusNode: durationFocusNode,
                      validator: (value) {
                        return context
                            .read<CreateTripRiderCubit>()
                            .validateForm(
                              message: 'Duration is required',
                              condition: value == null || value.isEmpty,
                            );
                      },
                    ),
                    DefaultTextFormField(
                      currentController: passengers,
                      hint: 'Passengers',
                      currentFocusNode: passengersFocusNode,
                      validator: (value) {
                        return context
                            .read<CreateTripRiderCubit>()
                            .validateForm(
                              message: 'Passengers is required',
                              condition: value == null || value.isEmpty,
                            );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              const AppInfoText(
                text: Labels.theApplicationDoesNot,
              ),
              const SizedBox(height: 4),
              const AppInfoText(
                text: Labels.thePremiumPackageGivesYou,
              ),
              const SizedBox(height: 4),
              const AppInfoText(
                text: Labels.paymentInCash,
              ),
              const SizedBox(height: 4),
              const AppInfoText(
                text: Labels.freeCancellation,
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Flexible(
                      child: AppButton(
                        height: 40,
                        label: Labels.premiumRequest,
                        style: Styles.headerText(color: Colors.white),
                        onPressed: () {
                          // Perform actions for Premium Request
                        },
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: AppButton(
                        height: 40,
                        backColor: const Color(0xFF0B1135),
                        label: Labels.request,
                        style: Styles.headerText(color: Colors.white),
                        onPressed: () async {
                          context
                              .read<CreateTripRiderCubit>()
                              .validateAndSubmitForm();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
