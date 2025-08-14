# CustomListView Widget

## نظرة عامة

`CustomListView` هو widget متقدم ومرن لعرض القوائم في Flutter يوفر العديد من الميزات المتقدمة مثل:

- ✨ رسوم متحركة للعناصر
- 🔄 Pull-to-refresh
- ♾️ تحميل المزيد تلقائياً (Infinite scrolling)
- 🎨 تخصيص كامل للألوان والتصميم
- 📱 دعم للحالات الفارغة ومؤشرات التحميل
- 🔧 مرونة في التخصيص والتحكم

## المميزات الرئيسية

### 🎭 الرسوم المتحركة
- رسوم متحركة لظهور العناصر
- تحكم في منحنى الرسوم المتحركة
- مدة قابلة للتخصيص

### 🔄 التحديث والتحميل
- Pull-to-refresh مدمج
- تحميل تلقائي للمزيد من البيانات
- مؤشرات تحميل قابلة للتخصيص

### 🎨 التخصيص البصري
- ألوان قابلة للتخصيص
- خلفيات وحدود دائرية
- ظلال وتأثيرات بصرية
- فواصل بين العناصر

### 📱 تجربة المستخدم
- haptic feedback
- حالات فارغة قابلة للتخصيص
- مؤشرات تحميل متنوعة
- دعم للتمرير العكسي

## طريقة الاستخدام

### الاستخدام الأساسي

```dart
CustomListView<String>(
  items: ['العنصر 1', 'العنصر 2', 'العنصر 3'],
  itemBuilder: (context, item, index) {
    return ListTile(
      title: Text(item),
      leading: CircleAvatar(child: Text('${index + 1}')),
    );
  },
)
```

### مع Pull-to-Refresh

```dart
CustomListView<String>(
  items: items,
  itemBuilder: itemBuilder,
  enablePullToRefresh: true,
  onRefresh: () async {
    // منطق التحديث
    await loadNewData();
  },
)
```

### مع التحميل التلقائي

```dart
CustomListView<String>(
  items: items,
  itemBuilder: itemBuilder,
  enableLoadMore: true,
  loadMoreThreshold: 200.0,
  onLoadMore: () async {
    // منطق تحميل المزيد
    await loadMoreData();
  },
)
```

### مع التخصيص المتقدم

```dart
CustomListView<String>(
  items: items,
  itemBuilder: itemBuilder,
  backgroundColor: Colors.grey[50],
  glowColor: AppColors.PRIMARY_COLOR,
  borderRadius: BorderRadius.circular(12),
  itemSpacing: 8.0,
  enableItemAnimation: true,
  animationDuration: Duration(milliseconds: 500),
  animationCurve: Curves.bounceOut,
  showDivider: true,
  dividerColor: Colors.grey[300],
)
```

## المعاملات المتاحة

### البيانات الأساسية

| المعامل | النوع | الوصف |
|---------|-------|--------|
| `items` | `List<T>` | قائمة العناصر المراد عرضها |
| `itemBuilder` | `Widget Function(BuildContext, T, int)` | دالة بناء العناصر |

### التخصيص العام

| المعامل | النوع | القيمة الافتراضية | الوصف |
|---------|-------|-----------------|--------|
| `padding` | `EdgeInsetsGeometry?` | `null` | المسافات الداخلية |
| `shrinkWrap` | `bool` | `false` | تقليص حجم القائمة |
| `reverse` | `bool` | `false` | التمرير العكسي |
| `scrollController` | `ScrollController?` | `null` | تحكم مخصص في التمرير |

### الألوان والتصميم

| المعامل | النوع | القيمة الافتراضية | الوصف |
|---------|-------|-----------------|--------|
| `glowColor` | `Color?` | `AppColors.SECONDARY_COLOR` | لون التوهج |
| `backgroundColor` | `Color?` | `null` | لون الخلفية |
| `itemSpacing` | `double?` | `null` | المسافة بين العناصر |
| `borderRadius` | `BorderRadius?` | `null` | انحناء الحواف |
| `shadow` | `BoxShadow?` | `null` | الظل |

### الحالات الخاصة

| المعامل | النوع | القيمة الافتراضية | الوصف |
|---------|-------|-----------------|--------|
| `emptyWidget` | `Widget?` | widget افتراضي | widget الحالة الفارغة |
| `loadingWidget` | `Widget?` | widget افتراضي | widget التحميل |
| `isLoading` | `bool` | `false` | حالة التحميل |

### التفاعل

| المعامل | النوع | القيمة الافتراضية | الوصف |
|---------|-------|-----------------|--------|
| `onRefresh` | `VoidCallback?` | `null` | دالة التحديث |
| `onLoadMore` | `VoidCallback?` | `null` | دالة تحميل المزيد |
| `enablePullToRefresh` | `bool` | `false` | تفعيل التحديث |
| `enableLoadMore` | `bool` | `false` | تفعيل التحميل التلقائي |
| `loadMoreThreshold` | `double` | `200.0` | حد التحميل التلقائي |

### الفواصل

