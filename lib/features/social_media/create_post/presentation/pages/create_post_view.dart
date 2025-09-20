import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../core/widget/clickable_widget.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../domain/entities/activity_entity.dart';
import '../../domain/entities/feeling_entity.dart';
import '../../domain/entities/life_event_entity.dart';
import '../../domain/entities/place_entity.dart';
import 'build_life_event_view.dart';
import 'select_activity_view.dart';
import 'select_feeling_view.dart';
import '../widgets/build_colors_ballet.dart';
import '../widgets/build_create_post.dart';
import '../widgets/build_create_post_app_bar.dart';
import '../widgets/build_create_post_header.dart';
import '../widgets/build_media_card.dart';
import '../widgets/build_search_friends.dart';
import '../widgets/build_sheet_item.dart';
import '../../../social_posts/presentation/pages/Social_home.dart';
import '../../../social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../routes/routes.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snapping_bottom_sheet/snapping_bottom_sheet.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../cubit/create_post_cubit.dart';
import '../../../../../helpers/manage_vibration.dart';

class CreatePostView extends StatefulWidget {
  const CreatePostView({super.key, this.lifeEvent});
  final LifeEventEntity? lifeEvent;

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

  Future<PlaceEntity> getLocationAddress() async {
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
    String address = await getAddress(position.latitude, position.longitude);
    PlaceEntity selectedPlace = PlaceEntity(
        formattedAddress: address,
        name: address,
        lat: position.latitude,
        lng: position.longitude);
    return selectedPlace;
  }

