import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/home/house_cup/team_tile.dart';
import 'package:get_up_park/app/top_level_providers.dart';

class StandingsListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final houseCupTeamsAsyncValue = watch(houseCupTeamsStreamProvider);

    return houseCupTeamsAsyncValue.when(
      data: (teams) {
        return ListView.separated(
          itemCount: teams.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (context, index) {
            return const Divider(height: 8, thickness: 0.75,);
          },
          itemBuilder: (context, index) {
            return TeamTile(team: teams[index], rank: index + 1);
          },
        );
      },
      loading: () => Container(),
      error: (_,__) => EmptyContent(title: 'Error loading team standings',)
    );
  }

}