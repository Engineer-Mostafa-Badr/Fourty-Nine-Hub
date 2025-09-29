import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import '../../../../helpers/manage_vibration.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../logic/currency_cubit.dart';
import '../widgets/exchange_rate_display_widget.dart';
import '../widgets/refresh_settings_widget.dart';

class ArabicNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Convert English numerals to Arabic numerals for display
    String arabicText = newValue.text
        .replaceAll('0', '٠')
        .replaceAll('1', '١')
        .replaceAll('2', '٢')
        .replaceAll('3', '٣')
        .replaceAll('4', '٤')
        .replaceAll('5', '٥')
        .replaceAll('6', '٦')
        .replaceAll('7', '٧')
        .replaceAll('8', '٨')
        .replaceAll('9', '٩');

    return TextEditingValue(
      text: arabicText,
      selection: newValue.selection,
    );
  }
}

class CurrencyExchangePage extends StatefulWidget {
  const CurrencyExchangePage({super.key});

  @override
  State<CurrencyExchangePage> createState() => _CurrencyExchangePageState();
}

class _CurrencyExchangePageState extends State<CurrencyExchangePage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final TextEditingController _amountController = TextEditingController();
  bool _isExpanded = false;
  final bool _showSettings = false;

  late AnimationController _refreshAnimationController;
  late AnimationController _pulseAnimationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Add app lifecycle observer
    WidgetsBinding.instance.addObserver(this);

    // Initialize controllers
    _amountController.text = '00.00';

    // Animation controllers
    _refreshAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _refreshAnimationController,
      curve: Curves.linear,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start pulse animation for auto-refresh indicator
    _pulseAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _amountController.dispose();
    _refreshAnimationController.dispose();
    _pulseAnimationController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    context.read<CurrencyCubit>().onAppStateChanged(state);
  }

  void _startRefreshAnimation() {
    _refreshAnimationController.repeat();
  }

  void _stopRefreshAnimation() {
    _refreshAnimationController.stop();
    _refreshAnimationController.reset();
  }

  void _updateControllerTextForLocale() {
    if (context.isArabic) {
      // Convert current text to Arabic numerals
      String currentText = _amountController.text;
      String arabicText = currentText
          .replaceAll('0', '٠')
          .replaceAll('1', '١')
          .replaceAll('2', '٢')
          .replaceAll('3', '٣')
          .replaceAll('4', '٤')
          .replaceAll('5', '٥')
          .replaceAll('6', '٦')
          .replaceAll('7', '٧')
          .replaceAll('8', '٨')
          .replaceAll('9', '٩');
      _amountController.text = arabicText;
    } else {
      // Convert current text to English numerals
      String currentText = _amountController.text;
      String englishText = currentText
          .replaceAll('٠', '0')
          .replaceAll('١', '1')
          .replaceAll('٢', '2')
          .replaceAll('٣', '3')
          .replaceAll('٤', '4')
          .replaceAll('٥', '5')
          .replaceAll('٦', '6')
          .replaceAll('٧', '7')
          .replaceAll('٨', '8')
          .replaceAll('٩', '9');
      _amountController.text = englishText;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Update controller text based on current locale
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateControllerTextForLocale();
    });

    return CustomScaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: AppColors.PRIMARY_COLOR,
          elevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          leading: SizedBox(
            width: 30,
            height: 30,
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(Icons.arrow_back_ios,
                  color: AppColors.whiteColor, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          title: Text(
            context.isArabic ? 'تبديل العملات' : 'Exchange',
            style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          // actions: [
          //   // Settings toggle
          //   BlocBuilder<CurrencyCubit, CurrencyState>(
          //     builder: (context, state) {
          //       return IconButton(
          //         icon: Icon(
          //           _showSettings ? Icons.close : Icons.settings,
          //           color: AppColors.PRIMARY_COLOR,
          //           size: 20,
          //         ),
          //         onPressed: () {
          //           setState(() {
          //             _showSettings = !_showSettings;
          //           });
          //           ManageVibration.vibrate();
          //         },
          //       );
          //     },
          //   ),

          //   // Auto-refresh status indicator
          //   BlocBuilder<CurrencyCubit, CurrencyState>(
          //     builder: (context, state) {
          //       final cubit = context.read<CurrencyCubit>();

          //       if (state is CurrencyRefreshing) {
          //         _startRefreshAnimation();
          //       } else {
          //         _stopRefreshAnimation();
          //       }

          //       return AnimatedBuilder(
          //         animation: _rotationAnimation,
          //         builder: (context, child) {
          //           return Transform.rotate(
          //             angle: _rotationAnimation.value * 2 * 3.14159,
          //             child: AnimatedBuilder(
          //               animation: _pulseAnimation,
          //               builder: (context, child) {
          //                 return Transform.scale(
          //                   scale: cubit.autoRefreshEnabled
          //                       ? _pulseAnimation.value
          //                       : 1.0,
          //                   child: IconButton(
          //                     icon: Icon(
          //                       cubit.autoRefreshEnabled
          //                           ? Icons.sync
          //                           : Icons.sync_disabled,
          //                       color: cubit.autoRefreshEnabled
          //                           ? Colors.green
          //                           : Colors.grey,
          //                       size: 20,
          //                     ),
          //                     onPressed: () {
          //                       ManageVibration.vibrate();
          //                       if (cubit.autoRefreshEnabled) {
          //                         cubit.disableAutoRefresh();
          //                       } else {
          //                         cubit.enableAutoRefresh();
          //                       }
          //                     },
          //                   ),
          //                 );
          //               },
          //             ),
          //           );
          //         },
          //       );
          //     },
          //   ),
          // ],
        ),
      ),
      body: BlocConsumer<CurrencyCubit, CurrencyState>(
        listener: (context, state) {
          if (state is CurrencyError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: context.isArabic ? 'إعادة المحاولة' : 'Retry',
                  textColor: AppColors.getReversedTextColor(context),
                  onPressed: () {
                    context.read<CurrencyCubit>().forceRefresh();
                  },
                ),
              ),
            );
          } else if (state is CurrencyUpdatedSilently) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.sync,
                        color: AppColors.getReversedTextColor(context),
                        size: 16),
                    const SizedBox(width: 8),
                    Text(context.isArabic
                        ? 'تم تحديث الأسعار تلقائياً'
                        : 'Rates updated automatically'),
                  ],
                ),
                backgroundColor: Colors.blue,
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is CurrencyRatesUpdatedSilently) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.update,
                        color: AppColors.getReversedTextColor(context),
                        size: 16),
                    const SizedBox(width: 8),
                    Text(context.isArabic
                        ? 'تم تحديث قائمة الأسعار'
                        : 'Rate list updated'),
                  ],
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is CurrencyRefreshed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle,
                        color: AppColors.getReversedTextColor(context),
                        size: 16),
                    const SizedBox(width: 8),
                    Text(context.isArabic
                        ? 'تم التحديث بنجاح'
                        : 'Refreshed successfully'),
                  ],
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<CurrencyCubit>();

          return GlowingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            color: AppColors.SECONDARY_COLOR,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Settings widget (collapsible)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: _showSettings ? null : 0,
                    child: _showSettings
                        ? const RefreshSettingsWidget()
                        : const SizedBox.shrink(),
                  ),

                  // Auto-refresh status indicator (compact)
                  // if (!_showSettings && cubit.lastUpdateTime != null)
                  //   Container(
                  //     width: double.infinity,
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 16, vertical: 8),
                  //     margin: const EdgeInsets.symmetric(
                  //         horizontal: 16, vertical: 8),
                  //     decoration: BoxDecoration(
                  //       gradient: LinearGradient(
                  //         colors: cubit.autoRefreshEnabled
                  //             ? [
                  //                 Colors.green.withOpacity(0.1),
                  //                 Colors.green.withOpacity(0.05)
                  //               ]
                  //             : [
                  //                 Theme.of(context)
                  //                     .dividerColor
                  //                     .withOpacity(0.1),
                  //                 Theme.of(context)
                  //                     .dividerColor
                  //                     .withOpacity(0.05)
                  //               ],
                  //       ),
                  //       borderRadius: BorderRadius.circular(12),
                  //       border: Border.all(
                  //         color: cubit.autoRefreshEnabled
                  //             ? Colors.green.withOpacity(0.3)
                  //             : Theme.of(context).dividerColor.withOpacity(0.3),
                  //       ),
                  //     ),
                  //     child: Row(
                  //       children: [
                  //         AnimatedBuilder(
                  //           animation: _pulseAnimation,
                  //           builder: (context, child) {
                  //             return Transform.scale(
                  //               scale: cubit.autoRefreshEnabled
                  //                   ? _pulseAnimation.value
                  //                   : 1.0,
                  //               child: Icon(
                  //                 cubit.autoRefreshEnabled
                  //                     ? Icons.sync
                  //                     : Icons.sync_disabled,
                  //                 size: 16,
                  //                 color: cubit.autoRefreshEnabled
                  //                     ? Colors.green
                  //                     : Colors.grey,
                  //               ),
                  //             );
                  //           },
                  //         ),
                  //         const SizedBox(width: 8),
                  //         Expanded(
                  //           child: Text(
                  //             context.isArabic
                  //                 ? 'آخر تحديث: ${cubit.getTimeSinceLastUpdate()}'
                  //                 : 'Last update: ${cubit.getTimeSinceLastUpdate()}',
                  //             style: TextStyle(
                  //               fontSize: 11,
                  //               color: cubit.autoRefreshEnabled
                  //                   ? Colors.green.shade700
                  //                   : Theme.of(context)
                  //                           .textTheme
                  //                           .bodyMedium
                  //                           ?.color
                  //                           ?.withOpacity(0.7) ??
                  //                       Colors.grey,
                  //               fontWeight: FontWeight.w500,
                  //             ),
                  //           ),
                  //         ),
                  //         if (cubit.autoRefreshEnabled)
                  //           GestureDetector(
                  //             onTap: () {
                  //               ManageVibration.vibrate();
                  //               cubit.forceRefresh();
                  //             },
                  //             child: Container(
                  //               padding: const EdgeInsets.symmetric(
                  //                   horizontal: 8, vertical: 4),
                  //               decoration: BoxDecoration(
                  //                 color: Colors.green,
                  //                 borderRadius: BorderRadius.circular(12),
                  //               ),
                  //               child: Text(
                  //                 context.isArabic ? 'تحديث' : 'Refresh',
                  //                 style: TextStyle(
                  //                   color:
                  //                       AppColors.getReversedTextColor(context),
                  //                   fontSize: 10,
                  //                   fontWeight: FontWeight.bold,
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //       ],
                  //     ),
                  //   ),

                  // Main conversion card
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xff0B1035), Color(0xffddf6f3)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          context.isArabic
                              ? 'تبديل العملات'
                              : 'Currency Exchange',
                          style: TextStyle(
                            color: context.isArabic
                                ? Colors.white
                                : AppColors.getReversedTextColor(context),
                            fontSize: 48.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Sizer(height: 16),
                        Text(
                          context.isArabic
                              ? 'تبديل العملات بشكل سريع وعرض السعر للعملة في الوقت الحالي'
                              : 'Exchange currencies instantly and view real-time rates',
                          style: TextStyle(
                            color: context.isArabic
                                ? Colors.white
                                : AppColors.getReversedTextColor(context)
                                    .withOpacity(0.7),
                            fontSize: 24.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Sizer(height: 32),

                        // From Currency Section
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .shadowColor
                                    .withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.isArabic ? 'المبلغ' : 'Amount',
                                style: TextStyle(
                                  color: context.isDarkMode
                                      ? Colors.white
                                      : Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.color
                                              ?.withOpacity(0.7) ??
                                          Colors.grey,
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Amount Section
                              Row(
                                children: [
                                  // Currency selector
                                  GestureDetector(
                                    onTap: () {
                                      ManageVibration.vibrate();
                                      _showFromCurrencySelector(context, cubit);
                                    },
                                    child: Container(
                                      width: 240.w,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: AppColors.getFillColor(context),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Theme.of(context).dividerColor,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            _getCurrencyFlag(
                                                cubit.fromCurrency),
                                            style: TextStyle(fontSize: 40.sp),
                                          ),
                                          const SizedBox(width: 6),
                                          Flexible(
                                            child: AutoSizeText(
                                              _getCurrencyShortName(
                                                  cubit.fromCurrency),
                                              style: TextStyle(
                                                fontSize: 32.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Sizer(width: 12),
                                          Icon(
                                            Icons.keyboard_arrow_down,
                                            size: 40.sp,
                                            color: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.color
                                                    ?.withOpacity(0.7) ??
                                                Colors.grey,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  Sizer(width: 24.w),

                                  // Amount input
                                  Expanded(
                                    child: SizedBox(
                                      height: 80.h,
                                      child: TextField(
                                        controller: _amountController,
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        inputFormatters: context.isArabic
                                            ? [ArabicNumberInputFormatter()]
                                            : null,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 32.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 12),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .dividerColor),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12)),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .dividerColor),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: AppColors.PRIMARY_COLOR),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12)),
                                          ),
                                          hintText: context.isArabic
                                              ? '٠.٠٠'
                                              : '0.00',
                                          hintStyle: TextStyle(
                                            color: Theme.of(context).hintColor,
                                          ),
                                          filled: true,
                                          fillColor:
                                              AppColors.getFillColor(context),
                                        ),
                                        onChanged: (value) {
                                          // Convert Arabic numerals back to English for parsing
                                          String englishValue = value
                                              .replaceAll('٠', '0')
                                              .replaceAll('١', '1')
                                              .replaceAll('٢', '2')
                                              .replaceAll('٣', '3')
                                              .replaceAll('٤', '4')
                                              .replaceAll('٥', '5')
                                              .replaceAll('٦', '6')
                                              .replaceAll('٧', '7')
                                              .replaceAll('٨', '8')
                                              .replaceAll('٩', '9');
                                          final amount =
                                              double.tryParse(englishValue) ??
                                                  0.0;
                                          cubit.setAmount(amount);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Swap button
                              Sizer(height: 20.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: Theme.of(context).dividerColor,
                                      thickness: 1,
                                    ),
                                  ),
                                  Sizer(width: 16.w),
                                  GestureDetector(
                                    onTap: () {
                                      ManageVibration.vibrate();
                                      cubit.swapCurrencies();
                                      setState(() {});
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF1B2951),
                                            Color(0xFF2A3A5C)
                                          ],
                                        ),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF1B2951)
                                                .withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: SvgPicture.asset(
                                        Assets.swapIcon,
                                        height: 20,
                                        width: 20,
                                        colorFilter: const ColorFilter.mode(
                                          Colors.white,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Sizer(width: 16.w),
                                  Expanded(
                                    child: Divider(
                                      color: Theme.of(context).dividerColor,
                                      thickness: 1,
                                    ),
                                  ),
                                ],
                              ),

                              Sizer(height: 20.h),
                              Text(
                                context.isArabic
                                    ? 'المبلغ المحول'
                                    : 'Converted Amount',
                                style: TextStyle(
                                  color: context.isDarkMode
                                      ? Colors.white
                                      : Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.color
                                              ?.withOpacity(0.7) ??
                                          Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Sizer(height: 12.h),

                              // Converted Amount Section
                              Row(
                                children: [
                                  // To Currency selector
                                  GestureDetector(
                                    onTap: () {
                                      ManageVibration.vibrate();
                                      _showToCurrencySelector(context, cubit);
                                    },
                                    child: Container(
                                      width: 240.w,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: AppColors.getRedColor(context)
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppColors.getRedColor(context)
                                              .withOpacity(0.3),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            _getCurrencyFlag(cubit.toCurrency),
                                            style: TextStyle(fontSize: 40.sp),
                                          ),
                                          Sizer(width: 6.w),
                                          Flexible(
                                            child: AutoSizeText(
                                              _getCurrencyShortName(
                                                  cubit.toCurrency),
                                              style: TextStyle(
                                                fontSize: 32.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Sizer(width: 4.w),
                                          Icon(
                                            Icons.keyboard_arrow_down,
                                            size: 40.sp,
                                            color:
                                                AppColors.getRedColor(context),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  Sizer(width: 12.w),

                                  // Converted amount display
                                  Expanded(
                                    child: Container(
                                      height: 70.h,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.green.shade50,
                                            Colors.green.shade100,
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.green.withOpacity(0.3),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          _getConvertedAmount(state, cubit),
                                          style: TextStyle(
                                            fontSize: 32.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green.shade700,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Calculate button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1B2951), Color(0xFF2A3A5C)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1B2951).withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: state is CurrencyLoading
                            ? null
                            : () {
                                ManageVibration.vibrate();
                                FocusScope.of(context).unfocus();
                                String englishText = _amountController.text
                                    .replaceAll('٠', '0')
                                    .replaceAll('١', '1')
                                    .replaceAll('٢', '2')
                                    .replaceAll('٣', '3')
                                    .replaceAll('٤', '4')
                                    .replaceAll('٥', '5')
                                    .replaceAll('٦', '6')
                                    .replaceAll('٧', '7')
                                    .replaceAll('٨', '8')
                                    .replaceAll('٩', '9');
                                final amount =
                                    double.tryParse(englishText) ?? 0.0;
                                cubit.setAmount(amount);
                                cubit.convertCurrency();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: state is CurrencyLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.calculate,
                                    color: context.isArabic
                                        ? Colors.white
                                        : AppColors.getReversedTextColor(
                                            context),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    context.isArabic ? 'حساب' : 'Calculate',
                                    style: TextStyle(
                                      color: context.isArabic
                                          ? Colors.white
                                          : AppColors.getReversedTextColor(
                                              context),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),

                  // Exchange rate info
                  if (_shouldShowExchangeRate(state)) ...[
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue.shade200,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              context.isArabic
                                  ? 'سعر الصرف الإرشادي'
                                  : 'Indicative Exchange Rate',
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getExchangeRateText(state),
                              style: TextStyle(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade800,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Expandable rates section
                  GestureDetector(
                    onTap: () {
                      ManageVibration.vibrate();
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                      if (_isExpanded) {
                        cubit.getAllExchangeRates(cubit.fromCurrency);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1B2951), Color(0xFF2A3A5C)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1B2951).withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.getReversedTextColor(context)
                                  .withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.language,
                              color: context.isArabic
                                  ? Colors.white
                                  : AppColors.getReversedTextColor(context),
                              size: 20,
                            ),
                          ),
                          Sizer(width: 32.w),
                          Expanded(
                            child: Text(
                              context.isArabic
                                  ? 'يمكنك مراجعة سعر الصرف\nفي جميع دول العالم'
                                  : 'Check exchange rates\nfor all world currencies',
                              style: TextStyle(
                                color: context.isArabic
                                    ? Colors.white
                                    : AppColors.getReversedTextColor(context),
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          AnimatedRotation(
                            turns: _isExpanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: context.isArabic
                                  ? Colors.white
                                  : AppColors.getReversedTextColor(context),
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Exchange rates list
                  if (_isExpanded) ...[
                    const SizedBox(height: 16),
                    BlocBuilder<CurrencyCubit, CurrencyState>(
                      builder: (context, state) {
                        if (state is CurrencyRatesLoaded ||
                            state is CurrencyRatesUpdatedSilently) {
                          final currencyRates = state is CurrencyRatesLoaded
                              ? state.currencyRates
                              : (state as CurrencyRatesUpdatedSilently)
                                  .currencyRates;
                          return ExchangeRateDisplayWidget(
                            currencyRates: currencyRates,
                            baseCurrency: cubit.fromCurrency,
                          );
                        } else if (state is CurrencyLoading) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Column(
                                children: [
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFF1B2951)),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    context.isArabic
                                        ? 'جاري تحميل سعر الصرف...'
                                        : 'Loading exchange rates...',
                                    style: TextStyle(
                                      color: context.isArabic
                                          ? Colors.white
                                          : Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else if (cubit.allRates != null) {
                          return ExchangeRateDisplayWidget(
                            currencyRates: cubit.allRates,
                            baseCurrency: cubit.fromCurrency,
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ],

                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Helper methods
  bool _shouldShowExchangeRate(CurrencyState state) {
    return state is CurrencyConverted ||
        state is CurrencyUpdatedSilently ||
        (context.read<CurrencyCubit>().lastExchangeRate != null);
  }

  String _formatNumberForLocale(double number, {int decimalPlaces = 2}) {
    final formattedNumber = number.toStringAsFixed(decimalPlaces);
    if (context.isArabic) {
      // Convert English numerals to Arabic numerals
      return formattedNumber
          .replaceAll('0', '٠')
          .replaceAll('1', '١')
          .replaceAll('2', '٢')
          .replaceAll('3', '٣')
          .replaceAll('4', '٤')
          .replaceAll('5', '٥')
          .replaceAll('6', '٦')
          .replaceAll('7', '٧')
          .replaceAll('8', '٨')
          .replaceAll('9', '٩');
    }
    return formattedNumber;
  }

  String _getConvertedAmount(CurrencyState state, CurrencyCubit cubit) {
    double amount = 0.0;
    if (state is CurrencyConverted) {
      amount = state.exchangeRate.conversionResult;
    } else if (state is CurrencyUpdatedSilently) {
      amount = state.exchangeRate.conversionResult;
    } else if (cubit.lastExchangeRate != null) {
      amount = cubit.lastExchangeRate!.conversionResult;
    }
    return _formatNumberForLocale(amount);
  }

  String _getExchangeRateText(CurrencyState state) {
    final cubit = context.read<CurrencyCubit>();

    if (state is CurrencyConverted) {
      final formattedRate = _formatNumberForLocale(
          state.exchangeRate.conversionRate,
          decimalPlaces: 4);
      final baseCurrencyName =
          _getCurrencyShortName(state.exchangeRate.baseCode);
      final targetCurrencyName =
          _getCurrencyShortName(state.exchangeRate.targetCode);
      return '1 $baseCurrencyName = $formattedRate $targetCurrencyName';
    } else if (state is CurrencyUpdatedSilently) {
      final formattedRate = _formatNumberForLocale(
          state.exchangeRate.conversionRate,
          decimalPlaces: 4);
      final baseCurrencyName =
          _getCurrencyShortName(state.exchangeRate.baseCode);
      final targetCurrencyName =
          _getCurrencyShortName(state.exchangeRate.targetCode);
      return '1 $baseCurrencyName = $formattedRate $targetCurrencyName';
    } else if (cubit.lastExchangeRate != null) {
      final rate = cubit.lastExchangeRate!;
      final formattedRate =
          _formatNumberForLocale(rate.conversionRate, decimalPlaces: 4);
      final baseCurrencyName = _getCurrencyShortName(rate.baseCode);
      final targetCurrencyName = _getCurrencyShortName(rate.targetCode);
      return '1 $baseCurrencyName = $formattedRate $targetCurrencyName';
    }
    return '';
  }

  String _getCurrencyFlag(String code) {
    final cubit = context.read<CurrencyCubit>();
    final currency = cubit.getCurrencyByCode(code);

    if (currency != null) {
      return currency.flag;
    }

    return '💱';
  }

  String _getCurrencyName(String code) {
    final cubit = context.read<CurrencyCubit>();
    final currency = cubit.getCurrencyByCode(code);

    if (currency != null) {
      if (context.isArabic) {
        return currency.nameAr;
      } else {
        return currency.name;
      }
    }

    return code;
  }

  String _getCurrencyShortName(String code) {
    final currencyShortNames = {
      'USD': context.isArabic ? 'دولار' : 'Dollar',
      'EUR': context.isArabic ? 'يورو' : 'Euro',
      'GBP': context.isArabic ? 'جنيه' : 'Pound',
      'JPY': context.isArabic ? 'ين' : 'Yen',
      'AUD': context.isArabic ? 'دولار' : 'Dollar',
      'CAD': context.isArabic ? 'دولار' : 'Dollar',
      'CHF': context.isArabic ? 'فرنك' : 'Franc',
      'CNY': context.isArabic ? 'يوان' : 'Yuan',
      'SEK': context.isArabic ? 'كرونا' : 'Krona',
      'NZD': context.isArabic ? 'دولار' : 'Dollar',
      'MXN': context.isArabic ? 'بيزو' : 'Peso',
      'SGD': context.isArabic ? 'دولار' : 'Dollar',
      'HKD': context.isArabic ? 'دولار' : 'Dollar',
      'NOK': context.isArabic ? 'كرونا' : 'Krone',
      'KRW': context.isArabic ? 'وون' : 'Won',
      'TRY': context.isArabic ? 'ليرة' : 'Lira',
      'RUB': context.isArabic ? 'روبل' : 'Ruble',
      'INR': context.isArabic ? 'روبية' : 'Rupee',
      'BRL': context.isArabic ? 'ريال' : 'Real',
      'ZAR': context.isArabic ? 'راند' : 'Rand',
      'PLN': context.isArabic ? 'زلوتي' : 'Zloty',
      'EGP': context.isArabic ? 'جنيه' : 'Pound',
      'AED': context.isArabic ? 'درهم' : 'Dirham',
      'SAR': context.isArabic ? 'ريال' : 'Riyal',
      'QAR': context.isArabic ? 'ريال' : 'Riyal',
      'KWD': context.isArabic ? 'دينار' : 'Dinar',
      'BHD': context.isArabic ? 'دينار' : 'Dinar',
      'OMR': context.isArabic ? 'ريال' : 'Rial',
      'JOD': context.isArabic ? 'دينار' : 'Dinar',
      'LBP': context.isArabic ? 'ليرة' : 'Pound',
      'IQD': context.isArabic ? 'دينار' : 'Dinar',
      'IRR': context.isArabic ? 'ريال' : 'Rial',
      'THB': context.isArabic ? 'باهت' : 'Baht',
      'MYR': context.isArabic ? 'رنجت' : 'Ringgit',
      'IDR': context.isArabic ? 'روبية' : 'Rupiah',
      'PHP': context.isArabic ? 'بيزو' : 'Peso',
      'VND': context.isArabic ? 'دونغ' : 'Dong',
      'TWD': context.isArabic ? 'دولار' : 'Dollar',
      'PKR': context.isArabic ? 'روبية' : 'Rupee',
      'BGN': context.isArabic ? 'ليف' : 'Lev',
      'CZK': context.isArabic ? 'كورونا' : 'Koruna',
      'HUF': context.isArabic ? 'فورنت' : 'Forint',
      'RON': context.isArabic ? 'ليو' : 'Leu',
      'HRK': context.isArabic ? 'كونا' : 'Kuna',
      'RSD': context.isArabic ? 'دينار' : 'Dinar',
      'UAH': context.isArabic ? 'هريفنيا' : 'Hryvnia',
      'BYN': context.isArabic ? 'روبل' : 'Ruble',
      'KZT': context.isArabic ? 'تنغي' : 'Tenge',
      'UZS': context.isArabic ? 'سوم' : 'Som',
      'AZN': context.isArabic ? 'مانات' : 'Manat',
      'GEL': context.isArabic ? 'لاري' : 'Lari',
      'AMD': context.isArabic ? 'درام' : 'Dram',
      'TMT': context.isArabic ? 'مانات' : 'Manat',
      'KGS': context.isArabic ? 'سوم' : 'Som',
      'TJS': context.isArabic ? 'سوموني' : 'Somoni',
      'MDL': context.isArabic ? 'ليو' : 'Leu',
      'MKD': context.isArabic ? 'دينار' : 'Denar',
      'ALL': context.isArabic ? 'ليك' : 'Lek',
      'BAM': context.isArabic ? 'مارك' : 'Mark',
      'ISK': context.isArabic ? 'كرونا' : 'Krona',
      'DKK': context.isArabic ? 'كرونا' : 'Krone',
      'CLP': context.isArabic ? 'بيزو' : 'Peso',
      'COP': context.isArabic ? 'بيزو' : 'Peso',
      'PEN': context.isArabic ? 'سول' : 'Sol',
      'UYU': context.isArabic ? 'بيزو' : 'Peso',
      'PYG': context.isArabic ? 'غواراني' : 'Guarani',
      'BOB': context.isArabic ? 'بوليفيانو' : 'Boliviano',
      'VES': context.isArabic ? 'بوليفار' : 'Bolívar',
      'GYD': context.isArabic ? 'دولار' : 'Dollar',
      'SRD': context.isArabic ? 'دولار' : 'Dollar',
      'AWG': context.isArabic ? 'فلورين' : 'Florin',
      'ANG': context.isArabic ? 'غيلدر' : 'Guilder',
      'BBD': context.isArabic ? 'دولار' : 'Dollar',
      'BZD': context.isArabic ? 'دولار' : 'Dollar',
      'BMD': context.isArabic ? 'دولار' : 'Dollar',
      'BSD': context.isArabic ? 'دولار' : 'Dollar',
      'CUP': context.isArabic ? 'بيزو' : 'Peso',
      'DOP': context.isArabic ? 'بيزو' : 'Peso',
      'GTQ': context.isArabic ? 'كيتزال' : 'Quetzal',
      'HNL': context.isArabic ? 'ليمبيرا' : 'Lempira',
      'HTG': context.isArabic ? 'غورد' : 'Gourde',
      'JMD': context.isArabic ? 'دولار' : 'Dollar',
      'KYD': context.isArabic ? 'دولار' : 'Dollar',
      'NIO': context.isArabic ? 'كوردوبا' : 'Córdoba',
      'PAB': context.isArabic ? 'بالبوا' : 'Balboa',
      'TTD': context.isArabic ? 'دولار' : 'Dollar',
      'XCD': context.isArabic ? 'دولار' : 'Dollar',
      'AFN': context.isArabic ? 'أفغاني' : 'Afghani',
      'BDT': context.isArabic ? 'تاكا' : 'Taka',
      'BTN': context.isArabic ? 'نغولتروم' : 'Ngultrum',
      'KHR': context.isArabic ? 'ريال' : 'Riel',
      'LAK': context.isArabic ? 'كيب' : 'Kip',
      'LKR': context.isArabic ? 'روبية' : 'Rupee',
      'MMK': context.isArabic ? 'كيات' : 'Kyat',
      'MNT': context.isArabic ? 'توغريك' : 'Tugrik',
      'MVR': context.isArabic ? 'روفية' : 'Rufiyaa',
      'NPR': context.isArabic ? 'روبية' : 'Rupee',
      'DZD': context.isArabic ? 'دينار' : 'Dinar',
      'AOA': context.isArabic ? 'كوانزا' : 'Kwanza',
      'BWP': context.isArabic ? 'بولا' : 'Pula',
      'BIF': context.isArabic ? 'فرنك' : 'Franc',
      'CVE': context.isArabic ? 'إسكودو' : 'Escudo',
      'KMF': context.isArabic ? 'فرنك' : 'Franc',
      'CDF': context.isArabic ? 'فرنك' : 'Franc',
      'DJF': context.isArabic ? 'فرنك' : 'Franc',
      'ERN': context.isArabic ? 'ناكفا' : 'Nakfa',
      'ETB': context.isArabic ? 'بير' : 'Birr',
      'GMD': context.isArabic ? 'دالاسي' : 'Dalasi',
      'GHS': context.isArabic ? 'سيدي' : 'Cedi',
      'GNF': context.isArabic ? 'فرنك' : 'Franc',
      'KES': context.isArabic ? 'شلن' : 'Shilling',
      'LSL': context.isArabic ? 'لوتي' : 'Loti',
      'LRD': context.isArabic ? 'دولار' : 'Dollar',
      'LYD': context.isArabic ? 'دينار' : 'Dinar',
      'MGA': context.isArabic ? 'أرياري' : 'Ariary',
      'MWK': context.isArabic ? 'كواشا' : 'Kwacha',
      'MRU': context.isArabic ? 'أوقية' : 'Ouguiya',
      'MUR': context.isArabic ? 'روبية' : 'Rupee',
      'MAD': context.isArabic ? 'درهم' : 'Dirham',
      'MZN': context.isArabic ? 'ميتيكال' : 'Metical',
      'NAD': context.isArabic ? 'دولار' : 'Dollar',
      'NGN': context.isArabic ? 'نايرا' : 'Naira',
      'RWF': context.isArabic ? 'فرنك' : 'Franc',
      'STN': context.isArabic ? 'دوبرا' : 'Dobra',
      'SCR': context.isArabic ? 'روبية' : 'Rupee',
      'SLE': context.isArabic ? 'ليون' : 'Leone',
      'SOS': context.isArabic ? 'شلن' : 'Shilling',
      'SSP': context.isArabic ? 'جنيه' : 'Pound',
      'SDG': context.isArabic ? 'جنيه' : 'Pound',
      'SZL': context.isArabic ? 'ليلانجيني' : 'Lilangeni',
      'TZS': context.isArabic ? 'شلن' : 'Shilling',
      'TND': context.isArabic ? 'دينار' : 'Dinar',
      'UGX': context.isArabic ? 'شلن' : 'Shilling',
      'ZMW': context.isArabic ? 'كواشا' : 'Kwacha',
      'ZWL': context.isArabic ? 'دولار' : 'Dollar',
      'FJD': context.isArabic ? 'دولار' : 'Dollar',
      'PGK': context.isArabic ? 'كينا' : 'Kina',
      'SBD': context.isArabic ? 'دولار' : 'Dollar',
      'TOP': context.isArabic ? 'بانغا' : 'Paʻanga',
      'VUV': context.isArabic ? 'فاتو' : 'Vatu',
      'WST': context.isArabic ? 'تالا' : 'Tala',
      'XPF': context.isArabic ? 'فرنك' : 'Franc',
    };

    return currencyShortNames[code] ?? code;
  }

  String _getCountryName(String code, {bool? useEnglish}) {
    final cubit = context.read<CurrencyCubit>();
    final currency = cubit.getCurrencyByCode(code);

    if (currency != null) {
      bool shouldUseEnglish = useEnglish ?? !context.isArabic;

      if (shouldUseEnglish) {
        return currency.countryName ?? currency.name;
      } else {
        return currency.countryNameAr ?? currency.nameAr;
      }
    }

    return code;
  }

  void _showFromCurrencySelector(BuildContext context, CurrencyCubit cubit) {
    _showCurrencySelector(
      context,
      cubit.availableCurrencies,
      cubit.fromCurrency,
      (currency) {
        cubit.setFromCurrency(currency);
        setState(() {});
      },
      context.isArabic ? 'اختر العملة الأساسية' : 'Choose Base Currency',
    );
  }

  void _showToCurrencySelector(BuildContext context, CurrencyCubit cubit) {
    _showCurrencySelector(
      context,
      cubit.availableCurrencies,
      cubit.toCurrency,
      (currency) {
        cubit.setToCurrency(currency);
        setState(() {});
      },
      context.isArabic ? 'اختر العملة المستهدفة' : 'Choose Target Currency',
    );
  }

  void _showCurrencySelector(
    BuildContext context,
    List<dynamic> currencies,
    String selectedCurrency,
    Function(String) onSelected,
    String title,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: AppColors.getFillColor(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 70.w,
              height: 4.h,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.getFillColor(context),
                border: Border(
                  bottom: BorderSide(color: Theme.of(context).dividerColor),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.getTextColor(context),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),

            // Currency list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: currencies.length,
                itemBuilder: (context, index) {
                  final currency = currencies[index];
                  final isSelected = currency.code == selectedCurrency;
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.PRIMARY_COLOR.withOpacity(0.1)
                          : null,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(
                              color: AppColors.PRIMARY_COLOR.withOpacity(0.3))
                          : null,
                    ),
                    child: ListTile(
                      onTap: () {
                        onSelected(currency.code);
                        Navigator.pop(context);
                        ManageVibration.vibrate();
                      },
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.getFillColor(context),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            currency.flag,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      title: Text(
                        '${_getCountryName(currency.code, useEnglish: false)} - ${_getCurrencyName(currency.code)}',
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          color: context.isDarkMode
                              ? Colors.white
                              : isSelected
                                  ? AppColors.PRIMARY_COLOR
                                  : AppColors.getTextColor(context),
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: context.isDarkMode
                                  ? Colors.white
                                  : AppColors.PRIMARY_COLOR,
                              size: 24,
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
