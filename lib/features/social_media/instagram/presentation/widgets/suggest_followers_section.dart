import 'package:flutter/material.dart';
import '../../domain/entities/data_suggest_follow_instagram_entity.dart';
import 'discover_people_profile_instagram_list_view_item.dart';

class SuggestFollowersSection extends StatelessWidget {
  const SuggestFollowersSection({super.key, required this.suggestions});

  final List<SuggestionEntity> suggestions;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: ListView.separated(
        itemCount: suggestions.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsetsDirectional.only(
              start: index == 0 ? 10 : 0,
              end: index == 10 ? 10 : 0,
            ),
            child: DiscoverPeopleProfileInstagramListViewItem(
              suggest: suggestions[index],
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
          width: 16,
        ),
      ),
    );
  }
}
