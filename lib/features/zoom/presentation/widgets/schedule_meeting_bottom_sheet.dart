import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/time_of_day_helper.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/zoom/presentation/bloc/meeting_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ScheduleMeetingScreen extends StatefulWidget {
  const ScheduleMeetingScreen({super.key});

  @override
  _ScheduleMeetingScreenState createState() => _ScheduleMeetingScreenState();
}

class _ScheduleMeetingScreenState extends State<ScheduleMeetingScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  final _titleController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final _dateFormat = DateFormat('MM/dd/yyyy');
  final _timeFormat = DateFormat('h:mm a');

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
          print(_startTime);
        } else {
          _endTime = picked;
          print(_endTime);
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
    _focusNode.requestFocus();
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
              .add(const EdgeInsets.symmetric(vertical: 25)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: AppColors.SECONDARY_COLOR),
                    ),
                  ),
                  Text(
                    "Schedule Meeting",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: AppColors.PRIMARY_COLOR,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final title = _titleController.text;
                      if (title.isNotEmpty &&
                          _selectedDate != null &&
                          _endTime != null) {
                        if (_endTime!.isBefore(_startTime!)) {
                          showErrorMessage(
                              context, 'Start Date must be before End Date');

                          return;
                        }
                        if (_startTime!.isBefore(TimeOfDay.now())) {
                          showErrorMessage(
                              context, 'Start Date must be in the future');

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
                        showErrorMessage(context, 'Please fill all fields');
                      }
                    },
                    child: const Text(
                      "Done",
                      style: TextStyle(
                        color: AppColors.PRIMARY_COLOR,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              // Meeting Title
              TextField(
                focusNode: _focusNode,
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Meeting Title',
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16.0),
              // Date Picker
              _buildDateTimeSelection(
                title: 'Date',
                content: _selectedDate != null
                    ? _dateFormat.format(_selectedDate!)
                    : 'Select date',
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 16.0),
              // Start Time Picker
              _buildDateTimeSelection(
                title: 'From',
                content: _startTime != null
                    ? _startTime!.format(context)
                    : 'Select start time',
                onTap: () => _selectTime(context, true),
              ),
              const SizedBox(height: 16.0),
              // End Time Picker
              _buildDateTimeSelection(
                title: 'To',
                content: _endTime != null
                    ? _endTime!.format(context)
                    : 'Select end time',
                onTap: () => _selectTime(context, false),
              ),
              const SizedBox(height: 16.0),
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
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Container(),
                ),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black54,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.black54,
                  size: 20,
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
