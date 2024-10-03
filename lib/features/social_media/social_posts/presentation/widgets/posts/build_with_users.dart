import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_user_entity.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class BuildWithUsers extends StatelessWidget {
  const BuildWithUsers({super.key, required this.users});
  final List<TwitterUserEntity> users;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BackAppBar(
          label: LocaleKeys.withUsers.localize,
        ),
        body: ListView(
          children: List.generate(
            users.length,
            (index) => GestureDetector(
              onTap: () {
                context.push(Routes.OTHERSACCOUNT, extra: users[index].id);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(users[index].image ?? ''),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Label(
                      text:
                          '${users[index].firstName} ${users[index].lastName}',
                      style: Styles.headerText(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
