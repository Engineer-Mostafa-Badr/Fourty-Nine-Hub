import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'privacy_state.dart';

class PrivacyCubit extends Cubit<PrivacyState> {
  PrivacyCubit() : super(PrivacyInitial());
}
