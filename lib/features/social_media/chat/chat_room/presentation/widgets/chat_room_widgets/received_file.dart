// // ignore_for_file: use_build_context_synchronously, library_prefixes

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:path/path.dart';
// import 'package:reddy_chat_app/Core/models/chat_model.dart';
// import 'package:reddy_chat_app/Core/models/message_model.dart';
// import 'package:reddy_chat_app/Core/utils/api_service.dart';
// import 'package:reddy_chat_app/Core/utils/functions/download_files.dart';
// import 'package:reddy_chat_app/Core/utils/functions/message_options_function.dart';
// import 'package:reddy_chat_app/Features/Chats/presentaion/views/widgets/contact_circle_avatar.dart';
// import 'package:reddy_chat_app/constants.dart';
// import 'package:http/http.dart' as http;
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// import '../../../../Auth/presentation/manager/user_cubit.dart';

// class ReceivedFile extends StatefulWidget {
//   final IO.Socket socket;
//   const ReceivedFile({
//     Key? key,
//     required this.messageModel,
//     required this.chatModel,
//     required this.controller,
//     required this.socket,
//   }) : super(key: key);
//   final MessageModel messageModel;
//   final ChatModel chatModel;
//   final TextEditingController controller;
//   @override
//   State<ReceivedFile> createState() => _ReceivedFileState();
// }

// class _ReceivedFileState extends State<ReceivedFile> {
//   String? fileName;
//   String? fileSize;
//   String? fileExtension;

//   // IO.Socket? socket;
//   @override
//   void initState() {
//     // initTheSocket();
//     fileName = getFileName();
//     fileExtension = extension(fileName!).substring(1).toUpperCase();
//     super.initState();
//   }

//   void reactToMessage(
//       {required String emoji, required String id, required String userId}) {
//     // Emit a socket event to react to the message
//     widget.socket.emit('reactToMessage', {
//       'messageId': id,
//       'emoji': emoji,
//       'userId': userId,
//     });
//   }

//   // initTheSocket() async {
//   //   socket = IO.io(ApiService.baseUrl, {
//   //     'transports': ['websocket'],
//   //     'autoConnect': false,
//   //   });
//   //   socket!.connect();
//   //   socket!.onDisconnect((data) {});
//   //   socket!.onConnect((data) {});
//   // }

