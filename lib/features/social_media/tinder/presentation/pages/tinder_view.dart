import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_person_model.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/stateless/dynamic/shared_scaffold.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../cubit/tinder_cubit.dart';
import '../cubit/tinder_state.dart';

class TinderView extends StatelessWidget {
  const TinderView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TinderViewCubit()
        ..fetchUserData()
        ..fetchSubCategoryData(),
      child: BlocBuilder<TinderViewCubit, TinderViewState>(
        builder: (context, state) {
          return SharedScaffold(
            body: state.userData.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Label(
                                  text: 'Find',
                                  style: Styles.headerText(),
                                ),
                              ),
                            ),
                            const Divider(),
                            SizedBox(
                              height: 160,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: state.subCategoryData.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      clipBehavior: Clip.hardEdge,
                                      color: Colors.transparent,
                                      child: FittedBox(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(state
                                                      .subCategoryData[index]
                                                      .picture
                                                      .toString()))),
                                          width: 160,
                                          height: 160,
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              width: double.infinity,
                                              color: Colors.white54,
                                              child: Text(
                                                '${state.subCategoryData[index].nameEn}',
                                                textAlign: TextAlign.center,
                                                textScaler:
                                                    const TextScaler.linear(
                                                        1.2),
                                                style: Styles.headerText(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const Divider(),
                            SizedBox(
                              height: MediaQuery.of(context).size.height -
                                  kToolbarHeight -
                                  150,
                              child: Stack(
                                children:
                                    state.userData.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  UserData user = entry.value;
                                  return _buildCard(
                                      context, index, user.pictures, user);
                                }).toList(),
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            )
                          ],
                        ),
                      ),
                      PositionedDirectional(
                        bottom: 10,
                        end: 10,
                        child: FloatingActionButton(
                          backgroundColor: Colors.red,
                          onPressed: () {},
                          shape: const CircleBorder(),
                          child: const Icon(
                            Icons.add_photo_alternate_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
            mainCategoryId: 2,
          );
        },
      ),
    );
  }

  Widget _buildCard(
      BuildContext context, int index, List<String> images, UserData user) {
    final cubit = context.read<TinderViewCubit>();
    final state = cubit.state;
    bool isFrontCard = index == state.currentIndex;

    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      bottom: 0,
      child: isFrontCard
          ? GestureDetector(
              onPanStart: (details) {
                cubit.updatePanStart(details.globalPosition);
              },
              onPanUpdate: (details) {
                final position = details.globalPosition - state.startDragOffset;
                final rotation = position.dx /
                    (position.dy > state.startDragOffset.dy - 180 ? 500 : -500);
                cubit.updatePanUpdate(position, rotation);
              },
              onPanEnd: (details) {
                if (state.position.dx > 250 ||
                    state.position.dx < -250 ||
                    state.position.dy > 250 ||
                    state.position.dy < -250) {
                  cubit.swipeAway();
                } else {
                  cubit.resetPan();
                }
              },
              onTapUp: (details) {
                double tapPosition = details.localPosition.dx;
                double screenWidth = MediaQuery.of(context).size.width;

                if (tapPosition < screenWidth / 2) {
                  cubit.previousStory();
                } else {
                  cubit.nextStory();
                }
              },
              child: Transform.translate(
                offset: state.position,
                child: Transform.rotate(
                  angle: state.rotation,
                  child:
                      _cardWidget(context, images: user.pictures, user: user),
                ),
              ),
            )
          : const Offstage(),
    );
  }

  Widget _cardWidget(
    BuildContext context, {
    required List<String> images,
    required UserData user,
  }) {
    final state = context.read<TinderViewCubit>().state;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        clipBehavior: Clip.hardEdge,
        elevation: 4,
        child: Stack(
          children: [
            Hero(
              tag: 'userHero-${user.id}', // Ensure each hero tag is unique

              child: Image.network(
                (images.isNotEmpty)
                    ? images[state.currentStoryIndex]
                    : UIConst.profilePlaceHolder,
                errorBuilder: (context, error, stackTrace) => Image.network(
                  UIConst.profilePlaceHolder,
                  fit: BoxFit.fitHeight,
                  height: double.infinity,
                ),
                fit: BoxFit.fitHeight,
                height: double.infinity,
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (dotIndex) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2.0),
                      height: 4,
                      decoration: BoxDecoration(
                        color: (dotIndex == state.currentStoryIndex)
                            ? Colors.red
                            : Colors.white54,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Positioned(
              bottom: kToolbarHeight * 1.2,
              right: 20,
              left: 20,
              child: _buildPersonInfo(context: context, user: user),
            ),
            Positioned(
              bottom: 8,
              right: 10,
              left: 10,
              child: _buildActions(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonInfo(
      {required BuildContext context, required UserData user}) {
    return InkWell(
      onTap: () => context.push(Routes.OTHERSACCOUNT),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BadgedLabel(
                  color: AppColors.SECONDARY_COLOR,
                  label: 'Nearby',
                ),
                Label(
                  text:
                      "${user.user.first.firstName} ${user.user.first.lastName}",
                  style: Styles.headerText(color: Colors.white, fontSize: 26),
                ),
                Row(
                  children: [
                    Icon(
                      user.user.first.gender == 'male'
                          ? Icons.male
                          : Icons.female,
                      color: Colors.white,
                    ),
                    const Sizer(),
                    Label(
                      text: user.user.first.birthday ?? '',
                      style: Styles.mediumText(color: Colors.white),
                    ),
                  ],
                )
              ],
            ),
          ),
          const Icon(
            Icons.arrow_upward_rounded,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildFloatingActionButton(context, Icons.person, null),
        _buildFloatingActionButton(context, Icons.chat, null,
            color: Colors.red),
        _buildFloatingActionButton(context, Icons.card_giftcard, () {},
            color: AppColors.ACCENT_COLOR),
        _buildFloatingActionButton(context, Icons.report, () {
          showModalBottomSheet(
            context: context,
            builder: (context) => SizedBox(
              height: MediaQuery.of(context).size.height / 1.5,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: ReportView(id: '2'),
              ),
            ),
          );
        }, color: AppColors.PRIMARY_COLOR),
      ],
    );
  }

  Widget _buildFloatingActionButton(
      BuildContext context, IconData icon, VoidCallback? onPressed,
      {Color? color}) {
    return FloatingActionButton.small(
      onPressed: onPressed,
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      child: Icon(
        icon,
        color: color != null ? Colors.white : null,
      ),
    );
  }
}
//rommana1