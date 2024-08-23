import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/default_button.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/all_trip_model/all_trip_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/trip_cubit.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class TripCardWidget extends StatefulWidget {
  TripCardWidget({super.key, required this.model, this.buttons = false});
  final AllTripModel model;
  final bool buttons;

  @override
  State<TripCardWidget> createState() => _TripCardWidgetState();
}

class _TripCardWidgetState extends State<TripCardWidget> {
  TextEditingController price = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    price.text = widget.model.price?.toStringAsFixed(0) ?? "0";
  }

  @override
  Widget build(BuildContext context) {
    var tripCubit = context.read<TripCubit>();
    return BlocConsumer<TripCubit, ShippingState>(
      listener: (context, state) {
        if (state is SuccessAcceptOfferState) {
          showSuccessMessage(context, state.message);
        }
        if (state is SuccessSendNewOfferState) {
          context.pop();
          showSuccessMessage(context, state.message);
        }
        if (state is SuccessAcceptPremiumOfferState) {
          showSuccessMessage(context, state.message);
        }
        if (state is FailureShippingState) {
          showErrorMessage(context, getFailureMessage(state.failure, context));
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            if (!widget.buttons) {
              context.push(Routes.DRIVERREQUESTSDETIALS, extra: widget.model);
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black38),
                borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'New Trip',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      '${widget.model.price?.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Divider(),
                const SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10)),
                ),
                const SizedBox(height: 5),
                const Divider(),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Text(
                      'From: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.red),
                    ),
                    Expanded(
                      child: Text(
                        widget.model.startLocation ?? "",
                        style: const TextStyle(fontSize: 12),
                        // overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Text(
                      'To: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.red),
                    ),
                    Expanded(
                      child: Text(
                        widget.model.targetLocation ?? "",
                        style: const TextStyle(fontSize: 12),
                        // overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Divider(),
                const SizedBox(height: 5),
                const Text(
                  'Description:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.red),
                ),
                Text(
                  widget.model.desc ?? "",
                  style: const TextStyle(fontSize: 12),
                  // overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                const Divider(),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Text(
                            'Date: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.red),
                          ),
                          Flexible(
                            child: Text(
                              widget.model.time!.split(":").first,
                              style: const TextStyle(fontSize: 12),
                              // overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'Time: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.red),
                          ),
                          Flexible(
                            child: Text(
                              "${widget.model.time!.split(":")[1]}:${widget.model.time!.split(":")[2]}",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (widget.buttons)
                  Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      // DefaultTextFormField(currentFocusNode: FocusNode(), currentController: TextEditingController(), hint: model.price.toString()),
                      // SizedBox(height: 15,),
                      Row(
                        children: [
                          // Expanded(
                          //   child: DefaultButton(
                          //     height: 50,
                          //     padding: EdgeInsets.zero,
                          //     borderRadius: BorderRadius.circular(7),
                          //     onPressed: () {
                          // tripCubit.newOffer(
                          //                     id: model.id ?? "",
                          //                     price: model.price??0, message: "The request has been successfully approved.");
                          //     },
                          //     label: "Accept Offer",
                          //   ),
                          // ),
                          Expanded(
                            child: AppButton(
                              style: Styles.mediumText(
                                  fontSize: 18, color: Colors.white),
                              label: "Send Offer",
                              onPressed: () {
                                tripCubit.newOffer(
                                    id: widget.model.id ?? "",
                                    price: widget.model.price ?? 0,
                                    message:
                                        "The request has been successfully approved.");
                              },
                              backColor: AppColors.PRIMARY_COLOR,
                              color: Colors.white,
                              // height: 40,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: DefaultTextFormField(
                              currentFocusNode: FocusNode(),
                              currentController: price,
                              hint: widget.model.price.toString(),
                              constraints: BoxConstraints(
                                maxHeight: kToolbarHeight * .6,
                                minHeight: kToolbarHeight * .6,
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          )
                          // Expanded(
                          //   child: AppButton(
                          //     // height: 50,
                          //     // padding: EdgeInsets.zero,
                          //     // borderRadius: BorderRadius.circular(7),
                          //     onPressed: () {
                          //       showDialog(
                          //         context: context,
                          //         builder: (context) {
                          //           return Dialog(
                          //             child: Container(
                          //               padding: const EdgeInsets.all(20),
                          //               margin: const EdgeInsets.symmetric(
                          //                   horizontal: 10),
                          //               width: double.infinity,
                          //               // height: 150,
                          //               decoration: BoxDecoration(
                          //                 color: Colors.white,
                          //                 borderRadius:
                          //                     BorderRadius.circular(20),
                          //               ),
                          //               child: Column(
                          //                 mainAxisSize: MainAxisSize.min,
                          //                 children: [
                          //                   Text(
                          //                     "New Offer",
                          //                     style: Styles.headerText(
                          //                         fontSize: 20,
                          //                         color: Colors.red),
                          //                   ),
                          //                   const SizedBox(
                          //                     height: 30,
                          //                   ),
                          //                   DefaultTextFormField(
                          //                     keyboardType:
                          //                         TextInputType.number,
                          //                     currentController: price,
                          //                     currentFocusNode: FocusNode(),
                          //                     hint: "Price",
                          //                   ),
                          //                   const SizedBox(
                          //                     height: 40,
                          //                   ),
                          //                   DefaultButton(
                          //                     onPressed: () {
                          //                       tripCubit.newOffer(
                          //                           id: model.id ?? "",
                          //                           price: double.parse(
                          //                               price.text,), message: "Your offer has been sent, please wait for a response.");
                          //                     },
                          //                     label: "Send New Offer",
                          //                     height: 55,
                          //                     width: double.infinity,
                          //                     padding: EdgeInsets.zero,
                          //                   )
                          //                 ],
                          //               ),
                          //             ),
                          //           );
                          //         },
                          //       );
                          //     },
                          //     label: "New Offer",
                          //     // backgroundColor: Colors.red,
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              label: Labels.call,
                              color: Colors.white,
                              icon: Icons.call,
                              backColor: AppColors.DARK_GRAY_COLOR,
                              onPressed: () {},
                              style: Styles.mediumText(
                                  fontSize: 18, color: Colors.white),
                            ),
                          ),
                          const Sizer(),
                          Expanded(
                            child: AppButton(
                              label: Labels.message,
                              icon: Icons.message,
                              backColor: AppColors.DARK_GRAY_COLOR,
                              style: Styles.mediumText(
                                  fontSize: 18, color: Colors.white),
                              onPressed: () {},
                            ),
                          ),
                          const Sizer(),
                          Expanded(
                            child: AppButton(
                              label: Labels.report,
                              icon: Icons.report,
                              backColor: Colors.red,
                              style: Styles.mediumText(
                                  fontSize: 18, color: Colors.white),
                              onPressed: () {
                                tripCubit.report();
                              },
                            ),
                          ),
                          // const Icon(
                          //   Icons.report,
                          //   color: Colors.red,
                          // )
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
