import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/zoom/presentation/bloc/meeting_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

import '../../../../routes/routes.dart';
import '../../../../service_locator/service_locator.dart';
import '../bloc/meeting_state.dart';

class JoinMeetingScreen extends StatefulWidget {
  const JoinMeetingScreen({
    super.key,
    required this.shareScreen,
  });

  final bool shareScreen;

  @override
  State<JoinMeetingScreen> createState() => _JoinMeetingScreenState();
}

class _JoinMeetingScreenState extends State<JoinMeetingScreen> {
  final TextEditingController _meetingIdController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  // String? _errorMessage;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _meetingIdController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? validateInput(String? value) {
      // Regular expression to check for only numbers, slashes, and periods
      RegExp regExp = RegExp(r'^[0-9]*$');

      if (value == null || value.isEmpty) {
        return 'Please enter some text';
      } else if (!regExp.hasMatch(value)) {
        return 'Invalid input: Only numbers, /, and . are allowed';
      }
      if (value.length < 8) {
        return 'Meeting ID must be 8 numbers';
      }
      return null; // Input is valid
    }

    void onTextChanged(String value) {
      // Remove spaces from the input text
      String newValue = value.replaceAll(' ', '');
      if (newValue != value) {
        _meetingIdController.value = _meetingIdController.value.copyWith(
          text: newValue,
          selection:
              TextSelection.fromPosition(TextPosition(offset: newValue.length)),
        );
      }
    }

    return BlocProvider.value(
      value: serviceLocator<MeetingCubit>(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back_ios)),
          title: const Text(
            'Join a meeting',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.PRIMARY_COLOR,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            // bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                if (widget.shareScreen)
                  Label(
                    text: 'Join a Meeting with Share screen',
                    style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: TextFormField(
                    controller: _meetingIdController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    validator: validateInput,
                    maxLength: 8,
                    onChanged: onTextChanged,
                    decoration: const InputDecoration(
                      hintText: 'Meeting ID',
                      // errorText: _errorMessage,
                      counterText: '',
                      labelStyle: TextStyle(color: AppColors.QUANTITY_COLOR),
                      hintStyle: TextStyle(color: AppColors.QUANTITY_COLOR),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      filled: true,
                      fillColor: AppColors.GREY_LIGHT_COLOR,
                    ),
                  ),
                ),
                // Label(
                //   text: 'Join with a Personal link name',
                //   style: Styles.mediumText(
                //       color: Colors.blue.shade900, fontSize: 25),
                //   // style: TextStyle(color: AppColors.PRIMARY_COLOR),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: TextField(
                    controller: _userNameController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.name,
                    onSubmitted: (String meeetingId) {},
                    decoration: InputDecoration(
                      labelStyle:
                          const TextStyle(color: AppColors.QUANTITY_COLOR),
                      hintText: context.read<UserCubit>().state.data!.fullName,
                      hintStyle: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      filled: true,
                      fillColor: AppColors.GREY_LIGHT_COLOR,
                    ),
                  ),
                ),
                BlocConsumer<MeetingCubit, MeetingState>(
                    listener: (context, state) {
                  String meetingId = _meetingIdController.text.trim();

                  if (state.isSuccess) {
                    // context.pop();
                    CliLogger.success('Success');
                    context.push(
                      Routes.MEETINGROOM,
                      extra: ZegoArgs(
                        meetingId,
                        context.read<MeetingCubit>().isHost,
                        _userNameController.text.trim().isNotEmpty
                            ? _userNameController.text.trim()
                            : context.read<UserCubit>().state.data!.fullName,
                        shareScreen: widget.shareScreen,
                      ),
                    );
                    showSuccessMessage(
                      context,
                      'Joining meeting with ID: $meetingId',
                    );
                  } else if (state.isFailure) {}
                }, builder: (context, state) {
                  if (state.isLoading) {
                    return const CircularProgressIndicator.adaptive();
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String meetingId = _meetingIdController.text.trim();
                          if (meetingId.isEmpty) {
                            showErrorMessage(
                                context, 'Meeting ID cannot be empty');
                            // context.pop();
                            return;
                          } else {
                            var cubit = context.read<MeetingCubit>();
                            await joinRoom(cubit, meetingId);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(context.screenWidth * 0.8, 50),
                        backgroundColor: AppColors.PRIMARY_COLOR,
                      ),
                      child: const Label(
                        text: 'Join Meeting',
                        color: Colors.white,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> joinRoom(MeetingCubit cubit, String liveId) async {
  return cubit.joinNewMeeting(liveId);
}

//for passing args
class ZegoArgs {
  final String liveId;
  final String userName;
  final bool isHost;
  final bool shareScreen;

  ZegoArgs(this.liveId, this.isHost, this.userName, {this.shareScreen = false});
}
