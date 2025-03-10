import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class RegisterExpansionTile extends StatefulWidget {
  RegisterExpansionTile(
      {super.key, required this.title, required this.children, this.onChange});

  late Widget title;
  final List<Widget> children;
  final ValueChanged<Widget>? onChange;

  @override
  State<RegisterExpansionTile> createState() => _RegisterExpansionTileState();
}

class _RegisterExpansionTileState extends State<RegisterExpansionTile> {
  var controller = ExpansionTileController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.GREYBG,
      ),
      child: ExpansionTile(
        controller: controller,
        title: widget.title,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.GREYBG,
        expandedAlignment: Alignment.centerLeft,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            width: double.infinity,
            height: 10,
          ),
          Container(
            constraints: const BoxConstraints(
              maxHeight: 300,
              minHeight: 40
            ),
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: List.generate(
                widget.children.length,
                    (index) => InkWell(
                  onTap: () {
                    setState(() {
                      widget.title = widget.children[index];
                      controller.collapse();
                    });

                    if (widget.onChange != null) {
                      widget.onChange!(widget.children[index]); // Notify parent
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
          )
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Column(
          //     spacing: 8,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: List.generate(
          //       widget.children.length,
          //       (index) => InkWell(
          //         onTap: () {
          //           setState(() {
          //             widget.title = widget.children[index];
          //             controller.collapse();
          //           });
          //
          //           if (widget.onChange != null) {
          //             widget.onChange!(widget.children[index]); // Notify parent
          //           }
          //         },
          //         child: SizedBox(
          //           width: double.infinity,
          //           height: 30,
          //           child: widget.children[index],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
