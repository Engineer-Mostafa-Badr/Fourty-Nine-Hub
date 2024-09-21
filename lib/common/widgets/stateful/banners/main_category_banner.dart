import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

class MainCategoryBanner extends StatefulWidget {
  final MainCategoryEntity category;
  final bool canRegister;
  final Function()? onRegister;
  final bool? Function()? onFavorite;
  const MainCategoryBanner({
    super.key,
    this.canRegister = false,
    // this.favoriteName,
    this.onRegister,
    required this.category,
    required this.onFavorite,
  });

  @override
  State<MainCategoryBanner> createState() => _MainCategoryBannerState();
}

class _MainCategoryBannerState extends State<MainCategoryBanner> {
  bool isFavorite = false;

  @override
  void initState() {
    isFavorite = widget.category.isFavorite ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.08,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.transparent,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: CachedNetworkImageProvider(
            widget.category.banner,
          ),
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3),
            BlendMode.darken,
          ),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          PositionedDirectional(end: 0, child: _buildRegisterButton()),
          Label(
            text: widget.category.name,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 45.zSP),
          ),
          PositionedDirectional(
            start: 0,
            child: Column(
              children: [
                if (context.read<UserCubit>().isLoggedIn)
                  InkWell(
                    onTap: () async {
                      final result = widget.onFavorite?.call();
                      if (result != null && result != isFavorite) {
                        setState(() {
                          isFavorite = result;
                        });
                      }
                    },
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: AppColors.SECONDARY_COLOR,
                    ),
                  ),
                Sizer(
                  height: 15.zH,
                ),
                Label(
                  text:
                      '${widget.category.total.toShortScale} ${widget.category.favoriteName ?? Labels.ads}',
                  style: Styles.mediumText(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton() {
    if (widget.canRegister) {
      return InkWell(
        onTap: () => widget.onRegister?.call(),
        child: Text(Labels.register,
            style: Styles.mediumText(
                color: Colors.white, fontWeight: FontWeight.bold)),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
