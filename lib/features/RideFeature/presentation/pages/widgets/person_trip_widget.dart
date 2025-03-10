import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';

class PersonTripWidget extends StatelessWidget {
  final String image;
  final String name;

  const PersonTripWidget({
    super.key,
    required this.image,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ClipOval(
            child: Container(
              width: 50,
              height: 50,
              color: Colors.grey[300],
              child: Image.asset(
                image,
                fit: BoxFit.scaleDown,
                width: 50,
                height: 50,
              ),
            ),
          ),

          SizedBox(
            width: 70,
            child: Label(
              text: name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
