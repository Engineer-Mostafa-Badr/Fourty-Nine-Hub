part of 'on_boarding_cubit.dart';

class OnBoardingState {
  int currentIndex;
  String titleAr;
  String titleEn;
  String image;

  OnBoardingState({
    this.currentIndex = 0,
    this.titleAr = '',
    this.titleEn = '',
    this.image = '',
  });

  OnBoardingState copyWith({
    int? currentIndex,
    String? titleAr,
    String? titleEn,
    String? image,
  }) {
    return OnBoardingState(
      currentIndex: currentIndex ?? this.currentIndex,
      titleAr: titleAr ?? this.titleAr,
      titleEn: titleEn ?? this.titleEn,
      image: image ?? this.image,
    );
  }
}
