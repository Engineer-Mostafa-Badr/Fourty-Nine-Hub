import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:shimmer/shimmer.dart';

class MainCategoryBanner extends StatefulWidget {
  final MainCategoryEntity category;
  final bool canRegister;
  final Function()? onRegister;
  final bool? Function()? onFavorite;
  final Color? color;

  const MainCategoryBanner({
    super.key,
    this.canRegister = false,
    this.onRegister,
    required this.category,
    this.color = Colors.white,
    this.onFavorite,
  });

  @override
  State<MainCategoryBanner> createState() => _MainCategoryBannerState();
}

class _MainCategoryBannerState extends State<MainCategoryBanner> {
  late bool _isFavorite;

  @override
  void initState() {
    _isFavorite = widget.category.isFavorite;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.transparent,
      ),
      child: Stack(
        children: [
          Positioned.fill(
              child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: CachedNetworkImage(
              imageUrl: widget.category.banner,
              fit: BoxFit.fill,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  color: Colors.white,
                ),
              ),
              errorWidget: (context, url, error) {
                debugPrint(
                    'error while displaying images in the url $url ${error.toString()}');
                return const Icon(Icons.error, color: Colors.red);
              },
            ),
          )),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .09,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.black38,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                _buildRegisterButton(),
                widget.canRegister ? const Spacer() : const SizedBox.shrink(),
                Label(
                  text: widget.category.name,
                  style:
                      Styles.headerText(color: AppColors.AUTH_CONTAINER_COLOR),
                ),
                const Spacer(),
                Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        final result = widget.onFavorite?.call();
                        if (result != null && result != _isFavorite) {
                          setState(() {
                            _isFavorite = result;
                          });
                        }
                      },
                      child: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: AppColors.SECONDARY_COLOR,
                      ),
                    ),
                    const Sizer(height: 20),
                    Label(
                      text: '${widget.category.total.toShortScale} ${LocaleKeys.ads.localize}',
                      style: Styles.mediumText(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.AUTH_CONTAINER_COLOR),
                    )
                  ],
                ),
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
            style: Styles.mediumText(color: Colors.white)),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
