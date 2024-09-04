import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';
import 'package:fourtyninehub/features/zoom/presentation/bloc/meeting_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ScheduleMeetingBottomSheet extends StatefulWidget {
  const ScheduleMeetingBottomSheet({super.key});

  @override
  _ScheduleMeetingBottomSheetState createState() =>
      _ScheduleMeetingBottomSheetState();
}

class _ScheduleMeetingBottomSheetState
    extends State<ScheduleMeetingBottomSheet> {
  DateTime? _startDateTime;
  DateTime? _endDateTime;
  final _titleController = TextEditingController();
  final _dateFormat = DateFormat('yyyy-MM-dd');
  final _timeFormat = DateFormat('HH:mm');
  final FocusNode focusNode = FocusNode();
  Future<void> _selectDateTime(BuildContext context, DateTime? initialDateTime,
      ValueChanged<DateTime?> onDateTimeSelected) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDateTime?.toLocal() ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDateTime ?? DateTime.now()),
      );
      if (selectedTime != null) {
        onDateTimeSelected(DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        ));
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  initState() {
    focusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        // height: context.screenHeight,
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 50.0,
          bottom: MediaQuery.of(context).viewInsets.bottom +
              16.0, // Adjust for the keyboard
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Schedule Meeting',
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16.0),
            TextField(
              focusNode: focusNode,
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Meeting Title',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16.0),
            _buildDateTimeSelection(
              title: 'Start Date & Time',
              dateTime: _startDateTime,
              onTap: () => _selectDateTime(context, _startDateTime,
                  (dateTime) => setState(() => _startDateTime = dateTime)),
            ),
            SizedBox(height: 16.0.zH),
            _buildDateTimeSelection(
              title: 'End Date & Time',
              dateTime: _endDateTime,
              onTap: () => _selectDateTime(context, _endDateTime,
                  (dateTime) => setState(() => _endDateTime = dateTime)),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.PRIMARY_COLOR,
                  minimumSize:
                      Size(MediaQuery.sizeOf(context).width / 1.2, 60)),
              onPressed: () async {
                final title = _titleController.text;
                if (title.isNotEmpty &&
                    _startDateTime != null &&
                    _endDateTime != null) {
                  // Process the meeting details
                  // print('Meeting Title: $title');
                  // print('Start DateTime: $_startDateTime');
                  // print('id: ${widget.genRandNo}');
                  // print('End DateTime: $_endDateTime');
                  if (_titleController.text.isNotEmpty &&
                      _endDateTime != null &&
                      _startDateTime != null) {
                    if (_endDateTime!.isBefore(_startDateTime!)) {
                      showErrorMessage(
                          context, 'Start Date must be before End Date');
                      context.pop();
                      return;
                    }
                    if (_startDateTime!.isBefore(DateTime.now())) {
                      showErrorMessage(
                          context, 'Start Date must be in the future');
                      context.pop();
                      return;
                    }
                    await context.read<MeetingCubit>().createNewMeeting(
                          startTime: _startDateTime,
                          title: _titleController.text.trim(),
                          endTime: _endDateTime,
                        );

                    if (context.mounted)
                      context.pushReplacementNamed(Routes.ZOOM);
                  } else {
                    context.pop();
                    showErrorMessage(context, 'Please fill all fields');
                  }
                }
                // Navigator.pop(context);
              },
              child: const Text(
                'Schedule',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeSelection({
    required String title,
    DateTime? dateTime,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8.0),
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text(
              dateTime != null
                  ? '${_dateFormat.format(dateTime)} ${_timeFormat.format(dateTime)}'
                  : 'Select date & time',
              style: const TextStyle(fontSize: 16.0, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
