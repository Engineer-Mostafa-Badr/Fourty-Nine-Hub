// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import '../../../../../core/extensions/context_extension.dart';
// import '../../../../../core/widget/clickable_widget.dart';
// import '../../../../../core/widget/custom_circular_progress_indicator.dart';
// import '../cubit/create_post_cubit.dart';
// import '../../../../../res/assets/assets.dart';
// import '../../../../../routes/routes.dart';
// import 'package:go_router/go_router.dart';
// import '../../../../../helpers/manage_vibration.dart';

// class CachedSvgImage extends StatefulWidget {
//   final String imageUrl;
//   final String fallbackImage; // Local fallback SVG
//   final double width;
//   final double height;
//   final Color? color;

//   const CachedSvgImage({
//     required this.imageUrl,
//     this.fallbackImage = "assets/fallback.svg", // Default fallback SVG
//     this.color, // Default fallback SVG
//     this.width = 100,
//     this.height = 100,
//     super.key,
//   });

//   @override
//   _CachedSvgImageState createState() => _CachedSvgImageState();
// }

// class LifeEvent extends StatefulWidget {
//   const LifeEvent({super.key});

//   @override
//   State<LifeEvent> createState() => _LifeEventState();
// }

// class _CachedSvgImageState extends State<CachedSvgImage> {
//   File? _svgFile;
//   bool _hasError = false;

//   @override
//   Widget build(BuildContext context) {
//     if (_hasError || _svgFile == null) {
//       return Image.asset(
//         widget.fallbackImage,
//         width: widget.width,
//         height: widget.height,
//       );
//     }

//     return SvgPicture.file(
//       _svgFile!,
//       width: widget.width,
//       color: widget.color,
//       height: widget.height,
//       placeholderBuilder: (context) => const CustomCircularProgressIndicator(),
//       errorBuilder: (context, error, stackTrace) {
//         return SvgPicture.asset(
//           widget.fallbackImage,
//           width: widget.width,
//           height: widget.height,
//         );
//       },
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     _loadSvg();
//   }

//   Future<void> _loadSvg() async {
//     try {
//       final file = await DefaultCacheManager().getSingleFile(widget.imageUrl);
//       if (mounted) {
//         setState(() {
//           _svgFile = file;
//           _hasError = false;
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _hasError = true;
//         });
//       }
//     }
//   }
// }

// class _LifeEventState extends State<LifeEvent> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Create Life Event",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
//         ),
//       ),
//       body: BlocBuilder<CreatePostCubit, CreatePostState>(
//           builder: (context, state) {
//         var cubit = context.read<CreatePostCubit>();
//         return Column(
//           // shrinkWrap: true,
//           // padding: const EdgeInsets.all(0),
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const Divider(),
//             Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 child: Image.asset(
//                   Assets.lifeEvent,
//                   width: double.infinity,
//                   height: 116,
//                   fit: BoxFit.fill,
//                 )),
//             const SizedBox(
//               width: 225,
//               child: Text(
//                 "Share and remember important moments from your life.",
//                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             const SizedBox(
//               height: 8,
//             ),
//             const Divider(),
//             const SizedBox(
//               height: 16,
//             ),
//             const Text(
//               "SELECT A CATEGORY",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(
//               height: 8,
//             ),
//             Expanded(
//                 child: cubit.isLoadingMoreLifeEvent
//                     ? Center(
//                         child: CustomCircularProgressIndicator(),
//                       )
//                     : GridView.builder(
//                         shrinkWrap: true,
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         itemCount: cubit.lifeEventCategories.length,
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 3,
//                           crossAxisSpacing: 5,
//                           mainAxisSpacing: 0,
//                           childAspectRatio: 1,
//                         ),
//                         itemBuilder: (context, index) {
//                           print(cubit.lifeEventCategories[index].image);
//                           return ClickableWidget(
//                             onTap: () {
//       ManageVibration.vibrate();
//                               context.pushNamed(Routes.LIFEEVENTSub,
//                                   extra: cubit.lifeEventCategories[index]);
//                             },
//                             child: Container(
//                               padding: const EdgeInsetsDirectional.only(
//                                   end: 10, bottom: 16),
//                               child: Column(children: [
//                                 CachedSvgImage(
//                                     imageUrl:
//                                         cubit.lifeEventCategories[index].image,
//                                     fallbackImage: Assets.logo,
//                                     height: 42,
//                                     width: 42),
//                                 // SvgPicture.network(cubit.lifeEventCategories[index].image,height: 42,width: 42,fit: BoxFit.fill,),
//                                 // ImageFromInternet(image: cubit.lifeEventCategories[index].image,height: 42,width: 42,fit: BoxFit.fill,defaultLogo: true,isSvg: true,),
//                                 // Image.asset(
//                                 //   Assets.lifeEvent,
//                                 //   width: 42,
//                                 //   height: 42,
//                                 //   fit: BoxFit.fill,
//                                 // ),
//                                 const SizedBox(
//                                   height: 8,
//                                 ),
//                                 Text(
//                                   context.isArabic
//                                       ? cubit.lifeEventCategories[index].titleAr
//                                       : cubit
//                                           .lifeEventCategories[index].titleEn,
//                                   style: const TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w500),
//                                   textAlign: TextAlign.center,
//                                   maxLines: 2,
//                                 ),
//                               ]),
//                             ),
//                           );
//                         },
//                       ))
//           ],
//         );
//       }),
//     );
//   }

