// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_reaction_button/flutter_reaction_button.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:fourtyninehub/common/widgets/stateless/images/profile_image.dart';
// import 'package:go_router/go_router.dart';

// import '../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
// import '../../../../../../common/widgets/dynamic/sizer.dart';
// import '../../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
// import '../../../../../../common/widgets/stateless/buttons/text_button.dart';
// import '../../../../../../common/widgets/stateless/images/social_image_viewer.dart';
// import '../../../../../../common/widgets/stateless/labels/ReadMoreLabel.dart';
// import '../../../../../../common/widgets/stateless/labels/label.dart';
// import '../../../../../../core/enums/post_type_enum.dart';
// import '../../../../../../res/assets/assets.dart';
// import '../../../../../../res/style/app_colors.dart';
// import '../../../../../../res/style/const.dart';
// import '../../../../../../res/style/styles.dart';
// import '../../../../../../routes/routes.dart';
// import 'PostOptions.dart';
// import 'post_comments.dart';

// // ignore: must_be_immutable
// class PostCard extends StatefulWidget {
//   final PostType postType;
//   bool isLiked;
//   PostCard(
//       {super.key, this.postType = PostType.Facebook, this.isLiked = false});

//   @override
//   State<PostCard> createState() => _PostCardState();
// }

// class _PostCardState extends State<PostCard> {
//   final List<String> images = [
//     UIConst.socialImagePlaceHolder,
//     UIConst.socialImagePlaceHolder,
//     UIConst.socialImagePlaceHolder,
//     UIConst.socialImagePlaceHolder,
//     UIConst.socialImagePlaceHolder,
//   ];
//   final pageController = PageController();

//   @override
//   void initState() {
//     pageController.addListener(() {
//       setState(() {});
//     });

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(color: Colors.white),
//       child: widget.postType == PostType.Instagram
//           ? Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: _buildAccountRow(context: context),
//                 ),
//                 _buildContent(
//                     label: UIConst.placeholderText,
//                     image: UIConst.socialImagePlaceHolder),
//                 _buildInstagramCounter(),
//               ],
//             )
//           : Container(
//               padding: const EdgeInsets.all(10),
//               decoration: const BoxDecoration(color: Colors.white),
//               child: Column(
//                 children: [
//                   _buildAccountRow(context: context),
//                   Container(
//                     margin:
//                         const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                     decoration: BoxDecoration(
//                         border: Border.all(color: AppColors.LIGHT_GRAY_COLOR)),
//                     child: Column(
//                       children: [
//                         _buildAccountRow(context: context, showOptions: false),
//                         _buildContent(
//                             label: UIConst.placeholderText,
//                             image: UIConst.socialImagePlaceHolder),
//                         _buildStatisticsWidget(),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildStatisticsWidget() {
//     return widget.postType == PostType.Facebook
//         ? _buildFacebookStaticsWidget()
//         : _buildTwitterStaticsWidget();
//   }

//   Widget _buildTwitterStaticsWidget() {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 5),
//       child: Row(
//         children: [
//           Expanded(
//             child: _buildTwitterItem(
//                 icon: Icons.comment,
//                 label: '14,350',
//                 onTap: () => bottomSheet(
//                     isScrollControlled: true,
//                     context: context,
//                     widget: const PostComments())),
//           ),
//           Expanded(
//             child: _buildTwitterItem(
//                 icon: FontAwesomeIcons.retweet, label: '250', onTap: () {}),
//           ),
//           Expanded(
//             child: _buildTwitterItem(
//                 icon: Icons.favorite_outline, label: '80,9k', onTap: () {}),
//           ),
//           Expanded(
//             child: _buildTwitterItem(
//                 icon: Icons.analytics, label: '14,350', onTap: () {}),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTwitterItem({
//     required IconData icon,
//     required String label,
//     required Function onTap,
//   }) {
//     return InkWell(
//       onTap: () => onTap(),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             icon,
//             size: 14,
//             color: Colors.grey,
//           ),
//           const Sizer(),
//           Label(text: label, style: Styles.mediumText(color: Colors.grey)),
//         ],
//       ),
//     );
//   }

