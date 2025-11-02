import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/enums/base_status_enum.dart';
import '../../../../helpers/subscription_method.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

import '../../domain/usecases/create_auction_use_case.dart';
import '../cubit/auction_cubit.dart';
import 'fetch_single_auction_screen.dart';

class CreateAuctionScreen extends StatefulWidget {
  const CreateAuctionScreen({super.key});

  @override
  State<CreateAuctionScreen> createState() => _CreateAuctionScreenState();
}

class _CreateAuctionScreenState extends State<CreateAuctionScreen> {
  String? selectedMainCategory;
  String? selectedSubCategory;
  String? selectedMainCategoryId; // NEW
  String? selectedSubCategoryId; // NEW

  // Map of file path -> VideoPlayerController
  final Map<String, VideoPlayerController> _videoControllers = {};
  @override
  void initState() {
    super.initState();
    // Load initial main categories
    context.read<AuctionCubit>().loadInitialMainCategoryAuction();
  }
  // NEW: Text controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _minBidPriceController = TextEditingController();
  final _timeController = TextEditingController();
  DateTime? _startAt; // NEW
  DateTime? _endAt;   // NEW
  Future<void> _pickDateTime(BuildContext context, {required bool isStart}) async {
    final now = DateTime.now();
    final isDark = context.isDarkMode;

    // Pick date
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: isDark ? Colors.red :AppColors.PRIMARY_COLOR, // header, buttons
              onPrimary: Colors.white, // text/icon on primary
              onSurface: isDark ? Colors.white : Colors.black, // text on background
              surface: isDark ? Colors.black : Colors.white,
            ), dialogTheme: DialogThemeData(backgroundColor: isDark ? Colors.black : Colors.white),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    // Pick time
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              dialHandColor: isDark ? AppColors.PRIMARY_COLOR_DARK: AppColors.PRIMARY_COLOR,
              // dialBackgroundColor: isDark ? Colors.grey[900] : Colors.blue,
              hourMinuteTextColor: isDark ? AppColors.PRIMARY_COLOR_DARK : Colors.black,
              dayPeriodTextColor: isDark ?  AppColors.PRIMARY_COLOR_DARK : Colors.black,
              entryModeIconColor: isDark ?  AppColors.PRIMARY_COLOR_DARK : Colors.black,
            ), dialogTheme: DialogThemeData(backgroundColor: isDark ? Colors.black : Colors.white),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null) return;

    final combined = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      if (isStart) {
        _startAt = combined;
      } else {
        _endAt = combined;
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    // Dispose text controllers
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _minBidPriceController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<VideoPlayerController> _initializeVideo(String path) async {
    if (_videoControllers.containsKey(path)) return _videoControllers[path]!;

    final controller = VideoPlayerController.file(File(path));
    await controller.initialize();

    // Listen to video end to reset
    controller.addListener(() {
      if (controller.value.position >= controller.value.duration && controller.value.duration != Duration.zero) {
        setState(() {
          controller.seekTo(Duration.zero);
          controller.pause(); // Reset to "play" state
        });
      }
    });

    _videoControllers[path] = controller;
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuctionCubit>();

    return BlocListener<AuctionCubit, AuctionState>(
      // listener: (context, state) {
      //   // 🔹 Error handling
      //   if (state.status == StateStatus.error && state.failure != null) {
      //     final errorMessage =getFailureMessage(state.failure!, context) ?? "Something went wrong!";
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(content: Text(errorMessage)),
      //     );
      //   }
      //
      //   // 🔹 Success handling
      //   if (state.status == StateStatus.success && state.createAuction != null) {
      //     final response = state.createAuction!;
      //
      //     if (response.data?.userSubscription == false) {
      //       // 🚨 Not subscribed → open subscription
      //       SubscriptionMethod().subscribe(
      //         subscribeId: response.data?.subCategoryId ?? '',
      //         onSubscribe: () {
      //           context.pop(); // close subscription screen
      //           context.pop(); // close create screen
      //           context.read<AuctionCubit>().clearCreateAuctionResponse(); // ✅ Clear after handling
      //         },
      //         showRegular: false,
      //         title: "Subscribe",
      //       );
      //     } else {
      //       // 🎉 Successfully created
      //       if (response.message != null) {
      //         ScaffoldMessenger.of(context).showSnackBar(
      //           SnackBar(content: Text(response.message!)),
      //         );
      //       }
      //       context.read<AuctionCubit>().clearCreateAuctionResponse(); // ✅ Clear after handling
      //       context.pop(true); // close create auction screen
      //     }
      //   }
      // },
      listenWhen: (previous, current) {
        // ✅ Only trigger when createAuction actually changes from null to something
        return previous.createAuction != current.createAuction &&
            current.createAuction != null;
      },
      listener: (context, state) {
        // 🔹 Error handling
        if (state.status == StateStatus.error && state.failure != null) {
          final errorMessage = getFailureMessage(state.failure!, context) ?? "Something went wrong!";
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }

        // 🔹 Success handling
        if (state.status == StateStatus.success && state.createAuction != null) {
          final response = state.createAuction!;

          if (response.data?.userSubscription == false) {
            SubscriptionMethod().subscribe(
              subscribeId: response.data?.subCategoryId ?? '',
              // onSubscribe: () {
              //   context.pop();
              //   context.pop();
              // },
              showRegular: false,
              title: "Subscribe",
            );
          } else {
            if (response.message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(response.message!)),
              );
            }
            context.pop(true);
          }
        }
      },
  child: CustomScaffold(
    enableCustomAppBar: true,
    appBar: BackAppBar(
      label:LocaleKeys.addAuction.localize,
    ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // Media Gallery Container
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.grey[50]!, Colors.grey[100]!],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Media list
                  BlocBuilder<AuctionCubit, AuctionState>(
                    builder: (context, state) {
                      if (state.uploadedFiles.isEmpty) {
                        return Container(
                          // height: 200,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.photo_library_outlined,
                                  size: 40,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                LocaleKeys.noMediaUploadedYet.localize,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                LocaleKeys.uploadImagesOrVideo.localize,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return Container(
                        height: 220,
                        padding: const EdgeInsets.all(16),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: state.uploadedFiles.length,
                          itemBuilder: (context, index) {
                            final fileEntity = state.uploadedFiles[index];
                            final path = fileEntity.file.path;
                            final isImage = path.endsWith(".jpg") || path.endsWith(".png");

                            return Container(
                              margin: const EdgeInsets.only(right: 16),
                              child: Stack(
                                children: [
                                  // Media display
                                  Hero(
                                    tag: "media_$index",
                                    child: Container(
                                      width: 160,
                                      height: 180,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 15,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: isImage
                                            ? Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            Image.file(File(path), fit: BoxFit.cover),
                                            Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Colors.transparent,
                                                    Colors.black.withOpacity(0.1),
                                                  ],
                                                  stops: const [0.6, 1.0],
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 8,
                                              left: 8,
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.black.withOpacity(0.7),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: const [
                                                    Icon(Icons.image, size: 12, color: Colors.white),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      "IMG",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                            : FutureBuilder<VideoPlayerController>(
                                          future: _initializeVideo(path),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return Container(
                                                color: Colors.grey[800],
                                                child: const Center(
                                                  child: CircularProgressIndicator(
                                                    color: Colors.white,
                                                    strokeWidth: 3,
                                                  ),
                                                ),
                                              );
                                            }
                                            final controller = snapshot.data!;
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  controller.value.isPlaying
                                                      ? controller.pause()
                                                      : controller.play();
                                                });
                                              },
                                              child: AspectRatio(
                                                aspectRatio: controller.value.aspectRatio,
                                                child: VideoPlayer(controller),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Delete Button
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (_videoControllers.containsKey(path)) {
                                          _videoControllers[path]?.dispose();
                                          _videoControllers.remove(path);
                                        }
                                        context.read<AuctionCubit>().deleteUploadedFile(fileEntity);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.9),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.red.withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(Icons.close_rounded, color: Colors.white, size: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),

                  // Uploading overlay
                  BlocBuilder<AuctionCubit, AuctionState>(
                    builder: (context, state) {
                      if (state.isUploading) {
                        return Container(
                          height: 220,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                   "${ LocaleKeys.uploadingImage.localize}....",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    onPressed: () => context.read<AuctionCubit>().uploadMedia(isImage: true),
                    label: LocaleKeys.uploadImage.localize,
                    backColor: AppColors.PRIMARY_COLOR_DARK,
                    iconWidget: Icon(Icons.file_upload_outlined,color: Colors.white,),
                    // icon: Icons.file_upload_outlined,

                    // child: Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: const [
                    //     Icon(Icons.image_rounded),
                    //     SizedBox(width: 12),
                    //     Text("Add Image"),
                    //   ],
                    // ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppButton(
                    onPressed: () => context.read<AuctionCubit>().uploadMedia(isImage: false),
                    label: LocaleKeys.uploadVideo.localize,
                    backColor: AppColors.PRIMARY_COLOR_DARK,
                    iconWidget: Icon(Icons.file_upload_outlined,color: Colors.white,),
                    // icon: Icons.file_upload_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // ---------------- Main Category Dropdown ----------------
            // BlocBuilder<AuctionCubit, AuctionState>(
            //   builder: (context, state) {
            //     return PaginatedDropdown(
            //       title: selectedMainCategory ??  LocaleKeys.selectMainCategoryAuction.localize,
            //       // items: cubit.mainCategories.map((e) => e.nameEn ?? "").toList(),
            //       items: cubit.mainCategories.map((e) {
            //         return context.isArabic ? (e.nameAr ?? "") : (e.nameEn ?? "");
            //       }).toList(),
            //       hasMore: cubit.hasMoreMainCategories,
            //       loadMore: () => cubit.getMainCategoryAuction(),
            //       onSelected: (value) {
            //         selectedMainCategory = value;
            //         final mainCat = cubit.mainCategories
            //             .firstWhere((e) => e.nameEn == value);
            //         selectedMainCategoryId = mainCat.id; // NEW
            //         cubit.loadSubCategories(mainCat.id!);
            //         selectedSubCategory = null;
            //         selectedSubCategoryId = null;
            //         setState(() {});
            //       },
            //     );
            //   },
            // ),
            BlocBuilder<AuctionCubit, AuctionState>(
              builder: (context, state) {
                return PaginatedDropdown(
                  title: selectedMainCategory ?? LocaleKeys.selectMainCategoryAuction.localize,
                  items: cubit.mainCategories.map((e) {
                    return context.isArabic ? (e.nameAr ?? "") : (e.nameEn ?? "");
                  }).toList(),
                  hasMore: cubit.hasMoreMainCategories,
                  loadMore: () => cubit.getMainCategoryAuction(),
                  onSelected: (value) {
                    selectedMainCategory = value;

                    // 🔑 match selected value depending on language
                    final mainCat = cubit.mainCategories.firstWhere((e) {
                      return context.isArabic ? e.nameAr == value : e.nameEn == value;
                    });

                    selectedMainCategoryId = mainCat.id;
                    cubit.loadSubCategories(mainCat.id!);
                    selectedSubCategory = null;
                    selectedSubCategoryId = null;
                    setState(() {});
                  },
                );
              },
            ),

            const SizedBox(height: 16),

            // ---------------- Sub Category Dropdown ----------------
            if (selectedMainCategory != null)
              BlocBuilder<AuctionCubit, AuctionState>(
                builder: (context, state) {
                  return PaginatedDropdown(
                    title: selectedSubCategory ?? LocaleKeys.selectSubCategoryAuction.localize,
                    items: cubit.subCategories.map((e) {
                      return context.isArabic ? (e.nameAr ?? "") : (e.nameEn ?? "");
                    }).toList(),
                    hasMore: cubit.hasMoreSubCategories,
                    loadMore: () async {
                      final mainCat = cubit.mainCategories.firstWhere((e) {
                        return context.isArabic
                            ? e.nameAr == selectedMainCategory
                            : e.nameEn == selectedMainCategory;
                      });
                      await cubit.getSubCategories(mainCat.id!);
                    },
                    onSelected: (value) {
                      selectedSubCategory = value;

                      // ✅ Match selected value depending on current language
                      final subCat = cubit.subCategories.firstWhere((e) {
                        return context.isArabic ? e.nameAr == value : e.nameEn == value;
                      });

                      selectedSubCategoryId = subCat.id;
                      setState(() {});
                    },
                  );
                },
              ),

            // BlocBuilder<AuctionCubit, AuctionState>(
              //   builder: (context, state) {
              //     return PaginatedDropdown(
              //       title: selectedSubCategory ??  LocaleKeys.selectSubCategoryAuction.localize,
              //       items: cubit.subCategories.map((e) => e.nameEn ?? "").toList(),
              //       hasMore: cubit.hasMoreSubCategories,
              //       loadMore: () async {
              //         final mainCat = cubit.mainCategories
              //             .firstWhere((e) => e.nameEn == selectedMainCategory);
              //         await cubit.getSubCategories(mainCat.id!);
              //       },
              //       onSelected: (value) {
              //         selectedSubCategory = value;
              //         final subCat = cubit.subCategories
              //             .firstWhere((e) => e.nameEn == value);
              //         selectedSubCategoryId = subCat.id; // NEW
              //         setState(() {});
              //       },
              //     );
              //   },
              // ),

            const SizedBox(height: 16),

            // ---------------- Text Fields ----------------
            _buildTextField(LocaleKeys.title.localize, controller: _titleController),
            _buildTextField(LocaleKeys.desc.localize, controller: _descriptionController),
            _buildTextField(LocaleKeys.price.localize,
                keyboardType: TextInputType.number, controller: _priceController),
            _buildTextField(LocaleKeys.minBiddingPrice.localize,
                keyboardType: TextInputType.number,
                controller: _minBidPriceController),
            // ---------------- Time Pickers ----------------
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                   LocaleKeys.auctionTime.localize,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.black),
                  ),
                  const SizedBox(height: 12),

                  // Start Time
                  GestureDetector(
                    onTap: () => _pickDateTime(context, isStart: true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 18, color: Colors.redAccent),
                          const SizedBox(width: 10),
                          Text(
                            _startAt != null
                                ? "${_startAt!.toLocal()}".split('.')[0] // show local date
                                :  LocaleKeys.selectStartDateAndTime.localize,
                            style: TextStyle(
                              fontSize: 14,
                              color: _startAt != null ? Colors.black : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // End Time
                  GestureDetector(
                    onTap: () => _pickDateTime(context, isStart: false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 18, color: Colors.redAccent),
                          const SizedBox(width: 10),
                          Text(
                            _endAt != null
                                ? "${_endAt!.toLocal()}".split('.')[0]
                                :  LocaleKeys.selectEndDateAndTime.localize,
                            style: TextStyle(
                              fontSize: 14,
                              color: _endAt != null ? Colors.black : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10,),

            // ---------------- Publish Button ----------------
            // ---------------- Publish Button ----------------
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () {
                  // if (true) {
                  //   SubscriptionMethod().subscribe(
                  //     subscribeId: '662cfacc35ddb6ba8094f80f',
                  //     onSubscribe: () {
                  //       context.pop();
                  //       context.pop();
                  //     },
                  //     showRegular: false,
                  //     title: "Subscribe"
                  //   );
                  //   return;
                  // }
                  final mediaIds = cubit.getAllMediaIds(); // from AuctionCubit

                  // Validate all fields
                  final title = _titleController.text.trim();
                  final description = _descriptionController.text.trim();
                  final priceText = _priceController.text.trim();
                  final minBidText = _minBidPriceController.text.trim();

                  if (selectedMainCategoryId == null ||
                      selectedSubCategoryId == null ||
                      title.isEmpty ||
                      description.isEmpty ||
                      priceText.isEmpty ||
                      minBidText.isEmpty ||
                      _startAt == null ||
                      _endAt == null ||
                      mediaIds.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(
                        content: Text("⚠️${LocaleKeys.pleaseFillAllFields.localize}"),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }

                  final price = num.tryParse(priceText);
                  final minBiddingPrice = num.tryParse(minBidText);

                  if (price == null || minBiddingPrice == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(
                        content: Text("⚠️ ${LocaleKeys.emptyFieldNotValid.localize}"),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }

                  // Create params
                  final params = CreateAuctionParams(
                    mainCategoryId: selectedMainCategoryId!,
                    subCategoryId: selectedSubCategoryId!,
                    title: title,
                    description: description,
                    price: price,
                    minBiddingPrice: minBiddingPrice,
                    startAt: _startAt!.toUtc().toIso8601String(),
                    endAt: _endAt!.toUtc().toIso8601String(),
                    media: mediaIds,
                  );

                  // Call cubit
                  cubit.createAuction(params: params);
                },
                child:  Text(
                  LocaleKeys.publish.localize,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

            // SizedBox(
            //   height: 50,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.redAccent,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(25),
            //       ),
            //     ),
            //     onPressed: () {
            //       final mediaIds = cubit.getAllMediaIds(); // from AuctionCubit
            //       print("Title: ${_titleController.text}");
            //       print("Description: ${_descriptionController.text}");
            //       print("Price: ${_priceController.text}");
            //       print("Min Bid Price: ${_minBidPriceController.text}");
            //       print("Time: ${_timeController.text}");
            //       print("Main Category ID: $selectedMainCategoryId");
            //       print("Sub Category ID: $selectedSubCategoryId");
            //       print("Media IDs: $mediaIds");
            //       if (_startAt != null && _endAt != null) {
            //         print("startAt: ${_startAt!.toUtc().toIso8601String()}");
            //         print("endAt: ${_endAt!.toUtc().toIso8601String()}");
            //       } else {
            //         print("⚠️ Please select start and end time");
            //       }
            //     },
            //     child: const Text(
            //       "Publish",
            //       style: TextStyle(fontSize: 16, color: Colors.white),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    ),
);
  }

  // UPDATED: added controller support
  Widget _buildTextField(
      String hint, {
        TextInputType keyboardType = TextInputType.text,
        Color? color,
        TextEditingController? controller, // NEW
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: FormTextField(
        controller: controller, // NEW
        type: keyboardType,
        hint: hint,
        fillColor: color,
        inputFormatters: [
          NoPasteFormatterAuction(), // Prevent paste operations
        ],
      ),
    );
  }
}



// ---------------- PaginatedDropdown Widget ----------------
class PaginatedDropdown extends StatefulWidget {
  final String title;
  final List<String> items;
  final Future<void> Function() loadMore;
  final Function(String) onSelected;
  final bool hasMore;

  const PaginatedDropdown({
    super.key,
    required this.title,
    required this.items,
    required this.loadMore,
    required this.onSelected,
    required this.hasMore,
  });

  @override
  State<PaginatedDropdown> createState() => _PaginatedDropdownState();
}

class _PaginatedDropdownState extends State<PaginatedDropdown> {
  bool isOpen = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 50) {
        if (widget.hasMore) {
          widget.loadMore();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Dropdown Button ---
        GestureDetector(
          onTap: () => setState(() => isOpen = !isOpen),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color:  AppColors.cF5F5F5,
              // border: Border.all(color: Colors.grey.shade400), // Thin border
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title, style: Styles.mediumText(
                  fontWeight: FontWeight.w400,
                  color:AppColors.black
                )),
                Icon(
                  isOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),

        // --- Dropdown List ---
        if (isOpen)
          Container(
            height: 250, // Adjust height
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: AppColors.cE1E1E1, // Light grey background like image
              borderRadius: BorderRadius.circular(8),
              // border: Border.all(color: Colors.grey.shade400),
            ),
            child: widget.items.isEmpty
                ?  Center(child: Text(LocaleKeys.noData.localize, style: Styles.mediumText(
                fontWeight: FontWeight.w400,
                color:AppColors.black
            )))
                : ListView.builder(
              controller: _scrollController,
              itemCount: widget.items.length + (widget.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < widget.items.length) {
                  return InkWell(
                    onTap: () {
                      widget.onSelected(widget.items[index]);
                      setState(() => isOpen = false);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      child: Text(
                        widget.items[index],
                        style:Styles.mediumText(
                            fontWeight: FontWeight.w600,
                         color: AppColors.black
                        )
                      ),
                    ),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }
              },
            ),
          ),
      ],
    );
  }
}


