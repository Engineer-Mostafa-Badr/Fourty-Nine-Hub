import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';

import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';

class AddAboutScreen extends StatefulWidget {
  const AddAboutScreen({super.key, required this.currentBio});

  final String currentBio;

  @override
  State<AddAboutScreen> createState() => _AddAboutScreenState();
}

class _AddAboutScreenState extends State<AddAboutScreen> {
  late TextEditingController currentController;

  @override
  void initState() {
    currentController = TextEditingController(text: widget.currentBio);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> about = [
      currentController.text,
      'Available',
      'Busy',
      'At school',
      'At the movies',
      'At work',
      'Battery about to die',
      'In a meeting',
      'At the gym',
      'Sleeping',
      'Urgent calls only',
    ];
    return CustomScaffold(
      appBar: BackAppBar(label: LocaleKeys.about.localize),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(),
              const Divider(
                thickness: 1,
                color: Colors.black12,
                height: 1,
              ),
              Label(
                text: 'currently set to',
                style: Styles.mediumText(
                  color: Colors.black45,
                ),
              ),
              TextField(
                controller: currentController,
                decoration: const InputDecoration(
                  hintText: 'currently set to',
                  filled: false,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  suffixIcon: Icon(
                    Icons.edit_outlined,
                    color: AppColors.SECONDARY_COLOR,
                  ),
                ),
                onSubmitted: (value) async {
                  await context.read<UserCubit>().updateUserBio(bio: value);
                  await context.read<UserCubit>().getUser();
                  setState(() {});
                },
              ),
              const Divider(
                thickness: 1,
                color: Colors.black12,
                height: 1,
              ),
              Label(
                text: 'select about',
                style: Styles.mediumText(
                  color: Colors.black45,
                ),
              ),
              ...List.generate(
                about.length,
                (index) {
                  if ((index != 0 && currentController.text != about[index]) ||
                      index == 0) {
                    return InkWell(
                      onTap: () async {
                        currentController.text = about[index];
                        await context
                            .read<UserCubit>()
                            .updateUserBio(bio: about[index]);
                        await context.read<UserCubit>().getUser();
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Label(
                              text: about[index],
                              style: Styles.headerText(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            if (currentController.text == about[index])
                              const Icon(
                                Icons.check,
                                color: AppColors.SECONDARY_COLOR,
                              ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
