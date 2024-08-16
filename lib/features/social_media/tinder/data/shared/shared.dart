import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/gift_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_person_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/shared/tinder_shared_utils.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/gift_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';

class OutlineText extends StatelessWidget {
  final String text;
  final double strokeWidth;
  final Color strokeColor;
  final TextStyle textStyle;
  final TextScaler textScaler;

  const OutlineText({
    this.textScaler = const TextScaler.linear(1),
    super.key,
    required this.text,
    this.strokeWidth = 2.5,
    this.strokeColor = Colors.black,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Stroke text
        Text(
          text,
          style: textStyle.copyWith(
            foreground: Paint()
              ..color = strokeColor
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth,
          ),
        ),
        // Original text
        Text(
          text,
          style: textStyle,
          textScaler: textScaler,
        ),
      ],
    );
  }
}

class BottomSheetContent extends StatefulWidget {
  final String accessToken;
  final UserCubit userCubit;
  final UserData cardUser;

  const BottomSheetContent(
      {super.key,
      required this.accessToken,
      required this.userCubit,
      required this.cardUser});

  @override
  BottomSheetContentState createState() => BottomSheetContentState();
}

class BottomSheetContentState extends State<BottomSheetContent> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _fetchInitialGifts();
  }

  void _fetchInitialGifts() {
    context.read<GiftsCubit>().fetchGifts(accessToken: widget.accessToken);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<GiftsCubit>().fetchGifts(accessToken: widget.accessToken);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tinderCubit = context.watch<TinderViewCubit>();
    final userCubit = context.watch<UserCubit>();

    return BlocBuilder<GiftsCubit, GiftsState>(
      builder: (context, state) {
        if (state is GiftsInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GiftsLoaded) {
          // return GridView.builder(
          //   controller: _scrollController,
          //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 2,
          //     childAspectRatio: 1,
          //   ),
          //   itemCount: state.gifts.length + 1,
          //   // Add one for the loading indicator
          //   itemBuilder: (context, index) {
          //     if (index < state.gifts.length) {
          //       final gift = state.gifts[index];
          //       return Card(
          //         child: Center(child: Text(gift.nameEn ?? '')),
          //       );
          //     } else {
          //       // Loading indicator at the bottom
          //       return const Center(child: CircularProgressIndicator());
          //     }
          //   },
          // );
          return GridView.builder(
            controller: _scrollController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 3 / 4,
            ),
            itemCount: state.gifts.length + 1,
            shrinkWrap: true,
            // Add one for the loading indicator
            itemBuilder: (context, index) {
              if (index < state.gifts.length) {
                return _buildGiftItem(context, state.gifts[index],
                    tinderCubit: tinderCubit, userCubit: userCubit);
              } else {
                // Loading indicator at the bottom
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
        } else if (state is GiftsError) {
          return Center(child: Text(state.message));
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildGiftItem(BuildContext context, GiftData gift,
      {required UserCubit userCubit, required TinderViewCubit tinderCubit}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FittedBox(
        child: InkWell(
          onTap: () => _handleGiftTap(context, gift,
              userCubit: userCubit, tinderCubit: tinderCubit),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildGiftImage(gift),
              const SizedBox(height: 8),
              Text(
                gift.nameEn ?? 'No Name',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                '${gift.value ?? 0} 💰',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGiftImage(GiftData gift) {
    // const String svgUrl =
    //     'https://49hub-reels.s3.eu-central-1.amazonaws.com/gifts/Sail%20Away.svg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAZI2LDRJFLQMKAMUH%2F20240811%2Feu-central-1%2Fs3%2Faws4_request&X-Amz-Date=20240811T192725Z&X-Amz-Expires=3600&X-Amz-Signature=2e2b255cec93eb38bdd7521d8bb44dce238e611919b41810f2677dacdab755d6&X-Amz-SignedHeaders=host&x-id=GetObject';

    return SvgPicture.network(
      gift.picture!,
      fit: BoxFit.scaleDown,
      placeholderBuilder: (BuildContext context) => Image.asset(
        'assets/images/icon.png',
        width: 50,
        height: 50,
      ),
      width: 50,
      height: 50,
    );
    // : Image.asset(
    //     'assets/images/icon.png',
    //     width: 50,
    //     height: 50,
    //   );

    //   Image.network(
    //   gift.picture,
    //   loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
    //     if (loadingProgress == null) {
    //       return child;
    //     } else {
    //       return Center(
    //         child: CircularProgressIndicator(
    //           value: loadingProgress.expectedTotalBytes != null
    //               ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
    //               : null,
    //         ),
    //       );
    //     }
    //   },
    //   errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
    //     return Center(child: Text('Failed to load image'));
    //   },
    // );
    // //------------------------------
    //   gift.picture != null
    //       ? Image.network(
    //           gift.picture!,
    //           width: 50,
    //           height: 50,
    //           loadingBuilder: (context, child, loadingProgress) =>
    //               Image.asset(
    //             'assets/images/icon.png',
    //             width: 50,
    //             height: 50,
    //           ),
    //           errorBuilder: (context, error, stackTrace) => Image.asset(
    //             'assets/images/icon.png',
    //             width: 50,
    //             height: 50,
    //           ),
    //         )
    //       : Image.asset(
    //           'assets/images/icon.png',
    //           width: 50,
    //           height: 50,
    //         );
  }

  Future<void> _handleGiftTap(BuildContext context, GiftData gift,
      {required UserCubit userCubit,
      required TinderViewCubit tinderCubit}) async {
    final data = await context.read<TinderViewCubit>().sendGift(
          receiverId: widget.cardUser.id!,
          subCategoryId: '66af974f8bf69f9469944746',
          giftId: gift.sId ?? '',
          // currentUserToken: TinderSharedUtils.token,
          accessToken: userCubit.state.token!.accessToken,
        );

    TinderSharedUtils.handleGiftResponse(
        context: context, response: data!, gift: gift);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