//   Widget _buildFacebookStaticsWidget() {
//     return Column(
//       children: [
//         Container(
//           margin: const EdgeInsets.symmetric(vertical: 5),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _buildReactionCounter(),
//               Label(
//                   text: '134,031 views',
//                   style: Styles.mediumText(color: Colors.grey))
//             ],
//           ),
//         ),
//         const Divider(
//           color: AppColors.LIGHT_GRAY_COLOR,
//         ),
//         SizedBox(
//           height: kToolbarHeight * .6,
//           child: Row(
//             children: [
//               Expanded(child: _buildReactionsButton()),
//               Expanded(
//                 child: _buildReactionPlaceHolder(
//                     icon: Icons.chat_bubble_outline_rounded,
//                     label: 'Comment',
//                     onTap: () {
//                       bottomSheet(
//                         context: context,
//                         isScrollControlled: true,
//                         widget: const PostComments(),
//                       );
//                     }),
//               ),
//               Expanded(
//                 child: _buildReactionPlaceHolder(
//                     icon: Icons.chat_rounded,
//                     label: 'Message',
//                     onTap: () => context.push(Routes.CHAT)),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildInstagramCounter() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Label(
//               text: '6,486,359 likes',
//               style: Styles.mediumText(fontWeight: FontWeight.bold)),
//           RichText(
//               text: TextSpan(children: [
//             TextSpan(
//                 text: 'Abeer.omar',
//                 style: Styles.mediumText(fontWeight: FontWeight.bold)),
//             WidgetSpan(
//                 child: ReadMoreLabel(
//               text: UIConst.placeholderText,
//               trimLines: 2,
//               style: Styles.mediumText(color: Colors.grey),
//             ))
//           ])),
//           TextAppButton(
//             label: 'View all 19 comments',
//             onPressed: () {
//               bottomSheet(
//                 context: context,
//                 isScrollControlled: true,
//                 widget: const PostComments(),
//               );
//             },
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildReactionCounter() {
//     return Row(
//       children: [
//         Image.asset(
//           Assets.wow,
//           height: 20,
//         ),
//         const Sizer(),
//         Label(text: '1k', style: Styles.mediumText())
//       ],
//     );
//   }

//   Widget _buildReactionsButton() {
//     return ReactionButton<String>(
//       boxColor: Colors.white,
//       boxRadius: 10,

//       onReactionChanged: (Reaction<String>? reaction) {},
//       toggle: false,
//       direction: ReactionsBoxAlignment.rtl,
//       placeholder: Reaction<String>(
//         value: null,
//         icon: _buildReactionPlaceHolder(
//             icon: Icons.thumb_up_alt_outlined, label: 'Like'),
//       ),
//       // boxColor: Colors.black.withOpacity(0.5),
//       itemsSpacing: 10,
//       itemSize: const Size(20, 20),
//       reactions: <Reaction<String>>[
//         Reaction<String>(
//           value: 'like',
//           icon: _buildReactionItem(image: Assets.like),
//         ),
//         Reaction<String>(
//           value: 'heart',
//           icon: _buildReactionItem(image: Assets.heart),
//         ),
//         Reaction<String>(
//           value: 'wow',
//           icon: _buildReactionItem(image: Assets.wow),
//         ),
//         Reaction<String>(
//           value: 'sad',
//           icon: _buildReactionItem(image: Assets.sad),
//         ),
//         Reaction<String>(
//           value: 'angry',
//           icon: _buildReactionItem(image: Assets.angry),
//         ),
//       ],
//       selectedReaction: Reaction<String>(
//         value: 'like',
//         icon: _buildReactionItem(image: Assets.like),
//       ),
//     );
//   }

//   Widget _buildReactionPlaceHolder({
//     required IconData icon,
//     required String label,
//     Function? onTap,
//   }) {
//     if (onTap == null) {
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             icon,
//             color: Colors.grey,
//           ),
//           const Sizer(),
//           Label(text: label, style: Styles.mediumText(color: Colors.grey))
//         ],
//       );
//     } else {
//       return InkWell(
//         onTap: () => onTap(),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               icon,
//               color: Colors.grey,
//             ),
//             const Sizer(),
//             Label(text: label, style: Styles.mediumText(color: Colors.grey))
//           ],
//         ),
//       );
//     }
//   }

//   Widget _buildReactionItem({
//     required String image,
//   }) {
//     return Image.asset(
//       image,
//       height: 20,
//     );
//   }

//   Widget _buildContent({
//     String? label,
//     String? image,
//   }) {
//     return widget.postType == PostType.Twitter
//         ? _buildTwitterContent(image: image, label: label)
//         : widget.postType == PostType.Instagram
//             ? _buildContentInstagram(image: image, label: label)
//             : _buildContentFacebook(image: image, label: label);
//   }

//   Widget _buildTwitterContent({
//     String? label,
//     String? image,
//   }) {
//     return Column(
//       children: [
//         if (label != null) ReadMoreLabel(text: label),
//         const Sizer(),
//         if (image != null)
//           Image.network(
//             image,
//             width: double.infinity,
//             fit: BoxFit.cover,
//           ),
//       ],
//     );
//   }

//   Widget _buildContentFacebook({
//     String? label,
//     String? image,
//   }) {
//     return Column(
//       children: [
//         if (label != null) ReadMoreLabel(text: label),
//         const Sizer(),
//         if (image != null)
//           Image.network(
//             image,
//             width: double.infinity,
//             fit: BoxFit.cover,
//           ),
//       ],
//     );
//   }

  // Widget _buildContentInstagram({
  //   String? label,
  //   String? image,
  // }) {
  //   return Column(
  //     children: [
  //       const Sizer(),
  //       SizedBox(
  //         height: kToolbarHeight * 4,
  //         child: PageView.builder(
  //             controller: pageController,
  //             scrollDirection: Axis.horizontal,
  //             itemCount: images.length,
  //             itemBuilder: (context, index) {
  //               return SocialImageViewer(
  //                 image: images[index],
  //                 index: index + 1,
  //                 length: images.length,
  //                 onDoubleTap: () {
  //                   widget.isLiked = !widget.isLiked;
  //                   setState(() {});
  //                 },
  //               );
  //             }),
  //       ),
  //       const Sizer(
  //         height: 5,
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Expanded(
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   IconAppButton(
  //                     icon: widget.isLiked
  //                         ? Icons.favorite
  //                         : Icons.favorite_border,
  //                     onPressed: () {
  //                       widget.isLiked = !widget.isLiked;
  //                       setState(() {});
  //                     },
  //                     color: widget.isLiked ? Colors.red : Colors.grey,
  //                     size: 25,
  //                   ),
  //                   const Sizer(),
  //                   IconAppButton(
  //                     icon: Icons.chat_bubble_outline_rounded,
  //                     onPressed: () {
  //                       bottomSheet(
  //                         context: context,
  //                         isScrollControlled: true,
  //                         widget: const PostComments(),
  //                       );
  //                     },
  //                     color: Colors.grey,
  //                     size: 25,
  //                   ),
  //                   const Sizer(),
  //                   IconAppButton(
  //                     icon: Icons.send_rounded,
  //                     color: Colors.grey,
  //                     onPressed: () => context.push(Routes.CHAT),
  //                     size: 25,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Expanded(
  //               child: Center(
  //                 child: SizedBox(
  //                   height: 8,
  //                   child: ListView.separated(
  //                       shrinkWrap: true,
  //                       scrollDirection: Axis.horizontal,
  //                       itemCount: images.length,
  //                       separatorBuilder: (context, index) => const Sizer(
  //                             width: 3,
  //                           ),
  //                       itemBuilder: (context, index) {
  //                         return CircleAvatar(
  //                           radius: 4,
  //                           backgroundColor:
  //                               pageController.page?.toInt() == index
  //                                   ? AppColors.SECONDARY_COLOR
  //                                   : AppColors.PRIMARY_COLOR,
  //                         );
  //                       }),
  //                 ),
  //               ),
  //             ),
  //             Expanded(
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.end,
  //                 children: [
  //                   IconAppButton(
  //                     icon: Icons.bookmark_outline,
  //                     color: Colors.grey,
  //                     onPressed: () {},
  //                     size: 25,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       )
  //     ],
  //   );
  // }

//   Widget _buildAccountRow({
//     required BuildContext context,
//     bool showOptions = true,
//   }) {
//     return widget.postType == PostType.Twitter
//         ? Row(
//             children: [
//               const ProfileImage(accountId: 0),
//               const Sizer(),
//               Label(
//                   text: 'Poetry',
//                   style: Styles.mediumText(fontWeight: FontWeight.w500)),
//               const Sizer(),
//               const Icon(
//                 Icons.verified,
//                 color: AppColors.PRIMARY_COLOR,
//               ),
//               const Sizer(),
//               Label(
//                   text: '@lastvibes . 18h',
//                   style: Styles.mediumText(color: Colors.grey)),
//             ],
//           )
//         : widget.postType == PostType.Instagram
//             ? Row(
//                 children: [
//                   InkWell(
//                     onTap: () => context.push(Routes.OTHERSACCOUNT),
//                     child: const CircleAvatar(
//                       radius: 22,
//                       backgroundColor: AppColors.SECONDARY_COLOR,
//                       child: CircleAvatar(
//                         radius: 20,
//                         backgroundColor: Colors.white,
//                         backgroundImage:
//                             NetworkImage(UIConst.profilePlaceHolder),
//                       ),
//                     ),
//                   ),
//                   const Sizer(),
//                   Expanded(
//                       child: InkWell(
//                     onTap: () => context.push(Routes.OTHERSACCOUNT),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         TextAppButton(
//                             label: 'Kero Amged',
//                             onPressed: () =>
//                                 () => context.push(Routes.OTHERSACCOUNT)),
//                         RichText(
//                             text: TextSpan(children: [
//                           TextSpan(
//                               text: '19 hr   ',
//                               style: Styles.mediumText(color: Colors.grey)),
//                         ]))
//                       ],
//                     ),
//                   )),
//                   IconButton(
//                       onPressed: () {
//                         bottomSheet(
//                             context: context, widget: const PostOptions());
//                       },
//                       icon: const Icon(Icons.more_vert)),
//                 ],
//               )
//             : Row(
//                 children: [
//                   InkWell(
//                     onTap: () => context.push(Routes.OTHERSACCOUNT),
//                     child: const CircleAvatar(
//                       backgroundColor: Colors.white,
//                       backgroundImage: NetworkImage(UIConst.profilePlaceHolder),
//                     ),
//                   ),
//                   const Sizer(),
//                   Expanded(
//                       child: InkWell(
//                     onTap: () => context.push(Routes.OTHERSACCOUNT),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         TextAppButton(
//                             label: 'Kero Amged',
//                             onPressed: () =>
//                                 () => context.push(Routes.OTHERSACCOUNT)),
//                         RichText(
//                             text: TextSpan(children: [
//                           TextSpan(
//                               text: '19 hr   ',
//                               style: Styles.mediumText(color: Colors.grey)),
//                           const WidgetSpan(
//                               child: Icon(
//                             Icons.group,
//                             size: 14,
//                             color: Colors.grey,
//                           ))
//                         ]))
//                       ],
//                     ),
//                   )),
//                   if (showOptions)
//                     IconButton(
//                         onPressed: () {
//                           bottomSheet(
//                               context: context, widget: const PostOptions());
//                         },
//                         icon: const Icon(Icons.more_horiz)),
//                   if (showOptions)
//                     IconAppButton(icon: Icons.clear, onPressed: () {})
//                 ],
//               );
//   }
// }
