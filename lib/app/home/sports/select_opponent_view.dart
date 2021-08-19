


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/list_items_builder.dart';
import 'package:get_up_park/app/home/sports/opponent_model.dart';
import 'package:get_up_park/app/home/sports/tiles/select_opponent_tile.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/routing/app_router.dart';

// watch database
class SelectOpponentView extends ConsumerWidget {

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        title: const Text(
          'Select Opponent',
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
        actions: [
            IconButton(
            padding: const EdgeInsets.only(right: 16),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pushNamed(
                AppRoutes.createOpponentView,
              );
            },
            icon: const Icon(
                Icons.add_circle_outline
            ),
          ),
        ],
      ),
      body: _buildContents(context, watch),
    );
    //print(user.uid);
  }

  Widget _buildContents(BuildContext context, ScopedReader watch) {
    final opponentsAsyncValue = watch(opponentsStreamProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListItemsBuilder<Opponent>(
          data: opponentsAsyncValue,
          itemBuilder: (context, opponent) => SelectOpponentTile(opponent: opponent)
      ),
    );
  }
}