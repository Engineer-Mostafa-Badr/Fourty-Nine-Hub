import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import '../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../helpers/manage_vibration.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../../domain/entity/chance_ad_entity.dart';
import '../../domain/use_case/join_chance_ad_use_case.dart';
import '../controller/cubit/chance_cubit.dart';
import '../controller/cubit/chance_states.dart';
import '../../../../core/messages/messages.dart';
import '../../../../core/utils/format_numbers.dart';

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
  int days = 0;
  int hours = 0;
  int minutes = 0;
  int seconds = 0;

  // متغير محلي لتتبع عدد المشاهدات
  late int currentViews;
  // متغير محلي لتتبع حالة الإعجاب
  late bool isFavorite;
  // وقت بداية الجلسة كبديل إذا لم يكن هناك تاريخ إنشاء
  late DateTime sessionStart;
  // متغير محلي لتتبع مساهمة المستخدم في هذا الإعلان
  double userContribution = 0.0;
  // متغير لتتبع آخر مساهمة تم إضافتها
  double? pendingContribution;

  @override
  void initState() {
    super.initState();

    // تهيئة عدد المشاهدات من البيانات الأصلية
    currentViews = widget.chanceAd?.views ?? widget.views;
    // تهيئة حالة الإعجاب من البيانات الأصلية
    isFavorite = widget.chanceAd?.isFavorite ?? false;
    // تهيئة وقت بداية الجلسة
    sessionStart = DateTime.now();
    // تهيئة مساهمة المستخدم من البيانات الأصلية
    userContribution = widget.chanceAd?.userContribution ?? 0.0;

    _countdownController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
    _startElapsedTimer();

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

  void _startElapsedTimer() {
    // حساب الوقت المنقضي منذ الإنشاء
    _calculateElapsedTime();

    // تحديث الوقت كل ثانية
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        _calculateElapsedTime();
        return true; // استمر في العد
      }
      return false;
    });
  }

  void _calculateElapsedTime() {
    if (widget.chanceAd?.createdAt != null) {
      try {
        final createdAt = DateTime.parse(widget.chanceAd!.createdAt);
        final now = DateTime.now();
        final elapsed = now.difference(createdAt);

        setState(() {
          days = elapsed.inDays;
          hours = elapsed.inHours % 24;
          minutes = elapsed.inMinutes % 60;
          seconds = elapsed.inSeconds % 60;
        });
      } catch (e) {
        // في حالة فشل تحليل التاريخ، استخدم وقت افتراضي
        setState(() {
          days = 0;
          hours = 0;
          minutes = 0;
          seconds = 0;
        });
      }
    } else {
      // إذا لم يكن هناك تاريخ إنشاء، عد منذ بداية الجلسة
      final elapsed = DateTime.now().difference(sessionStart);

      setState(() {
        days = elapsed.inDays;
        hours = elapsed.inHours % 24;
        minutes = elapsed.inMinutes % 60;
        seconds = elapsed.inSeconds % 60;
      });
    }
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
                // إضافة المساهمة المعلقة إلى إجمالي مساهمات المستخدم
                if (pendingContribution != null) {
                  userContribution += pendingContribution!;
                  pendingContribution = null; // إعادة تعيين المساهمة المعلقة
                }
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
                // تحديث حالة الإعجاب
                isFavorite = state.chanceAdDetails!.isFavorite;
              });
            }
          },
        ),
      ],
      child: CustomScaffold(
        enableCustomAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: BackAppBar(
            label: context.isArabic ? " الفرصة" : "Chance",
            enableCustomAppBar: true,
            textColor: context.isDarkMode
                ? AppColors.getReversedTextColor(context)
                : Colors.white,
          ),
        ),
        body: Column(
          children: [
            // // Header
            // Container(
            //   padding: EdgeInsets.only(
            //     top: MediaQuery.of(context).padding.top + 12.h,
            //     left: 20.w,
            //     right: 20.w,
            //     bottom: 12.h,
            //   ),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.black.withOpacity(0.05),
            //         blurRadius: 4,
            //         offset: const Offset(0, 2),
            //       ),
            //     ],
            //   ),
            //   child: Row(
            //     children: [
            //       GestureDetector(
            //         onTap: () => Navigator.pop(context),
            //         child: Icon(Icons.arrow_back_ios,
            //             size: 28.sp, color: Colors.black87),
            //       ),
            //       const Spacer(),
            //       Text(
            //         'Chance',
            //         style: TextStyle(
            //           fontSize: 26.sp,
            //           fontWeight: FontWeight.w700,
            //           color: Colors.black87,
            //         ),
            //       ),
            //       const Spacer(),
            //       Container(width: 28.w), // Balance the layout
            //     ],
            //   ),
            // ),
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
                            width: 660.w,
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
                                  height: 430.h,
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
                                ManageVibration.vibrate();
                                _toggleFavorite();
                              },
                              child: Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite
                                      ? Colors.red
                                      : Colors.grey[600],
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
                        // color: Colors.white,
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
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                              fontFamily: "roboto",
                            ),
                          ),
                          SizedBox(height: 8.h),
                          // Description
                          Text(
                            widget.description,
                            style: TextStyle(
                              fontSize: 26.sp,
                              color: Color(0xff0D141C),
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          // Collection Progress
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.isArabic ? 'مجمع' : 'Collected',
                                style: TextStyle(
                                  fontSize: 30.sp,
                                  color: Color(0XFF0D141C),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                context.isArabic
                                    ? '${FormatNumbers().convertToArabicNumerals(_getCollectedAmount().toInt().toString())} جنيه مصري'
                                    : '${_getCollectedAmount().toInt()} EGP',
                                style: TextStyle(
                                  fontSize: 32.sp,
                                  color: Color(0XFF0D141C),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          // Progress Bar
                          LinearProgressIndicator(
                            value: _getProgressValue(),
                            backgroundColor: Color(0xffCFDBE8),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.c0B1035,
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                            minHeight: 12.h,
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.isArabic ? 'الهدف' : 'Target:',
                                style: TextStyle(
                                  fontSize: 30.sp,
                                  color: Color(0xffF33D49),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                context.isArabic
                                    ? '${FormatNumbers().convertToArabicNumerals(widget.price.toString())} جنيه مصري'
                                    : '${widget.price} EGP',
                                style: TextStyle(
                                  fontSize: 32.sp,
                                  color: Color(0xffF33D49),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          // Elapsed Time Timer
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildTimeUnit(days.toString(),
                                  context.isArabic ? 'أيام' : 'Days'),
                              _buildTimeUnit(hours.toString().padLeft(2, '0'),
                                  context.isArabic ? 'ساعات' : 'Hours'),
                              _buildTimeUnit(minutes.toString().padLeft(2, '0'),
                                  context.isArabic ? 'دقائق' : 'Minutes'),
                              _buildTimeUnit(seconds.toString().padLeft(2, '0'),
                                  context.isArabic ? 'ثواني' : 'Seconds'),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          // Views - استخدام المتغير المحلي
                          Row(
                            children: [
                              SvgPicture.asset(
                                Assets.eyeChance,
                                height: 24.h,
                                width: 24.w,
                              ),
                              SizedBox(width: 10.w),
                              Label(
                                text: context.isArabic
                                    ? '${FormatNumbers().convertToArabicNumerals(_formatViews(currentViews).toString())} مشاهد'
                                    : '${_formatViews(currentViews)} views',
                                style: TextStyle(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff0D141C),
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
                            context.isArabic ? 'مشاركاتك' : 'Your Shares',
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w700,
                              color: Color(0xCC0B1035),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            _getTotalUserContributions(),
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                    // Join Button
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ManageVibration.vibrate();
                          _showParticipateBottomSheet();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          context.isArabic ? 'انضم' : 'Join',
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
      width: 155.w,
      height: 105.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Color(0xffe8edf5),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            context.isArabic
                ? FormatNumbers().convertToArabicNumerals(value)
                : value,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w700,
              color: Color(0xff0D141C),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w400,
              color: Color(0xff0D141C),
            ),
          ),
        ],
      ),
    );
  }

  String _formatViews(int views) {
    String formattedViews;
    if (views >= 1000000) {
      formattedViews = '${(views / 1000000).toStringAsFixed(1)}M';
    } else if (views >= 1000) {
      formattedViews = '${(views / 1000).toStringAsFixed(1)}K';
    } else {
      formattedViews = views.toString();
    }

    return context.isArabic
        ? FormatNumbers().convertToArabicNumerals(formattedViews)
        : formattedViews;
  }

  void _refreshLocalData() {
    // Refresh the chance ad details to get updated data
    if (widget.chanceAd != null) {
      context.read<ChanceCubit>().getChanceAdDetails(widget.chanceAd!.id);
    }
  }

  void _toggleFavorite() {
    if (widget.chanceAd?.id != null) {
      // تحديث فوري في الواجهة
      setState(() {
        isFavorite = !isFavorite;
      });

      // إرسال التحديث للباك إند
      context.read<ChanceCubit>().toggleChanceAdFavorite(widget.chanceAd!.id);
    }
  }

  String _getTotalUserContributions() {
    // استخدام التتبع المحلي للمساهمات مع أي مساهمة معلقة
    double totalContributions = userContribution;
    if (pendingContribution != null) {
      totalContributions += pendingContribution!;
    }

    final amount = totalContributions.toStringAsFixed(0);
    return context.isArabic
        ? '${FormatNumbers().convertToArabicNumerals(amount)} جنيه مصري'
        : '$amount EGP';
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
                      context.isArabic ? 'شارك' : 'Participate',
                      style: TextStyle(
                        fontSize: 36.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ManageVibration.vibrate();
                        Navigator.pop(bottomSheetContext);
                      },
                      child: Icon(Icons.close,
                          size: 36.sp, color: Colors.grey[600]),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                // Question
                Text(
                  context.isArabic ? 'هل تريد مشاركة?' : 'One or more shares?',
                  style: TextStyle(
                    fontSize: 32.sp,
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
                      hintText: context.isArabic ?  'أدخل المبلغ بالجنيه' : 'Enter the amount in EGP',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: 32.sp,
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
                      ManageVibration.vibrate();
                      final inputText = amountController.text.trim();
                      final amount = double.tryParse(inputText);

                      print("Input text: $inputText");
                      print("Parsed amount: $amount");

                      if (inputText.isEmpty) {
                        ScaffoldMessenger.of(bottomSheetContext).showSnackBar(
                          SnackBar(content: Text(context.isArabic? 'من فضلك أدخل مبلغ' : 'Please enter an amount')),
                        );
                      } else if (amount == null) {
                        ScaffoldMessenger.of(bottomSheetContext).showSnackBar(
                           SnackBar(
                              content: Text(context.isArabic? 'من فضلك أدخل رقم صحيح' : 'Please enter a valid number')),
                        );
                      } else if (amount <= 0) {
                        ScaffoldMessenger.of(bottomSheetContext).showSnackBar(
                           SnackBar(
                              content: Text( context.isArabic? 'المبلغ يجب أن يكون أكبر من صفر' : 'Amount must be greater than zero')),
                        );
                      } else if (amount < 1) {
                        ScaffoldMessenger.of(bottomSheetContext).showSnackBar(
                           SnackBar(
                              content: Text( context.isArabic? 'الحد الأدنى للمساهمة 1 جنيه' : 'Minimum contribution is 1 EGP')),
                        );
                      } else if (widget.chanceAd == null) {
                        ScaffoldMessenger.of(bottomSheetContext).showSnackBar(
                           SnackBar(
                              content: Text( context.isArabic? 'خطاء في بيانات الإعلان' : 'Error in ad data')),
                        );
                      } else {
                        Navigator.pop(bottomSheetContext);
                        // تخزين المساهمة المعلقة
                        pendingContribution = amount;
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
                      context.isArabic ? 'تأكيد' : 'Confirm',
                      style: TextStyle(
                        fontSize: 32.sp,
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
