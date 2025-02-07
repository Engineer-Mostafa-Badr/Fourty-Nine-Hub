import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/build_create_post.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/build_create_post_app_bar.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/build_create_post_header.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/build_media_card.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/build_sheet_item.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../cubit/create_post_cubit.dart';
import 'package:snapping_bottom_sheet/snapping_bottom_sheet.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/activity_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/pages/select_activity_view.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/pages/select_feeling_view.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/feeling_entity.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:go_router/go_router.dart';

class CreatePostView extends StatefulWidget {
  const CreatePostView({super.key, required this.social});
  final String social;

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  FocusNode focusNode = FocusNode();
  late SheetController sheetController;
  @override
  void initState() {
    sheetController = SheetController();
    focusNode.requestFocus();
    // if(sheetController.state?.currentScrollOffset == 0.05){
    //   setState(() {
    //     // context.read<CreatePostCubit>().state.isSheetOpen = false;
    //   });
    //   print("isSheetOpen$isSheetOpen");
    // }else{
    //   setState(() {
    //     context.read<CreatePostCubit>().state.isSheetOpen = true;
    //   });
    // }
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  Future<String> getLocationAddress() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled
    // serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    //   return Future.error('Location services are disabled.');
    // }

    PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      print("✅ Location permission granted.");
    } else if (status.isDenied) {
      print("❌ Location permission denied.");
    } else if (status.isPermanentlyDenied) {
      print("⚠️ Location permission permanently denied. Open settings.");
      await openAppSettings();
    }
    // Check location permission status
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // Request permission if denied
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    // When permissions are granted, fetch the current position
    Position position = await Geolocator.getCurrentPosition();

