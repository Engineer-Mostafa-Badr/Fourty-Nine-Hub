import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/account_taps/lists/presentation/cubit/lists_cubit.dart';

import '../../../../../res/strings/labels.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../domain/entities/users_list_entity.dart';
import '../widgets/list_item_card.dart';

class ListsView extends StatelessWidget {
  const ListsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BackAppBar(label: Labels.lists),
        body: BlocConsumer<ListsCubit, ListsState>(
            listener: (context, state) {},
            builder: (context, state) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    height: kToolbarHeight * 1,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        listItem(
                            label: Labels.friends,
                            icon: Icons.handshake,
                            context: context,
                            type: ListTypes.friends),
                        listItem(
                            label: Labels.followers,
                            icon: Icons.group,
                            context: context,
                            type: ListTypes.followers),
                        listItem(
                            label: Labels.friendRequests,
                            icon: Icons.h_mobiledata,
                            context: context,
                            type: ListTypes.requests),
                        listItem(
                            label: Labels.blocked,
                            icon: Icons.block,
                            context: context,
                            type: ListTypes.blocked),
                      ],
                    ),
                  ),
                  Expanded(
                      child: state.isLoading
                          ? const Center(
                              child: CircularProgressIndicator.adaptive(),
                            )
                          : state.selectedList == ListTypes.friends
                              ? _buildListUsersWidet(
                                  list: state.friends ?? [],
                                  type: ListTypes.friends)
                              : state.selectedList == ListTypes.followers
                                  ? _buildListUsersWidet(
                                      list: state.followers ?? [],
                                      type: ListTypes.followers)
                                  : state.selectedList == ListTypes.requests
                                      ? _buildListUsersWidet(
                                          list: state.requests ?? [],
                                          type: ListTypes.requests)
                                      : _buildListUsersWidet(
                                          list: state.blocked ?? [],
                                          type: ListTypes.blocked))
                ],
              );
            }));
  }

  Widget _buildListUsersWidet({
    required List<UsersListEntity> list,
    required ListTypes type,
  }) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return ListItemCard(
            user: list[index].user,
            type: type,
          );
        });
  }

  Widget listItem({
    required String label,
    required IconData icon,
    required BuildContext context,
    required ListTypes type,
  }) {
    final controller = context.read<ListsCubit>();
    return BlocBuilder<ListsCubit, ListsState>(builder: (context, state) {
      bool selected = state.selectedList == type;
      return InkWell(
        onTap: () => controller.changeListType(type: type),
        child: Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: selected
                  ? AppColors.PRIMARY_COLOR
                  : AppColors.LIGHT_GRAY_COLOR,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 14,
                  color: selected ? Colors.white : Colors.black,
                ),
                const Sizer(
                  width: 5,
                ),
                Label(
                  text: label,
                  style: Styles.mediumText(
                      color: selected ? Colors.white : Colors.black),
                ),
              ],
            )),
      );
    });
  }
}
