import 'package:flutter/material.dart';

class UserImage extends StatelessWidget {
  const UserImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 24,
      child: Icon(Icons.person, color: Colors.white, size: 24),
    );
  }
}
