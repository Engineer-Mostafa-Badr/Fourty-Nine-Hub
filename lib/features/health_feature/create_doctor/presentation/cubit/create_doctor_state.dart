part of 'create_doctor_cubit.dart';

enum CreateDoctorStates { loading, initState, error }

class CreateDoctorState {
  final CreateDoctorStates status;
  final Failure? failure;
  final bool hasCall;
  final bool hasHomeVisit;
  final bool hasClinic;
  CreateDoctorState({
    this.status = CreateDoctorStates.loading,
    this.failure,
    this.hasCall = false,
    this.hasHomeVisit = false,
    this.hasClinic = false,
  });
  CreateDoctorState copyWith({
    CreateDoctorStates? status,
    Failure? failure,
    bool? hasCall,
    bool? hasHomeVisit,
    bool? hasClinic,
  }) {
    return CreateDoctorState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      hasCall: hasCall ?? this.hasCall,
      hasHomeVisit: hasHomeVisit ?? this.hasHomeVisit,
      hasClinic: hasClinic ?? this.hasClinic,
    );
  }

  final List<String> governorates = [
    'Alexandria',
    'Cairo',
    'Giza',
    'Aswan',
    'Asyut',
    'Beheira',
    'Beni Suef'
  ];

  final List<String> cities = [
    'Alexandria',
    'Cairo',
    'Giza',
    'Aswan',
    'Asyut',
    'Beheira',
    'Beni Suef'
  ];
}