  Future<String> getAddress(double latitude, double longitude) async {
    try {
      // Get the placemark (address) from coordinates
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      // context.pop();

      // If there are placemarks (addresses) available
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        print("place.street${place.street}");
        print("place.locality${place.locality}");
        print("place.country${place.country}");
        print("place.street${place.street}");
        return "${place.locality}, ${place.administrativeArea}, ${place.country}";
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

  Future<PlaceEntity> fetchLocationAndAddress() async {
    try {
      showLoadingDialog(context);
      PlaceEntity address = await getLocationAddress();
      print("Location Address: ${address.toMap()}");
      context.pop();
      return address;
    } catch (e) {
      print(e);
      context.pop();
      return PlaceEntity(formattedAddress: '', name: '', lat: 0, lng: 0);
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
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            print(controller.handlePopAction());
            if (controller.handlePopAction() == true) {
              context.go(Routes.SOCIAL,
                  extra: SocialParams(
                      userId: UserCubit.to.state.data?.id ?? '', index: 0));
            } else {
              controller.handleBack(context);
            }
          },
          child: CustomScaffold(
            body: Container(
              height: double.infinity,
              width: double.infinity,
              margin: const EdgeInsets.only(top: 40),
              child: Stack(
                children: [
                  ListView(
                    padding: EdgeInsets.only(bottom: 140.h),
                    shrinkWrap: true,
                    children: [
                      BuildCreatePostAppBar(
                        onTap: () {
                          ManageVibration.vibrate();
                          controller.createPost(
                            context: context,
                          );
                        },
                      ),
                      BuildCreatePostHeader(
                        isTwitter: false,
                          sheetController: sheetController,
                          controller: controller,
                          state: state),
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
                        sheetController: sheetController,
                      ),
                      // const Sizer(),
                      // if (widget.social != 'twitter' &&
                      //     (state.images == null || state.images!.isEmpty) &&
                      //     state.isBiggerThen150 == false)
                      //   const BuildColorsBallet(),
                      Column(
                        children: [
                          if (state.gifImage != null &&
                              (state.gifImage?.isNotEmpty ?? false))
                            Stack(
                              children: [
                                ImageFromInternet(
                                  width: double.infinity,
                                  height: 300,
                                  image: state.gifImage ?? '',
                                ),
                                PositionedDirectional(
                                    top: 8,
                                    end: 8,
                                    child: ClickableWidget(
                                      onTap: () {
                                        ManageVibration.vibrate();
                                        context
                                            .read<CreatePostCubit>()
                                            .removeGif();
                                      },
                                      child: Container(
                                          height: 35,
                                          width: 35,
                                          decoration: const BoxDecoration(
                                              color: AppColors.PRIMARY_COLOR,
                                              shape: BoxShape.circle),
                                          alignment: Alignment.center,
                                          child: const Icon(
                                            Icons.close,
                                            size: 18,
                                            color: Colors.white,
                                          )),
                                    ))
                              ],
                            ),
                          const Sizer(),
                          if (state.images != null && state.images!.isNotEmpty)
                            BuildMediaCard(),
                          const Sizer(),
                          if (state.selectedLifeEvent != null &&
                              state.selectedLifeEvent!.id.isNotEmpty)
                            const BuildLifeEventView(),
                          if ((state.selectedLifeEvent == null ||
                                  state.selectedLifeEvent!.id.isEmpty) &&
                              (state.gifImage == null ||
                                  (state.gifImage?.isEmpty ?? false)) &&
                              (state.images == null || state.images!.isEmpty))
                            const BuildColorsBallet(),
                        ],
                      )
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
                      color: context.isDarkMode
                          ? AppColors.getFillColor(context)
                          : Colors.white,
                      shadowColor: Colors.black26,
                      elevation: 0,
                      maxWidth: MediaQuery.of(context).size.width,
                      cornerRadius: 0,
                      closeOnBackdropTap: true,
                      padding: EdgeInsets.zero,
                      snapSpec: const SnapSpec(
                        snap: true,
                        initialSnap: 0.6,
                        snappings: [0.1, 0.4, 0.8],
                        positioning: SnapPositioning.relativeToAvailableSpace,
                      ),
                      body: Container(),
                      builder: (context, state1) => Column(
                        children: [
                          Container(
                              width: double.infinity,
                              height: 10.h,
                              margin: const EdgeInsets.only(bottom: 30),
                              color: context.isDarkMode
                                  ? AppColors.getFillColor(context)
                                  : Colors.white,
                              child: Center(
                                child: Icon(
                                  Icons.keyboard_arrow_up,
                                  color: AppColors.getTextColor(context),
                                ),
                              )),
                          const Divider(),
                          if ((state.gifImage == null ||
                                  (state.gifImage?.isEmpty ?? false)) &&
                              (state.selectedLifeEvent == null ||
                                  (state.selectedLifeEvent?.id.isEmpty ??
                                      false)))
                            BuildSheetItem(
                                icon: Assets.imageIcon,
                                title: context.isArabic
                                    ? 'صورة/فيديو'
                                    : "Photo/video",
                                onTap: () async {
                                  ManageVibration.vibrate();
                                  await controller.uploadPhoto(
                                      context: context);
                                  sheetController.collapse();
                                },
                                hasDivider: true),
                          BuildSheetItem(
                              icon: Assets.tagIcon,
                              title: context.isArabic
                                  ? 'اشارة لأشخاص'
                                  : "Tag people",
                              onTap: () {
                                ManageVibration.vibrate();
                                sheetController.collapse();
                                bottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    widget: BuildSearchFriends(
                                      controller:
                                          context.read<CreatePostCubit>(),
                                      onSelectUser: (user) => context
                                          .read<CreatePostCubit>()
                                          .selectUsers(user),
                                    ));
                              },
                              hasDivider: true),
                          BuildSheetItem(
                              icon: Assets.feelingIcon,
                              title: context.isArabic ? 'شعور' : "Feeling",
                              onTap: () {
                                ManageVibration.vibrate();
                                sheetController.collapse();
                                bottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    widget: SelectFeelingView(
                                      feelings: context
                                              .read<CreatePostCubit>()
                                              .state
                                              .feelings ??
                                          [],
                                      onSelected: (FeelingEntity item) =>
                                          context
                                              .read<CreatePostCubit>()
                                              .selectedFeeling(item: item),
                                    ));
                              },
                              hasDivider: true),
                          BuildSheetItem(
                              icon: Assets.feelingIcon,
                              title: context.isArabic ? 'نشاط' : "Activity",
                              onTap: () {
                                ManageVibration.vibrate();
                                sheetController.collapse();
                                bottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    widget: SelectActivity(
                                      activities: context
                                              .read<CreatePostCubit>()
                                              .state
                                              .activities ??
                                          [],
                                      onSelected: (ActivityEntity item) =>
                                          context
                                              .read<CreatePostCubit>()
                                              .selectActivity(item: item),
                                    ));
                              },
                              hasDivider: true),
                          BuildSheetItem(
                              icon: Assets.locationIcon,
                              title: state.place != null ||
                                      (state.place?.name.isEmpty ?? false)
                                  ? context.isArabic
                                      ? 'ازالة الموقع'
                                      : "Remove Location"
                                  : context.isArabic
                                      ? 'موقع'
                                      : "Check in",
                              onTap: () async {
                                ManageVibration.vibrate();
                                // if(state.place!=null||(state.place?.name.isEmpty??false)){
                                //   context.read<CreatePostCubit>().removeAddress();
                                // }else{
                                PlaceEntity address =
                                    await fetchLocationAndAddress();
                                if (address.name.isNotEmpty) {
                                  context
                                      .read<CreatePostCubit>()
                                      .setAddress(address);
                                  sheetController.collapse();
                                }
                                // }
                              },
                              hasDivider: true),
                          // BuildSheetItem(
                          //     icon: Assets.liveVideoIcon,
                          //     title: "Live video",
                          //     onTap: () {},
                          //     hasDivider: true),
                          if ((state.gifImage == null &&
                                  (state.gifImage?.isEmpty ?? false)) &&
                              state.selectedLifeEvent == null &&
                              (state.selectedLifeEvent?.id.isEmpty ?? false))
                            BuildSheetItem(
                                icon: Assets.backgroundIcon,
                                title: context.isArabic
                                    ? 'لون الخلفية'
                                    : "Background color",
                                onTap: () {
                                  ManageVibration.vibrate();
                                  controller.showRemoveBalletColors();
                                  sheetController.collapse();
                                },
                                hasDivider: true),
                          if ((state.gifImage == null ||
                                  (state.gifImage?.isEmpty ?? false)) &&
                              (state.selectedLifeEvent == null ||
                                  (state.selectedLifeEvent?.id.isEmpty ??
                                      false)))
                            BuildSheetItem(
                                icon: Assets.cameraIcon,
                                title: context.isArabic ? 'كاميرا' : "Camera",
                                color: context.isDarkMode ? Colors.white : null,
                                onTap: () async {
                                  ManageVibration.vibrate();
                                  await controller.uploadPhoto(
                                      context: context, isGallery: false);
                                  sheetController.collapse();
                                },
                                hasDivider: true),
                          if ((state.images == null ||
                                  (state.images?.isEmpty ?? false)) &&
                              (state.selectedLifeEvent == null ||
                                  (state.selectedLifeEvent?.id.isEmpty ??
                                      false)))
                            BuildSheetItem(
                                icon: Assets.gifIcon,
                                title: context.isArabic ? 'صورة متحركة' : "GIF",
                                onTap: () async {
                                  ManageVibration.vibrate();
                                  print(state.images);
                                  print(state.images?.length);
                                  print(state.selectedLifeEvent);
                                  print(state.selectedLifeEvent?.id);
                                  sheetController.collapse();
                                  final gif = await GiphyGet.getGif(
                                    context: context,
                                    apiKey:
                                        "4zu1PNDOTTLV9hxPIoeHAOYUcGRvB5NQ", // Replace with your actual API key
                                    lang: context.isArabic
                                        ? GiphyLanguage.arabic
                                        : GiphyLanguage.english,
                                    randomID: "",
                                    searchText: context.isArabic
                                        ? 'بحث عن صورة متحركة'
                                        : "Search GIF",
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
                          if ((state.images == null ||
                                  (state.images?.isEmpty ?? false)) &&
                              (state.gifImage == null ||
                                  (state.gifImage?.isEmpty ?? false)))
                            BuildSheetItem(
                                icon: Assets.lifeEventIcon,
                                title: context.isArabic ? 'حدث' : "Life event",
                                onTap: () {
                                  ManageVibration.vibrate();
                                  sheetController.collapse();
                                  context.push(Routes.LIFEEVENT);
                                },
                                hasDivider: true),
                          // BuildSheetItem(
                          //     icon: Assets.musicIcon,
                          //     title: "Music",
                          //     onTap: () {},
                          //     hasDivider: true),
                          // BuildSheetItem(
                          //   icon: Assets.avatarIcon,
                          //   title: "Your avatar",
                          //   onTap: () {},
                          //   hasDivider: false,
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
