import 'package:flutter/material.dart';
import '../../../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';

class MyBroadcastsCard extends StatelessWidget {
  const MyBroadcastsCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(Routes.BROADCAST),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: SizedBox(
            width: 50,
            height: 50,
            child: Image.network(
              "https://play-lh.googleusercontent.com/QuVFM8a1DJFaLb3M0iHjgylkrS0ddvpBzDSHOGxs7YzqAFIHeXJwZ53aX7SaMImmA30=w240-h480-rw",
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: const Text('إذاعة القرآن الكريم'),
        subtitle: const Text('تلاوة للشيخ بدر التركي'),
        trailing: const Text('5:00 Am'),
      ),
    );
  }
}