    // Get address from latitude and longitude
    return await getAddress(position.latitude, position.longitude);
  }

  Future<String> getAddress(double latitude, double longitude) async {
    try {
      // Get the placemark (address) from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      // context.pop();

      // If there are placemarks (addresses) available
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        // context.pop();
      } else {
        // context.pop();
        return "No address found";
      }
    } catch (e) {
      // context.pop();
      return "Error: $e";
    }
  }

  Future<String> fetchLocationAndAddress() async {
    try {
      showLoadingDialog(context);
      String address = await getLocationAddress();
      print("Location Address: $address");
      context.pop();
      return address;
    } catch (e) {
      print(e);
      context.pop();
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<CreatePostCubit>();
    return BlocConsumer<CreatePostCubit, CreatePostState>(
      listener: (context, state) {
        if (state.status == CreatePostStates.error) {}
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
            height: double.infinity,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 40),
            child: Stack(
              children: [
                ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: [
                    BuildCreatePostAppBar(
                      onTap: () {
                        controller.createPost(
                            context: context, type: widget.social);
                      },
                    ),
                    BuildCreatePostHeader(sheetController:sheetController,controller:controller,state:state),

                    if (widget.social != 'twitter')
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Row(
                          children: [
                            if (state.selectedFeeling != null &&
                                state.selectedFeeling!.name.isNotEmpty)
                              Container(
                                margin:
                                    const EdgeInsetsDirectional.only(start: 10),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5.h),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        controller.onRemoveFeeling();
                                      },
                                      child: const Align(
                                        alignment: AlignmentDirectional.topEnd,
                                        child: Icon(
                                          Icons.close,
                                          size: 16,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    Align(
                                        alignment:
                                            AlignmentDirectional.bottomStart,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6.w),
                                          child: Row(
                                            children: [
                                              Text(
                                                  '${LocaleKeys.feeling.localize} ',
                                                  style: Styles.mediumText(
                                                    color: AppColors
                                                        .AUTH_CONTAINER_COLOR,
                                                  )),
                                              Text(state.selectedFeeling!.name,
                                                  style: Styles.mediumText(
                                                    color: AppColors
                                                        .AUTH_CONTAINER_COLOR,
                                                  )),
                                            ],
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            //Sizer(width: 10.w,),
                            if (state.selectedLocation != null &&
                                state.selectedLocation!.isNotEmpty)Container(
                              margin:
                              const EdgeInsetsDirectional.only(start: 10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5.h),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      controller.onRemoveAddress();
                                    },
                                    child: const Align(
                                      alignment: AlignmentDirectional.topEnd,
                                      child: Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  Align(
                                      alignment:
                                      AlignmentDirectional.bottomStart,
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width*0.8,
                                        child:Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Label(
                                            text:state.selectedLocation??'',
                                            style: Styles.mediumText(),
                                            maxLines: 1,
                                          ),
                                        )
                                      )
                                  ),
                                ],
                              ),
                            ),
                            if (state.selectedActivity != null &&
                                state.selectedActivity!.name.isNotEmpty)
                              Container(
                                margin:
                                    const EdgeInsetsDirectional.only(start: 10),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5.h),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        controller.onRemoveActivity();
                                      },
                                      child: const Align(
                                        alignment: AlignmentDirectional.topEnd,
                                        child: Icon(
                                          Icons.close,
                                          size: 16,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    Align(
                                        alignment:
                                            AlignmentDirectional.bottomStart,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            state.selectedActivity!.name,
                                            style: Styles.mediumText(),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    if (state.selectedUsers != null &&
                        state.selectedUsers!.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Label(
                          text: '${LocaleKeys.withKey.localize}: ',
                          style: Styles.headerText(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: SingleChildScrollView(
                          scrollDirection:
                              Axis.horizontal, // Enable horizontal scrolling
                          child: Row(
                            children: [
                              Wrap(
                                direction: Axis.horizontal,
                                runSpacing: 10,
                                spacing: 10,
                                children: List.generate(
                                  state.selectedUsers!.length,
                                  (index) => GestureDetector(
                                    onTap: () {},
                                    child: BadgedLabel(
                                      label: state
                                              .selectedUsers?[index].fullName ??
                                          '',
                                      onRemove: () {
                                        controller.onRemoveUser(
                                            state.selectedUsers![index]);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const Sizer(),
                    BuildCreatePost(
                      onChange: (c) {
                        if (c.isNotEmpty) {
                          sheetController.collapse();
                        }
                        if (c.length > 80 &&
                            c.length < 120 &&
                            state.backColor != '#FFFFFFFF') {
                          controller.onBigger80();
                        } else if (c.length > 120 &&
                            c.length < 150 &&
                            state.backColor != '#FFFFFFFF') {
                          controller.onBigger120();
                        } else if (c.length > 150) {
                          controller.onBigger150();
                        } else {
                          controller.onSmallerText();
                        }
                        return controller.removeBackground();
                      },
                      controller: sheetController,
                    ),
                    // const Sizer(),
                    // if (widget.social != 'twitter' &&
                    //     (state.images == null || state.images!.isEmpty) &&
                    //     state.isBiggerThen150 == false)
                    //   const BuildColorsBallet(),
                    if (state.gifImage != null ||
                        (state.gifImage?.isNotEmpty ?? false))
                      ImageFromInternet(
                        width: 200,
                        height: 300,
                        image: state.gifImage ?? '',
                      ),
                    const Sizer(),
                    if (state.images != null && state.images!.isNotEmpty)
                      const Expanded(child: BuildMediaCard()),
                    // const Sizer(),
                    // BuildOptions(controller:controller,social:widget.social),
                  ],
                ),
                IgnorePointer(
                  ignoring:
                      (sheetController.state?.currentScrollOffset ?? 0) > 0,
                  child: SnappingBottomSheet(
                    controller: sheetController,
                    duration: const Duration(milliseconds: 500),
                    color: Colors.white,
                    shadowColor: Colors.black26,
                    elevation: 0,
                    maxWidth: MediaQuery.of(context).size.width,
                    cornerRadius: 0,
                    closeOnBackdropTap: true,
                    padding: EdgeInsets.zero,
                    snapSpec: const SnapSpec(
                      snap: true,
                      initialSnap: 0.6,
                      snappings: [0.15, 0.8, 0.8],
                      positioning: SnapPositioning.relativeToAvailableSpace,
                    ),
                    body: Container(),
                    builder: (context, state) => Column(
                      children: [
                        Container(
                            width: double.infinity,
                            height: 10.h,
                            margin: const EdgeInsets.only(bottom: 30),
                            color: Colors.white,
                            child: const Center(
                              child: Icon(
                                Icons.keyboard_arrow_up,
                                color: Colors.black,
                              ),
                            )),
                        Divider(),
                        BuildSheetItem(
                            icon: Assets.imageIcon,
                            title: "Photo/video",
                            onTap: () async {
                              await controller.uploadPhoto(context: context);
                              sheetController.collapse();
                            },
                            hasDivider: true),
                        BuildSheetItem(
                            icon: Assets.tagIcon,
                            title: "Tag people",
                            onTap: () {},
                            hasDivider: true),
                        BuildSheetItem(
                            icon: Assets.feelingIcon,
                            title: "Feeling",
                            onTap: () {
                              sheetController.collapse();
                              bottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  widget: SelectFeelingView(
                                    feelings: context
                                        .read<CreatePostCubit>()
                                        .state.feelings ?? [],
                                    onSelected: (FeelingEntity item) => context
                                        .read<CreatePostCubit>()
                                        .selectedFeeling(item: item),
                                  ));
                            },
                            hasDivider: true),
                        BuildSheetItem(
                            icon: Assets.feelingIcon,
                            title: "Activity",
                            onTap: () {
                              sheetController.collapse();
                              bottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  widget: SelectActivity(
                                    activities: context
                                        .read<CreatePostCubit>().state.activities ?? [],
                                    onSelected: (ActivityEntity item) => context
                                        .read<CreatePostCubit>()
                                        .selectActivity(item: item),
                                  ));
                            },
                            hasDivider: true),
                        BuildSheetItem(
                            icon: Assets.locationIcon,
                            title: "Check in",
                            onTap: () async{
                              String address = await fetchLocationAndAddress();
                              if(address.isNotEmpty){
                                context.read<CreatePostCubit>().setAddress(address);
                                sheetController.collapse();
                              }
                            },
                            hasDivider: true),
                        BuildSheetItem(
                            icon: Assets.liveVideoIcon,
                            title: "Live video",
                            onTap: () {},
                            hasDivider: true),
                        BuildSheetItem(
                            icon: Assets.backgroundIcon,
                            title: "Background color",
                            onTap: () {},
                            hasDivider: true),
                        BuildSheetItem(
                            icon: Assets.cameraIcon,
                            title: "Camera",
                            onTap: () async {
                              await controller.uploadPhoto(
                                  context: context, isGallery: false);
                              sheetController.collapse();
                            },
                            hasDivider: true),
                        BuildSheetItem(
                            icon: Assets.gifIcon,
                            title: "GIF",
                            onTap: () async {
                              final gif = await GiphyGet.getGif(
                                context: context,
                                apiKey:
                                    "4zu1PNDOTTLV9hxPIoeHAOYUcGRvB5NQ", // Replace with your actual API key
                                lang: context.isArabic
                                    ? GiphyLanguage.arabic
                                    : GiphyLanguage.english,
                                randomID: "",
                                searchText: "Search GIF",
                                tabColor: Colors.blue,
                              );

                              if (gif != null) {
                                sheetController.collapse();
                                controller.onSelectGif(
                                    gif.images?.original?.url ?? '');
                                print(gif.images?.original?.url);
                                // controller.onGifSelected(gif.images.original!.url);
                              }
                            },
                            hasDivider: true),
                        BuildSheetItem(
                            icon: Assets.lifeEventIcon,
                            title: "Life event",
                            onTap: () {},
                            hasDivider: true),
                        BuildSheetItem(
                            icon: Assets.musicIcon,
                            title: "Music",
                            onTap: () {},
                            hasDivider: true),
                        BuildSheetItem(
                          icon: Assets.avatarIcon,
                          title: "Your avatar",
                          onTap: () {},
                          hasDivider: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
