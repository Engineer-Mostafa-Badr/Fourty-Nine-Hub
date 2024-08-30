import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/routing_helper.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:go_router/go_router.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../cubit/create_company_ad_cubit.dart';
import 'create_post_image.dart';
import 'create_posts_company.dart';

class CreateCompanyAdView extends StatelessWidget {
  const CreateCompanyAdView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        centerTitle: false,
        label: 'Company Advertise', //adds files
      ),
      body: BlocConsumer<CreateCompanyAdCubit, CreateCompanyAdState>(
          listener: (context, state) {},
          builder: (context, state) {
            // final controller = context.read<CreateCompanyAdCubit>();
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _buildContainer(
                          title: 'Text only',
                          price: '200',
                          context: context,
                          function: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                       const CreatePostCompany(picture: false, title: 'Create Text Post',)),
                            );
                          },
                        ),
                        _buildContainer(
                          title: 'Picture only',
                          price: '200',
                          context: context,
                          function: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const CreatePostCompany(text: false, title: 'Create Picture Post',)),
                            );
                            // IconButton
                            //   (
                            //   onPressed: () async{
                            //     await controller.uploadPhoto();
                            //   },
                            //   icon: const Icon(
                            //     Icons.image,
                            //     color: Colors.green,
                            //     size: 30,
                            //   ),);
                            // if (state.images != null && state.images!.isNotEmpty)
                            //   Expanded(child: _buildMediaCard()),

                            //  final controller = context.read<CreatePostCubit>();
                            // Widget _buildMediaCard() {
                            //   return BlocBuilder<CreatePostCubit, CreatePostState>(
                            //       builder: (context, state) {
                            //         final controller = context.read<CreatePostCubit>();
                            //         return GridView.builder(
                            //             shrinkWrap: true,
                            //             physics: NeverScrollableScrollPhysics(),
                            //             padding: const EdgeInsets.all(10),
                            //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            //                 crossAxisCount: state.images!.length == 1 ? 1 : 2),
                            //             itemCount: state.images!.length < 4 ? state.images!.length : 4,
                            //             itemBuilder: (context, index) => InkWell(
                            //               onTap: () {
                            //                 if (index != 3 || (index == 3 && state.images!.length == 4)) {
                            //                   showDialog(
                            //                       context: context,
                            //                       builder: (context) => ImageDetailsScreen(
                            //                         image: state.images![index].file.path,
                            //                         isFile: true,
                            //                         onRemoveImage: () {
                            //                           controller.removePhoto(state.images![index]);
                            //                           context.pop();
                            //                         },
                            //                       ));
                            //                 } else {
                            //                   showDialog(
                            //                       context: context,
                            //                       builder: (context) => ShowAllImages(
                            //                         images: state.images!,
                            //                         onRemoveImage: (UploadFileEntity image) {
                            //                           controller.removePhoto(image);
                            //                         },
                            //                       ));
                            //                 }
                            //               },
                            //               child: Stack(
                            //                 children: [
                            //                   Stack(
                            //                     children: [
                            //                       Container(
                            //                         margin: const EdgeInsetsDirectional.only(
                            //                             end: 10, bottom: 10),
                            //                         padding: const EdgeInsets.all(10),
                            //                         decoration: BoxDecoration(
                            //                           borderRadius: BorderRadius.circular(15),
                            //                           image: DecorationImage(
                            //                             fit: BoxFit.fill,
                            //                             image: FileImage(
                            //                               File(state.images?[index].file.path ?? ''),
                            //                             ),
                            //                           ),
                            //                         ),
                            //                       ),
                            //                       if (index == 3 && state.images!.length > 4)
                            //                         Container(
                            //                           margin: const EdgeInsetsDirectional.only(
                            //                               end: 10, bottom: 10),
                            //                           // padding: const EdgeInsets.all(10),
                            //                           alignment: Alignment.center,
                            //                           decoration: BoxDecoration(
                            //                             borderRadius: BorderRadius.circular(15),
                            //                             color: Colors.black.withOpacity(0.5),
                            //                           ),
                            //                           child: Center(
                            //                             child: Label(
                            //                               text: "+${state.images!.length - 4}",
                            //                               style: Styles.headerText(
                            //                                 color: Colors.white,
                            //                               ),
                            //                             ),
                            //                           ),
                            //                         ),
                            //                     ],
                            //                   ),
                            //                   if (index == 0 && state.images!.length == 1)
                            //                     PositionedDirectional(
                            //                       end: 15,
                            //                       top: 5,
                            //                       child: InkWell(
                            //                         onTap: () {
                            //                           controller.removePhoto(state.images?[index]);
                            //                         },
                            //                         child: const Icon(
                            //                           Icons.close,
                            //                           color: Colors.red,
                            //                         ),
                            //                       ),
                            //                     ),
                            //                 ],
                            //               ),
                            //             ));
                            //       });
                            // }
                          },
                        ),
                        _buildContainer(
                          title: 'Text with pictures',
                          price: '200',
                          context: context,
                          function: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const CreatePostCompany( title: 'Create Post',)),
                            );
                          },
                        ),
                        _buildContainer(
                          title: 'Reel',
                          price: '200',
                          context: context,
                          function: () {},
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsetsDirectional.only(bottom: 35.zH),
                          padding: const EdgeInsetsDirectional.symmetric(
                              vertical: 10, horizontal: 10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(20.zR),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Total',
                                style: Styles.headerText(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor),
                              ),
                              const Spacer(),
                              Text(
                                '10',
                                style: Styles.mediumText(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsetsDirectional.only(bottom: 35.zH),
                          padding: const EdgeInsetsDirectional.symmetric(
                              vertical: 10, horizontal: 10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.SECONDARY_COLOR,
                            borderRadius: BorderRadius.circular(20.zR),
                          ),
                          child: Center(
                            child: Text(
                              'Pay',
                              style: Styles.headerText(
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget _buildContainer({
    required String title,
    required String price,
    required Function function,
    context,
  }) =>
      Container(
        margin: EdgeInsetsDirectional.only(bottom: 35.zH),
        padding:
            const EdgeInsetsDirectional.symmetric(vertical: 7, horizontal: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20.zR),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: Styles.headerText(
                  color: Theme.of(context).scaffoldBackgroundColor),
            ),
            const Spacer(),
            Text(
              price,
              style: Styles.mediumText(
                  color: Theme.of(context).scaffoldBackgroundColor),
            ),
            IconButton(
              onPressed: () {
                function();
              },
              icon: const Icon(
                Icons.check_circle,
                color: AppColors.AUTH_CONTAINER_COLOR,
              ),
            ),
          ],
        ),
      );

// Widget _buildOptionWidget({required CompanyAdEntity adOption}) {
//   return BlocBuilder<CreateCompanyAdCubit, CreateCompanyAdState>(
//       builder: (context, state) {
//     final controller = context.read<CreateCompanyAdCubit>();
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Expanded(
//               child: Label(
//                 text: adOption.title,
//                 style: Styles.headerText(),
//               ),
//             ),
//             IconAppButton(
//                 icon: Icons.upload,
//                 isCircle: true,
//                 onPressed: () async => FilePickerHelper().pickMedia()),
//           ],
//         ),
//         ListView.builder(
//             itemCount: adOption.options.length,
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemBuilder: (context, index) {
//               final option = adOption.options[index];
//               return Row(
//                 children: [
//                   Checkbox(
//                       value: controller.optionSelected(option),
//                       onChanged: (v) => controller.onSelection(option)),
//                   Expanded(
//                       child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Label(
//                         text: option.title,
//                         style: Styles.mediumText(fontWeight: FontWeight.w400),
//                       ),
//                       Label(
//                         text: option.subTitle,
//                         style: Styles.mediumText(fontWeight: FontWeight.w300),
//                       ),
//                     ],
//                   )),
//                 ],
//               );
//             })
//       ],
//     );
//   });
// }
}