//   @override
//   void dispose() {
//     // socket!.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       splashColor: Colors.grey.withOpacity(0.8),
//       onTapDown: (TapDownDetails details) {
//         final RenderBox overlay =
//             Overlay.of(context).context.findRenderObject() as RenderBox;
//         final Offset tapPosition =
//             overlay.globalToLocal(details.globalPosition);
//         showPopupMenu(
//           context,
//           widget.messageModel,
//           false,
//           widget.chatModel,
//           widget.messageModel.contentType!,
//           tapPosition,
//           widget.controller,
//         );
//       },
//       child: Padding(
//         padding: const EdgeInsets.only(left: 8, top: 6, bottom: 6),
//         child: GestureDetector(
//           onTapDown: (TapDownDetails details) {
//             final RenderBox overlay =
//                 Overlay.of(context).context.findRenderObject() as RenderBox;
//             final Offset tapPosition =
//                 overlay.globalToLocal(details.globalPosition);
//             showPopupMenu(
//                 context,
//                 widget.messageModel,
//                 false,
//                 widget.chatModel,
//                 widget.messageModel.contentType!,
//                 tapPosition,
//                 widget.controller);
//           },
//           child: Container(
//             color: Colors.transparent,
//             child: Padding(
//               padding: const EdgeInsets.only(
//                 right: 64,
//               ),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ContactCircleAvatar(
//                     userModel: widget.messageModel.userId!,
//                     radius: 14,
//                   ),
//                   const SizedBox(width: 4),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           color:
//                               BlocProvider.of<UserCubit>(context).systemTheme ==
//                                       'Light'
//                                   ? Constants.receivedMessageLightMode
//                                   : BlocProvider.of<UserCubit>(context)
//                                               .systemTheme ==
//                                           'Dark'
//                                       ? Constants.receivedMessageDarkMode
//                                       : Constants.whiteColor,
//                           borderRadius: const BorderRadius.only(
//                             topRight: Radius.circular(16),
//                             bottomLeft: Radius.circular(16),
//                             bottomRight: Radius.circular(16),
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: BlocProvider.of<UserCubit>(context)
//                                           .systemTheme ==
//                                       'Dark'
//                                   ? Constants.whiteColor.withOpacity(0.1)
//                                   : Colors.black.withOpacity(0.1),
//                               spreadRadius: 0.1,
//                               blurRadius: 5,
//                               offset: const Offset(
//                                   0, 0), // changes position of shadow
//                             ),
//                           ],
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 8, vertical: 8),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               ConstrainedBox(
//                                 constraints: BoxConstraints(
//                                   maxWidth:
//                                       MediaQuery.of(context).size.width * 0.65,
//                                 ),
//                                 child: Text(
//                                   widget.messageModel.userId!.name!,
//                                   style: GoogleFonts.openSans(
//                                       color: BlocProvider.of<UserCubit>(context)
//                                                   .systemTheme ==
//                                               'Light'
//                                           ? Constants.redColor
//                                           : Constants.primaryColor,
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                               const SizedBox(
//                                 height: 6,
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   downloadAndOpenFile(
//                                     fileUrl: ApiService.imagesBaseUrl +
//                                         widget.messageModel.content!,
//                                     contentType:
//                                         widget.messageModel.contentType!,
//                                   );
//                                 },
//                                 child: SizedBox(
//                                   width:
//                                       MediaQuery.of(context).size.width * 0.65,
//                                   height:
//                                       MediaQuery.of(context).size.height * 0.08,
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(8),
//                                     child: Container(
//                                       padding: const EdgeInsets.all(8),
//                                       decoration: BoxDecoration(
//                                         color: Constants.blackColor
//                                             .withOpacity(0.05),
//                                       ),
//                                       child: Row(
//                                         children: [
//                                           const Icon(
//                                             Icons.insert_drive_file,
//                                             size: 40,
//                                             color: Constants.greyColor,
//                                           ),
//                                           Column(
//                                             mainAxisSize: MainAxisSize.min,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               SizedBox(
//                                                 width: MediaQuery.of(context)
//                                                         .size
//                                                         .width *
//                                                     0.5,
//                                                 child: Text(
//                                                   fileName!,
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                   style: GoogleFonts.openSans(
//                                                     color: Constants.greyColor,
//                                                     fontSize: 14,
//                                                     fontWeight: FontWeight.bold,
//                                                   ),
//                                                 ),
//                                               ),
//                                               FutureBuilder(
//                                                 future: getFileSizeAsync(),
//                                                 builder: (context, snapshot) {
//                                                   if (snapshot
//                                                           .connectionState ==
//                                                       ConnectionState.done) {
//                                                     return Text(
//                                                       '${fileSize ?? ''}'
//                                                       ' - '
//                                                       '$fileExtension',
//                                                       style:
//                                                           GoogleFonts.openSans(
//                                                               color: Constants
//                                                                   .greyColor,
//                                                               fontSize: 10,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold),
//                                                     );
//                                                   } else {
//                                                     return const SizedBox();
//                                                   }
//                                                 },
//                                               )
//                                             ],
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(
//                                 height: 6,
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 mainAxisSize: MainAxisSize.max,
//                                 children: [
//                                   Text(
//                                     DateFormat('h:mm a')
//                                         .format(widget.messageModel.createdAt!),
//                                     style: GoogleFonts.openSans(
//                                         color:
//                                             BlocProvider.of<UserCubit>(context)
//                                                         .systemTheme ==
//                                                     'Dark'
//                                                 ? Constants.whiteColor
//                                                     .withOpacity(0.5)
//                                                 : Constants.greyColor,
//                                         fontSize: 10,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 4,
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width *
//                             0.47, // Adjust the width as needed
//                         child: GridView.builder(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           gridDelegate:
//                               const SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount:
//                                 4, // You can adjust the number of columns as needed
//                             crossAxisSpacing: 4,
//                             mainAxisSpacing: 4,
//                             childAspectRatio: 1.5,
//                           ),
//                           itemCount: widget.messageModel.reactions.length,
//                           itemBuilder: (context, index) {
//                             final emoji = widget.messageModel.reactions.keys
//                                 .elementAt(index);
//                             final count =
//                                 widget.messageModel.reactions[emoji]?.length ??
//                                     0;
//                             bool isReacted =
//                                 widget.messageModel.reactions[emoji]?.contains(
//                                       BlocProvider.of<UserCubit>(context)
//                                           .userModel
//                                           .id,
//                                     ) ??
//                                     false;
//                             return GestureDetector(
//                               onTap: () {
//                                 reactToMessage(
//                                   emoji: emoji,
//                                   id: widget.messageModel.id!,
//                                   userId: BlocProvider.of<UserCubit>(context)
//                                       .userModel
//                                       .id!,
//                                 );
//                               },
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(16),
//                                   color: isReacted
//                                       ? BlocProvider.of<UserCubit>(context)
//                                                   .systemTheme ==
//                                               'Light'
//                                           ? Constants.redColor
//                                           : BlocProvider.of<UserCubit>(context)
//                                                       .systemTheme ==
//                                                   'Dark'
//                                               ? Constants.blueDarkMode
//                                               : Constants.classicBlue
//                                       : BlocProvider.of<UserCubit>(context)
//                                                   .systemTheme ==
//                                               'Dark'
//                                           ? Constants.sendMessageDarkMode
//                                           : const Color.fromARGB(
//                                                   255, 150, 169, 182)
//                                               .withOpacity(0.6),
//                                 ),
//                                 child: Center(
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         emoji,
//                                         style: const TextStyle(
//                                             fontSize:
//                                                 12), // Adjust the size as needed
//                                       ),
//                                       const SizedBox(width: 2),
//                                       Text(
//                                         count.toString(),
//                                         style: const TextStyle(
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.w600,
//                                           color: Constants.whiteColor,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   getFileName() {
//     String fileUrl = ApiService.imagesBaseUrl + widget.messageModel.content!;

//     String fileName = extractFileName(fileUrl);
//     String cleanedFileName = cleanFileName(fileName);
//     // print('file name : $cleanedFileName'); // Output: pdf-test.pdf
//     return cleanedFileName;
//   }

//   String extractFileName(String url) {
//     Uri uri = Uri.parse(url);
//     String path = uri.path;
//     List<String> segments = path.split('/');
//     return segments.last;
//   }

//   String cleanFileName(String fileName) {
//     // Assuming the format is UUID-fileName.pdf
//     return fileName.substring(37);
//   }

//   Future<void> getFileSizeAsync() async {
//     fileSize = await getFileSize(
//       fileUrl: ApiService.imagesBaseUrl + widget.messageModel.content!,
//     );
//   }

//   Future<String?> getFileSize({required String fileUrl}) async {
//     try {
//       final response = await http.head(Uri.parse(fileUrl));

//       if (response.statusCode == 200) {
//         // Content-Length header contains the file size in bytes
//         String? contentLengthHeader = response.headers['content-length'];
//         if (contentLengthHeader != null) {
//           int fileSizeInBytes = int.parse(contentLengthHeader);

//           // Convert the file size to a formatted string
//           // print(formatFileSize(fileSizeInBytes: fileSizeInBytes));
//           return formatFileSize(fileSizeInBytes: fileSizeInBytes);
//         } else {
//           // print('Content-Length header not found in the response.');
//         }
//       } else {
//         // print('Failed to fetch file size. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       // print('Error: $e');
//     }
//     return null;
//   }

//   String formatFileSize({required int fileSizeInBytes}) {
//     const int kb = 1024;
//     const int mb = kb * 1024;
//     const int gb = mb * 1024;

//     if (fileSizeInBytes < kb) {
//       return '$fileSizeInBytes B';
//     } else if (fileSizeInBytes < mb) {
//       double sizeInKB = fileSizeInBytes / kb;
//       return '${sizeInKB.toStringAsFixed(2)} KB';
//     } else if (fileSizeInBytes < gb) {
//       double sizeInMB = fileSizeInBytes / mb;
//       return '${sizeInMB.toStringAsFixed(2)} MB';
//     } else {
//       double sizeInGB = fileSizeInBytes / gb;
//       return '${sizeInGB.toStringAsFixed(2)} GB';
//     }
//   }
// }
