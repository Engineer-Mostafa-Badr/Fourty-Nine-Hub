import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/social_media/club_house/domain/entities/club_voice_room_entity.dart';
import 'package:fourtyninehub/features/social_media/club_house/domain/usecases/add_club_voice_use_case.dart';
import 'package:fourtyninehub/features/social_media/club_house/domain/usecases/join_club_voice_use_case.dart';
import 'package:icons_launcher/utils/cli_logger.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../../common/models/public/pagination_params.dart';
import '../../../../../core/enums/zego_request_state.dart';
import '../../domain/usecases/end_club_voice_use_case.dart';
import '../../domain/usecases/get_club_voice_use_case.dart';
import '../../domain/usecases/leave_club_voice_use_case.dart';
import '../../domain/usecases/search_club_voice_use_case.dart';
import 'club_voice_state.dart'; // Assuming this is the file where your state classes are defined

class ClubVoiceCubit extends Cubit<ClubVoiceState> {
  final AddClubVoiceUseCase addClubVoiceUseCase;
  final GetClubVoiceUseCase getClubVoiceUseCase;
  final EndClubVoiceUseCase endClubVoiceUseCase;
  final LeaveClubVoiceUseCase leaveClubVoiceUseCase;
  final JoinClubVoiceUseCase joinClubVoiceUseCase;
  final SearchClubVoiceUseCase searchClubVoiceUseCase;
  ClubVoiceCubit(
    this.addClubVoiceUseCase,
    this.getClubVoiceUseCase,
    this.endClubVoiceUseCase,
    this.leaveClubVoiceUseCase,
    this.joinClubVoiceUseCase,
    this.searchClubVoiceUseCase,
  ) : super(const ClubVoiceState());

  String roomId = '';
  Future<void> addRoom(String subject) async {
    emit(state.copyWith(requestState: ZegoRequestState.loading));
    if (!isClosed) {
      await addClubVoiceUseCase(AddRoomParams(subject: subject)).then((value) {
        value.fold((l) {
          emit(state.copyWith(requestState: ZegoRequestState.failure));
        }, (r) {
          roomId = r.roomId;
          emit(state.copyWith(requestState: ZegoRequestState.success));
        });
      }).catchError((onError) {
        print('error $onError');
        emit(state.copyWith(requestState: ZegoRequestState.failure));
      });
    }
  }

  void joinRoom(String roomId) {
    emit(state.copyWith(requestState: ZegoRequestState.loading));
    joinClubVoiceUseCase(RoomMetaParams(roomId: roomId))
        .then((value) =>
            emit(state.copyWith(requestState: ZegoRequestState.success)))
        .catchError((onError) =>
            emit(state.copyWith(requestState: ZegoRequestState.failure)));
  }

  void leaveRoom(String roomId) {
    leaveClubVoiceUseCase(RoomMetaParams(roomId: roomId))
        .then((value) =>
            emit(state.copyWith(requestState: ZegoRequestState.success)))
        .catchError((onError) =>
            emit(state.copyWith(requestState: ZegoRequestState.failure)));
  }

  void endRoom(String roomId) {
    endClubVoiceUseCase(RoomMetaParams(roomId: roomId))
        .then((value) =>
            emit(state.copyWith(requestState: ZegoRequestState.success)))
        .catchError((onError) =>
            emit(state.copyWith(requestState: ZegoRequestState.failure)));
  }

  List<ClubVoiceRoomEntity> searchedRooms = [];
  void searchRoom(String roomSubject) {
    searchClubVoiceUseCase(SearchParams(roomSubject: roomSubject))
        .then((value) {
      emit(state.copyWith(requestState: ZegoRequestState.success));
    }).catchError((onError) {
      emit(state.copyWith(requestState: ZegoRequestState.failure));
    });
  }

  final PagingController<int, ClubVoiceRoomEntity> roomsPagingController =
      PagingController(firstPageKey: 1);
  int pageSize = 10;
  int roomsLength = 0;
  List<ClubVoiceRoomEntity> rooms = [];
  void loadData() async {
    await getAllRooms(1);
    roomsPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getAllRooms(pageKey);
    });
  }

  void refreshRooms() {
    roomsPagingController.refresh();
  }

  Future<void> getAllRooms(int page) async {
    emit(state.copyWith(requestState: ZegoRequestState.loading));
    getClubVoiceUseCase(PaginationParams(page: page, limit: pageSize))
        .then((value) {
      value.fold((l) {
        // CliLogger.error('there is an error ${l.toString()}',
        //     level: CliLoggerLevel.two);
        emit(state.copyWith(
          requestState: ZegoRequestState.failure,
        ));
      }, (r) {
        final isLastPage = r.length < pageSize;
        if (page == 1) {
          print("page == 1 $page");
          roomsPagingController.itemList = [];
        }
        if (isLastPage) {
          print("isLastPage = $isLastPage");
          roomsPagingController.appendLastPage(r);
        } else {
          print("isNotLastPage = $isLastPage");
          final nextPageKey = page + 1;
          roomsPagingController.appendPage(r, nextPageKey);
        }
        CliLogger.success('there is an success', level: CliLoggerLevel.two);
        rooms = r;
        roomsLength = r.length;
        emit(
          state
              .copyWith(requestState: ZegoRequestState.success)
              .copyWith(roomsList: r),
        );
      });
    }).catchError((onError) {
      CliLogger.error('there is an error from catch',
          level: CliLoggerLevel.three);
    });
  }
}