//   @override
//   initState() {
//     context.read<CreatePostCubit>().getLifeEventCategories();
//     super.initState();
//   }
// }

///! to run widgtetbook run this command
library;

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/cubit/create_post_cubit.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class CachedSvgImage extends StatefulWidget {
  final String imageUrl;
  final String fallbackImage; // Local fallback SVG
  final double width;
  final double height;
  final Color? color;

  const CachedSvgImage({
    required this.imageUrl,
    this.fallbackImage = "assets/fallback.svg", // Default fallback SVG
    this.color,
    this.width = 100,
    this.height = 100,
    super.key,
  });

  @override
  _CachedSvgImageState createState() => _CachedSvgImageState();
}

class LifeEvent extends StatefulWidget {
  const LifeEvent({super.key});

  @override
  State<LifeEvent> createState() => _LifeEventState();
}

// تحسين إضافي: إضافة widget للتعامل مع حالات مختلفة من الصور
class OptimizedCachedSvgImage extends StatefulWidget {
  final String imageUrl;
  final String fallbackImage;
  final double width;
  final double height;
  final Color? color;
  final Duration cacheDuration;
  final BoxFit fit;

  const OptimizedCachedSvgImage({
    required this.imageUrl,
    this.fallbackImage = "assets/fallback.svg",
    this.color,
    this.width = 100,
    this.height = 100,
    this.cacheDuration = const Duration(days: 7),
    this.fit = BoxFit.contain,
    super.key,
  });

  @override
  _OptimizedCachedSvgImageState createState() =>
      _OptimizedCachedSvgImageState();
}

