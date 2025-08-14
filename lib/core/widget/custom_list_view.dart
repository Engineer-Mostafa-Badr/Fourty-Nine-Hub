import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

import '../../res/style/app_colors.dart';

class CustomListView<T> extends StatefulWidget {
  // البيانات
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  
  // التخصيص
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final bool reverse;
  final ScrollController? scrollController;
  
  // الألوان والتصميم
  final Color? glowColor;
  final Color? backgroundColor;
  final double? itemSpacing;
  final BorderRadius? borderRadius;
  final BoxShadow? shadow;
  
  // الحالات الفارغة والتحميل
  final Widget? emptyWidget;
  final Widget? loadingWidget;
  final bool isLoading;
  
  // التفاعل
  final VoidCallback? onRefresh;
  final VoidCallback? onLoadMore;
  final bool enablePullToRefresh;
  final bool enableLoadMore;
  final double loadMoreThreshold;
  
  // الفصل بين العناصر
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final bool showDivider;
  final Color? dividerColor;
  final double? dividerHeight;
  
  // الرسوم المتحركة
  final Duration animationDuration;
  final Curve animationCurve;
  final bool enableItemAnimation;
  
  // التمرير
  final bool enableHapticFeedback;
  final double overscrollDistance;

  const CustomListView({
    Key? key,
    required this.items,
    required this.itemBuilder,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    this.reverse = false,
    this.scrollController,
    this.glowColor,
    this.backgroundColor,
    this.itemSpacing,
    this.borderRadius,
    this.shadow,
    this.emptyWidget,
    this.loadingWidget,
    this.isLoading = false,
    this.onRefresh,
    this.onLoadMore,
    this.enablePullToRefresh = false,
    this.enableLoadMore = false,
    this.loadMoreThreshold = 200.0,
    this.separatorBuilder,
    this.showDivider = false,
    this.dividerColor,
    this.dividerHeight,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    this.enableItemAnimation = true,
    this.enableHapticFeedback = true,
    this.overscrollDistance = 20.0,
  }) : super(key: key);

  @override
  State<CustomListView<T>> createState() => _CustomListViewState<T>();
}

