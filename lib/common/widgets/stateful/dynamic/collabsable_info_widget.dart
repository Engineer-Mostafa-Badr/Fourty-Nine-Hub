import 'package:flutter/material.dart';
import '../../stateless/labels/ReadMoreLabel.dart';
import '../../stateless/labels/label.dart';
import '../../../../res/style/styles.dart';

class CollabsableInfoWidget extends StatefulWidget {
  final String label;
  final String details;
  const CollabsableInfoWidget(
      {super.key, required this.details, required this.label});

  @override
  State<CollabsableInfoWidget> createState() => _CollabsableInfoWidgetState();
}

class _CollabsableInfoWidgetState extends State<CollabsableInfoWidget> {
  bool showDetails = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDetails = !showDetails;
        setState(() {});
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: kToolbarHeight * .7,
            child: Row(
              children: [
                Expanded(
                    child:
                        Label(text: widget.label, style: Styles.mediumText())),
                Icon(
                  showDetails ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                ),
              ],
            ),
          ),
          if (showDetails)
            ReadMoreLabel(
              text: widget.details,
              style: Styles.mediumText(fontWeight: FontWeight.w400),
            ),
        ],
      ),
    );
  }
}
