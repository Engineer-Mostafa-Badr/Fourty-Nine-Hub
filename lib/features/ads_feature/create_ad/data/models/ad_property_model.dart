import 'package:fourtyninehub/features/ads_feature/create_ad/data/models/selection_model.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/ad_properties_entity.dart';

class AdPropertyModel extends AdPropertiesEntity {
  AdPropertyModel({
    required super.id,
    required super.nameAr,
    required super.nameEn,
    required super.type,
    required super.values,
    super.subCategoryId,
    super.mainCategoryId,
  });
  factory AdPropertyModel.fromJson(Map<String, dynamic> json) {
    // التحقق من أن هذا حقل المسمى الوظيفي
    final isJobTitleField =
        json['name_ar']?.toString().toLowerCase().contains('مسمى') == true ||
            json['name_ar']?.toString().toLowerCase().contains('وظيفي') ==
                true ||
            json['name_en']?.toString().toLowerCase().contains('job') == true ||
            json['name_en']?.toString().toLowerCase().contains('title') == true;

    // التحقق من أن هذا حقل نوع الخدمة
    final isServiceTypeField = json['name_ar']
                ?.toString()
                .toLowerCase()
                .contains('نوع') ==
            true ||
        json['name_ar']?.toString().toLowerCase().contains('خدمة') == true ||
        json['name_ar']?.toString().toLowerCase().contains('خدمات') == true ||
        json['name_en']?.toString().toLowerCase().contains('service') == true ||
        json['name_en']?.toString().toLowerCase().contains('type') == true;

    List<SelectionModel> processedValues = [];

    if (json['selections'] != null) {
      processedValues = (json['selections'] as List).map((e) {
        var selection = SelectionModel.fromJson(e);
        // استبدال مؤقت للنص
        if (selection.nameAr == 'ورديات') {
          return SelectionModel(
            nameAr: 'نبطشيات',
            nameEn: selection.nameEn,
            type: selection.type,
          );
        }
        return selection;
      }).toList();
    }

    // إضافة خيارات التمريض للمسمى الوظيفي
    if (isJobTitleField) {
      final nursingOptions = [
        SelectionModel(nameAr: 'ممرضة', nameEn: 'Nurse (Female)', type: ''),
        SelectionModel(nameAr: 'ممرض', nameEn: 'Nurse (Male)', type: ''),
        SelectionModel(
            nameAr: 'مشرفة تمريض',
            nameEn: 'Nursing Supervisor (Female)',
            type: ''),
        SelectionModel(
            nameAr: 'مشرف تمريض',
            nameEn: 'Nursing Supervisor (Male)',
            type: ''),
        SelectionModel(
            nameAr: 'فني تمريض', nameEn: 'Nursing Technician (Male)', type: ''),
        SelectionModel(
            nameAr: 'فنية تمريض',
            nameEn: 'Nursing Technician (Female)',
            type: ''),
      ];

      // إضافة الخيارات الجديدة إذا لم تكن موجودة
      for (var nursingOption in nursingOptions) {
        if (!processedValues
            .any((existing) => existing.nameAr == nursingOption.nameAr)) {
          processedValues.add(nursingOption);
        }
      }
    }

    // إضافة خيارات الخدمات الجديدة لنوع الخدمة
    if (isServiceTypeField) {
      final dentalServiceOptions = [
        SelectionModel(nameAr: 'حشو عادي', nameEn: 'Regular Filling', type: ''),
        SelectionModel(
            nameAr: 'حشو العصب', nameEn: 'Root Canal Filling', type: ''),
        SelectionModel(nameAr: 'عمل اشاعة', nameEn: 'X-Ray', type: ''),
        SelectionModel(
            nameAr: 'أكثر من خدمه معآ', nameEn: 'Multiple Services', type: ''),
      ];

      // إضافة الخيارات الجديدة إذا لم تكن موجودة
      for (var dentalOption in dentalServiceOptions) {
        if (!processedValues
            .any((existing) => existing.nameAr == dentalOption.nameAr)) {
          processedValues.add(dentalOption);
        }
      }
    }

    return AdPropertyModel(
      id: json['propId'] ?? json['_id'],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
      type: json['type'],
      subCategoryId: json['sub_category_id'],
      mainCategoryId: json['main_category_id'],
      values: processedValues,
    );
  }
}
