import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/daily_trivia/leaderboard/advisory_leaderboard_entry_model.dart';
import 'package:get_up_park/app/daily_trivia/leaderboard/leaderboard_entry_cards.dart';
import 'package:get_up_park/app/daily_trivia/leaderboard/leaderboard_entry_model.dart';
import 'package:get_up_park/app/home/settings/user_tile.dart';
import 'package:get_up_park/app/sign_in/register_user_view.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/constants/strings.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/shared_widgets/loading.dart';
import 'package:google_fonts/google_fonts.dart';

final userStreamProvider =
StreamProvider.autoDispose<PTUser>((ref) {
  final database = ref.watch(databaseProvider);
  return database.userStream();
});

final leaderboardStreamProvider =
StreamProvider.autoDispose<List<LeaderboardEntry>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.leaderboardStream();
});

final advisoryLeaderboardStreamProvider =
StreamProvider.autoDispose<List<AdvisoryLeaderboardEntry>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.advisoryLeaderboardStream();
});

// watch database
class Leaderboard extends ConsumerWidget {

  const Leaderboard({required this.scrollController, required this.hideAppBar});

  final ScrollController scrollController;
  final bool hideAppBar;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final userAsyncValue = watch(userStreamProvider);
    final leaderboardAsyncValue = watch(leaderboardStreamProvider);
    final advisoryLeaderboardAsyncValue = watch(advisoryLeaderboardStreamProvider);
    return userAsyncValue.when(
      data: (user) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              brightness: Brightness.light,
              elevation: 1,
              centerTitle: true,
              title: const Text(
                'Leaderboard',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              iconTheme: IconThemeData(
                  color: hideAppBar ? Colors.white : Colors.black
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).pushNamed(
                        AppRoutes.descriptionView,
                      );
                    },
                    child: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.black,
                        size: 22,
                      ),
                    ),
                  ),
                ),
                () {
                  if(user.admin == userTypes[0]) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).pushNamed(
                            AppRoutes.allQuestionsView,
                          );
                        },
                        child: const CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.more_horiz,
                            color: Colors.black,
                            size: 22,
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox(height: 0);
                }(),

              ],
              bottom: TabBar(
                labelColor: Colors.red,
                labelStyle: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                ),

                unselectedLabelColor: Colors.grey[800],
                unselectedLabelStyle: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                ),
                tabs: [
                  const Tab(
                    text: 'Individual',

                  ),
                  const Tab(
                    text: 'Advisory',
                  ),
                ],
              ),
            ),

            body: TabBarView(
              children: [
                SingleChildScrollView(controller: scrollController,child: LoadIndividualLeaderboardView(leaderboardAsyncValue: leaderboardAsyncValue)),
                SingleChildScrollView(controller: scrollController, child: LoadAdvisoryLeaderboardView(advisoryLeaderboardAsyncValue: advisoryLeaderboardAsyncValue)),
              ],
            ),
            bottomNavigationBar: SizedBox(
              height: MediaQuery.of(context).size.height * 0.115,
              width: MediaQuery.of(context).size.width,
              child: UserLeaderboardEntryCard(leaderboardAsyncValue: leaderboardAsyncValue, user: user,)
            ),
          ),
        );
      },
      loading: () =>
          Container(
            color: Colors.transparent,
          ),
      error: (_, __) {
        return EmptyContent();
      },
    );
  }
}

class LoadIndividualLeaderboardView extends StatefulWidget {
  const LoadIndividualLeaderboardView({required this.leaderboardAsyncValue});

  final AsyncValue<List<LeaderboardEntry>> leaderboardAsyncValue;

  @override
  _LoadIndividualLeaderboardViewState createState() => _LoadIndividualLeaderboardViewState();
}

class _LoadIndividualLeaderboardViewState extends State<LoadIndividualLeaderboardView> {

  bool loadingData = true;

  List<LeaderboardEntry> allEntries = [];

  @override
  Widget build(BuildContext context) {

    widget.leaderboardAsyncValue.whenData((entries) async {
      if(allEntries.length != entries.length) {
        allEntries.clear();
        setState(() {
          allEntries = entries;
        });

        Timer(const Duration(milliseconds: 100), () {
          setState(() {
            loadingData = false;
          });
        });
      }
    });

    if(loadingData) {
      return const LoadingGroupsScroll();
    }

    return ListView.builder(
        itemCount: allEntries.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 10),
        itemBuilder: (context, index) {
          return LeaderboardEntryCard(leaderboardEntry: allEntries[index], rank: index + 1);
        }
    );
  }
}

class LoadAdvisoryLeaderboardView extends StatefulWidget {
  const LoadAdvisoryLeaderboardView({required this.advisoryLeaderboardAsyncValue});

  final AsyncValue<List<AdvisoryLeaderboardEntry>> advisoryLeaderboardAsyncValue;

  @override
  _LoadAdvisoryLeaderboardViewState createState() => _LoadAdvisoryLeaderboardViewState();
}

class _LoadAdvisoryLeaderboardViewState extends State<LoadAdvisoryLeaderboardView> {

  bool loadingData = true;

  List<AdvisoryLeaderboardEntry> allEntries = [];

  // Map<String, int> advisoryLeaderboardEntries = {};

  @override
  Widget build(BuildContext context) {

    widget.advisoryLeaderboardAsyncValue.whenData((entries) async {

      if(allEntries.length != entries.length) {
        allEntries.clear();
        setState(() {
          allEntries = entries;
        });

        Timer(const Duration(milliseconds: 100), () {
          setState(() {
            loadingData = false;
          });
        });
      }
    });

    if(loadingData) {
      return const LoadingGroupsScroll();
    }

    return ListView.builder(
        itemCount: allEntries.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 10),
        itemBuilder: (context, index) {
          return AdvisoryLeaderboardEntryCard(advisory: allEntries[index].advisor, score: allEntries[index].score, rank: index + 1);
        }
    );
  }
}
