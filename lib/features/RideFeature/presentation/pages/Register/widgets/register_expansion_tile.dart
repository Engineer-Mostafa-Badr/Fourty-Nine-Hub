import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_empty_widget.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class RegisterExpansionTile extends StatefulWidget {
  const RegisterExpansionTile({
    super.key,
    required this.title,
    required this.children,
    required this.length,
    this.onChange,
    this.onSelect,
    this.emptyText,
    this.initialTitle,
  });

  final Widget title;
  final String? emptyText;
  final List<Widget> children;
  final int length;
  final ValueChanged<Widget>? onChange;
  final Function(int id)? onSelect;
  final Widget? initialTitle; // Add initialTitle property

  @override
  State<RegisterExpansionTile> createState() => _RegisterExpansionTileState();
}

class _RegisterExpansionTileState extends State<RegisterExpansionTile> {
  var controller = ExpansibleController();
  late Widget selectedTitle;

  @override
  void initState() {
    super.initState();
    selectedTitle = widget.initialTitle ?? widget.title;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color:
            context.isDarkMode ? AppColors.GREY_DARK_COLOR : AppColors.GREYBG,
      ),
      child: ExpansionTile(
        controller: controller,
        title: selectedTitle, // Use state variable
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor:
            context.isDarkMode ? AppColors.GREY_DARK_COLOR : AppColors.GREYBG,
        expandedAlignment: Alignment.centerLeft,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        dense: true,
        children: [
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            width: double.infinity,
            height: 10,
          ),
          Container(
            constraints: const BoxConstraints(maxHeight: 250),
            child: widget.children.isNotEmpty
                ? ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: List.generate(
                      widget.children.length,
                      (index) => InkWell(
                        onTap: () {
                          ManageVibration.vibrate();
                          if (widget.children.isNotEmpty) {
                            setState(() {
                              selectedTitle =
                                  widget.children[index]; // Update state
                              controller.collapse();
                            });

                            if (widget.onChange != null) {
                              widget.onChange!(
                                  widget.children[index]); // Notify parent
                              if (widget.onSelect != null) {
                                widget.onSelect!(index);
                              }
                            }
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          width: double.infinity,
                          height: 30,
                          child: widget.children[index],
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: CustomEmptyWidget(
                        label: widget.emptyText ??
                            (context.isArabic
                                ? 'لا يوجد نتائج'
                                : 'No results found')),
                  ),
          ),
        ],
      ),
    );
  }
}
