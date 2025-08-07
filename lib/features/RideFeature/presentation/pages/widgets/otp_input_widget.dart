import 'package:flutter/material.dart';

class OtpInputWidget extends StatefulWidget {
  final int length;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;

  const OtpInputWidget({
    super.key,
    this.length = 6,
    this.onCompleted,
    this.onChanged,
  });

  @override
  State<OtpInputWidget> createState() => _OtpInputWidgetState();
}

class _OtpInputWidgetState extends State<OtpInputWidget> {
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(widget.length, (_) => TextEditingController());
    focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleInput(int index, String value) {
    if (value.isNotEmpty) {
      if (index < widget.length - 1) {
        FocusScope.of(context).requestFocus(focusNodes[index + 1]);
      } else {
        FocusScope.of(context).unfocus();
      }
    }
  }

  // عند حذف الحرف
  void _handleDelete(int index, String value) {
    if (value.isEmpty) {
      if (index > 0) {
        FocusScope.of(context).requestFocus(focusNodes[index - 1]);
      }
    }
  }

  String _getOtpValue() {
    return controllers.map((c) => c.text).join();
  }

  void _notifyChanges() {
    final currentOtp = _getOtpValue();

    if (widget.onChanged != null) {
      widget.onChanged!(currentOtp);
    }

    if (currentOtp.length == widget.length &&
        !currentOtp.contains('') &&
        widget.onCompleted != null) {
      widget.onCompleted!(currentOtp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: SizedBox(
            width: 44,
            child: TextField(
              controller: controllers[index],
              focusNode: focusNodes[index],

              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,

              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                counterText: '',

                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  _handleInput(index, value);
                } else {
                  _handleDelete(index, value);
                }
                _notifyChanges();
              },
            ),
          ),
        );
      }),
    );
  }
}

