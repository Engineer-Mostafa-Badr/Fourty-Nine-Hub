import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import '../../../../res/style/app_colors.dart';
import '../logic/currency_cubit.dart';

class RefreshSettingsWidget extends StatefulWidget {
  const RefreshSettingsWidget({super.key});

  @override
  State<RefreshSettingsWidget> createState() => _RefreshSettingsWidgetState();
}

class _RefreshSettingsWidgetState extends State<RefreshSettingsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _getIntervalText(Duration interval, bool isArabic) {
    if (interval.inMinutes < 60) {
      return isArabic
          ? '${interval.inMinutes} دقيقة'
          : '${interval.inMinutes} minutes';
    } else if (interval.inHours < 24) {
      if (interval.inHours == 1) {
        return isArabic ? 'ساعة واحدة' : '1 hour';
      } else if (interval.inHours == 2) {
        return isArabic ? 'ساعتين' : '2 hours';
      } else {
        return isArabic
            ? '${interval.inHours} ساعات'
            : '${interval.inHours} hours';
      }
    } else {
      return isArabic ? '${interval.inDays} يوم' : '${interval.inDays} days';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CurrencyCubit, CurrencyState>(
      listener: (context, state) {
        if (state is CurrencyAutoRefreshEnabled) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                context.isArabic
                    ? 'تم تفعيل التحديث التلقائي'
                    : 'Auto-refresh enabled',
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is CurrencyAutoRefreshDisabled) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                context.isArabic
                    ? 'تم إيقاف التحديث التلقائي'
                    : 'Auto-refresh disabled',
              ),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is CurrencyRefreshIntervalChanged) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                context.isArabic
                    ? 'تم تغيير فترة التحديث إلى ${_getIntervalText(state.interval, true)}'
                    : 'Refresh interval changed to ${_getIntervalText(state.interval, false)}',
              ),
              backgroundColor: Colors.blue,
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is CurrencyAutoRefreshFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                context.isArabic
                    ? 'فشل في التحديث التلقائي'
                    : 'Auto-refresh failed',
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: context.isArabic ? 'إعادة المحاولة' : 'Retry',
                textColor: Colors.white,
                onPressed: () {
                  context.read<CurrencyCubit>().forceRefresh();
                },
              ),
            ),
          );
        }
      },
      child: BlocBuilder<CurrencyCubit, CurrencyState>(
        builder: (context, state) {
          final cubit = context.read<CurrencyCubit>();

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Column(
                children: [
                  // Header
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                      if (_isExpanded) {
                        _animationController.forward();
                      } else {
                        _animationController.reverse();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF1B2951),
                            const Color(0xFF1B2951).withOpacity(0.8),
                          ],
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              cubit.autoRefreshEnabled
                                  ? Icons.sync
                                  : Icons.sync_disabled,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.isArabic
                                      ? 'إعدادات التحديث'
                                      : 'Refresh Settings',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                if (cubit.lastUpdateTime != null)
                                  Text(
                                    context.isArabic
                                        ? 'آخر تحديث: ${cubit.getTimeSinceLastUpdate()}'
                                        : 'Last update: ${cubit.getTimeSinceLastUpdate()}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          AnimatedRotation(
                            turns: _isExpanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Expandable content
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: _isExpanded ? null : 0,
                    child: _isExpanded
                        ? FadeTransition(
                            opacity: _fadeAnimation,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  // Auto-refresh toggle
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: cubit.autoRefreshEnabled
                                          ? Colors.green.withOpacity(0.1)
                                          : Colors.grey.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: cubit.autoRefreshEnabled
                                            ? Colors.green.withOpacity(0.3)
                                            : Colors.grey.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.auto_mode,
                                          color: cubit.autoRefreshEnabled
                                              ? Colors.green
                                              : Colors.grey,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                context.isArabic
                                                    ? 'التحديث التلقائي'
                                                    : 'Auto-refresh',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                context.isArabic
                                                    ? 'تحديث الأسعار تلقائياً في الخلفية'
                                                    : 'Update rates automatically in background',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Switch(
                                          value: cubit.autoRefreshEnabled,
                                          onChanged: (value) {
                                            if (value) {
                                              cubit.enableAutoRefresh();
                                            } else {
                                              cubit.disableAutoRefresh();
                                            }
                                          },
                                          activeColor: Colors.green,
                                          activeTrackColor:
                                              Colors.green.withOpacity(0.3),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Interval selector (only shown when auto-refresh is enabled)
                                  if (cubit.autoRefreshEnabled) ...[
                                    const SizedBox(height: 16),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.blue.withOpacity(0.3),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.schedule,
                                                color: Colors.blue.shade700,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                context.isArabic
                                                    ? 'فترة التحديث:'
                                                    : 'Refresh interval:',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.blue.shade700,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                color: Colors.blue
                                                    .withOpacity(0.3),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<Duration>(
                                                value: cubit.refreshInterval,
                                                isExpanded: true,
                                                items: cubit
                                                    .getAvailableRefreshIntervals()
                                                    .map((interval) {
                                                  return DropdownMenuItem<
                                                      Duration>(
                                                    value: interval,
                                                    child: Text(
                                                      _getIntervalText(interval,
                                                          context.isArabic),
                                                      style: const TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (value) {
                                                  if (value != null) {
                                                    cubit.setRefreshInterval(
                                                        value);
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],

                                  const SizedBox(height: 16),

                                  // Action buttons
                                  Row(
                                    children: [
                                      // Manual refresh button
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: state is CurrencyRefreshing
                                              ? null
                                              : () {
                                                  cubit.forceRefresh();
                                                },
                                          icon: state is CurrencyRefreshing
                                              ? const SizedBox(
                                                  width: 16,
                                                  height: 16,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                  ),
                                                )
                                              : const Icon(Icons.refresh,
                                                  size: 18),
                                          label: Text(
                                            context.isArabic
                                                ? 'تحديث الآن'
                                                : 'Refresh Now',
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor:
                                                const Color(0xFF1B2951),
                                            side: const BorderSide(
                                              color: Color(0xFF1B2951),
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Status indicator
                                  if (cubit.lastUpdateTime != null) ...[
                                    const SizedBox(height: 16),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.info_outline,
                                            size: 16,
                                            color: Colors.grey.shade600,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  context.isArabic
                                                      ? 'آخر تحديث: ${cubit.getTimeSinceLastUpdate()}'
                                                      : 'Last update: ${cubit.getTimeSinceLastUpdate()}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey.shade700,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                if (cubit.autoRefreshEnabled)
                                                  Text(
                                                    context.isArabic
                                                        ? 'التحديث التالي: ${_getIntervalText(cubit.refreshInterval, true)}'
                                                        : 'Next update: ${_getIntervalText(cubit.refreshInterval, false)}',
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color:
                                                          Colors.grey.shade600,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
