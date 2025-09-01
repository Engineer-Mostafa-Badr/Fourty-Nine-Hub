import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/reel_entity.dart';

// Events
abstract class TiktokEvent extends Equatable {
  const TiktokEvent();

  @override
  List<Object?> get props => [];
}

class LoadReels extends TiktokEvent {}

class PlayReel extends TiktokEvent {
  final String reelId;

  const PlayReel(this.reelId);

  @override
  List<Object?> get props => [reelId];
}

class PauseReel extends TiktokEvent {
  final String reelId;

  const PauseReel(this.reelId);

  @override
  List<Object?> get props => [reelId];
}

class LikeReel extends TiktokEvent {
  final String reelId;

  const LikeReel(this.reelId);

  @override
  List<Object?> get props => [reelId];
}

class ShareReel extends TiktokEvent {
  final String reelId;

  const ShareReel(this.reelId);

  @override
  List<Object?> get props => [reelId];
}

// States
abstract class TiktokState extends Equatable {
  const TiktokState();

  @override
  List<Object?> get props => [];
}

class TiktokInitial extends TiktokState {}

class TiktokLoading extends TiktokState {}

class TiktokLoaded extends TiktokState {
  final List<ReelEntity> reels;
  final String? currentPlayingReelId;
  final int currentIndex;

  const TiktokLoaded({
    required this.reels,
    this.currentPlayingReelId,
    this.currentIndex = 0,
  });

  @override
  List<Object?> get props => [reels, currentPlayingReelId, currentIndex];

