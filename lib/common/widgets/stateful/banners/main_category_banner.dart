import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class MainCategoryBanner extends StatefulWidget {
  final MainCategoryEntity category;
  final bool canRegister;
  final Function()? onRegister;
  final bool? Function()? onFavorite;
  const MainCategoryBanner(
      {super.key,
      this.canRegister = false,
      this.onRegister,
      this.onFavorite,
      required this.category});

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
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.transparent,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(widget.category.banner),
          )),
      child: Row(
        children: [
          _buildRegisterButton(),
          widget.canRegister ? const Spacer() : const SizedBox.shrink(),
          Label(
            text: widget.category.name,
            style: Styles.headerText(color: Colors.white),
          ),
          const Spacer(),
          Column(
            children: [
              InkWell(
                onTap: () {
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
              const Sizer(
                height: 20,
              ),
              Label(
                text: '${widget.category.total.toShortScale} ${Labels.ads}',
                style: Styles.mediumText(color: Colors.white),
              )
            ],
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
