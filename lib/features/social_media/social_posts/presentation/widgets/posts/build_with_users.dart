import 'package:flutter/material.dart';
import '../../../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../core/extensions/string_extension.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../twitter/domain/entities/twitter_user_entity.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/widget/custom_scaffold.dart';

class BuildWithUsers extends StatelessWidget {
  const BuildWithUsers({super.key, required this.users});
  final List<TwitterUserEntity> users;
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: BackAppBar(
            label: LocaleKeys.withUsers.localize,
          ),
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
