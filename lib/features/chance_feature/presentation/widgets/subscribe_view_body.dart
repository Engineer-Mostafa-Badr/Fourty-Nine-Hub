import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';


class SubscribeViewBody extends StatelessWidget {
  const SubscribeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child:
            Container(
              height: 200,
              decoration: const BoxDecoration(

              ),
              child: Image.asset('assets/images/doctor.png'),
            ),
          ),
          const SizedBox(height: 20),
           Text(
           LocaleKeys.subscribe.localize,
            style: Styles.headerText(
              color: Theme.of(context).primaryColor,
              fontSize: 80.sp
            ),
          ),
          const SizedBox(height: 10),
           Text(
            'Type the value you want to participation',
            textAlign: TextAlign.center,
            style: Styles.mediumText(),
          ),
          const SizedBox(height: 20),
          Text(
            'participation with points (points)',
            textAlign: TextAlign.center,
            style: Styles.mediumText(),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: ()
                  {
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
                    backgroundColor: AppColors.PRIMARY_COLOR,
                  ),
                  child:  Icon(Icons.remove,color: Theme.of(context).scaffoldBackgroundColor,)
              ),
              const Spacer(),
              Container(
                width: context.screenWidth / 2,
                padding: const EdgeInsets.only(top: 3,bottom: 3,left:2,right: 6),
                decoration: BoxDecoration(
                  color: AppColors.PRIMARY_COLOR,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {},
                    ),
                    const Spacer(),
                    Text('0', style: Styles.mediumText(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      fontSize: 100.sp,
                    )),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                  onPressed: ()
                  {
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
                    backgroundColor: AppColors.PRIMARY_COLOR,
                  ),
                  child:  Icon(Icons.add,color: Theme.of(context).scaffoldBackgroundColor,)
              )
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'participation  with wallet balance (pounds)',
            textAlign: TextAlign.center,
            style: Styles.mediumText(),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: ()
                  {
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
                    backgroundColor: AppColors.SECONDARY_COLOR,
                  ),
                  child:  Icon(Icons.remove,color: Theme.of(context).scaffoldBackgroundColor,)
              ),
              const Spacer(),
              Container(
                width: context.screenWidth / 2,
                padding: const EdgeInsets.only(top: 3,bottom: 3,left:2,right: 6),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {},
                    ),
                    const Spacer(),
                     Text('0', style: Styles.mediumText(
                       color: Theme.of(context).scaffoldBackgroundColor,
                       fontSize: 100.sp,
                     )),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                  onPressed: ()
                  {
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
                    backgroundColor: AppColors.SECONDARY_COLOR,
                  ),
                  child:  Icon(Icons.add,color: Theme.of(context).scaffoldBackgroundColor,)
              )
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: AppColors.SECONDARY_COLOR,

                ),
                child:  Text('Subscribe to the product', style: Styles.mediumText(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  fontSize: 50.sp
                )),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: ()
                {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
                  backgroundColor: AppColors.SECONDARY_COLOR,
                ),
                child:  Icon(Icons.arrow_forward_ios,color: Theme.of(context).scaffoldBackgroundColor,)
              )
            ],
          ),
        ],
      ),
    ) ;
  }
}