  TiktokLoaded copyWith({
    List<ReelEntity>? reels,
    String? currentPlayingReelId,
    int? currentIndex,
  }) {
    return TiktokLoaded(
      reels: reels ?? this.reels,
      currentPlayingReelId: currentPlayingReelId ?? this.currentPlayingReelId,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}

class TiktokError extends TiktokState {
  final String message;

  const TiktokError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class TiktokCubit extends Cubit<TiktokState> {
  TiktokCubit() : super(TiktokInitial());

  void loadReels() {
    emit(TiktokLoading());
    
    // Sample reels with actual m3u8 playlist URLs
    final List<ReelEntity> reels = [
      ReelEntity(
        id: '1',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/c7a273fd-264e-447b-a3a0-257bbed9fcab/playlist.m3u8',
        title: 'Amazing Video 1',
        description: 'Check out this amazing content!',
        authorName: 'Creator 1',
        likes: 1234,
        comments: 89,
        shares: 45,
        duration: const Duration(seconds: 30),
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      ReelEntity(
        id: '2',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/8ae93b98-5c0a-4a44-945e-55ca05ab6567/playlist.m3u8',
        title: 'Incredible Video 2',
        description: 'You won\'t believe what happens next!',
        authorName: 'Creator 2',
        likes: 5678,
        comments: 234,
        shares: 123,
        duration: const Duration(seconds: 45),
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      ReelEntity(
        id: '3',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/9dee7645-b735-442c-88c3-7b2221786900/playlist.m3u8',
        title: 'Epic Video 3',
        description: 'This is absolutely epic!',
        authorName: 'Creator 3',
        likes: 9876,
        comments: 567,
        shares: 234,
        duration: const Duration(seconds: 60),
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      ReelEntity(
        id: '4',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/df6e766f-cee7-4156-98e6-fe942380af33/playlist.m3u8',
        title: 'Viral Video 4',
        description: 'Going viral! 🔥',
        authorName: 'Creator 4',
        likes: 15000,
        comments: 1200,
        shares: 800,
        duration: const Duration(seconds: 25),
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      ReelEntity(
        id: '5',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/d23511b9-426b-4abd-b746-3400baf46c91/playlist.m3u8',
        title: 'Trending Video 5',
        description: 'Trending now! 📈',
        authorName: 'Creator 5',
        likes: 8900,
        comments: 678,
        shares: 345,
        duration: const Duration(seconds: 40),
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      ReelEntity(
        id: '6',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/1583fae3-3335-4f7d-8fbb-02271cac5438/playlist.m3u8',
        title: 'Amazing Video 6',
        description: 'Pure entertainment! 🎬',
        authorName: 'Creator 6',
        likes: 4321,
        comments: 234,
        shares: 123,
        duration: const Duration(seconds: 35),
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      ReelEntity(
        id: '7',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/18fbb414-83a9-42fb-9b74-072507e17ff3/playlist.m3u8',
        title: 'Incredible Video 7',
        description: 'Mind-blowing content! 💥',
        authorName: 'Creator 7',
        likes: 7654,
        comments: 456,
        shares: 234,
        duration: const Duration(seconds: 50),
        createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
      ),
      ReelEntity(
        id: '8',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/6c5be629-f4e4-4b47-a319-95fa54213dee/playlist.m3u8',
        title: 'Epic Video 8',
        description: 'Epic moments captured! 📸',
        authorName: 'Creator 8',
        likes: 11234,
        comments: 789,
        shares: 456,
        duration: const Duration(seconds: 28),
        createdAt: DateTime.now().subtract(const Duration(minutes: 1)),
      ),
      ReelEntity(
        id: '9',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/6bfa174a-3a0b-4a8e-a5f1-4fa7ecb3ba76/playlist.m3u8',
        title: 'Amazing Video 9',
        description: 'Another amazing video! 🎥',
        authorName: 'Creator 9',
        likes: 5432,
        comments: 321,
        shares: 156,
        duration: const Duration(seconds: 32),
        createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
      ),
      ReelEntity(
        id: '10',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/5b20bdcf-50aa-4cb7-bb1d-493f32ddfd5d/playlist.m3u8',
        title: 'Incredible Video 10',
        description: 'This is incredible! 🌟',
        authorName: 'Creator 10',
        likes: 8765,
        comments: 543,
        shares: 234,
        duration: const Duration(seconds: 38),
        createdAt: DateTime.now().subtract(const Duration(minutes: 40)),
      ),
      ReelEntity(
        id: '11',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/9b97cd2a-1ce1-488d-8778-76d855124722/playlist.m3u8',
        title: 'Epic Video 11',
        description: 'Epic content right here! ⚡',
        authorName: 'Creator 11',
        likes: 12345,
        comments: 789,
        shares: 456,
        duration: const Duration(seconds: 42),
        createdAt: DateTime.now().subtract(const Duration(minutes: 35)),
      ),
      ReelEntity(
        id: '12',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/615006b2-630a-42f1-afe2-70ea175889bd/playlist.m3u8',
        title: 'Viral Video 12',
        description: 'Going viral! 🚀',
        authorName: 'Creator 12',
        likes: 18765,
        comments: 1234,
        shares: 678,
        duration: const Duration(seconds: 29),
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      ReelEntity(
        id: '13',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/58aa8092-18ae-428c-b87f-69796a68fc9f/playlist.m3u8',
        title: 'Trending Video 13',
        description: 'Trending now! 📊',
        authorName: 'Creator 13',
        likes: 9876,
        comments: 654,
        shares: 321,
        duration: const Duration(seconds: 36),
        createdAt: DateTime.now().subtract(const Duration(minutes: 25)),
      ),
      ReelEntity(
        id: '14',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/96d15566-9992-4b46-97f1-e168181ac97e/playlist.m3u8',
        title: 'Amazing Video 14',
        description: 'Pure entertainment! 🎭',
        authorName: 'Creator 14',
        likes: 6543,
        comments: 432,
        shares: 198,
        duration: const Duration(seconds: 33),
        createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
      ),
      ReelEntity(
        id: '15',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/47e62315-80c3-47b7-8c76-2fa65f4107c8/playlist.m3u8',
        title: 'Incredible Video 15',
        description: 'Mind-blowing! 💫',
        authorName: 'Creator 15',
        likes: 11234,
        comments: 876,
        shares: 543,
        duration: const Duration(seconds: 41),
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      ReelEntity(
        id: '16',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/3d827556-2636-44ba-856f-952e0aa4528f/playlist.m3u8',
        title: 'Epic Video 16',
        description: 'Epic moments! 🎬',
        authorName: 'Creator 16',
        likes: 14567,
        comments: 987,
        shares: 654,
        duration: const Duration(seconds: 27),
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      ReelEntity(
        id: '17',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/756ed4eb-fe32-4c09-b756-3b3a69f40616/playlist.m3u8',
        title: 'Viral Video 17',
        description: 'Viral sensation! 🌊',
        authorName: 'Creator 17',
        likes: 22345,
        comments: 1456,
        shares: 789,
        duration: const Duration(seconds: 34),
        createdAt: DateTime.now().subtract(const Duration(minutes: 8)),
      ),
      ReelEntity(
        id: '18',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/8ee40536-ec35-4b47-860c-43b6a547ad27/playlist.m3u8',
        title: 'Trending Video 18',
        description: 'Trending worldwide! 🌍',
        authorName: 'Creator 18',
        likes: 16789,
        comments: 1123,
        shares: 567,
        duration: const Duration(seconds: 39),
        createdAt: DateTime.now().subtract(const Duration(minutes: 6)),
      ),
      ReelEntity(
        id: '19',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/73b56938-314f-4670-a7ef-1c2ee2183f85/playlist.m3u8',
        title: 'Amazing Video 19',
        description: 'Amazing content! ✨',
        authorName: 'Creator 19',
        likes: 8765,
        comments: 654,
        shares: 321,
        duration: const Duration(seconds: 31),
        createdAt: DateTime.now().subtract(const Duration(minutes: 4)),
      ),
      ReelEntity(
        id: '20',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/9ca43f59-bc29-4e08-b0ee-ab81f00ead1b/playlist.m3u8',
        title: 'Incredible Video 20',
        description: 'Incredible moments! 🎯',
        authorName: 'Creator 20',
        likes: 13456,
        comments: 987,
        shares: 456,
        duration: const Duration(seconds: 37),
        createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
      ReelEntity(
        id: '21',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/6333fe2c-1651-4560-b13e-bb14ff693d1e/playlist.m3u8',
        title: 'Epic Video 21',
        description: 'Epic content! 🏆',
        authorName: 'Creator 21',
        likes: 19876,
        comments: 1345,
        shares: 678,
        duration: const Duration(seconds: 43),
        createdAt: DateTime.now().subtract(const Duration(minutes: 1)),
      ),
      ReelEntity(
        id: '22',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/78beafe0-9cd0-46de-b7bf-a955c161b405/playlist.m3u8',
        title: 'Viral Video 22',
        description: 'Going viral! 🔥',
        authorName: 'Creator 22',
        likes: 25678,
        comments: 1678,
        shares: 890,
        duration: const Duration(seconds: 26),
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      ReelEntity(
        id: '23',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/591b59fb-4d0f-4a5f-8372-639d7aa4c31d/playlist.m3u8',
        title: 'Trending Video 23',
        description: 'Trending now! 📈',
        authorName: 'Creator 23',
        likes: 14567,
        comments: 1098,
        shares: 543,
        duration: const Duration(seconds: 35),
        createdAt: DateTime.now().subtract(const Duration(minutes: 25)),
      ),
      ReelEntity(
        id: '24',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/c4f5754e-f530-4e5a-82c9-fd911cfe5580/playlist.m3u8',
        title: 'Amazing Video 24',
        description: 'Amazing content! 🌟',
        authorName: 'Creator 24',
        likes: 9876,
        comments: 765,
        shares: 234,
        duration: const Duration(seconds: 30),
        createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
      ),
      ReelEntity(
        id: '25',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/990ee83e-5445-4ae0-a127-076c2b8eb685/playlist.m3u8',
        title: 'Incredible Video 25',
        description: 'Incredible moments! 💫',
        authorName: 'Creator 25',
        likes: 12345,
        comments: 987,
        shares: 456,
        duration: const Duration(seconds: 38),
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      ReelEntity(
        id: '26',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/71d47819-5e01-4889-9295-95136d323a28/playlist.m3u8',
        title: 'Epic Video 26',
        description: 'Epic content! ⚡',
        authorName: 'Creator 26',
        likes: 17890,
        comments: 1234,
        shares: 567,
        duration: const Duration(seconds: 32),
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      ReelEntity(
        id: '27',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/93fcc6dc-2253-45ec-8ca8-bf18e081f283/playlist.m3u8',
        title: 'Viral Video 27',
        description: 'Viral sensation! 🚀',
        authorName: 'Creator 27',
        likes: 23456,
        comments: 1567,
        shares: 789,
        duration: const Duration(seconds: 29),
        createdAt: DateTime.now().subtract(const Duration(minutes: 8)),
      ),
      ReelEntity(
        id: '28',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/a55b07f7-d2f9-41c0-ab2c-0708494812ef/playlist.m3u8',
        title: 'Trending Video 28',
        description: 'Trending worldwide! 🌍',
        authorName: 'Creator 28',
        likes: 15678,
        comments: 1123,
        shares: 456,
        duration: const Duration(seconds: 36),
        createdAt: DateTime.now().subtract(const Duration(minutes: 6)),
      ),
      ReelEntity(
        id: '29',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/872cd793-f7d9-4238-87bf-30afb3f935dd/playlist.m3u8',
        title: 'Amazing Video 29',
        description: 'Amazing content! ✨',
        authorName: 'Creator 29',
        likes: 9876,
        comments: 765,
        shares: 234,
        duration: const Duration(seconds: 33),
        createdAt: DateTime.now().subtract(const Duration(minutes: 4)),
      ),
      ReelEntity(
        id: '30',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/d4ff5971-bfad-4a1d-a39b-bb64f8f60928/playlist.m3u8',
        title: 'Incredible Video 30',
        description: 'Incredible moments! 🎯',
        authorName: 'Creator 30',
        likes: 13456,
        comments: 987,
        shares: 456,
        duration: const Duration(seconds: 40),
        createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
      ReelEntity(
        id: '31',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/74ff4b3b-6351-4bcc-a8b8-afe2bb9b38b2/playlist.m3u8',
        title: 'Epic Video 31',
        description: 'Epic content! 🏆',
        authorName: 'Creator 31',
        likes: 19876,
        comments: 1345,
        shares: 678,
        duration: const Duration(seconds: 28),
        createdAt: DateTime.now().subtract(const Duration(minutes: 1)),
      ),
      ReelEntity(
        id: '32',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/75fe6bb5-5fac-4317-960c-2a481f050078/playlist.m3u8',
        title: 'Viral Video 32',
        description: 'Going viral! 🔥',
        authorName: 'Creator 32',
        likes: 25678,
        comments: 1678,
        shares: 890,
        duration: const Duration(seconds: 31),
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      ReelEntity(
        id: '33',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/6dc67514-7132-4f30-91c0-e42630b8e14c/playlist.m3u8',
        title: 'Trending Video 33',
        description: 'Trending now! 📈',
        authorName: 'Creator 33',
        likes: 14567,
        comments: 1098,
        shares: 543,
        duration: const Duration(seconds: 37),
        createdAt: DateTime.now().subtract(const Duration(minutes: 25)),
      ),
      ReelEntity(
        id: '34',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/44ea96c2-1c80-4c80-b0be-a7d659fab3f4/playlist.m3u8',
        title: 'Amazing Video 34',
        description: 'Amazing content! 🌟',
        authorName: 'Creator 34',
        likes: 9876,
        comments: 765,
        shares: 234,
        duration: const Duration(seconds: 34),
        createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
      ),
      ReelEntity(
        id: '35',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/416cdd5b-93e2-4ac3-a790-fa76cc3271ce/playlist.m3u8',
        title: 'Incredible Video 35',
        description: 'Incredible moments! 💫',
        authorName: 'Creator 35',
        likes: 12345,
        comments: 987,
        shares: 456,
        duration: const Duration(seconds: 39),
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      ReelEntity(
        id: '36',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/bcc46f0c-f9f2-4584-9dc0-ac8a2ba7108f/playlist.m3u8',
        title: 'Epic Video 36',
        description: 'Epic content! ⚡',
        authorName: 'Creator 36',
        likes: 17890,
        comments: 1234,
        shares: 567,
        duration: const Duration(seconds: 26),
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      ReelEntity(
        id: '37',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/3dce9fcb-2a0b-46c9-bc21-4e4d9435587f/playlist.m3u8',
        title: 'Viral Video 37',
        description: 'Viral sensation! 🚀',
        authorName: 'Creator 37',
        likes: 23456,
        comments: 1567,
        shares: 789,
        duration: const Duration(seconds: 35),
        createdAt: DateTime.now().subtract(const Duration(minutes: 8)),
      ),
      ReelEntity(
        id: '38',
        videoUrl: 'https://vz-134bf9bf-f83.b-cdn.net/0fc10c28-92b1-476c-b01f-f07423e2b297/playlist.m3u8',
        title: 'Trending Video 38',
        description: 'Trending worldwide! 🌍',
        authorName: 'Creator 38',
        likes: 15678,
        comments: 1123,
        shares: 456,
        duration: const Duration(seconds: 41),
        createdAt: DateTime.now().subtract(const Duration(minutes: 6)),
      ),
    ];

    emit(TiktokLoaded(reels: reels));
  }

  void playReel(String reelId) {
    if (state is TiktokLoaded) {
      final currentState = state as TiktokLoaded;
      emit(currentState.copyWith(currentPlayingReelId: reelId));
    }
  }

  void pauseReel(String reelId) {
    if (state is TiktokLoaded) {
      final currentState = state as TiktokLoaded;
      if (currentState.currentPlayingReelId == reelId) {
        emit(currentState.copyWith(currentPlayingReelId: null));
      }
    }
  }

  void likeReel(String reelId) {
    if (state is TiktokLoaded) {
      final currentState = state as TiktokLoaded;
      final updatedReels = currentState.reels.map((reel) {
        if (reel.id == reelId) {
          return reel.copyWith(
            likes: reel.likes + (reel.isLiked ? -1 : 1),
            isLiked: !reel.isLiked,
          );
        }
        return reel;
      }).toList();

      emit(currentState.copyWith(reels: updatedReels));
    }
  }

  void shareReel(String reelId) {
    if (state is TiktokLoaded) {
      final currentState = state as TiktokLoaded;
      final updatedReels = currentState.reels.map((reel) {
        if (reel.id == reelId) {
          return reel.copyWith(shares: reel.shares + 1);
        }
        return reel;
      }).toList();

      emit(currentState.copyWith(reels: updatedReels));
    }
  }

  void setCurrentIndex(int index) {
    if (state is TiktokLoaded) {
      final currentState = state as TiktokLoaded;
      emit(currentState.copyWith(currentIndex: index));
    }
  }
}
