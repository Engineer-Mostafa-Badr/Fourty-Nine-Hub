import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';

part 'health_share_cubit_state.dart';

class HealthShareCubit extends Cubit<HealthShareState> {
  HealthShareCubit() : super(HealthShareCubitInitial());

  List<SubCategoryEntity> subCategories = [];

  List<String> cities = ['Cairo', 'Giza', 'Alex'];
  List<String> areas = ['Cairo', 'Giza', 'Alex'];
}
