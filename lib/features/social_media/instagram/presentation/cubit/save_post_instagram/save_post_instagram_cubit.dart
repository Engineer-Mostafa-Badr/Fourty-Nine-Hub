import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/remove_save_post_instagram_use_case.dart';
import '../../../domain/usecases/save_post_instagram_use_case.dart';

part 'save_post_instagram_state.dart';

class SavePostInstagramCubit extends Cubit<SavePostInstagramState> {
  SavePostInstagramCubit(this._savePostInstagramUseCase, this._removeSavePostInstagramUseCase)
      : super(SavePostInstagramState(status: SavePostInstagramStatus.initial));
  final SavePostInstagramUseCase _savePostInstagramUseCase;
  final RemoveSavePostInstagramUseCase _removeSavePostInstagramUseCase;

  Future<void> savePostInstagram(String postId) async {
    emit(state.copyWith(status: SavePostInstagramStatus.loading));
    final result = await _savePostInstagramUseCase(
      SavePostInstagramParams(
        postId: postId,
      ),
    );
    result.fold(
        (l) => emit(state.copyWith(status: SavePostInstagramStatus.failure)),
        (r) => emit(state.copyWith(status: SavePostInstagramStatus.success, isSave: r)));
  }

  Future<void> removeSavePostInstagram(String postId) async {
    emit(state.copyWith(status: SavePostInstagramStatus.loading));
    final result = await _removeSavePostInstagramUseCase(
      SavePostInstagramParams(
        postId: postId,
      ),
    );
    result.fold(
        (l) => emit(state.copyWith(status: SavePostInstagramStatus.failure)),
        (r) => emit(state.copyWith(status: SavePostInstagramStatus.success, isSave: r)));
  }
}
