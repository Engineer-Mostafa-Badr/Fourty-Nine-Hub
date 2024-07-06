import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'contact_us_state.dart';

class ContactUsCubit extends Cubit<ContactUsState> {
  ContactUsCubit() : super(ContactUsInitial());
}
