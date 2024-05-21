part of 'healthcare_bloc.dart';

abstract class HealthcareState extends Equatable {
  const HealthcareState();  

  @override
  List<Object> get props => [];
}
class HealthcareInitial extends HealthcareState {}
