import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/add_main_category_to_favorites_usecase.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/remove_main_category_to_favorites_usecase.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class MainCategoryBanner extends StatefulWidget {
  final MainCategoryEntity category;
  final bool canRegister;
  final Function()? onRegister;
  final Color? color;
  const MainCategoryBanner(
      {super.key,
      this.canRegister = false,
      this.onRegister,
      required this.category,
        this.color=Colors.white,
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
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(widget.category.banner),
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.black.withOpacity(0.5), // Darken the background
            ),
          ),
          Row(
            children: [
              _buildRegisterButton(),
              widget.canRegister ? const Spacer() : const SizedBox.shrink(),
              Label(
                text: widget.category.name,
                style: Styles.headerText(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: widget.color,
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  InkWell(
                    onTap: () async {
                      if (_isFavorite) {
                        final result = await serviceLocator<
                            RemoveMainCategoryFromFavoritesUseCase>()
                            .call(widget.category.id);
                        result.fold(
                              (l) => showErrorMessage(context, "Can't remove from favorite"),
                              (r) {
                            setState(() {
                              _isFavorite = false;
                            });
                          },
                        );
                      } else {
                        final result = await serviceLocator<
                            AddMainCategoryToFavoritesUseCase>()
                            .call(widget.category.id);
                        result.fold(
                              (l) => showErrorMessage(context, "Can't add to favorite"),
                              (r) {
                            setState(() {
                              _isFavorite = true;
                            });
                          },
                        );
                      }
                    },
                    child: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: AppColors.SECONDARY_COLOR,
                    ),
                  ),
                  const Sizer(height: 20),
                  Label(
                    text: '${widget.category.total.toShortScale} ${Labels.ads}',
                    style: Styles.mediumText(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: widget.color,
                    ),
                  )
                ],
              ),
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
