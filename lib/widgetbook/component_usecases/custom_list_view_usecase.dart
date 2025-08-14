import 'package:flutter/material.dart';
import 'package:fourtyninehub/widgetbook/component_usecases/text_input_widget_usecases.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import '../../core/widget/custom_list_view.dart';
import '../../res/style/app_colors.dart';
import '../utils/flutter_markdown.dart';

@widgetbook.UseCase(
  name: 'CustomListView Documentation',
  type: MarkdownViewer,
)
MarkdownViewer customListViewDocumentation(BuildContext context) {
  return const MarkdownViewer(
    markdownFilePath: 'assets/markdown/docs/custom_listview_doc.md',
  );
}

@widgetbook.UseCase(
  name: 'CustomListView with Knobs',
  type: CustomListView,
)
Widget customListViewWidget(BuildContext context) {
  // البيانات
  final itemCount = context.knobs.int.slider(
    label: 'Item Count',
    initialValue: 10,
    min: 0,
    max: 50,
  );

  final isLoading = context.knobs.boolean(
    label: 'Is Loading',
    initialValue: false,
  );

  // التخصيص
  final shrinkWrap = context.knobs.boolean(
    label: 'Shrink Wrap',
    initialValue: false,
  );

  final reverse = context.knobs.boolean(
    label: 'Reverse',
    initialValue: false,
  );

  // الألوان والتصميم
  final backgroundColor = context.knobs.listOrNull<String>(
    label: 'Background Color',
    options: [
      'None',
      'White',
      'Grey Light',
      'Primary Light',
      'Secondary Light',
    ],
    initialOption: 'None',
  );

  final glowColor = context.knobs.list<String>(
    label: 'Glow Color',
    options: [
      'Primary',
      'Secondary',
      'Red',
      'Green',
      'Blue',
      'Orange',
    ],
    initialOption: 'Primary',
  );

  final itemSpacing = context.knobs.doubleOrNull.slider(
    label: 'Item Spacing',
    initialValue: null,
    min: 0.0,
    max: 20.0,
  );

  final borderRadius = context.knobs.doubleOrNull.slider(
    label: 'Border Radius',
    initialValue: null,
    min: 0.0,
    max: 20.0,
  );

  // التفاعل
  final enablePullToRefresh = context.knobs.boolean(
    label: 'Enable Pull to Refresh',
    initialValue: false,
  );

  final enableLoadMore = context.knobs.boolean(
    label: 'Enable Load More',
    initialValue: false,
  );

  final loadMoreThreshold = context.knobs.double.slider(
    label: 'Load More Threshold',
    initialValue: 200.0,
    min: 50.0,
    max: 500.0,
  );

  // الفصل بين العناصر
  final showDivider = context.knobs.boolean(
    label: 'Show Divider',
    initialValue: false,
  );

  final dividerHeight = context.knobs.doubleOrNull.slider(
    label: 'Divider Height',
    initialValue: 1.0,
    min: 0.5,
    max: 5.0,
  );

  // الرسوم المتحركة
  final enableItemAnimation = context.knobs.boolean(
    label: 'Enable Item Animation',
    initialValue: true,
  );

  final animationDuration = context.knobs.int.slider(
    label: 'Animation Duration (ms)',
    initialValue: 300,
    min: 100,
    max: 1000,
  );

  final animationCurve = context.knobs.list<String>(
    label: 'Animation Curve',
    options: [
      'easeInOut',
      'easeIn',
      'easeOut',
      'bounceIn',
      'bounceOut',
      'elasticIn',
      'elasticOut',
    ],
    initialOption: 'easeInOut',
  );

  // التمرير
  final enableHapticFeedback = context.knobs.boolean(
    label: 'Enable Haptic Feedback',
    initialValue: true,
  );

  // تحويل القيم
  Color? selectedBackgroundColor;
  switch (backgroundColor) {
    case 'White':
      selectedBackgroundColor = Colors.white;
      break;
    case 'Grey Light':
      selectedBackgroundColor = Colors.grey[50];
      break;
    case 'Primary Light':
      selectedBackgroundColor = AppColors.PRIMARY_COLOR.withOpacity(0.1);
      break;
    case 'Secondary Light':
      selectedBackgroundColor = AppColors.SECONDARY_COLOR.withOpacity(0.1);
      break;
  }

  Color selectedGlowColor;
  switch (glowColor) {
    case 'Primary':
      selectedGlowColor = AppColors.PRIMARY_COLOR;
      break;
    case 'Secondary':
      selectedGlowColor = AppColors.SECONDARY_COLOR;
      break;
    case 'Red':
      selectedGlowColor = Colors.red;
      break;
    case 'Green':
      selectedGlowColor = Colors.green;
      break;
    case 'Blue':
      selectedGlowColor = Colors.blue;
      break;
    case 'Orange':
      selectedGlowColor = Colors.orange;
      break;
    default:
      selectedGlowColor = AppColors.PRIMARY_COLOR;
  }

  Curve selectedAnimationCurve;
  switch (animationCurve) {
    case 'easeIn':
      selectedAnimationCurve = Curves.easeIn;
      break;
    case 'easeOut':
      selectedAnimationCurve = Curves.easeOut;
      break;
    case 'bounceIn':
      selectedAnimationCurve = Curves.bounceIn;
      break;
    case 'bounceOut':
      selectedAnimationCurve = Curves.bounceOut;
      break;
    case 'elasticIn':
      selectedAnimationCurve = Curves.elasticIn;
      break;
    case 'elasticOut':
      selectedAnimationCurve = Curves.elasticOut;
      break;
    default:
      selectedAnimationCurve = Curves.easeInOut;
  }

  // إنشاء البيانات
  final items = List.generate(itemCount, (index) => 'العنصر رقم ${index + 1}');

  return WidgetbookScreenUtilFormWrapper(
    child: Scaffold(
      appBar: AppBar(
        title: const Text('CustomListView Demo'),
        backgroundColor: selectedGlowColor,
      ),
      body: CustomListView<String>(
        items: items,
        isLoading: isLoading,
        shrinkWrap: shrinkWrap,
        reverse: reverse,
        backgroundColor: selectedBackgroundColor,
        glowColor: selectedGlowColor,
        itemSpacing: itemSpacing,
        borderRadius: borderRadius != null ? BorderRadius.circular(borderRadius) : null,
        enablePullToRefresh: enablePullToRefresh,
        enableLoadMore: enableLoadMore,
        loadMoreThreshold: loadMoreThreshold,
        showDivider: showDivider,
        dividerHeight: dividerHeight,
        enableItemAnimation: enableItemAnimation,
        animationDuration: Duration(milliseconds: animationDuration),
        animationCurve: selectedAnimationCurve,
        enableHapticFeedback: enableHapticFeedback,
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, item, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: selectedGlowColor,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                item,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text('وصف العنصر رقم ${index + 1}'),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: selectedGlowColor,
                size: 16,
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم النقر على $item'),
                    backgroundColor: selectedGlowColor,
                  ),
                );
              },
            ),
          );
        },
        onRefresh: enablePullToRefresh ? () async {
          await Future.delayed(const Duration(seconds: 2));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم التحديث بنجاح!')),
          );
        } : null,
        onLoadMore: enableLoadMore ? () async {
          await Future.delayed(const Duration(seconds: 1));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تحميل المزيد!')),
          );
        } : null,
        emptyWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.list_alt_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد عناصر للعرض',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'قم بزيادة عدد العناصر من الإعدادات',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
        loadingWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: selectedGlowColor,
            ),
            const SizedBox(height: 16),
            const Text(
              'جاري التحميل...',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'CustomListView - Empty State',
  type: CustomListView,
)
Widget customListViewEmptyState(BuildContext context) {
  final emptyStateType = context.knobs.list<String>(
    label: 'Empty State Type',
    options: [
      'Default',
      'Custom Icon',
      'Illustration',
      'Action Button',
    ],
    initialOption: 'Default',
  );

  Widget emptyWidget;
  switch (emptyStateType) {
    case 'Custom Icon':
      emptyWidget = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'السلة فارغة',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ابدأ بإضافة بعض المنتجات',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      );
      break;
    case 'Illustration':
      emptyWidget = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.PRIMARY_COLOR.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inbox_outlined,
              size: 60,
              color: AppColors.PRIMARY_COLOR,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'لا توجد رسائل',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ستظهر رسائلك هنا عندما تحصل على رسائل جديدة',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      );
      break;
    case 'Action Button':
      emptyWidget = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          const Text(
            'لا توجد مفضلة',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'احفظ العناصر التي تحبها هنا',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('استكشاف المنتجات!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.PRIMARY_COLOR,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'استكشف الآن',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
      break;
    default:
      emptyWidget = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.list_alt,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد عناصر',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      );
  }

  return WidgetbookScreenUtilFormWrapper(
    child: Scaffold(
      appBar: AppBar(
        title: const Text('CustomListView - Empty States'),
      ),
      body: CustomListView<String>(
        items: const [], // قائمة فارغة
        itemBuilder: (context, item, index) => Container(),
        emptyWidget: emptyWidget,
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'CustomListView - Loading State',
  type: CustomListView,
)
Widget customListViewLoadingState(BuildContext context) {
  final loadingType = context.knobs.list<String>(
    label: 'Loading Type',
    options: [
      'Default',
      'Custom Spinner',
      'Skeleton',
      'Shimmer Effect',
    ],
    initialOption: 'Default',
  );

  Widget loadingWidget;
  switch (loadingType) {
    case 'Custom Spinner':
      loadingWidget = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 6,
              color: AppColors.PRIMARY_COLOR,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'جاري تحميل البيانات...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
      break;
    case 'Skeleton':
      loadingWidget = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...List.generate(3, (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                ),
                title: Container(
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                subtitle: Container(
                  height: 12,
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          )),
        ],
      );
      break;
    case 'Shimmer Effect':
      loadingWidget = const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.hourglass_empty,
            size: 48,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'تحميل المحتوى...',
            style: TextStyle(fontSize: 16),
          ),
        ],
      );
      break;
    default:
      loadingWidget = const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('جاري التحميل...'),
        ],
      );
  }

  return WidgetbookScreenUtilFormWrapper(
    child: Scaffold(
      appBar: AppBar(
        title: const Text('CustomListView - Loading States'),
      ),
      body: CustomListView<String>(
        items: const [],
        isLoading: true,
        itemBuilder: (context, item, index) => Container(),
        loadingWidget: loadingWidget,
      ),
    ),
  );
}