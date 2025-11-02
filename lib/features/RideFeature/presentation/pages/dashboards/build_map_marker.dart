import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class BuildMapMarker extends StatelessWidget {
  const BuildMapMarker({
    super.key,
    required this.manIconPath,
    required this.womanIconPath,
    required this.name,
    required this.isMale,
  });

  final String manIconPath;
  final String womanIconPath;
  final String name;
  final bool isMale;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Container(
          height: 45,
          width: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isMale ? Colors.blue.withOpacity(0.2) : Colors.pink.withOpacity(0.2),
            border: Border.all(color: AppColors.LIGHT_GRAY_COLOR, width: 2),
            image: DecorationImage(
              image: AssetImage(isMale ? manIconPath : womanIconPath),
              fit: BoxFit.cover,
              onError: (exception, stackTrace) {
                // This print statement is commented out, but would be the right place to debug asset loading errors
                // debugPrint('Failed to load asset image in marker: $exception');
              },
            ),
          ),
        ),
        if(name.isNotEmpty)PositionedDirectional(
          bottom: 0,
          end: 0,
          start: 0,
          child: Container(
            // width: 60,
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 0.5),
            ),
            alignment: Alignment.center,
            child: Text(name[0].toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w500,

                  color: AppColors.PRIMARY_COLOR,
                  fontSize: 8),),
          ),
        )
      ],
    );
  }
}