part of 'edit_page_cubit.dart';

sealed class EditPageState extends Equatable {
  const EditPageState();

  @override
  List<Object> get props => [];
}

final class EditPageInitial extends EditPageState {}

final class EditPageIndexChanged extends EditPageState {}
