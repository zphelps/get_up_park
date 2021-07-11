import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/home/sports/widgets/game_results_list_widget.dart';


class AllGameResultsView extends StatelessWidget {
  const AllGameResultsView({required this.group, required this.admin});

  final Group group;
  final String admin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text(
          '${group.name} Results',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevation: 1,
      ),
      body: GameResultsListWidget(groupName: group.name, group: group, admin: admin),
    );
  }
}
