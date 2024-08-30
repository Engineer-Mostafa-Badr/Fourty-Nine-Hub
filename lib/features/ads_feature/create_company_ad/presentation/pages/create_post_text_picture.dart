import 'package:flutter/material.dart';

import '../../../../../common/widgets/stateful/banners/back_appbar.dart';

class CreatePostTextPicture extends StatelessWidget {
  const CreatePostTextPicture({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        centerTitle: false,
        label: 'Create Picture Post',
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