| المعامل | النوع | القيمة الافتراضية | الوصف |
|---------|-------|-----------------|--------|
| `separatorBuilder` | `Widget Function(BuildContext, int)?` | `null` | بناء الفواصل |
| `showDivider` | `bool` | `false` | إظهار خطوط الفصل |
| `dividerColor` | `Color?` | `Colors.grey.withOpacity(0.3)` | لون خطوط الفصل |
| `dividerHeight` | `double?` | `1.0` | سُمك خطوط الفصل |

### الرسوم المتحركة

| المعامل | النوع | القيمة الافتراضية | الوصف |
|---------|-------|-----------------|--------|
| `animationDuration` | `Duration` | `300ms` | مدة الرسوم المتحركة |
| `animationCurve` | `Curve` | `Curves.easeInOut` | منحنى الحركة |
| `enableItemAnimation` | `bool` | `true` | تفعيل الرسوم المتحركة |

### التمرير والتفاعل

| المعامل | النوع | القيمة الافتراضية | الوصف |
|---------|-------|-----------------|--------|
| `enableHapticFeedback` | `bool` | `true` | الاهتزاز التفاعلي |
| `overscrollDistance` | `double` | `20.0` | مسافة التمرير الزائد |

## أمثلة متقدمة

### قائمة مع حالات مختلفة

```dart
class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<Product> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    setState(() => isLoading = true);
    // محاكاة استدعاء API
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      products = await ProductService.getProducts();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomListView<Product>(
      items: products,
      isLoading: isLoading,
      itemBuilder: (context, product, index) {
        return ProductCard(product: product);
      },
      enablePullToRefresh: true,
      enableLoadMore: true,
      onRefresh: loadProducts,
      onLoadMore: () async {
        final newProducts = await ProductService.loadMore();
        setState(() {
          products.addAll(newProducts);
        });
      },
      emptyWidget: EmptyStateWidget(
        icon: Icons.shopping_bag_outlined,
        title: 'لا توجد منتجات',
        subtitle: 'تصفح المتجر لإضافة منتجات',
        action: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/shop'),
          child: Text('تصفح الآن'),
        ),
      ),
      backgroundColor: Colors.grey[50],
      itemSpacing: 12,
      borderRadius: BorderRadius.circular(16),
    );
  }
}
```

### قائمة مع فواصل مخصصة

```dart
CustomListView<Message>(
  items: messages,
  itemBuilder: (context, message, index) {
    return MessageBubble(message: message);
  },
  separatorBuilder: (context, index) {
    final current = messages[index];
    final next = messages[index + 1];
    
    // إظهار تاريخ مختلف
    if (!isSameDay(current.date, next.date)) {
      return DateSeparator(date: next.date);
    }
    
    return SizedBox(height: 8);
  },
  reverse: true, // أحدث الرسائل في الأسفل
  padding: EdgeInsets.all(16),
)
```

### قائمة مع رسوم متحركة متقدمة

```dart
CustomListView<Item>(
  items: items,
  itemBuilder: itemBuilder,
  enableItemAnimation: true,
  animationDuration: Duration(milliseconds: 800),
  animationCurve: Curves.elasticOut,
  // رسوم متحركة مخصصة للتحديث
  onRefresh: () async {
    // إضافة تأثير اهتزاز
    HapticFeedback.mediumImpact();
    await refreshData();
  },
)
```

## نصائح للاستخدام الأمثل

### 1. تحسين الأداء

```dart
// استخدم shrinkWrap فقط عند الضرورة
CustomListView(
  shrinkWrap: false, // افتراضي - أفضل للأداء
  // ...
)

// تحكم في عدد العناصر المحملة
CustomListView(
  loadMoreThreshold: 100, // حمل قبل الوصول للنهاية بـ100px
  // ...
)
```

### 2. إدارة الذاكرة

```dart
class _MyWidgetState extends State<MyWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomListView(
      scrollController: _scrollController,
      // ...
    );
  }
}
```

### 3. التعامل مع البيانات الكبيرة

```dart
class PaginatedList extends StatefulWidget {
  @override
  _PaginatedListState createState() => _PaginatedListState();
}

class _PaginatedListState extends State<PaginatedList> {
  List<Item> items = [];
  int currentPage = 1;
  bool isLoadingMore = false;
  bool hasMoreData = true;

  @override
  Widget build(BuildContext context) {
    return CustomListView<Item>(
      items: items,
      itemBuilder: (context, item, index) => ItemCard(item: item),
      enableLoadMore: hasMoreData,
      onLoadMore: loadMoreData,
      loadMoreThreshold: 200,
    );
  }

  Future<void> loadMoreData() async {
    if (isLoadingMore || !hasMoreData) return;
    
    setState(() => isLoadingMore = true);
    
    try {
      final newItems = await ApiService.getItems(page: currentPage + 1);
      
      setState(() {
        items.addAll(newItems);
        currentPage++;
        hasMoreData = newItems.isNotEmpty;
        isLoadingMore = false;
      });
    } catch (e) {
      setState(() => isLoadingMore = false);
      // معالجة الخطأ
    }
  }
}
```

## التخصيص المتقدم

