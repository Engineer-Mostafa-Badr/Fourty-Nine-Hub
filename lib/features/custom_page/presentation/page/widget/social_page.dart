import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/widget/custom_floating_action_button.dart';
import 'package:fourtyninehub/features/custom_page/domain/use_case/update_social_page_use_case.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_cubit.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_states.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/edit_page_cubit/edit_page_cubit.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/edit_page.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../../../../res/style/styles.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  _SocialPageState createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  int? _selectedItem;

  // Updated list with three items
  final List<String> _items = [
    LocaleKeys.face.localize,
    LocaleKeys.insta.localize,
    LocaleKeys.Tweet.localize,
  ];

  final List<String> _images = [
    Assets.facebookLogo,
    Assets.instaLogo,
    Assets.twitterLogo,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<CustomPageCubit>(
        create: (BuildContext context) => serviceLocator()..fetchSocialPage(),
        child: BlocConsumer<CustomPageCubit, CustomPageState>(
          listener: (BuildContext context, state) {
            if (state.status == CustomPageStates.success) {
              setState(() {
                if (state.social!.face == true) {
                  _selectedItem = 0; // Face
                } else if (state.social!.insta == true) {
                  _selectedItem = 1; // Insta
                } else {
                  _selectedItem = 2; // 49Tweet
                }
              });
            }
          },
          builder: (BuildContext context, state) {
            if (state.status == CustomPageStates.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == CustomPageStates.success) {
              return Column(
                children: [
                  ListTile(
                    subtitle: Text(LocaleKeys.socialDescription.localize),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Radio<int>(
                            value: index,
                            groupValue: _selectedItem,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (int? value) {
                              setState(() {
                                _selectedItem = value;
                              });
                            },
                          ),
                          title: Text(
                            _items[index],
                            style: Styles.mediumText(
                              fontSize: 65.sp,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          trailing: Image.asset(_images[index],
                              height: 50.h, width: 50.w),
                          selected: _selectedItem == index,
                          selectedTileColor: Colors.transparent,
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: Text(LocaleKeys.errorLoadingSocialPage.localize),
              );
            }
          },
        ),
      ),
      floatingActionButton: BlocProvider<CustomPageCubit>(
        create: (BuildContext context) => serviceLocator(),
        child: BlocConsumer<CustomPageCubit, CustomPageState>(
          listener: (BuildContext context, state) {
            if (state.status == CustomPageStates.success) {
              showSuccessMessage(
                  context, LocaleKeys.updateSuccessfully.localize);
              BlocProvider.of<EditPageCubit>(context).changePage(
                  BlocProvider.of<EditPageCubit>(context).currentIndex + 1);
            }
          },
          builder: (BuildContext context, Object? state) {
            return CustomFloatingActionButton(onPressed: () {
              bool face = _selectedItem == 0;
              bool insta = _selectedItem == 1;
              bool tweet = _selectedItem == 2;

              context.read<CustomPageCubit>().updateSocialPage(
                SocialPageParams(
                  face: face,
                  insta: insta,
                  tweet: tweet,
                ),
              );

              print('Selected Item: ${_items[_selectedItem!]}');
            },text: LocaleKeys.next.localize,);
            return CustomElevatedButton(
              child: Text(
                LocaleKeys.next.localize,
                style: const TextStyle(color: AppColors.whiteColor),
              ),
              onPressed: () {
                bool face = _selectedItem == 0;
                bool insta = _selectedItem == 1;
                bool tweet = _selectedItem == 2;

                context.read<CustomPageCubit>().updateSocialPage(
                      SocialPageParams(
                        face: face,
                        insta: insta,
                        tweet: tweet,
                      ),
                    );

                print('Selected Item: ${_items[_selectedItem!]}');
              },
            );
          },
        ),
      ),
    );
  }
}
