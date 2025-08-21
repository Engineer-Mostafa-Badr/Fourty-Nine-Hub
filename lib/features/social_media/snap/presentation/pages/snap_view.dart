import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../widget/filter.dart';
import '../widget/media_preview_screen.dart';
import '../../utils/filters.dart';
import '../../../social_posts/presentation/pages/search_app_users.dart';
import '../../../social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/const.dart';
import '../../../../../routes/routes.dart';
import '../../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../../core/widget/custom_circular_progress_indicator.dart';
import '../../../../../helpers/manage_vibration.dart';

class SnapView extends StatelessWidget {
  const SnapView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdvancedSnapchatCameraScreen();
  }
}

class Filter1 {
  final String name;
  final ColorFilter? colorFilter;
  final String ffmpegFilter;

  const Filter1(this.name, this.colorFilter, {required this.ffmpegFilter});
}

class AdvancedSnapchatCameraScreen extends StatefulWidget {
  const AdvancedSnapchatCameraScreen({super.key});

  @override
  _AdvancedSnapchatCameraScreenState createState() =>
      _AdvancedSnapchatCameraScreenState();
}

class _AdvancedSnapchatCameraScreenState
    extends State<AdvancedSnapchatCameraScreen> with TickerProviderStateMixin {
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  bool isReady = false;
  bool isFrontCamera = false;
  bool isRecording = false;
  FlashMode _flashMode = FlashMode.off;
  double _currentZoomLevel = 1.0;
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

  /// Switches between front and back cameras
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

  Future<void> _toggleRecording() async {
    if (!_cameraController.value.isInitialized) return;

    try {
      if (isRecording) {
        await _cameraController.stopVideoRecording();
        setState(() {
          isRecording = false;
        });
      } else {
        await _cameraController.startVideoRecording();
        setState(() {
          isRecording = true;
        });
      }
    } catch (e) {
      log("Recording error: $e");
    }
  }

  void _changeFlashMode() {
    setState(() {
      if (_flashMode == FlashMode.off) {
        _flashMode = FlashMode.torch;
      } else if (_flashMode == FlashMode.auto) {
        _flashMode = FlashMode.off;
      } else {
        _flashMode = FlashMode.off;
      }
    });

    _cameraController.setFlashMode(_flashMode);
    _flashAnimationController.forward(from: 0.0);
  }

  /// Picks an image from the gallery
  Future<void> _pickImageFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path); // Set the image file
        });
      } else {
        print("No image selected.");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _flashAnimationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _capturePng() async {
    try {
      // Check if the camera controller is initialized
      if (!_cameraController.value.isInitialized) {
        print('Camera is not initialized');
        return;
      }

      // Capture the widget as an image
      RenderRepaintBoundary? boundary = _globalKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;

      // Check if boundary is null
      if (boundary == null) {
        print('Error: RepaintBoundary is null');
        return;
      }

      // Capture the image from the RepaintBoundary
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      // Check if byteData is null
      if (byteData == null) {
        print('Error: ByteData is null');
        return;
      }

      Uint8List pngBytes = byteData.buffer.asUint8List();

      // Get the directory to save the image
      final directory = await getApplicationDocumentsDirectory();
      String path =
          '${directory.path}/filtered_image_${DateTime.now().millisecondsSinceEpoch}.png';

      File imgFile = File(path);

      File savedImage = await imgFile.writeAsBytes(pngBytes);

      if (savedImage.existsSync()) {
        setState(() {
          _selectedImage = savedImage;
          print('Image captured and saved at ${_selectedImage!.path}');
        });
      } else {
        print('Error: Saved image does not exist');
      }
    } catch (e) {
      print('Error saving image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isReady || !_cameraController.value.isInitialized) {
      return const CustomScaffold(
        body: Center(child: CustomCircularProgressIndicator()),
      );
    }

    return CustomScaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onScaleUpdate: (details) {
          if (details.scale != 1.0) {
            _currentZoomLevel =
                (_currentZoomLevel * details.scale).clamp(1.0, _maxZoomLevel);
            _cameraController.setZoomLevel(_currentZoomLevel);
          }
        },
        child: Stack(
          children: [
            RepaintBoundary(
              key: _globalKey,
              child: ColorFiltered(
                colorFilter: advancedFilters[selectedFilterIndex]
                    ['colorFilter'],
                child: CameraPreview(_cameraController),
              ),
            ),
            GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! > 0) {
                  log("Swiped right: open chat");
                } else if (details.primaryVelocity! < 0) {
                  log("Swiped left: open stories");
                }
              },
            ),
            _buildTopIcons(),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Center(
                          child: IconButton(
                            color: Colors.white,
                            icon: Stack(
                              children: [
                                Icon(
                                  size: 60.sp,
                                  Icons.photo_library,
                                ),
                              ],
                            ),
                            onPressed: () =>
                                _pickImageFromGallery().then((value) {
                              if (_selectedImage?.path != null) {
                                return Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MediaPreview(
                                          mediaPath: _selectedImage?.path ?? '',
                                          mediaType: MediaType.image),
                                    ));
                              }
                            }), // Pick an image from gallery
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: Container(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Center(
                              child: Container(
                                height: MediaQuery.of(context).size.height *
                                    0.13, // Responsive circle height
                                width: MediaQuery.of(context).size.height *
                                    0.13, // Responsive circle width
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 6),
                                ),
                              ),
                            ),
                            PageView.builder(
                              controller: _pageController,
                              itemCount: advancedFilters.length,
                              onPageChanged: (index) {
                                setState(() {
                                  selectedFilterIndex = index;
                                  log("Filter $index applied");
                                });
                              },
                              itemBuilder: (context, index) {
                                isSelected = selectedFilterIndex == index;
                                log("${isSelected}88888888888888888888888888888888888$selectedFilterIndex  $index");
                                final filter = advancedFilters[index];

                                return GestureDetector(
                                  onTap: () {
                                    ManageVibration.vibrate();
                                    if (selectedFilterIndex == index) {
                                      _showOverlay(context);
                                      _capturePng().then((value) {
                                        setState(() {
                                          log("${_selectedImage!.path}____________________");
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MediaPreview(
                                                        mediaPath:
                                                            _selectedImage!
                                                                .path,
                                                        mediaType:
                                                            MediaType.image),
                                              ));
                                        });
                                      });
                                      log("Filter $index selected");
                                    }
                                  },
                                  onLongPress: _toggleRecording,
                                  child: AnimatedOpacity(
                                    duration: const Duration(milliseconds: 300),
                                    opacity: isSelected ? 1.0 : 0.5,
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeOut,
                                      child: Padding(
                                        padding: const EdgeInsets.all(14.0),
                                        child: Transform.scale(
                                          scale: isSelected ? 1.2 : 0.8,
                                          child: ColorFiltered(
                                            colorFilter: filter['colorFilter'],
                                            child: CircleAvatar(
                                              backgroundImage: const AssetImage(
                                                  'assets/filters/camera_filter.webp'),
                                              child: Text(
                                                filter['name'],
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Center(
                          child: IconButton(
                            color: Colors.white,
                            icon: Stack(
                              children: [
                                Icon(
                                  size: 60.sp,
                                  Icons.emoji_emotions_outlined,
                                ),
                              ],
                            ),
                            onPressed: () {
                              ManageVibration.vibrate();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()));
                              // Navigator.push(context, MaterialPageRoute(builder: (context)=>FaceDetectionCamera()));
                            }, // Pick an image from gallery
                          ),
                        ),
                      ),
                    ),
                    const Sizer(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTopIcons() {
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
                  ManageVibration.vibrate();
                  if (context.isUserLoggedIn) {
                    context.push(Routes.OTHERSACCOUNT,
                        extra: serviceLocator<UserCubit>().state.data!.id);
                  } else {
                    return pleaseLoginDialog(context);

                    // context.go(Routes.LOGIN);
                  }
                },
                child: CircleAvatar(
                  radius: 47.w,
                  backgroundColor: AppColors.AUTH_CONTAINER_COLOR,
                  child: ImageFromInternet(
                    image: serviceLocator<UserCubit>()
                            .state
                            .data
                            ?.profilePicture ??
                        UIConst.profilePlaceHolder,
                    height: 90.h,
                    width: 90.w,
                    isCircle: true,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: 10.w,
          ),
          IconButton(
              onPressed: () {
                ManageVibration.vibrate();
                showDialog(
                    context: context, builder: (_) => const SearchAppUsers());
              },
              icon: Icon(
                FontAwesomeIcons.magnifyingGlass,
                size: 50.sp,
              )),
          const Spacer(),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.loop, color: Colors.white, size: 30),
                onPressed: _switchCamera,
              ),
              IconButton(
                icon: Icon(
                  size: 50.sp,
                  _flashMode == FlashMode.off
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