class _CustomListViewState<T> extends State<CustomListView<T>>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;
  bool _isRefreshing = false;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    // إضافة مستمع للتمرير للتحميل التلقائي
    if (widget.enableLoadMore) {
      _scrollController.addListener(_scrollListener);
    }

    // تشغيل الرسوم المتحركة عند البناء
    if (widget.enableItemAnimation) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - widget.loadMoreThreshold &&
        !_isLoadingMore &&
        widget.onLoadMore != null) {
      _loadMore();
    }
  }

  Future<void> _handleRefresh() async {
    if (widget.onRefresh == null || _isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }

    try {
      widget.onRefresh!();
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  Future<void> _loadMore() async {
    if (widget.onLoadMore == null || _isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    if (widget.enableHapticFeedback) {
      HapticFeedback.selectionClick();
    }

    try {
      widget.onLoadMore!();
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  Widget _buildItem(BuildContext context, int index) {
    final item = widget.items[index];
    
    Widget child = widget.itemBuilder(context, item, index);

    // إضافة الرسوم المتحركة للعناصر
    if (widget.enableItemAnimation) {
      child = SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            (index * 0.1).clamp(0.0, 1.0),
            ((index + 1) * 0.1).clamp(0.0, 1.0),
            curve: widget.animationCurve,
          ),
        )),
        child: FadeTransition(
          opacity: CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              (index * 0.1).clamp(0.0, 1.0),
              ((index + 1) * 0.1).clamp(0.0, 1.0),
              curve: widget.animationCurve,
            ),
          ),
          child: child,
        ),
      );
    }

    // إضافة المسافات بين العناصر
    if (widget.itemSpacing != null && index < widget.items.length - 1) {
      child = Padding(
        padding: EdgeInsets.only(bottom: widget.itemSpacing!),
        child: child,
      );
    }

    return child;
  }

  Widget _buildSeparator(BuildContext context, int index) {
    if (widget.separatorBuilder != null) {
      return widget.separatorBuilder!(context, index);
    }

    if (widget.showDivider) {
      return Container(
        height: widget.dividerHeight ?? 1.0,
        color: widget.dividerColor ?? Colors.grey.withOpacity(0.3),
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildListView() {
    // إذا كان يتم التحميل
    if (widget.isLoading && widget.items.isEmpty) {
      return Center(
        child: widget.loadingWidget ??
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('جاري التحميل...'),
              ],
            ),
      );
    }

    // إذا كانت القائمة فارغة
    if (widget.items.isEmpty) {
      return Center(
        child: widget.emptyWidget ??
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'لا توجد عناصر للعرض',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
      );
    }

    Widget listView;

    // إنشاء ListView مع أو بدون فواصل
    if (widget.separatorBuilder != null || widget.showDivider) {
      listView = ListView.separated(
        controller: _scrollController,
        padding: widget.padding,
        shrinkWrap: widget.shrinkWrap,
        physics: widget.physics,
        reverse: widget.reverse,
        itemCount: widget.items.length,
        itemBuilder: _buildItem,
        separatorBuilder: _buildSeparator,
      );
    } else {
      listView = ListView.builder(
        controller: _scrollController,
        padding: widget.padding,
        shrinkWrap: widget.shrinkWrap,
        physics: widget.physics,
        reverse: widget.reverse,
        itemCount: widget.items.length,
        itemBuilder: _buildItem,
      );
    }

    // إضافة مؤشر التحميل في الأسفل
    if (widget.enableLoadMore) {
      listView = Column(
        children: [
          Expanded(child: listView),
          if (_isLoadingMore)
            Container(
              padding: const EdgeInsets.all(16),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text('جاري تحميل المزيد...'),
                ],
              ),
            ),
        ],
      );
    }

    return listView;
  }

  @override
  Widget build(BuildContext context) {
    Widget child = _buildListView();

    // إضافة GlowingOverscrollIndicator
    child = GlowingOverscrollIndicator(
      color: widget.glowColor ?? AppColors.SECONDARY_COLOR,
      axisDirection: widget.reverse ? AxisDirection.up : AxisDirection.down,
      child: child,
    );

    // إضافة RefreshIndicator إذا كان مفعلاً
    if (widget.enablePullToRefresh && widget.onRefresh != null) {
      child = RefreshIndicator(
        onRefresh: _handleRefresh,
        color: widget.glowColor ?? AppColors.SECONDARY_COLOR,
        child: child,
      );
    }

    // إضافة الخلفية والظلال
    if (widget.backgroundColor != null || 
        widget.borderRadius != null || 
        widget.shadow != null) {
      child = Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: widget.borderRadius,
          boxShadow: widget.shadow != null ? [widget.shadow!] : null,
        ),
        child: child,
      );
    }

    return child;
  }
}

// مثال على كيفية الاستخدام
class ExampleUsage extends StatelessWidget {
  const ExampleUsage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom ListView Example')),
      body: CustomListView<String>(
        items: List.generate(20, (index) => 'العنصر رقم ${index + 1}'),
        itemBuilder: (context, item, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.SECONDARY_COLOR,
                child: Text('${index + 1}'),
              ),
              title: Text(item),
              subtitle: Text('وصف العنصر رقم ${index + 1}'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                ManageVibration.vibrate();
                // معالجة النقر
              },
            ),
          );
        },
        padding: const EdgeInsets.all(8),
        enablePullToRefresh: true,
        enableLoadMore: true,
        showDivider: false,
        itemSpacing: 4,
        borderRadius: BorderRadius.circular(12),
        backgroundColor: Colors.grey[50],
        onRefresh: () async {
          // منطق التحديث
          await Future.delayed(const Duration(seconds: 2));
        },
        onLoadMore: () async {
          // منطق تحميل المزيد
          await Future.delayed(const Duration(seconds: 1));
        },
        emptyWidget: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.list_alt, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('لا توجد عناصر', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}