class _CachedSvgImageState extends State<CachedSvgImage> {
  Uint8List? _svgData;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    // عرض loading أثناء التحميل
    if (_isLoading) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: const Center(
          child: CustomCircularProgressIndicator(),
        ),
      );
    }

    // عرض fallback في حالة الخطأ أو فشل التحميل
    if (_hasError || _svgData == null) {
      return Image.asset(
        widget.fallbackImage,
        width: widget.width,
        height: widget.height,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.image_not_supported,
              size: widget.width * 0.5,
              color: Colors.grey[600],
            ),
          );
        },
      );
    }

    // عرض SVG من البيانات المحملة
    return SvgPicture.memory(
      _svgData!,
      width: widget.width,
      height: widget.height,
      colorFilter: widget.color != null
          ? ColorFilter.mode(widget.color!, BlendMode.srcIn)
          : null,
      placeholderBuilder: (context) => SizedBox(
        width: widget.width,
        height: widget.height,
        child: const Center(
          child: CustomCircularProgressIndicator(),
        ),
      ),
      // في حالة فشل عرض SVG، استخدم fallback
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          widget.fallbackImage,
          width: widget.width,
          height: widget.height,
          errorBuilder: (context, error, stackTrace) {
            // fallback نهائي في حالة فشل كل شيء
            return Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.broken_image,
                size: widget.width * 0.5,
                color: Colors.grey[600],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void didUpdateWidget(CachedSvgImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _loadSvg();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSvg();
  }

  Future<void> _loadSvg() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // محاولة تحميل SVG من الكاش
      final file = await DefaultCacheManager().getSingleFile(widget.imageUrl);

      if (mounted) {
        // قراءة محتوى الملف كـ bytes
        final bytes = await file.readAsBytes();
        setState(() {
          _svgData = bytes;
          _isLoading = false;
          _hasError = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }
}

class _LifeEventState extends State<LifeEvent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Life Event",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: BlocBuilder<CreatePostCubit, CreatePostState>(
          builder: (context, state) {
        var cubit = context.read<CreatePostCubit>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Divider(),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Image.asset(
                  Assets.lifeEvent,
                  width: double.infinity,
                  height: 116,
                  fit: BoxFit.fill,
                )),
            const SizedBox(
              width: 225,
              child: Text(
                "Share and remember important moments from your life.",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Divider(),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "SELECT A CATEGORY",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
                child: cubit.isLoadingMoreLifeEvent
                    ? Center(
                        child: CustomCircularProgressIndicator(),
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: cubit.lifeEventCategories.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 0,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          print(cubit.lifeEventCategories[index].image);
                          return ClickableWidget(
                            onTap: () {
                              context.pushNamed(Routes.LIFEEVENTSub,
                                  extra: cubit.lifeEventCategories[index]);
                            },
                            child: Container(
                              padding: const EdgeInsetsDirectional.only(
                                  end: 10, bottom: 16),
                              child: Column(children: [
                                CachedSvgImage(
                                    imageUrl:
                                        cubit.lifeEventCategories[index].image,
                                    fallbackImage: Assets.logo,
                                    height: 42,
                                    width: 42),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  context.isArabic
                                      ? cubit.lifeEventCategories[index].titleAr
                                      : cubit
                                          .lifeEventCategories[index].titleEn,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ]),
                            ),
                          );
                        },
                      ))
          ],
        );
      }),
    );
  }

  @override
  initState() {
    context.read<CreatePostCubit>().getLifeEventCategories();
    super.initState();
  }
}

class _OptimizedCachedSvgImageState extends State<OptimizedCachedSvgImage> {
  Uint8List? _svgData;
  bool _isLoading = true;
  bool _hasError = false;
  late final CacheManager _cacheManager;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildPlaceholder();
    }

    if (_hasError || _svgData == null) {
      // محاولة عرض fallback image
      return Image.asset(
        widget.fallbackImage,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
      );
    }

    return SvgPicture.memory(
      _svgData!,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      colorFilter: widget.color != null
          ? ColorFilter.mode(widget.color!, BlendMode.srcIn)
          : null,
      placeholderBuilder: (context) => _buildPlaceholder(),
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          widget.fallbackImage,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
        );
      },
    );
  }

  @override
  void didUpdateWidget(OptimizedCachedSvgImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _loadSvg();
    }
  }

  @override
  void dispose() {
    // تنظيف الذاكرة
    _svgData = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // إنشاء cache manager مخصص للـ SVG files
    _cacheManager = CacheManager(
      Config(
        'svg_cache',
        stalePeriod: widget.cacheDuration,
        maxNrOfCacheObjects: 100,
      ),
    );
    _loadSvg();
  }

  Widget _buildErrorWidget() {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image,
            size: widget.width * 0.3,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 4),
          Text(
            'Failed to load',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: CustomCircularProgressIndicator(),
      ),
    );
  }

  Future<void> _loadSvg() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final file = await _cacheManager.getSingleFile(widget.imageUrl);

      if (mounted) {
        final bytes = await file.readAsBytes();
        setState(() {
          _svgData = bytes;
          _isLoading = false;
          _hasError = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading SVG: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }
}
