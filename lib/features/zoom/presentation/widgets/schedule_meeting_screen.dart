import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/time_of_day_helper.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/zoom/presentation/bloc/meeting_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../res/style/styles.dart';

class ScheduleMeetingScreen extends StatefulWidget {
  const ScheduleMeetingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ScheduleMeetingScreenState createState() => _ScheduleMeetingScreenState();
}

class _ScheduleMeetingScreenState extends State<ScheduleMeetingScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  final _titleController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final _dateFormat = DateFormat('MM/dd/yyyy');
  // final _timeFormat = DateFormat('h:mm a');

  @override
  void dispose() {
    _titleController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      barrierDismissible: true,
      locale: context.locale,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.PRIMARY_COLOR, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: AppColors.PRIMARY_COLOR, // Body text color
            ),
            dialogBackgroundColor:
                Colors.white, // Background color of the dialog
          ),
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.PRIMARY_COLOR, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: AppColors.PRIMARY_COLOR, // Body text color
            ),
            dialogBackgroundColor:
                Colors.white, // Background color of the dialog
          ),
          child: child!,
        );
      },
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  @override
  initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _startTime = TimeOfDay.now();
    _endTime = TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 1);
    // _focusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 16.0,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0)
              .add(EdgeInsets.symmetric(vertical: 25.h)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Label(
                      text: LocaleKeys.cancel.localize,
                      style: Styles.headerText(
                        color: AppColors.SECONDARY_COLOR,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Label(
                      text: LocaleKeys.scheduleAMeeting.localize,
                      style: Styles.headerText(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: context.isDarkMode
                              ? Colors.white
                              : AppColors.PRIMARY_COLOR)),
                  TextButton(
                    onPressed: () async {
                      final title = _titleController.text;
                      if (title.isNotEmpty &&
                          _selectedDate != null &&
                          _endTime != null) {
                        if (_endTime!.isBefore(_startTime!)) {
                          showErrorMessage(context,
                              LocaleKeys.startDateTimeValidation.localize);

                          return;
                        }
                        if (_startTime!.isBefore(TimeOfDay.now())) {
                          showErrorMessage(context,
                              LocaleKeys.startDateBeginValidation.localize);

                          return;
                        }
                        await context.read<MeetingCubit>().createNewMeeting(
                              startTime: _combineDateAndTime(
                                _selectedDate!,
                                _startTime!,
                              ),
                              endTime: _combineDateAndTime(
                                _selectedDate!,
                                _endTime!,
                              ),
                              title: _titleController.text.trim(),
                            );

                        if (context.mounted) {
                          context.pushReplacementNamed(Routes.ZOOM);
                        }
                      } else {
                        showErrorMessage(
                            context, LocaleKeys.pleaseFillAllFields.localize);
                      }
                    },
                    child: Label(
                      text: LocaleKeys.done.localize,
                      style: Styles.headerText(
                        fontSize: 25,
                        color: AppColors.PRIMARY_COLOR,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              // Meeting Title
              TextField(
                focusNode: _focusNode,
                controller: _titleController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  // labelText: 'Meeting Title',
                  hintText: LocaleKeys.meetingTitle.localize,
                  border: const OutlineInputBorder(),
                  fillColor: context.isDarkMode
                      ? AppColors.GREY_DARK_COLOR
                      : AppColors.GREY_LIGHT_COLOR,
                ),
              ),
              SizedBox(height: 16.h),
              // Date Picker
              _buildDateTimeSelection(
                title: LocaleKeys.date.localize,
                content: _selectedDate != null
                    ? _dateFormat.format(_selectedDate!)
                    : 'Select date',
                onTap: () => _selectDate(context),
              ),
              SizedBox(height: 16.h),
              // Start Time Picker
              _buildDateTimeSelection(
                title: LocaleKeys.from.localize,
                content: _startTime != null
                    ? _startTime!.format(context)
                    : LocaleKeys.selectADate.localize,
                onTap: () => _selectTime(context, true),
              ),
              SizedBox(height: 16.h),
              // End Time Picker
              _buildDateTimeSelection(
                title: LocaleKeys.to.localize,
                content: _endTime != null
                    ? _endTime!.format(context)
                    : 'Select end time',
                onTap: () => _selectTime(context, false),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildDateTimeSelection({
    required String title,
    required String content,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Label(
                  text: title,
                  style: Styles.headerText(
                      fontSize: 25,
                      color: context.isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Container(),
                ),
                Label(
                  text: content,
                  style: Styles.headerText(
                    fontSize: 20,
                    color: context.isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: context.isDarkMode ? Colors.white70 : Colors.black54,
                  size: 15,
                )
              ],
            ),
          ),
          const Divider()
        ],
      ),
    );
  }

  DateTime _combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }
}
