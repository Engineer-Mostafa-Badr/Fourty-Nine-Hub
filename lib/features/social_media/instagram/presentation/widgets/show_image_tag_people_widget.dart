import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../cubit/create_post_instagram_cubit/create_post_instagram_cubit.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/styles.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class ShowImageTagPeopleWidget extends StatefulWidget {
  const ShowImageTagPeopleWidget({
    super.key,
    required this.onTap,
  });

  final void Function() onTap;

  @override
  State<ShowImageTagPeopleWidget> createState() =>
      _ShowImageTagPeopleWidgetState();
}

class _ShowImageTagPeopleWidgetState extends State<ShowImageTagPeopleWidget> {
  late final List<AssetEntity> images;

  @override
  void initState() {
    images = context.read<CreatePostInstagramCubit>().state.selectedGalleryPost;
    super.initState();
  }

  final List<Offset> _tapPositions = [];

  /// تقوم باستقبال موقع الضغط
  void _handleTapDown(TapDownDetails details) {
    setState(() {
      /// قمت بإضافة هذا السطر لأقوم بمسح كل مواقع الضغط السابقة لأنني
      /// اريد علامة ضغط واحدة فقط وكسلت بأن اقوم بتعديل الملف كله 😂
      _tapPositions.clear();

      _tapPositions.add(details.localPosition);
    });
  }

  /// تقوم بانشاء ويدجت ويعطيه مكان ظهوره
  Widget _buildTapIndicator(Offset position) {
    return Positioned(
      left: position.dx - 40,
      top: position.dy - 10,
      child: _buildCustomIndicator(),
    );
  }

  /// الويدجت التي ستظهر عندما يتم الضغط على الصورة
  Widget _buildCustomIndicator() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          context.isDarkMode
              ? Assets.instagramTriangleBlackIconDark
              : Assets.instagramTriangleBlackIcon,
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: ShapeDecoration(
            color: context.isDarkMode
                ? const Color(0xFFE5E5E5)
                : const Color(0xFF1A1A1A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Label(
            text: LocaleKeys.whoIsThis.localize,
            style: Styles.mediumText(
                color: context.isDarkMode
                    ? const Color(0xFF0D0D0D)
                    : Colors.white),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            GestureDetector(
              onTapDown: (TapDownDetails details) {
                _handleTapDown(details);
                widget.onTap();
              },
              child: AssetEntityImage(
                images[index],
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              ),
              // child: Image.file(
              //   images[index],
              //   fit: BoxFit.contain,
              //   width: double.infinity,
              //   height: double.infinity,
              // ),
            ),
            ..._tapPositions.map((position) => _buildTapIndicator(position)),
          ],
        );
      },
    );
  }
}
