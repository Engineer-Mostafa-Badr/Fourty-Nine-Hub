// import 'package:flutter/material.dart';
//
// class SocialChatsListView extends StatelessWidget {
//   const SocialChatsListView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ChatsCubit, ChatsState>(builder: (context, state) {
//       return state.chats == null
//           ? const Center(
//         child: CircularProgressIndicator.adaptive(),
//       )
//           : state.chats!.isEmpty
//           ? Center(
//         child: Label(
//             text: 'No Chats until now',
//             style: Styles.mediumText(
//                 fontWeight: FontWeight.bold, fontSize: 18)),
//       )
//           : ListView.separated(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemBuilder: (context, index) => Slidable(
//           key: ValueKey(index),
//           closeOnScroll: false,
//           endActionPane: ActionPane(
//             motion: const ScrollMotion(),
//             dismissible: DismissiblePane(onDismissed: () {}),
//             children: [
//               SlidableAction(
//                 onPressed: (value) {
//                   // bottomSheet(
//                   //     backColor:
//                   //         Theme.of(context).scaffoldBackgroundColor,
//                   //     context: context,
//                   //     isScrollControlled: true,
//                   //     widget: MoreIconBottomSheet(
//                   //       ChatCategoryEntity: state.chats![index],
//                   //       chatsCubit: chatCubit,
//                   //     ));
//                 },
//                 backgroundColor:
//                 const Color.fromARGB(255, 191, 191, 191),
//                 foregroundColor: Colors.white,
//                 icon: Icons.more_horiz,
//                 label: 'More',
//                 padding: EdgeInsets.zero,
//               ),
//               SlidableAction(
//                 onPressed: (value) async {},
//                 backgroundColor: AppColors.PRIMARY_COLOR,
//                 foregroundColor: Colors.white,
//                 icon: Icons.delete_outlined,
//                 label: state.chats![index].archived
//                     ? 'Unarchive'
//                     : 'Archive',
//                 padding: EdgeInsets.zero,
//               ),
//             ],
//           ),
//           child: ChatCard(
//             isSecret: isSecret,
//             chat: state.chats?[index],
//             chatsCubit: chatCubit,
//           ),
//         ),
//         separatorBuilder: (context, index) => const SizedBox(),
//         itemCount: state.chats?.length ?? 0,
//       );
//     });
//   }
// }
