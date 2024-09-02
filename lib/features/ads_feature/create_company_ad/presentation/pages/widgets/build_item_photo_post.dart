import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/cubit/company_advertise/company_advertise_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';
import '../../../data/models/company_advertise_model.dart';
import 'image_details.dart';

class BuildItemPhotoPost extends StatelessWidget {
  final int length;
  final Advertises advertises;
  bool? isPhoto;

   BuildItemPhotoPost(
      {super.key,
      required this.length,
      required this.advertises,
        this.isPhoto=true,
      });

  @override
  Widget build(BuildContext context) {
    final DateTime createdAt = DateTime.parse(advertises.createdAt!);
    final DateTime egyptTime = createdAt.toUtc().add(const Duration(hours: 3));
    final String formattedDayTime =
        DateFormat('EEEE, h:mm a').format(egyptTime);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: length == 1 ? 1 : 2),
              itemCount: length < 4 ? length : 4,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  if (index != 3 || (index == 3 && length == 4)) {
                    showDialog(
                        context: context,
                        builder: (context) => ImageDetails(
                              image: advertises.media![index].photo!,
                              function: () {
                                context
                                    .read<CompanyAdvertiseCubit>()
                                    .deletePost(context, advertises.media![index].sId!, 'photo');
                                Navigator.pop(context);
                              },
                            ));
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) => allImage(() {}));
                  }
                },
                child: Stack(
                  children: [
                    Container(
                      margin:
                          const EdgeInsetsDirectional.only(end: 10, bottom: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(advertises.media![index].photo!),
                        ),
                      ),
                    ),
                    if (index == 3 && length > 4)
                      Container(
                        margin: const EdgeInsetsDirectional.only(
                            end: 10, bottom: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.black.withOpacity(0.5),
                        ),
                        child: Center(
                          child: Label(
                            text: "+${advertises.media!.length - 4}",
                            style: Styles.headerText(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if(isPhoto!)
            IconButton(
              onPressed: () {
                context
                    .read<CompanyAdvertiseCubit>()
                    .deletePost(context, advertises.sId!, 'photo');
              },
              icon: const Icon(
                Icons.close,
                color: AppColors.SECONDARY_COLOR,
                size: 25,
              ),
            ),
          ],
        ),
        if(isPhoto!)
        Text(formattedDayTime),
      ],
    );
  }

  Widget allImage(Function function) => Container(
        height: double.infinity,
        width: double.infinity,
        color: AppColors.DARK_BLUE_COLOR,
        child: ListView.builder(
          itemCount: advertises.media!.length,
          itemBuilder: (context, index) => Material(
            // Add Material widget here
            color: Colors.transparent,
            // Ensure the background remains unchanged
            child: InkWell(
              onTap: () {
                print("object");
                showDialog(
                  context: context,
                  builder: (context) =>
                      ImageDetails(image: advertises.media![index].photo!,
                          function: function),
                );
              },
              child: Stack(
                children: [
                  Container(
                    height: 400,
                    margin: const EdgeInsets.only(bottom: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.DARK_BLUE_COLOR,
                      image: DecorationImage(
                        image: NetworkImage(advertises.media![index].photo!),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  // PositionedDirectional(
                  //   end: 5,
                  //   top: 5,
                  //   child: InkWell(
                  //     onTap: () async {
                  //       context.read<CompanyAdvertiseCubit>()
                  //           .deletePost(context, advertises.media![index].sId!, 'photo');
                  //     //  Navigator.pop(context);
                  //     },
                  //     child: Container(
                  //       height: 30,
                  //       width: 30,
                  //       alignment: Alignment.center,
                  //       padding: const EdgeInsets.all(5),
                  //       decoration: const BoxDecoration(
                  //         color: Colors.white,
                  //         shape: BoxShape.circle,
                  //       ),
                  //       child: const Icon(
                  //         Icons.close,
                  //         color: Colors.red,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      );
}
