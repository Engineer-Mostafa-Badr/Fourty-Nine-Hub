import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'create_company_ad_state.dart';

class CreateCompanyAdCubit extends Cubit<CreateCompanyAdState> {
  CreateCompanyAdCubit() : super(CreateCompanyAdInitial());
}
