import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/facebook_reels.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/normal_post_screen.dart';
import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_user_model.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class ProfilePosts extends StatelessWidget {
  const ProfilePosts({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> names = [
      "Omar Khaled",
      "Mona Hassan",
      "Ahmed Youssef",
      "Nour Ali",
      "Sara Tarek",
      "Mohamed Adel",
      "Laila Mostafa",
      "Khaled Ibrahim",
      "Nada Hossam",
      "Yara Mahmoud",
      "Mostafa Ayman",
      "Salma Sherif",
      "Hany Fathi",
      "Dina Magdy",
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ProfileDetails(),
        ),
        const Sizer(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 300.h,
              child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) =>
                  index == 0
                      ? _newHighlights(context)
                      : _highlights(context),
                  separatorBuilder: (context, index) =>
                  const Sizer(
                    width: 12,
                  ),
                  itemCount: 5),
            ),
            const Sizer(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(
                      text: LocaleKeys.friends.localize,
                      style: Styles.headerText(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Sizer(
                      height: 6,
                    ),
                    Label(
                      text:
                      '${1393} ${context.isArabic
                          ? LocaleKeys.friend.localize
                          : LocaleKeys.friends.localize}'
                          .toArabicNumbers(context),
                      style: Styles.mediumText(
                        color: context.isDarkMode
                            ? Colors.grey[300]
                            : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                ClickableWidget(
                  child: Label(
                    text: context.isArabic ? 'ابحث عن أصدقاء' : 'Find Friends',
                    style: Styles.mediumText(color: Color(0xffFF3308)),
                  ),
                ),
              ],
            ),
            const Sizer(
              height: 20,
            ),
            GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 6,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 1.0, // spacing between rows
                  crossAxisSpacing: 5.0, // spacing between columns
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) =>
                    _friendsTile(context, name: names[index])),
            const Sizer(
              height: 20,
            ),
            AppButton(
              label: context.isArabic ? 'عرض كل الأصدقاء' : 'See all friends',
              onPressed: () {},
              width: double.infinity,
              backColor: AppColors.getFindFillColor(context),
              color: AppColors.getTextColor(context),
              radius: 5,
              style: Styles.mediumText(fontWeight: FontWeight.bold),
            ),
            const Sizer(
              height: 50,
            ),
            Label(
              text: LocaleKeys.posts.localize,
              style: Styles.headerText(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Sizer(),
            Row(
              children: [
                CircleAvatar(
                  radius: 40.w,
                  backgroundColor:
                  Theme
                      .of(context)
                      .scaffoldBackgroundColor,
                  child: ImageFromInternet(
                    image:
                    //user.profilePicture ??
                    UIConst.profilePlaceHolder,
                    height: 250.h,
                    width: 300.w,
                    isCircle: true,
                  ),
                ),
                Sizer(),
                Expanded(
                  child: ClickableWidget(
                    onTap: (){context.push(Routes.CREATEPOST, extra: 'facebook');},
                    child: Label(text: context.isArabic?'بماذا تفكر؟': "What's on your mind?",style: Styles.headerText(
                      fontSize: 32,color: context.isDarkMode
                        ? Colors.grey[300]
                        : Colors.grey[700],
                    ), ),
                  ),
                ),
                ClickableWidget(onTap:(){},child: Icon(Icons.videocam,color: AppColors.getTextColor(context),))
              ],
            ),
            const Sizer(
              height: 40,
            ),
          ]),
        ),
        Divider(
          thickness: 6,
          color: AppColors.getFindFillColor(context),
        ),
        const Sizer(),
        ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(0),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
             // final user = context.read<UserCubit>().state.data;
              var posts =[PostEntity(id: "6824c83c5d72a038c1783ae1",
                type: "normal_post",
                user: TwitterUserModel(
                  id: "67ca35d096ca3293cc27deae",
                  firstName: "Mohamed",
                  lastName: "salama",
                  createdAt:DateTime.now() ,
                  hasStory: false, email: '@dsda', isDocumented: false,
                ),
                likesCount: 0,
                commentsCount: 0,
                loveCount: 0,
                sadCount: 0,
                wowCount: 0,
                angryCount: 0,
                images:[UIConst.socialImagePlaceHolder,UIConst.socialImagePlaceHolder] ,
                content: 'Lorem ipsum dolor sit amet consectetur. Ac diam curabitur accumsan commodo a et sit neque nullam. Fermentum at viverra '
              )] ;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(0),
                    physics:
                    const NeverScrollableScrollPhysics(),
                    itemCount:
                    posts.length ,
                    itemBuilder: (context, i) {
                      return NormalPostScreen(
                        postEntity: posts[0],
                      );
                    },
                  ),
                  // if (post.reels?.isNotEmpty ?? false)
                  //   FacebookReels(
                  //     reels: post.reels ?? [],
                  //   ),
                ],
              );
            }),

      ],
    );
  }
  Widget _newHighlights(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 180.w,
          height: 260.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey,
            ),
            color: Colors.transparent,
          ),
          child: Center(
            child: Icon(
              Icons.add,
              color: Colors.grey,
            ),
          ),
        ),
        Label(text: context.isArabic ? 'جديد' : 'New')
      ],
    );
  }

  Widget _highlights(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            width: 180.w,
            height: 260.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.transparent,
            ),
            child: ImageFromInternet(
              image: UIConst.socialImagePlaceHolder,
              fit: BoxFit.cover,
              width: double.infinity,
              borderRadius: BorderRadius.circular(10),
            )),
        Label(
          text: 'My Highlights',
          maxLines: 2,
        )
      ],
    );
  }

  Widget _friendsTile(BuildContext context, {required String name}) {
    return ClickableWidget(
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.ltr,
        children: [
          AspectRatio(
            aspectRatio: 4 / 5,
            child: Container(
              // width: 230.w,
              // height: 260.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent,
                ),
                child: ImageFromInternet(
                  image: UIConst.socialImagePlaceHolder,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(10),
                )),
          ),
          const Sizer(
            height: 8,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0.h),
            child: Label(
              text: name,
              style: Styles.mediumText(fontWeight: FontWeight.bold),
              maxLines: 2,
            ),
          )
        ],
      ),
    );
  }
}

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          text: LocaleKeys.details.localize,
          style:
          Styles.headerText(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const Sizer(),
        _detailsTile(
            context,
            context.isArabic
                ? 'مصور & مصمم جرافيكس'
                : 'Photographer & videographer',
            Icons.work_outlined),
        const Sizer(),
        _detailsTile(
            context,
            context.isArabic ? 'نيويورك، الولايات المتحدة' : 'NewYork, USA',
            Icons.home_rounded,
            label: context.isArabic ? 'أعيش في ' : 'Lives in'),
        const Sizer(),
        _detailsTile(
            context,
            context.isArabic ? 'بيهانس' : 'behance/rachelpodrez',
            Icons.link),
        const Sizer(),
        _detailsTile(context, 'Mohamed Magdy', Icons.info_rounded,
            label: context.isArabic
                ? 'مزيد من المعلومات عن'
                : 'More info about'),
      ],
    );
  }

  Widget _detailsTile(BuildContext context, String data, IconData icon,
      {String? label}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 24,
          color: context.isDarkMode ? Colors.white : Colors.grey,
        ),
        Sizer(
          width: 18.w,
        ),
        if (label != null)
          Label(
              text: label,
              style: Styles.headerText(color: Colors.grey, fontSize: 30)),
        if (label != null)
          Sizer(
            width: 12.h,
          ),
        Expanded(
          child: Label(
            text: data,
            style: Styles.headerText(fontSize: 30),
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}

