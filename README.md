# FourtyNineHub

تطبيق `fourtyninehub` هو واجهة موحّدة لخدمات شركة "49" تدمج بين الرحلات، المنشورات الاجتماعية، المحفظة الرقمية، المحادثات المباشرة، والإشعارات الذكية. التطبيق يهدف لتقديم تجربة محركّة بالخدمات المتعددة في مكان واحد مع دعم كامل للغات المتعدّدة (عربي / إنجليزي / أردي) وتحكّم مركزي في المحتوى من خلال لوحة إدارة مخصّصة.

### المميزات الرئيسية

- تسجيل دخول موحّد بالهاتف أو البريد مع التحقق برمز PIN.
- رحلة شاملة لقسم الخدمات (Ride, Star, Providers) مع نظام تتبّع، لوحة قيادة للرحلات، والاشتراكات المدفوعة.
- شبكة اجتماعية خفيفة (Reels، منشورات، تعليقات) مع دعم لإنشاء ومشاركة الوسائط.
- دردشة فورية داخل التطبيق + مكالمات صوتية/فيديو عبر CallKit و Firebase.
- إشعارات فورية بإستخدام `firebase_messaging` مع سجل إشعارات شامل وحساب للرسائل غير المقروءة.
- لوحة محفظة رقمية تعرض الرصيد، المعاملات، وتنبيهات المدفوعات.
- تخصيص المحتوى والصفحات من خلال وحدات `CustomPage` و `Secrets` التي تُفعّل محتوى ديناميكي بدون إعادة نشر التطبيق.
- دعم إعدادات المستخدم، التنبيهات، والتمرير السريع عبر `Floating Navigator` و `Choice Ruler`.

### البنية المعمارية

المشروع يطبق Clean Architecture مع تقسيم واضح بين الطبقات، وداخل `features/` كل ميزة لها هيكل فرعي موحّد:

```
features/
├── <feature_name>/
│   ├── data/
│   │   ├── models/
│   │   ├── sources/      # API / Local data sources
│   │   └── repositories/ # تطبيق الـ Contracts من الـ Domain
│   ├── domain/
│   │   ├── entities/
│   │   ├── usecases/
│   │   └── repositories/ # التعريفات المجردة التي تعتمد عليها الطبقات العليا
│   └── presentation/
│       ├── controllers/  # Cubit / Bloc
│       ├── widgets/      # مكونات UI قابلة لإعادة الاستخدام
│       └── pages/        # الشاشات والملاحة
└── common/   # (في حال الحاجة) shared widgets الخاصة بالـ features
```

كل ميزة تعتمد هذا النمط لتبسيط الاختبار، التسليم المستقل، وسهولة البحث عن الطبقات عند إضافة توسيعات جديدة.

كل ميزة تحتوي على طبقات Presentation (Cubit/Pages)، Domain (UseCases، Entities)، و Data (API، Repositories). يتم إدارة الحالة بواسطة `flutter_bloc` وخدمات تعتمد على `GetIt` للـ Dependency Injection.

### التقنيات والأدوات

- Flutter 3.8+ مع دعم منصات Android / iOS / Web / Desktop.
- State Management: `flutter_bloc`, `cubit`.
- DI: `get_it`.
- Localization: `easy_localization`.
- الشبكات: `dio`, `socket_io_client`, `web_socket_channel`.
- التخزين المحلي: `flutter_secure_storage`, `shared_preferences`.
- Firebase: `firebase_core`, `firebase_auth`, `firebase_messaging`, `cloud messaging`.
- خدمات إضافية: `google_mobile_ads`, `flutter_local_notifications`, `flutter_background_service`, `cached_network_image`, `flutter_screenutil`, `widgetbook`، وغيرها من الـ plugins الخاصة بالوسائط (camera, image_picker, video).
- أدوات تطوير: `flutter_lints`, `json_serializable`, `build_runner`, `widgetbook_generator`.

### كيفية الإعداد والتشغيل

1. تأكّد من إعداد مفاتيح Firebase وملفات `google-services.json` و `GoogleService-Info.plist`.
2. نظّف المشروع:
   ```bash
   flutter clean
   ```
3. ثبّت الحزم:
   ```bash
   flutter pub get
   ```
4. لتشغيل التطبيق على جهاز أو محاكي:
   ```bash
   flutter run
   ```
5. لبناء ملف APK (مع obfuscation باستخدام رموز الرمزية):
   ```bash
   flutter build apk --obfuscate --split-debug-info=build/app/outputs/symbols
   ```

### ملاحظات التطوير

- كل ميزة معزولة في مجلدها مع التزام بمعايير Clean Architecture لتسهيل الاختبار والتوسّع.
- يتم تنظيم الألوان، الثوابت، والموارد في `core/res` و `res/`.
- Widgets قابلة لإعادة الاستخدام ضمن `common/components` و `widgetbook` لتسريع عملية التصميم.
- يدعم التطبيق تغيّرات الوقت الشبكي ويستجيب تلقائيًا عبر `TimeSyncService`.
- يمكن تفعيل أو تعطيل صفحات مخصصة عبر `CustomPageCubit` دون إعادة إصدار للتطبيق.
