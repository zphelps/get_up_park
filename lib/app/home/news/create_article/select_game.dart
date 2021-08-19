import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/list_items_builder.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/home/groups/groups.dart';
import 'package:get_up_park/app/home/news/create_article/select_group_tile.dart';
import 'package:get_up_park/app/home/sports/sports.dart';
import 'package:get_up_park/app/home/sports/widgets/sports_vertical_scroll_widget.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/app/user_model.dart';

class SelectGame extends StatelessWidget {
  const SelectGame({required this.selectedGroup});

  final String selectedGroup;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        title: const Text(
          'Select Game',
          style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(child: SportsVerticalScrollWidget(
          user: PTUser(email: '', admin: '', id: '', groupsFollowing: [], firstName: '', datesTriviaCompleted: [], lastName: '', advisor: '', groupsUserCanAccess: []),
          selectGame: true,
          selectedGroup: selectedGroup)
      ),
    );
  }
}
