import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../domain/entities/feeling_entity.dart';

class SelectFeelingView extends StatelessWidget {
  final List<FeelingEntity> feelings;
  final Function(FeelingEntity) onSelected;

  const SelectFeelingView(
      {super.key, required this.feelings, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: BackAppBar(
        label: LocaleKeys.selectFeeling.localize,
      ),
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 4),
          itemCount: feelings.length,
          itemBuilder: (context, index) {
            final item = feelings[index];
            return InkWell(
              onTap: () {
                onSelected(item);
                Navigator.pop(context, item);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: .5)),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(item.image),
                    ),
                    const Sizer(),
                    Expanded(child: Label(text: item.name))
                  ],
                ),
              ),
            );
          }),
    );
  }
}
