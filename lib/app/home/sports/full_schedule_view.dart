import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/home/sports/widgets/game_schedule_list_widget.dart';
import 'package:get_up_park/routing/app_router.dart';


class FullScheduleView extends StatelessWidget {
  const FullScheduleView({required this.group, required this.admin});

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
          '${group.name} Schedule',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
              () {
            if(admin == 'true') {
              return IconButton(
                padding: const EdgeInsets.only(right: 16),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pushNamed(
                      AppRoutes.createGameView,
                      arguments: {
                        'group': group,
                      }
                  );
                },
                icon: const Icon(
                    Icons.add_circle_outline
                ),
              );
            }
            return const SizedBox(width: 0);
          }(),
        ],
        elevation: 1,
      ),
      body: SingleChildScrollView(child: GameScheduleListWidget(group: group, groupName: group.name, admin: admin, selectGame: false)),
    );
  }
}
