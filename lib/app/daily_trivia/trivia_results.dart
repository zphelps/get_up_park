import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/daily_trivia/begin_trivia_view.dart';
import 'package:get_up_park/app/daily_trivia/controllers/quiz/quiz_controller.dart';
import 'package:get_up_park/app/daily_trivia/controllers/quiz/quiz_state.dart';
import 'package:get_up_park/app/daily_trivia/leaderboard/leaderboard_entry_model.dart';
import 'package:get_up_park/app/daily_trivia/models/question_model.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/shared_widgets/loading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/services/firestore_database.dart';

final leaderboardStreamProvider =
StreamProvider.autoDispose<List<LeaderboardEntry>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.leaderboardStream();
});

final userStreamProvider =
StreamProvider.autoDispose<PTUser>((ref) {
  final database = ref.watch(databaseProvider);
  return database.userStream();
});

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month
        && day == other.day;
  }
}

class QuizResults extends ConsumerWidget {

  const QuizResults({
    required this.state,
    required this.questions,
  });

  final QuizState state;
  final List<Question> questions;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final leaderboardAsyncValue = watch(leaderboardStreamProvider);
    final userAsyncValue = watch(userStreamProvider);
    final database = context.read<FirestoreDatabase>(databaseProvider);

    int rank = 0;

    LeaderboardEntry userEntry = LeaderboardEntry(id: 'id', score: 0, firstName: '--', lastName: '--', advisor: '--');

    return leaderboardAsyncValue.when(
      data: (leaderboard) {
        print(leaderboard);
        userAsyncValue.whenData((user) {
          final String uid = FirebaseAuth.instance.currentUser!.uid;
          for(Question question in state.correct) {
            FirebaseFirestore.instance.collection('questions').doc(question.id).update(
                {
                  'usersAsked': FieldValue.arrayUnion([uid]),
                });
          }
          for(Question question in state.incorrect) {
            FirebaseFirestore.instance.collection('questions').doc(question.id).update(
                {
                  'usersAsked': FieldValue.arrayUnion([uid]),
                });
          }
          bool addDateCompleted = true;
          for(String date in user.datesTriviaCompleted) {
            if(DateTime.parse(date).isSameDate(DateTime.now())) {
              addDateCompleted = false;
            }
          }
          if(addDateCompleted) {
            database.addTriviaDay(database.uid);
            database.updateLeaderboardEntry(user, state.score);
            database.updateAdvisoryLeaderboardEntry(user.advisor, state.score);
          }

          for(int i = 0; i < leaderboard.length; i++) {
            if(leaderboard[i].id == user.id) {
              rank = i+1;
              userEntry = leaderboard[i];
              // database.updateLeaderboardEntry(user, state.score);
            }

          }
        });

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            elevation: 1,
            automaticallyImplyLeading: false,
            title: const Text(
              'Results',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            iconTheme: const IconThemeData(
                color: Colors.black
            ),
          ),
          body: Column(
            children: [
              const SizedBox(height: 20),
              Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: InkWell(
                // onTap: () {
                //   Navigator.of(context, rootNavigator: true).pushNamed(
                //       AppRoutes.groupEventsView,
                //   );
                // },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 15,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.red, Colors.orange]
                        ),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "Today's score:",
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        '${state.score} pts!',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const Divider(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Correct ',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Text(
                              '${state.correct.length}',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 26,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 0.15,
                          height: 45,
                          color: Colors.grey,
                        ),
                        Column(
                          children: [
                            Text(
                              'Incorrect',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Text(
                              '${state.incorrect.length}',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 26,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Current Rank',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Text(
                              '$rank',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 26,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 0.15,
                          height: 45,
                          color: Colors.grey,
                        ),
                        Column(
                          children: [
                            Text(
                              'Current Score',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Text(
                              '${userEntry.score}',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 26,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.175), //0.35
                      spreadRadius: 0,
                      blurRadius: 30,
                      offset: const Offset(0, 4),
                    )
                  ]
                ),
              ),
              const SizedBox(height: 15.0),
              InkWell(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pushReplacementNamed(
                    AppRoutes.leaderboardView,
                  );
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // color: Colors.red,
                    gradient: const LinearGradient(
                      // colors: [Color(0xFFD4418E), Color(0xFF0652C5)],
                      colors: [Colors.red, Colors.orange],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: boxShadow,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.leaderboard,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Leaderboard',
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // context.read(timerProvider.notifier).reset();
                  context.read(quizControllerProvider.notifier).reset(context);
                  Navigator.of(context).popUntil((route) => !route.hasActiveRouteBelow);
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // color: Colors.red,
                    gradient: const LinearGradient(
                      // colors: [Color(0xFFD4418E), Color(0xFF0652C5)],
                      colors: [Colors.red, Colors.orange],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: boxShadow,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Return home',
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // CustomButton(
              //   title: 'Leaderboard',
              //   onTap: () {
              //     context.refresh(quizRepositoryProvider);
              //     context.read(quizControllerProvider.notifier).reset(context);
              //   },
              // ),
              // // const SizedBox(height: 15.0),
              // CustomButton(
              //   title: 'Return home',
              //   onTap: () {
              //     context.refresh(quizRepositoryProvider);
              //     context.read(quizControllerProvider.notifier).reset(context);
              //   },
              // ),
            ],
          )
        );
      },
      loading: () => LoadingNewsScroll(),
      error: (_,__) => EmptyContent(title: 'Error loading user data',),
    );
  }
}