import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class RegisterExpansionTile extends StatefulWidget {
  const RegisterExpansionTile({
    super.key,
    required this.title,
    required this.children,
    required this.length,
    this.onChange,
  });

  final Widget title;
  final List<Widget> children;
  final int length;
  final ValueChanged<Widget>? onChange;

  @override
  State<RegisterExpansionTile> createState() => _RegisterExpansionTileState();
}

class _RegisterExpansionTileState extends State<RegisterExpansionTile> {
  var controller = ExpansionTileController();
  late Widget selectedTitle;

  @override
  void initState() {
    super.initState();
    selectedTitle = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.GREYBG,
      ),
      child: ExpansionTile(
        controller: controller,
        title: selectedTitle, // Use state variable
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.GREYBG,
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
            constraints: const BoxConstraints(
              maxHeight: 250,
              minHeight: 40,
            ),
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: List.generate(
                widget.children.length,
                    (index) => InkWell(
                  onTap: () {
                    if (widget.children.isNotEmpty) {
                      setState(() {
                        selectedTitle = widget.children[index]; // Update state
                        controller.collapse();
                      });

                      if (widget.onChange != null) {
                        widget.onChange!(widget.children[index]); // Notify parent
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
            ),
          ),
        ],
      ),
    );
  }
}
