import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widget/custom_scaffold.dart';
import '../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../controllers/chat_cubit.dart';
import '../widgets/stories_section_widget.dart';
import '../widgets/category_tabs_widget.dart';
import '../widgets/chat_item_widget.dart';
import '../widgets/privacy_message_widget.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().loadChats();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: HomeAppbar(
          isWithBackArrow: false,
          scaffoldKey:_scaffoldKey,
          language: true,
          isMenu:false
        // isHaveLeading: true,
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ChatLoaded) {
            return Column(
              children: [
                // Stories Section
                StoriesSectionWidget(stories: state.stories),
                
                // Category Tabs
                CategoryTabsWidget(
                  onTabChanged: (index) {
                    // TODO: Handle category change
                  },
                ),
                
                // Chat List
                Expanded(
                  child: ListView.builder(
                    itemCount: state.chats.length,
                    itemBuilder: (context, index) {
                      return ChatItemWidget(
                        chat: state.chats[index],
                        onTap: () {
                          // TODO: Navigate to chat detail
                        },
                      );
                    },
                  ),
                ),
                
                // Privacy Message
                const PrivacyMessageWidget(),
              ],
            );
          } else if (state is ChatError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.red,
                ),
              ),
            );
          }
          
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
