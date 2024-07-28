import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/bloc/twitter_bloc.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/build_meta_verified.dart';
import 'package:fourtyninehub/res/assets/assets.dart';

class BuildTwitterDocumentCard extends StatefulWidget {
  const BuildTwitterDocumentCard({super.key});

  @override
  State<BuildTwitterDocumentCard> createState() =>
      _BuildTwitterDocumentCardState();
}

class _BuildTwitterDocumentCardState extends State<BuildTwitterDocumentCard> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TwitterCubit, TwitterState>(listener: (context, state) {
      if (state.status == StateStatus.error) {
        showErrorMessage(
          context,
          getFailureMessage(
            state.failure ?? const UnknownFailure(),
            context,
          ),
        );
      }
    }, builder: (context, state) {
      final controller = context.read<TwitterCubit>();
      return InkWell(
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          bottomSheet(
            context: context,
            isScrollControlled: true,
            widget: const BuildMetaVerified(),
          );
        },
        child: Container(
          height: 120,
          width: double.infinity,
          margin: const EdgeInsets.all(10),
          // color: Colors.orange,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                Assets.metaVerified,
              ),
              fit: BoxFit.fill,
            ),
          ),
        ),
      );
    });
  }
}
