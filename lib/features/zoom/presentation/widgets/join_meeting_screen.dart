import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/zoom/presentation/controller/stream_cubit.dart';
import 'package:fourtyninehub/features/zoom/presentation/pages/meeting_room.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

import '../../../../core/localization/locale_keys.g.dart';
import '../../../../routes/routes.dart';
import '../controller/stream_state.dart';

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
        return LocaleKeys.emptyFieldNotValid.localize;
      } else if (!regExp.hasMatch(value)) {
        return LocaleKeys.invalidInputValidator.localize;
      }
      if (value.length < 8) {
        return LocaleKeys.meetingMustBe8Characters.localize;
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

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_ios)),
        title: Label(
          text: LocaleKeys.joinMeeting.localize,
          style: Styles.headerText(fontSize: 30, fontWeight: FontWeight.bold),
        ),

        // 'Join a meeting',
        // style: TextStyle(
        //   fontSize: 20.sp,
        //   fontWeight: FontWeight.bold,
        //   color: AppColors.PRIMARY_COLOR,
        // ),
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
                  text: LocaleKeys.joinMeetingWithShareScreen.localize,
                  style: Styles.mediumText(
                      color: context.isDarkMode
                          ? Colors.white
                          : AppColors.PRIMARY_COLOR),
                ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.h),
                child: TextFormField(
                  controller: _meetingIdController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  validator: validateInput,
                  maxLength: 8,
                  onChanged: onTextChanged,
                  decoration: InputDecoration(
                    hintText: LocaleKeys.meetingId.localize,
                    // errorText: _errorMessage,
                    counterText: '',
                    labelStyle:
                        const TextStyle(color: AppColors.QUANTITY_COLOR),
                    hintStyle: const TextStyle(color: AppColors.QUANTITY_COLOR),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    filled: true,
                    fillColor: context.isDarkMode
                        ? AppColors.GREY_DARK_COLOR
                        : AppColors.GREY_LIGHT_COLOR,
                  ),
                ),
              ),
              // Label(
              //   text: 'Join with a Personal link name',
              //   style: Styles.mediumText(
              //       color: Colors.blue.shade900, fontSize: 25.sp),
              //   // style: TextStyle(color: AppColors.PRIMARY_COLOR),
              // ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.h),
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
                    fillColor: context.isDarkMode
                        ? AppColors.GREY_DARK_COLOR
                        : AppColors.GREY_LIGHT_COLOR,
                  ),
                ),
              ),
              BlocConsumer<StreamCubit, StreamState>(
                  listener: (context, state) {
                String meetingId = _meetingIdController.text.trim();

                if (state.isSuccess) {
                  // context.pop();
                  CliLogger.success('Success');
                  context.pushReplacement(
                    Routes.MEETINGROOM,
                    extra: MeetingRoomArguments(
                      liveID: meetingId,
                      isHost: context.read<StreamCubit>().isHost,
                      userName: _userNameController.text.trim().isNotEmpty
                          ? _userNameController.text.trim()
                          : context.read<UserCubit>().state.data!.fullName,
                      shareScreen: widget.shareScreen,
                    ),
                  );
                  showSuccessMessage(
                    context,
                    '${LocaleKeys.joinMeetingWithId.localize} $meetingId',
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
                          var cubit = context.read<StreamCubit>();
                          await joinRoom(cubit, meetingId);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(context.screenWidth * 0.8, 50),
                      backgroundColor: AppColors.PRIMARY_COLOR,
                    ),
                    child: Label(
                      text: LocaleKeys.joinMeeting.localize,
                      color: Colors.white,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> joinRoom(StreamCubit cubit, String liveId) async {
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
