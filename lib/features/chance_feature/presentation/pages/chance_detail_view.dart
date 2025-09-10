import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ChanceDetailView extends StatefulWidget {
  final String title;
  final int price;
  final List<String> images;
  final double progress;
  final int participants;
  final int views;
  final String description;

  const ChanceDetailView({
    super.key,
    required this.title,
    required this.price,
    required this.images,
    required this.progress,
    required this.participants,
    required this.views,
    required this.description,
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

  @override
  void initState() {
    super.initState();
    _countdownController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
    _startCountdown();
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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8.h,
              left: 16.w,
              right: 16.w,
              bottom: 8.h,
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
                      size: 20.sp, color: Colors.black87),
                ),
                const Spacer(),
                Text(
                  'Chance',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                Container(width: 20.w), // Balance the layout
              ],
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Favorite Icon
                  Container(
                    margin: EdgeInsets.all(16.w),
                    child: Stack(
                      children: [
                        // Image Carousel
                        Container(
                          height: 250.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: CarouselSlider(
                              options: CarouselOptions(
                                height: 250.h,
                                viewportFraction: 1.0,
                                enableInfiniteScroll: false,
                                autoPlay: true,
                              ),
                              items: widget.images.map((image) {
                                return Image.network(
                                  image,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
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
                              // Toggle favorite
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
                                size: 16.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Content Card
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        // Description
                        Text(
                          widget.description,
                          style: TextStyle(
                            fontSize: 14.sp,
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
                                fontSize: 14.sp,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${(widget.price * widget.progress).toInt()} EGP',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        // Progress Bar
                        LinearProgressIndicator(
                          value: widget.progress,
                          backgroundColor: Colors.grey[200],
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.blue),
                          minHeight: 6.h,
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Target:',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              '${widget.price} EGP',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.red,
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
                            _buildTimeUnit(
                                minutes.toString().padLeft(2, '0'), 'Minutes'),
                            SizedBox(width: 12.w),
                            _buildTimeUnit(
                                seconds.toString().padLeft(2, '0'), 'Minutes'),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        // Views
                        Row(
                          children: [
                            Icon(Icons.visibility,
                                size: 16.sp, color: Colors.grey[600]),
                            SizedBox(width: 4.w),
                            Text(
                              '${widget.views}K views',
                              style: TextStyle(
                                fontSize: 12.sp,
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
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          '2 EGP',
                          style: TextStyle(
                            fontSize: 24.sp,
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
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showParticipateBottomSheet(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Join',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
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
    );
  }

  Widget _buildTimeUnit(String value, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _showParticipateBottomSheet() {
    final TextEditingController amountController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
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
                    onTap: () => Navigator.pop(context),
                    child:
                        Icon(Icons.close, size: 24.sp, color: Colors.grey[600]),
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
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'EGP',
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
                    Navigator.pop(context);
                    // Handle participation logic
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
      ),
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
