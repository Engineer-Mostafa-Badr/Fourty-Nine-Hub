import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class TopBarSnap extends StatefulWidget {
  const TopBarSnap({super.key});

  @override
  State<TopBarSnap> createState() => _TopBarSnapState();
}

class _TopBarSnapState extends State<TopBarSnap> with TickerProviderStateMixin{

  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  bool isReady = false;
  bool isFrontCamera = false;
  bool isRecording = false;
  FlashMode _flashMode = FlashMode.off;
  final double _currentZoomLevel = 1.0;
  final double _maxZoomLevel = 5.0;
  File? _selectedImage; // Holds the selected image
  final ImagePicker _picker = ImagePicker(); // Image picker instance

  // Animation controllers
  late AnimationController _flashAnimationController;
  late Animation<double> _flashAnimation;
  OverlayEntry? _overlayEntry;

  void _showOverlay(BuildContext context) {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);

    // Simulate a 3-second delay to hide the overlay
    Future.delayed(const Duration(milliseconds: 1500), () {
      _hideOverlay();
    });
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: ModalBarrier(
              color: Colors.black.withOpacity(0.5),
              dismissible:
              false, // Prevents tapping outside to dismiss the overlay
            ),
          ),
          const Center(
            child: CupertinoActivityIndicator(
              radius: 25,
              color: Colors.yellow,
            ),
          ),
        ],
      ),
    );
  }

  void _changeFlashMode() {
    setState(() {
      if (_flashMode == FlashMode.off) {
        _flashMode = FlashMode.auto;
      } else if (_flashMode == FlashMode.auto) {
        _flashMode = FlashMode.torch;
      } else {
        _flashMode = FlashMode.off;
      }
    });

    _cameraController.setFlashMode(_flashMode);
    _flashAnimationController.forward(from: 0.0);
  }

  // Filter PageView properties
  int selectedFilterIndex = 0; // Tracks which filter is applied
  final PageController _pageController =
  PageController(viewportFraction: 0.3); // Controls the page scrolling
  int totalFilters = 10; // Total number of filters
  final GlobalKey _globalKey = GlobalKey();
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeFlashAnimation();
  }

  /// Initializes the camera and sets up necessary configurations
  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      _cameraController = CameraController(
        _cameras[0],
        ResolutionPreset.high,
        enableAudio: true,
      );
      await _cameraController.initialize();
      setState(() {
        isReady = true;
      });
    } catch (e) {
      log("Camera initialization error: $e");
    }
  }

  /// Initializes flash mode animations
  void _initializeFlashAnimation() {
    _flashAnimationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _flashAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_flashAnimationController);
  }
  void _switchCamera() {
    setState(() {
      isFrontCamera = !isFrontCamera;
      selectedFilterIndex = 0;
      isSelected = false;
    });
    _cameraController = CameraController(
      isFrontCamera ? _cameras[1] : _cameras[0],
      ResolutionPreset.high,
      enableAudio: true,
    );
    _cameraController.initialize().then((_) {
      setState(() {});
    }).catchError((e) {
      log("Error switching camera: $e");
    });
  }
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      left: 8,
      right: 8,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  if(context.isUserLoggedIn){

                    context.push(Routes.OTHERSACCOUNT,
                        extra: serviceLocator<UserCubit>().state.data!.id);
                  }else{
                    context.go(Routes.LOGIN);
                  }
                },
                child: CircleAvatar(
                  radius: 30.w,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  child: ImageFromInternet(
                    image: serviceLocator<UserCubit>().state.data!.profilePicture ??
                        UIConst.profilePlaceHolder,
                    height: 60.h,
                    width: 60.w,
                    isCircle: true,
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    FontAwesomeIcons.shareNodes,
                    size: 30,
                    color: Colors.white,
                  ))
            ],
          ),
          const Spacer(),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.loop, color: Colors.white, size: 30),
                onPressed: _switchCamera,
              ),
              // FadeTransition(
              //   opacity: _flashAnimation,
              //   child: Container(
              //     padding: const EdgeInsets.all(8),
              //     decoration: BoxDecoration(
              //       color: Colors.black.withOpacity(0.6),
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //     child: Text(
              //       _flashMode == FlashMode.off
              //           ? "Flash Off"
              //           : _flashMode == FlashMode.auto
              //               ? "Flash Auto"
              //               : "Flash On",
              //       style: const TextStyle(color: Colors.white),
              //     ),
              //   ),
              // ),
              IconButton(
                icon: Icon(
                  size: 30,
                  _flashMode == FlashMode.off
                      ? FontAwesomeIcons.bolt
                      : _flashMode == FlashMode.auto
                      ? FontAwesomeIcons.bolt
                      : FontAwesomeIcons.bolt,
                  color: _flashMode == FlashMode.off
                      ? Colors.grey
                      : _flashMode == FlashMode.auto
                      ? Colors.yellow.shade100
                      : Colors.yellow,
                ),
                onPressed: _changeFlashMode,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
