import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:deepar_flutter_plus/deepar_flutter_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../cubit/snap_cubit.dart';
import '../cubit/snap_states.dart';
import 'media_preview_screen.dart';
import '../../../social_posts/presentation/pages/search_app_users.dart';
import '../../../social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/const.dart';
import '../../../../../routes/routes.dart';
import '../../../../../service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../../core/widget/custom_circular_progress_indicator.dart';

import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../helpers/manage_vibration.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DeepArControllerPlus deepArController;
  final GlobalKey _key = GlobalKey();
  File? _selectedImage;

  int selectedFilterIndex = 0;
  final PageController _pageController = PageController(viewportFraction: 0.3);

  @override
  void initState() {
    super.initState();
    deepArController = DeepArControllerPlus();
    _initializeDeepArController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _initializeDeepArController() async {
    if (!deepArController.isInitialized) {
      await deepArController.initialize(
        androidLicenseKey:
        '930f25b8068f75e888da6f36ca5e7743d7922d9e9b33f36390e980176eaf4e84a2a048142d9b1310',
        iosLicenseKey:
        '111a528fa021dbf6a64decfb751ca354e59793f11926845436472e094038cd491de29c031f9ead7f',
      );
    }
  }

  Future<void> _captureAndSaveImage() async {
    try {
      RenderRepaintBoundary? boundary =
      _key.currentContext!.findRenderObject() as RenderRepaintBoundary?;

      if (boundary != null) {
        ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);

        if (byteData != null) {
          Uint8List pngBytes = byteData.buffer.asUint8List();
          final directory = await getApplicationDocumentsDirectory();
          String path =
              '${directory.path}/captured_image_${DateTime.now().millisecondsSinceEpoch}.png';
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
        } else {
          print('Error: ByteData is null');
        }
      } else {
        print('Error: RenderRepaintBoundary is null');
      }
    } catch (e) {
      print('Error capturing and saving image: $e');
    }
  }

  Future<void> applyDynamicFilter(String url) async {
    try {
      final dio = Dio();
      final directory = await getApplicationDocumentsDirectory();
      final fileName = url.split('/').last;
      final filePath = '${directory.path}/$fileName';

      final file = File(filePath);

      // Check if the file already exists, if not, download it
      if (!file.existsSync()) {
        print("Downloading file from $url...");
        await dio.download(url, filePath);
        print("File downloaded to: $filePath");
      } else {
        print("File already exists at: $filePath");
      }

      // Apply the downloaded filter to DeepAR
      deepArController.switchEffect(filePath);
    } catch (e) {
      print("Error downloading or switching effect: $e");
    }
  }

  Widget buildCameraPreview() => RepaintBoundary(
    key: _key,
    child: SizedBox(
      height: MediaQuery.of(context).size.height * 0.78,
      child: Transform.scale(
        scale: 1.6,
        child: DeepArPreviewPlus(deepArController),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: FutureBuilder(
        future: _initializeDeepArController(),
        builder: (context, snapshot) {
          return BlocProvider<SnapCubit>(
            create: (BuildContext context) => serviceLocator()..fetchFilter(),
            child: BlocBuilder<SnapCubit, SnapState>(
              builder: (BuildContext context, state) {
                if (state.status == SnapStates.success) {
                  return Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          buildCameraPreview(),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
      ManageVibration.vibrate();
                                await _captureAndSaveImage().then((value) {
                                  setState(() {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MediaPreview(
                                          mediaPath: _selectedImage!.path,
                                          mediaType: MediaType.image,
                                        ),
                                      ),
                                    );
                                  });
                                });
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Center(
                                    child: Container(
                                      padding:
                                      EdgeInsets.symmetric(horizontal: 5.w),
                                      height:
                                      MediaQuery.of(context).size.height *
                                          0.13, // Responsive circle height
                                      width:
                                      MediaQuery.of(context).size.height *
                                          0.13, // Responsive circle width
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white, width: 8.w),
                                      ),
                                    ),
                                  ),
                                  PageView.builder(
                                    controller: _pageController,
                                    itemCount: state.snap?.length,
                                    onPageChanged: (index) async {
                                      setState(() {
                                        selectedFilterIndex = index;
                                      });

                                      // Automatically apply the filter when scrolled
                                      final filterUrl =
                                          state.snap![index].deepar;
                                      await applyDynamicFilter(filterUrl);
                                    },
                                    itemBuilder: (context, index) {
                                      final filter = state.snap![index];
                                      return Padding(
                                        padding: EdgeInsets.all(40.w),
                                        child: AnimatedContainer(
                                          duration:
                                          const Duration(milliseconds: 300),
                                          width: selectedFilterIndex == index
                                              ? 90.w
                                              : 70.w,
                                          height: selectedFilterIndex == index
                                              ? 90.h
                                              : 70.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: NetworkImage(filter.image),
                                              fit: BoxFit.contain,
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
                        ],
                      ),
                      _buildTopIcons(),
                    ],
                  );
                }
                return const Center(child: CustomCircularProgressIndicator());
              },
            ),
          );
        },
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
                        .data!
                        .profilePicture ??
                        UIConst.profilePlaceHolder,
                    height: 90.h,
                    width: 90.w,
                    isCircle: true,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 10.w),
          IconButton(
            onPressed: () {
      ManageVibration.vibrate();
              showDialog(
                context: context,
                builder: (_) => const SearchAppUsers(),
              );
            },
            icon: Icon(
              FontAwesomeIcons.magnifyingGlass,
              size: 50.sp,
            ),
          ),
          const Spacer(),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.loop, color: Colors.white, size: 30),
                onPressed: deepArController.flipCamera,
              ),
              IconButton(
                icon: Icon(
                  size: 50.sp,
                  deepArController.toggleFlash() == false
                      ? FontAwesomeIcons.bolt
                      : FontAwesomeIcons.bolt,
                  color: deepArController.toggleFlash() == false
                      ? Colors.grey
                      : Colors.yellow,
                ),
                onPressed: deepArController.toggleFlash,
              ),
            ],
          ),
        ],
      ),
    );
  }
}