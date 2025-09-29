import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class BeforeSplash extends StatefulWidget {
  const BeforeSplash({super.key, this.hasNavigated});
  final bool? hasNavigated;
  @override
  State<BeforeSplash> createState() => _BeforeSplashState();
}

class _BeforeSplashState extends State<BeforeSplash> {
  bool _hasNavigated = false;

  @override
  void initState() {
    if(widget.hasNavigated!=null){
      _hasNavigated = widget.hasNavigated??false;
    }
    super.initState();
    print("🚀 BeforeSplash initState() called");
    // Defer navigation until after the build phase is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("🚀 BeforeSplash addPostFrameCallback triggered");
      if (!_hasNavigated) {
        print("🚀 BeforeSplash calling initData()");
        initData();
      } else {
        print("🚀 BeforeSplash already navigated, skipping");
      }
    });
  }

  initData(){
    print("🚀 BeforeSplash initData() called");
    if (_hasNavigated) {
      print("🚀 BeforeSplash already navigated, returning early");
      return; // Prevent multiple navigation calls
    }
    _hasNavigated = true;
    print("🚀 BeforeSplash setting _hasNavigated = true");
    print("🚀 BeforeSplash navigating to ${Routes.splashScreen}");
    context.go(Routes.splashScreen);
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: CustomScaffold(body: Container(),));
  }
}
