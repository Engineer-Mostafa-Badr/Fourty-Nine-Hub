
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/widget/clickable_widget.dart';
import '../widgets/dialog/Show_dialog.dart';
import '../widgets/dialog/dialog_content.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../helpers/manage_vibration.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  UserProfilePageState createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  @override
  void initState() {
    super.initState();
    // final userId = context.read<UserCubit>().state.data?.id;
    // if (userId != null) {
    //   final tinderCubit = context.read<TinderViewCubit>();
    //   tinderCubit
    //     ..resetStoryIndex()
    //     ..fetchUserProfile(userId: userId);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return
        // context.watch<TinderViewCubit>().state.profileUserData == null
        //   ? _buildLoadingScaffold()
        // :
        _buildProfileScaffold(context);
  }

  CustomScaffold _buildLoadingScaffold() {
    return CustomScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: BackAppBar(
          label: LocaleKeys.profile.localize,
        ),
      ),
      body: const Center(child: CupertinoActivityIndicator()),
    );
  }

  CustomScaffold _buildProfileScaffold(BuildContext context) {
    // final userCubit = context.read<UserCubit>();
    return CustomScaffold(
      // floatingActionButton: _buildFloatingActionButton(context),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: BackAppBar(
          label: 'Mohamed Magdy',
          textColor: AppColors.getTextColor(context),
          iconColor:AppColors.getTextColor(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          //async {
          //   await context
          //       .read<TinderViewCubit>()
          //       .fetchUserProfile(userId: userCubit.state.data!.id);
          // },
          child: SingleChildScrollView(
            // physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSwipeCard(context),
                  _buildUserInfo(context),
                  // _buildStats(context),
                  const Sizer(
                    height: kToolbarHeight * 1.5,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeCard(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 16,
      height: MediaQuery.of(context).size.height * 0.60,
      child: const SwipeCardDemo(),
    );
  }

  // FloatingActionButton _buildFloatingActionButton(BuildContext context) {
  //   return FloatingActionButton(
  //     heroTag: 'upload_image',
  //     onPressed: () {
  //       Navigator.push(context,
  //           MaterialPageRoute(builder: (context) => const EditProfileTinder()));
  //       // _handleImageUpload(context);
  //     },
  //     backgroundColor: AppColors.SECONDARY_COLOR,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
  //     child: const Icon(Icons.edit, color: Colors.white),
  //   );
  // }

  // Future<void> _handleImageUpload(BuildContext context) async {
  //   try {
  //     final uploadResult = await UploadFile().uploadImage(
  //       subCategoryId: '66af974f8bf69f9469944746',
  //       onUploaded: (uploadedFile) async {
  //         final userCubit = context.read<UserCubit>();
  //         final tinderCubit = context.read<TinderViewCubit>();
  //
  //         // await tinderCubit.uploadPictures(pictures: [uploadedFile.mediaId]);
  //         // await tinderCubit
  //         //     .fetchUserProfile(userId: userCubit.state.data!.id)
  //         //     .then((value) => tinderCubit.resetStoryIndex());
  //       }, context: context,
  //     );
  //
  //     if (uploadResult == null) {
  //       log("Image upload failed: No file selecjhgjgted.");
  //     }
  //   } catch (e) {
  //      log("Image upload failed: $e");
  //
  //   }
  // }

  Widget _buildUserInfo(BuildContext context) {
    // final profileData = context.watch<TinderViewCubit>().state.profileUserData;
    // final userId = profileData?.userId;
    List<String> interests = [
      'Football',
      'Gym',
      'Reading',
      'Writing',
      'Travel',
      'Singing',
      'Painting',
    ];
    List<String> interestsAr = [
      'كرة القدم',
      'الجيم',
      'قراءة',
      'كتابة',
      'سفر',
      'غناء',
      'رسم',
    ];
    return Column(
      children: [
        _buildInfoContainer(
            prefixIcon: Assets.tinder_search,
            title: context.isArabic?'أبحث عن':'Looking For',
            child: Label(
              text: context.isArabic?'اصدقاء جُدد 👋':'New Friends 👋',
              style: Styles.headerText(
                  color: AppColors.getTextColor(context),
                  fontWeight: FontWeight.bold,
                  fontSize: 48),
            )),
        const Sizer(),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.h),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.getFindFillColor(context),
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Image.asset(Assets.about,height: 15.h,color:context.isDarkMode? Colors.white:Colors.black),
                  Sizer(),
                  Expanded(
                      child: Label(
                        text: context.isArabic?'عني':'About Me',
                        style: Styles.headerText(
                            fontSize: 32,
                            color: AppColors.getTextColor(context),
                            fontWeight: FontWeight.w500),
                      ),),
                   Icon(
                    Icons.more_horiz,
                    color:context.isDarkMode? const Color(0xFF808080):Colors.black,
                  ),]),
              const Sizer(),
              Label(
              text: context.isArabic?'مقاتل': 'Fighter',
              style: Styles.headerText(
              color:AppColors.getTextColor(context),
              fontWeight: FontWeight.bold,
              fontSize: 48),

          ),],
        )),
        // _buildInfoContainer(
        //     prefixIcon: Assets.about,
        //     suffixIcon: Icons.more_horiz,
        //     title:  context.isArabic?'عني':'About Me',
        //     child: Label(
        //       text: context.isArabic?'مقاتل': 'Fighter',
        //       style: Styles.headerText(
        //           color: Colors.white,
        //           fontWeight: FontWeight.bold,
        //           fontSize: 48),
        //     )),
        const Sizer(),
        _buildInfoContainer(
          prefixIcon: Assets.profile_card,
          suffixIcon: Icons.more_horiz,
          title:  context.isArabic?'عام':'Essentials',
          child: Column(
            children: [
              _buildInfoContent(
                title: context.isArabic?'يبعُد 10 ميل': '10 Miles Away',
                icon: Assets.location,
              ),
              const Sizer(),
              _buildInfoContent(
                title: context.isArabic?'188سم': '188cm',
                icon: Assets.ruler,
              ),
              const Sizer(),
              _buildInfoContent(
                title:context.isArabic?'جامعة القاهرة': 'cairo university',
                icon: Assets.graduation,
              ),
            ],
          ),
        ),
        const Sizer(),
        _buildInfoContainer(
            prefixIcon: Assets.pin,
            title: context.isArabic?'نمط الحياة':'Life Style',
            child: Column(
              children: [
                _buildInfoContent(
                  headerText:context.isArabic?'كحول': 'Drinking',
                  title: context.isArabic?'في مناسبات خاصة':'on special occasions',
                  icon: Assets.drinking,
                ),
                const Sizer(),
                _buildInfoContent(
                  headerText: context.isArabic?'التدخين':'Smoking',
                  title: context.isArabic?'مدخن':'Smoker',
                  icon: Assets.smoking,
                ),
                const Sizer(),
                _buildInfoContent(
                  headerText:context.isArabic?'تدريب': 'Workout',
                  title: context.isArabic?'احياناً':'sometimes',
                  icon: Assets.tinder_gym,
                ),
                const Sizer(),
                _buildInfoContent(
                  headerText: context.isArabic?'حيوانات أليفة':'Pets',
                  title: context.isArabic?'قطط':'Cat',
                  icon: Assets.pet,
                ),
              ],
            )),
        const Sizer(),
        _buildInfoContainer(
            prefixIcon: Assets.pin,
            title: context.isArabic?'اساسيات':'Basics',
            child: Column(
              children: [
                _buildInfoContent(
                  headerText:context.isArabic?'وسيلة التواصل': 'communication style',
                  title: context.isArabic?'رسائل نصية':'big time texter',
                  icon: Assets.chatting,
                ),
                const Sizer(),
                _buildInfoContent(
                  headerText: context.isArabic?'تعبير الحب':'love style',
                  title: context.isArabic?'الايماءات':'thoughtful gestures',
                  icon: Assets.love_style,
                ),
                const Sizer(),
                _buildInfoContent(
                  headerText: context.isArabic?'تعليم':'education',
                  title: context.isArabic?'بكالريوس':'bechelors',
                  icon: Assets.graduation,
                ),
                const Sizer(),
                _buildInfoContent(
                  headerText:context.isArabic?'برج': 'zodiac',
                  title: context.isArabic?'سرطان':'cancer',
                  icon: Assets.zodiac,
                ),
              ],
            )),
        const Sizer(),
        _buildInfoContainer(
            prefixIcon: Assets.interest,
            title: context.isArabic?'اهتمامات':'Interests',
            child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: (context.isArabic?interestsAr:interests)
                    .map(
                      (interest) => _buildInterestsBobble(title: interest),
                    )
                    .toList())),
        const Sizer(),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.h),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color:AppColors.getFindFillColor(context),
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                ...[
                  Image.asset(
                    Assets.inbox,
                    height: 35.h,
                    fit: BoxFit.cover,
                  ),
                  const Sizer(),
                ],
                  Expanded(
                      child: Label(
                        text:context.isArabic?'بادر بانطباعك الاولي':'stand out with a first impression',
                        style: Styles.headerText(
                            fontSize: 32,
                            color: AppColors.getTextColor(context),
                            fontWeight: FontWeight.w500),
                      )),
              ]),
              const Sizer(),
              Column(
                children: [
                  Label(
                    text:
                    context.isArabic?'أرسل رسالة للمساعدة في جذب الانتباه. اظهر ما جعلهم يبرزون، حمسهم، أو اجعلهم يضحكون':'Send a message before matching to help get their attention. sat what made them stand out, hype them up, or make them laugh.',
                    style: Styles.headerText(
                      fontSize: 30,
                      color: AppColors.getTextColor(context),
                    ),
                    maxLines: 5,
                  ),
                  const Sizer(),
                  FormTextField(
                    borderRadius: BorderRadius.circular(20),
                    hint: context.isArabic ? 'رسالتك' : 'Your Message',
                    style: Styles.headerText(fontSize: 28, color: AppColors.getTextColor(context)),
                    fillColor: AppColors.getFillColor(context),
                    suffix: TextButton(
                        onPressed: () {

      ManageVibration.vibrate();
                        },
                        child: Label(
                          text: LocaleKeys.send.localize,
                          style: Styles.headerText(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.getTextColor(context)),
                        )),
                    borderSide: context.isDarkMode?Colors.white:Colors.black,
                    textStyle: Styles.mediumText(color: AppColors.getTextColor(context)),
                    borderColor:context.isDarkMode?Colors.white:Colors.black,

                  )
                ],
              )
            ],
          ),
        ),
        // _buildInfoContainer(
        //     prefixIcon: Assets.inbox,
        //     title: context.isArabic?'بادر بانطباعك الاولي':'stand out with a first impression',
        //     child: Column(
        //       children: [
        //         Label(
        //           text:
        //           context.isArabic?'أرسل رسالة للمساعدة في جذب الانتباه. اظهر ما جعلهم يبرزون، حمسهم، أو اجعلهم يضحكون':'Send a message before matching to help get their attention. sat what made them stand out, hype them up, or make them laugh.',
        //           style: Styles.headerText(
        //             fontSize: 30,
        //             color: AppColors.getTextColor(context),
        //           ),
        //           maxLines: 5,
        //         ),
        //         const Sizer(),
        //         FormTextField(
        //           borderRadius: BorderRadius.circular(20),
        //           hint: context.isArabic ? 'رسالتك' : 'Your Message',
        //           style: Styles.headerText(fontSize: 28, color: AppColors.getTextColor(context)),
        //           fillColor: AppColors.getFillColor(context),
        //           suffix: TextButton(
        //               onPressed: () {},
        //               child: Label(
        //                 text: LocaleKeys.send.localize,
        //                 style: Styles.headerText(
        //                     fontSize: 32,
        //                     fontWeight: FontWeight.bold,
        //                     color: AppColors.getTextColor(context)),
        //               )),
        //           borderSide: context.isDarkMode?Colors.white:Colors.black,
        //           textStyle: Styles.mediumText(color: AppColors.getTextColor(context)),
        //           borderColor:context.isDarkMode?Colors.white:Colors.black,
        //
        //         )
        //       ],
        //     )),
        const Sizer(),
        ClickableWidget(
          child: _buildInfoContainer(
            child: Center(
              child: Label(
                text: context.isArabic
                    ? 'شارك ملف Mohamed الشخصي'
                    : 'Share Mohamed’s Profile',
                style: Styles.headerText(
                    color: AppColors.getTextColor(context), fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        const Sizer(),
        ClickableWidget(
          onTap: () => showDialogFind(
              context,
               FindDialogContent(
                topButtonTitle: context.isArabic?'نعم، حظر':'Yes, Block',
                bottomButtonTitle:context.isArabic?'لا، لا تحظر': 'No, Don’t Block',
              )),
          child: _buildInfoContainer(
            child: Center(
              child: Label(
                text: context.isArabic ? 'حظر Mohamed' : 'Block Mohamed',
                style: Styles.headerText(
                    color: AppColors.getTextColor(context), fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        const Sizer(),
        ClickableWidget(
          child: _buildInfoContainer(
            child: Center(
              child: Label(
                text:
                    context.isArabic ? 'الابلاغ عن Mohamed' : 'Report Mohamed',
                style: Styles.headerText(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const Sizer(),
      ],
    );
  }

  Widget _buildInfoContent(
      {required String icon, required String title, String? headerText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (headerText != null)
          Label(
            text: headerText,
            style: Styles.headerText(
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: AppColors.getTextColor(context),
            ),
          ),
        Container(
          decoration: const BoxDecoration(
            border: BorderDirectional(
                bottom: BorderSide(color: Color(0XFF808080), width: 1)),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            shape: const BorderDirectional(
                bottom: BorderSide(color: Color(0XFF808080), width: 1)),
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            leading:Image.asset(
              icon,
              height: 30.h,
              color: context.isDarkMode?AppColors.grey:Colors.black,
            ),
            title: Label(
              text: title,
              style: Styles.headerText(
                fontSize: 32,
                fontWeight: FontWeight.w500,
                color: AppColors.getTextColor(context),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoContainer({
    String? prefixIcon,
    String? title,
    IconData? suffixIcon,
    required Widget child,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color:AppColors.getFindFillColor(context),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            if (prefixIcon != null) ...[
              Image.asset(
                prefixIcon,
                height: 35.h,
                fit: BoxFit.cover,
                color: context.isDarkMode?null:Colors.black,
              ),
              const Sizer(),
            ],
            if (title != null)
              Expanded(
                  child: Label(
                text: title,
                style: Styles.headerText(
                    fontSize: 32,
                    color: AppColors.getTextColor(context),
                    fontWeight: FontWeight.w500),
              )),
            if (suffixIcon != null)
              Icon(
                suffixIcon,
                color:context.isDarkMode? const Color(0xFF808080):Colors.black,
              ),
          ]),
          const Sizer(),
          child
        ],
      ),
    );
  }

  getGender(BuildContext context, String comingGender) {
    if (comingGender.isNotEmpty) {
      if (comingGender == 'male') {
        return context.isArabic ? 'ذكر' : comingGender;
      }
      if (comingGender == 'female') {
        return context.isArabic ? 'أُنثى' : comingGender;
      }
    }
  }

  Widget _buildInterestsBobble({
    required String title,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 8.h),
      decoration: BoxDecoration(
        color:context.isDarkMode? const Color(0xFF404040):AppColors.DARK_GRAY_COLOR,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Label(
        text: title,
        style: Styles.headerText(color:Colors.white, fontSize: 32),
      ),
    );
  }

  // Widget _buildStats(BuildContext context) {
  //   //   final profileData = context.watch<TinderViewCubit>().state.profileUserData;
  //
  //   return Container(
  //     margin: EdgeInsets.symmetric(vertical: 10.h),
  //     padding: const EdgeInsets.all(16.0),
  //     decoration: BoxDecoration(
  //       color: AppColors.PRIMARY_COLOR,
  //       borderRadius: BorderRadius.circular(10.0),
  //       boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //       children: [
  //         _buildStatItem(LocaleKeys.user_info_followers.localize, '2000'
  //             //profileData?.followersCount.toString() ?? '0'
  //             ),
  //         _buildStatItem(LocaleKeys.user_info_following.localize, '2000'
  //             //  profileData?.followingCount.toString() ?? '0'
  //             ),
  //         _buildStatItem(LocaleKeys.user_info_friends.localize, '3003'
  //             //profileData?.friendsCount.toString() ?? '0'
  //             ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildStatItem(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          textScaler: TextScaler.noScaling,
          style: TextStyle(
            fontSize: 45.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          textScaler: TextScaler.noScaling,
          style: TextStyle(fontSize: 40.sp, color: Colors.white70),
        ),
      ],
    );
  }
}

class SwipeCardDemo extends StatefulWidget {
  const SwipeCardDemo({super.key});

  @override
  SwipeCardDemoState createState() => SwipeCardDemoState();
}

class SwipeCardDemoState extends State<SwipeCardDemo> {
  int _currentStoryIndex = 0;

  void _nextStory() {
    setState(() {
      final pictures = [
        Assets.spotlight_profile,
        Assets.personalImage,
        Assets.spotlight_profile,
        Assets.personalImage,
      ];

      // final pictures =
      //     context.read<TinderViewCubit>().state.profileUserData?.pictures ?? [];
      _currentStoryIndex = (_currentStoryIndex < pictures.length - 1)
          ? _currentStoryIndex + 1
          : pictures.length - 1;
    });
  }

  void _previousStory() {
    setState(() {
      _currentStoryIndex =
          (_currentStoryIndex > 0) ? _currentStoryIndex - 1 : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) => _handleTap(details.localPosition),
      child: _buildCard(context),
    );
  }

  void _handleTap(Offset localPosition) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool tappedLeftSide = localPosition.dx < screenWidth / 2;

    if (tappedLeftSide) {
      context.isArabic ? _nextStory() : _previousStory();
    } else {
      context.isArabic ? _previousStory() : _nextStory();
    }
  }

  Widget _buildCard(BuildContext context) {
    final pictures = [
      Assets.spotlight_profile,
      Assets.personalImage,
      Assets.spotlight_profile,
      Assets.personalImage,
    ];
    // context.watch<TinderViewCubit>().state.profileUserData?.pictures ?? [];
    final imageUrl = pictures[_currentStoryIndex];
    // pictures.isNotEmpty
    //     ? pictures.reversed.toList()[_currentStoryIndex].mediaKey
    //     : UIConst.profilePlaceHolder;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      elevation: 4,
      child: Stack(
        children: [
          Hero(
            tag: UniqueKey(),
            child: Image.asset(
              imageUrl,
              fit: BoxFit.fitHeight,
              height: double.infinity,
            ),

            /// delete the image.assets and uncomment the image.network

            // Image.network(
            //   imageUrl,
            //   width: double.infinity,
            //   errorBuilder: (context, error, stackTrace) =>
            //       Image.network(
            //     UIConst.profilePlaceHolder,
            //     fit: BoxFit.fitHeight,
            //     height: double.infinity,
            //   ),
            //   fit: BoxFit.cover,
            //   height: double.infinity,
            // ),
          ),
          Positioned.directional(
            top: 10,
            start: 10,
            end: 10,
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pictures.length,
                (dotIndex) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2.0),
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: (dotIndex == _currentStoryIndex)
                          ? Colors.white
                          : const Color(0XFF808080),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}