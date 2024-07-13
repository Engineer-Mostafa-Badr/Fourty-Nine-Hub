part of 'contact_us_cubit.dart';

class ContactUsState {
  final StateStatus status;
  final Failure? failure;
  final String? successMessage;
  const ContactUsState(
      {this.status = StateStatus.initial, this.failure, this.successMessage});
  ContactUsState copyWith({
     StateStatus? status,
   Failure? failure,
   String? successMessage,
  }) {
    return ContactUsState(
      status: status?? this.status,
      failure: failure?? this.failure,
      successMessage: successMessage?? this.successMessage,
    );
  }
}