### إنشاء حالة فارغة مخصصة

```dart
Widget buildCustomEmptyState() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      // صورة أو رسم توضيحي
      Image.asset(
        'assets/images/empty_state.png',
        width: 200,
        height: 200,
      ),
      SizedBox(height: 24),
      
      // عنوان رئيسي
      Text(
        'لا توجد عناصر حتى الآن',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      
      SizedBox(height: 12),
      
      // وصف
      Text(
        'ابدأ بإضافة عناصر جديدة لرؤيتها هنا',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.grey[600],
        ),
        textAlign: TextAlign.center,
      ),
      
      SizedBox(height: 32),
      
      // زر العمل
      ElevatedButton.icon(
        onPressed: () {
          // إجراء الإضافة
        },
        icon: Icon(Icons.add),
        label: Text('إضافة عنصر جديد'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.PRIMARY_COLOR,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    ],
  );
}
```

### مؤشر تحميل مخصص

```dart
Widget buildCustomLoadingIndicator() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      // مؤشر دوران مخصص
      Container(
        width: 60,
        height: 60,
        child: CircularProgressIndicator(
          strokeWidth: 4,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.PRIMARY_COLOR),
        ),
      ),
      
      SizedBox(height: 24),
      
      // نص التحميل
      Text(
        'جاري تحميل البيانات...',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      
      SizedBox(height: 8),
      
      // نص فرعي
      Text(
        'يرجى الانتظار',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
    ],
  );
}
```

## استكشاف الأخطاء

### المشاكل الشائعة وحلولها

#### 1. العناصر لا تظهر الرسوم المتحركة

```dart
// التأكد من تمرير enableItemAnimation
CustomListView(
  enableItemAnimation: true,
  animationDuration: Duration(milliseconds: 300),
  // ...
)
```

#### 2. Pull-to-refresh لا يعمل

```dart
// التأكد من تمرير onRefresh و enablePullToRefresh
CustomListView(
  enablePullToRefresh: true,
  onRefresh: () async {
    // منطق التحديث هنا
  },
  // ...
)
```

#### 3. التحميل التلقائي لا يعمل

```dart
// التأكد من المعاملات الصحيحة
CustomListView(
  enableLoadMore: true,
  loadMoreThreshold: 200.0, // ضبط المسافة
  onLoadMore: () async {
    // منطق التحميل هنا
  },
  // ...
)
```

#### 4. مشاكل الأداء مع القوائم الكبيرة

```dart
// استخدام معاملات محسنة للأداء
CustomListView(
  shrinkWrap: false, // تجنب true إلا للضرورة
  enableItemAnimation: false, // إيقاف الرسوم المتحركة للقوائم الكبيرة
  itemSpacing: null, // تجنب المسافات الإضافية
  // ...
)
```

## أمثلة للحالات المختلفة

### 1. قائمة المنتجات

```dart
CustomListView<Product>(
  items: products,
  itemBuilder: (context, product, index) {
    return ProductCard(
      product: product,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailPage(product: product),
        ),
      ),
    );
  },
  backgroundColor: Colors.grey[50],
  itemSpacing: 16,
  enablePullToRefresh: true,
  enableLoadMore: true,
  onRefresh: refreshProducts,
  onLoadMore: loadMoreProducts,
)
```

### 2. قائمة الرسائل

```dart
CustomListView<Message>(
  items: messages,
  reverse: true,
  itemBuilder: (context, message, index) {
    return MessageBubble(
      message: message,
      isMe: message.senderId == currentUserId,
    );
  },
  enableItemAnimation: true,
  animationCurve: Curves.bounceIn,
)
```

### 3. قائمة الإعدادات

```dart
CustomListView<SettingItem>(
  items: settingItems,
  itemBuilder: (context, setting, index) {
    return SettingTile(
      title: setting.title,
      icon: setting.icon,
      onTap: setting.onTap,
    );
  },
  showDivider: true,
  dividerHeight: 1,
  dividerColor: Colors.grey[300],
  backgroundColor: Colors.white,
  borderRadius: BorderRadius.circular(12),
)
```

## الخلاصة

`CustomListView` يوفر حلاً متكاملاً ومرناً لعرض القوائم في تطبيقات Flutter مع إمكانيات تخصيص واسعة وأداء محسن. يمكن استخدامه في معظم حالات الاستخدام التي تتطلب عرض قوائم تفاعلية وجذابة بصرياً.

### المميزات الرئيسية:
- 🎨 تخصيص بصري شامل
- 🔄 تفاعل متقدم (Pull-to-refresh, Load more)
- ✨ رسوم متحركة سلسة
- 📱 تجربة مستخدم محسنة
- 🔧 مرونة في التطبيق

### متى تستخدم CustomListView:
- ✅ عندما تحتاج لقائمة بميزات متقدمة
- ✅ عندما تريد تحكماً كاملاً في التصميم
- ✅ عندما تحتاج لرسوم متحركة للعناصر
- ✅ عندما تريد Pull-to-refresh و Load more
- ✅ عندما تحتاج لحالات مخصصة (فارغة، تحميل)