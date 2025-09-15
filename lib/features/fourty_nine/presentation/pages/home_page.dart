import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/page_preview.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/pages/fourty_nine.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/widgets/exit_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.state, this.isButtonsVisible = false});
  final bool? state;
  final bool isButtonsVisible;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isActivate = false; // make it mutable, not final
  StreamSubscription<bool>? _activationSubscription;

  @override
  void initState() {
    super.initState();
    initActivation();
    _listenToActivationChanges();
  }

  @override
  void dispose() {
    _activationSubscription?.cancel();
    super.dispose();
  }

  Future<void> initActivation() async {
    final activation = await CacheManager.getActivation() ?? false;
    setState(() {
      isActivate = activation;
    });
  }

  void _listenToActivationChanges() {
    _activationSubscription = CacheManager.activationStream.listen((bool activation) {
      if (mounted) {
        setState(() {
          isActivate = activation;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("isActivate $isActivate");
    return !isActivate
        ? const FourtyNineView()
        : ExitWidget(
          child: PagePreview(
                state: widget.state,
                isButtonsVisible: widget.isButtonsVisible,
              ),
        );
  }
}
