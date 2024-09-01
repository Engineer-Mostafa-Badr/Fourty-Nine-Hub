import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';

import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';
import 'photo_post_content.dart';
import 'photo_text_post_content.dart';
import 'reel_post_content.dart';
import 'text_post_content.dart';

class ShowPostCompanyAdvertise extends StatefulWidget {
  const ShowPostCompanyAdvertise({super.key});

  @override
  _ShowPostCompanyAdvertiseState createState() => _ShowPostCompanyAdvertiseState();
}

class _ShowPostCompanyAdvertiseState extends State<ShowPostCompanyAdvertise> {
  String _selectedType = 'Text Post'; // Default selected type

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        centerTitle: false,
        label: 'My Posts',
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            height: kToolbarHeight * 1,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                listItem(
                  label: 'Text Post',
                  type: 'Text Post',
                ),
                listItem(
                  label: 'Photo Post',
                  type: 'Photo Post',
                ),
                listItem(
                  label: 'Photo And Text Post',
                  type: 'Photo And Text Post',
                ),
                listItem(
                  label: 'Reels Post',
                  type: 'Reels Post',
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildContentWidget(_selectedType),
          ),
        ],
      ),
    );
  }

  Widget _buildContentWidget(String type) {
    switch (type) {
      case 'Text Post':
        return const TextPostContent();
      case 'Photo Post':
        return const PhotoPostContent();
      case 'Photo And Text Post':
        return const PhotoAndTextPostContent();
      case 'Reels Post':
        return const ReelsPostContent();
      default:
        return const Center(child: Text('Unknown Type'));
    }
  }

  Widget listItem({
    required String label,
    required String type,
  }) {
    bool selected = _selectedType == type;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5,horizontal:10),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: selected
              ? AppColors.PRIMARY_COLOR
              : AppColors.LIGHT_GRAY_COLOR,
        ),
        child: Row(
          children: [
            Label(
              text: label,
              style: Styles.mediumText(
                color: selected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
