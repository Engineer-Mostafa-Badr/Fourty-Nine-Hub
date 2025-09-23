import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entity/chance_ad_entity.dart';
import '../../domain/use_case/join_chance_ad_use_case.dart';
import '../controller/cubit/chance_cubit.dart';
import '../controller/cubit/chance_states.dart';
import '../../../../core/messages/messages.dart';

class ChanceDetailView extends StatefulWidget {
  final String title;
  final int price;
  final List<String> images;
  final double progress;
  final int participants;
  final int views;
  final String description;
  ChanceAdEntity? chanceAd; // إزالة final للسماح بالتعديل

  ChanceDetailView({
    super.key,
    required this.title,
    required this.price,
    required this.images,
    required this.progress,
    required this.participants,
    required this.views,
    required this.description,
    this.chanceAd,
  });

  @override
  State<ChanceDetailView> createState() => _ChanceDetailViewState();
}

class _ChanceDetailViewState extends State<ChanceDetailView>
    with TickerProviderStateMixin {
  late AnimationController _countdownController;
  int days = 3;
  int hours = 12;
  int minutes = 30;
  int seconds = 45;

  // متغير محلي لتتبع عدد المشاهدات
  late int currentViews;

  @override
  void initState() {
    super.initState();

    // تهيئة عدد المشاهدات من البيانات الأصلية
    currentViews = widget.chanceAd?.views ?? widget.views;

    _countdownController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
    _startCountdown();

    // زيادة عدد المشاهدات فوراً وإرسال للباك إند
    print('ChanceDetailView initState - chanceAd: ${widget.chanceAd?.id}');
    if (widget.chanceAd != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print('Calling incrementChanceAdView for adId: ${widget.chanceAd!.id}');

        // تحديث فوري في الواجهة
        setState(() {
          // زيادة المشاهدات بـ 1
          currentViews = currentViews + 1;
        });

        // إرسال التحديث للباك إند
        context.read<ChanceCubit>().incrementChanceAdView(widget.chanceAd!.id);
      });
    } else {
      print('WARNING: chanceAd is null, cannot increment view');
    }
  }

  void _startCountdown() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          if (seconds > 0) {
            seconds--;
          } else if (minutes > 0) {
            seconds = 59;
            minutes--;
          } else if (hours > 0) {
            seconds = 59;
            minutes = 59;
            hours--;
          } else if (days > 0) {
            seconds = 59;
            minutes = 59;
            hours = 23;
            days--;
          }
        });
        return days > 0 || hours > 0 || minutes > 0 || seconds > 0;
      }
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Listener لعملية الانضمام
        BlocListener<ChanceCubit, ChanceState>(
          listenWhen: (previous, current) =>
              previous.status != current.status &&
              (current.status == ChanceStates.joinSuccess ||
                  current.status == ChanceStates.error),
          listener: (context, state) {
            if (state.status == ChanceStates.joinSuccess) {
              showSuccessMessage(context, 'تم الانضمام للفرصة بنجاح!');

              // تحديث فوري للواجهة
              setState(() {
                // إعادة بناء الصفحة بالبيانات المحدثة
              });

              // طلب تحديث البيانات من الـ API
              if (widget.chanceAd != null) {
                _refreshLocalData();
              }
            } else if (state.status == ChanceStates.error) {
              showErrorMessage(
                  context, 'فشل في الانضمام للفرصة، حاول مرة أخرى');
            }
          },
        ),

        // Listener لتحديث تفاصيل الإعلان
        BlocListener<ChanceCubit, ChanceState>(
          listenWhen: (previous, current) =>
              current.chanceAdDetails != null &&
              current.chanceAdDetails!.id == widget.chanceAd?.id,
          listener: (context, state) {
            if (state.chanceAdDetails != null) {
              setState(() {
                // تحديث البيانات بالقيم الجديدة من الـ API
                widget.chanceAd = state.chanceAdDetails;
                // تحديث المشاهدات إذا كانت أكبر من القيمة المحلية
                if (state.chanceAdDetails!.views > currentViews) {
                  currentViews = state.chanceAdDetails!.views;
                }
              });
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 12.h,
                left: 20.w,
                right: 20.w,
                bottom: 12.h,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_ios,
                        size: 28.sp, color: Colors.black87),
                  ),
                  const Spacer(),
                  Text(
                    'Chance',
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  Container(width: 28.w), // Balance the layout
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Image Carousel with Favorite Icon
                    Container(
                      margin: EdgeInsets.all(20.w),
                      child: Stack(
                        children: [
                          // Image Carousel
                          Container(
                            height: 300.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.r),
                              child: CarouselSlider(
                                options: CarouselOptions(
                                  height: 300.h,
                                  viewportFraction: 1.0,
                                  enableInfiniteScroll: false,
                                  autoPlay: true,
                                ),
                                items: widget.images.map((image) {
                                  return Image.network(
                                    image,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[200],
                                        child: Icon(
                                          Icons.image_not_supported,
                                          size: 50.sp,
                                          color: Colors.grey[400],
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          // Favorite Icon
                          Positioned(
                            top: 12.h,
                            left: 12.w,
                            child: GestureDetector(
                              onTap: () {
                                // Toggle favorite functionality
                              },
                              child: Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 30.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Content Card
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          // Description
                          Text(
                            widget.description,
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.grey[600],
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          // Collection Progress
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Collected',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${_getCollectedAmount().toInt()} EGP',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          // Progress Bar
                          LinearProgressIndicator(
                            value: _getProgressValue(),
                            backgroundColor: Colors.grey[200],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.blue),
                            minHeight: 6.h,
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Target:',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${widget.price} EGP',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          // Countdown Timer
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildTimeUnit(days.toString(), 'Days'),
                              SizedBox(width: 12.w),
                              _buildTimeUnit(
                                  hours.toString().padLeft(2, '0'), 'Hours'),
                              SizedBox(width: 12.w),
                              _buildTimeUnit(minutes.toString().padLeft(2, '0'),
                                  'Minutes'),
                              SizedBox(width: 12.w),
                              _buildTimeUnit(seconds.toString().padLeft(2, '0'),
                                  'Seconds'),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          // Views - استخدام المتغير المحلي
                          Row(
                            children: [
                              Icon(Icons.visibility,
                                  size: 30.sp, color: Colors.grey[600]),
                              SizedBox(width: 6.w),
                              Text(
                                '${_formatViews(currentViews)} views',
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // Your Shares Section
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Your Shares',
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            widget.chanceAd?.userContribution != null
                                ? '${widget.chanceAd!.userContribution!.toStringAsFixed(0)} EGP'
                                : '0 EGP',
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    // Join Button
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _showParticipateBottomSheet(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'Join',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods للحصول على البيانات المحدثة
  double _getCollectedAmount() {
    if (widget.chanceAd?.totalContributions != null) {
      return widget.chanceAd!.totalContributions.toDouble();
    }
    return (widget.price * widget.progress);
  }

  double _getProgressValue() {
    if (widget.chanceAd?.totalContributions != null) {
      return (widget.chanceAd!.totalContributions / widget.price)
          .clamp(0.0, 1.0);
    }
    return widget.progress;
  }

  Widget _buildTimeUnit(String value, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  String _formatViews(int views) {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K';
    } else {
      return views.toString();
    }
  }

  void _refreshLocalData() {
    // Refresh the chance ad details to get updated data
    if (widget.chanceAd != null) {
      context.read<ChanceCubit>().getChanceAdDetails(widget.chanceAd!.id);
    }
  }

  void _showParticipateBottomSheet() {
    final TextEditingController amountController = TextEditingController();
    final cubit = context.read<ChanceCubit>(); // احصل على الـ cubit مسبقاً

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Padding(
            padding: EdgeInsets.all(28.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 20.h),

                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Participate',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(bottomSheetContext),
                      child: Icon(Icons.close,
                          size: 24.sp, color: Colors.grey[600]),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                // Question
                Text(
                  'One or more shares?',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 16.h),

                // Amount Input
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: TextField(
                    controller: amountController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: 'أدخل المبلغ بالجنيه',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[500],
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Confirm Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final inputText = amountController.text.trim();
                      final amount = double.tryParse(inputText);

                      print("Input text: $inputText");
                      print("Parsed amount: $amount");

                      if (inputText.isEmpty) {
                        ScaffoldMessenger.of(bottomSheetContext).showSnackBar(
                          const SnackBar(content: Text('من فضلك أدخل مبلغ')),
                        );
                      } else if (amount == null) {
                        ScaffoldMessenger.of(bottomSheetContext).showSnackBar(
                          const SnackBar(
                              content: Text('من فضلك أدخل رقم صحيح')),
                        );
                      } else if (amount <= 0) {
                        ScaffoldMessenger.of(bottomSheetContext).showSnackBar(
                          const SnackBar(
                              content: Text('المبلغ يجب أن يكون أكبر من صفر')),
                        );
                      } else if (amount < 1) {
                        ScaffoldMessenger.of(bottomSheetContext).showSnackBar(
                          const SnackBar(
                              content: Text('الحد الأدنى للمساهمة 1 جنيه')),
                        );
                      } else if (widget.chanceAd == null) {
                        ScaffoldMessenger.of(bottomSheetContext).showSnackBar(
                          const SnackBar(
                              content: Text('خطأ في بيانات الإعلان')),
                        );
                      } else {
                        Navigator.pop(bottomSheetContext);
                        // استخدم الـ cubit مباشرة
                        cubit.joinChanceAd(
                          JoinChanceAdParams(
                            adId: widget.chanceAd!.id,
                            amount: amount,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
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

  @override
  void dispose() {
    _countdownController.dispose();
    super.dispose();
  }
}

// Enums
enum ChanceStatus { available, expired, winner }

// Helper Extensions
extension ChanceStatusExtension on ChanceStatus {
  String get displayName {
    switch (this) {
      case ChanceStatus.available:
        return 'Available';
      case ChanceStatus.expired:
        return 'Expired';
      case ChanceStatus.winner:
        return 'Winner';
    }
  }
}
