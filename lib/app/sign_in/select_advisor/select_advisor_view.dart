


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/list_items_builder.dart';
import 'package:get_up_park/app/home/sports/opponent_model.dart';
import 'package:get_up_park/app/home/sports/tiles/select_opponent_tile.dart';
import 'package:get_up_park/app/sign_in/select_advisor/advisor_model.dart';
import 'package:get_up_park/app/sign_in/select_advisor/select_advisor_tile.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/shared_widgets/vertical_list_builder.dart';

// watch database
class SelectAdvisorView extends ConsumerWidget {

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        title: const Text(
          'Select advisor',
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
        // actions: [
        //   IconButton(
        //     padding: const EdgeInsets.only(right: 16),
        //     onPressed: () {
        //       Navigator.of(context, rootNavigator: true).pushNamed(
        //         AppRoutes.createOpponentView,
        //       );
        //     },
        //     icon: const Icon(
        //         Icons.add_circle_outline
        //     ),
        //   ),
        // ],
      ),
      body: _buildContents(context, watch),
    );
    //print(user.uid);
  }

  Widget _buildContents(BuildContext context, ScopedReader watch) {
    final advisorAsyncValue = watch(advisorStreamProvider);
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),
          InkWell(
            onTap: () async {
              HapticFeedback.heavyImpact();
              Navigator.pop(context, {
                'advisor': 'Parent/Other',
                'advisorImageURL': '',
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Row(
                children: [
                  const Text(
                    'Parent/Other',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 24,
                      offset: const Offset(0, 2), // changes position of shadow
                    ),
                  ]
              ),
            ),
          ),
          VerticalListBuilder<Advisor>(
              data: advisorAsyncValue,
              itemBuilder: (context, advisor) => SelectAdvisorTile(advisor: advisor)
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}