import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../res/assets/assets.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit() : super(OnBoardingState(currentIndex: 0));

  List<String> images = [
    Assets.onBoarding1,
    Assets.onBoarding2,
    Assets.onBoarding3,
    Assets.onBoarding4,
    Assets.onBoarding5,
    Assets.onBoarding6,
    Assets.onBoarding7,
    Assets.onBoarding8,
    Assets.onBoarding9,
    Assets.onBoarding10,
    Assets.onBoarding11,
    Assets.onBoarding12,
  ];
  List<String> titlesEn = [
    'Your trips are easier and faster! Book your ride anytime, anywhere',
    'Your transportation just got easier! Book your truck and track your shipment anytime with ease.',
    'Hungry? Order your favorite food and we will deliver it to your doorstep.',
    'Book your doctor visit in seconds, your health is our priority!',
    'Connect with your loved ones with high quality, unlimited audio and video.',
    'Buy and sell cars and apartments at the best prices, easily and safely',
    'Need maintenance? Find the best specialists in minutes',
    'Enjoy endless content! Flip through Reels and discover fun clips at every moment.',
    'Share your moments! Add stories and share your diary with your friends easily.',
    'Communicate without limits! Start chatting with your friends anytime and easily.',
    'Communicate freely! Enter voice rooms and talk to others easily and clearly.',
    'Go live! Share your moments with the world in a live broadcast without borders.',
  ];
  List<String> titlesAr = [
    'رحلاتك أصبحت أسهل وأسرع! احجز رحلتك في أي وقت وأي مكان.',
    'نقلك أصبح أسهل! احجز شاحنتك وتابع شحنتك في أي وقت بكل سهولة.',
    'جائع؟ اطلب طعامك المفضل وسنقوم بتوصيله إلى باب منزلك.',
    'احجز زيارة طبيبك في ثوانٍ، صحتك هي أولويتنا!',
    'تواصل مع أحبائك بجودة عالية وصوت وفيديو غير محدود.',
    'اشترِ وبِع السيارات والشقق بأفضل الأسعار بسهولة وأمان.',
    'تحتاج إلى صيانة؟ اعثر على أفضل المتخصصين في دقائق.',
    'استمتع بمحتوى لا ينتهي! تصفح الريلز واكتشف مقاطع ممتعة في كل لحظة.',
    'شارك لحظاتك! أضف القصص وشارك يومياتك مع أصدقائك بسهولة.',
    'تواصل بلا حدود! ابدأ الدردشة مع أصدقائك في أي وقت وبسهولة.',
    'تواصل بحرية! ادخل غرف الصوت وتحدث مع الآخرين بسهولة ووضوح.',
    'انطلق بالبث المباشر! شارك لحظاتك مع العالم في بث مباشر بلا حدود.',
  ];

  // Future<void> getOnboardingData() async {
  //   // CacheManager.getShowOnboarding();
  //   emit(
  //     state.copyWith(
  //       currentIndex: 0,
  //       image: images[0],
  //       titleAr: titlesAr[0],
  //       titleEn: titlesEn[0],
  //     ),
  //   );
  // }

  @override
  Future<void> close() {
    print("🔥 OnBoardingCubit is being closed!");
    return super.close();
  }

  Future<void> changeOnboardingData(int currentIndex) async {
    if (isClosed) {
      print("🚨 Cannot emit state, cubit is already closed.");
      return;
    }
    print('currentIndex: $currentIndex after emit');
    emit(
      state.copyWith(
        currentIndex: currentIndex,
        image: images[currentIndex],
        titleAr: titlesAr[currentIndex],
        titleEn: titlesEn[currentIndex],
      ),
    );
    print('currentIndex: $currentIndex before emit');
  }
}
