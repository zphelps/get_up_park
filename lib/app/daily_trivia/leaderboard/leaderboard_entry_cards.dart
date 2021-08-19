import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/daily_trivia/leaderboard/leaderboard_entry_model.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaderboardEntryCard extends StatelessWidget {
  const LeaderboardEntryCard({required this.leaderboardEntry, required this.rank});

  final int rank;
  final LeaderboardEntry leaderboardEntry;

  @override
  Widget build(BuildContext context) {
    RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    Function mathFunc = (Match match) => '${match[1]},';
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              // color: Colors.black.withOpacity(0.125),
              // spreadRadius: 0,
              // blurRadius: 5,
              // offset: const Offset(0, 1), // changes position of shadow
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 15,
              offset: const Offset(0, 2),
            ),
          ]
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.only(left: 10),
        minVerticalPadding: 0,
        horizontalTitleGap: 10,
        visualDensity: const VisualDensity(vertical: 0),
        leading: SizedBox(
          width: MediaQuery.of(context).size.width * 0.125,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                '$rank',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 0),
              AutoSizeText(
                    () {
                  if(rank % 10 == 1 && rank % 100 != 1) {
                    return 'st';
                  }
                  else if(rank % 10 == 2 && rank % 100 != 1) {
                    return 'nd';
                  }
                  else if(rank % 10 == 3 && rank % 100 != 1) {
                    return 'rd';
                  }
                  return 'th';
                }(),
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        title: Text(
          '${leaderboardEntry.firstName} ${leaderboardEntry.lastName}',
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 0),
            Text(
              leaderboardEntry.advisor,
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            '${leaderboardEntry.score.toString().replaceAllMapped(reg, mathFunc as String Function(Match))} pts',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontSize: 14
            ),
          ),
        ),
      ),
    );
  }
}

class AdvisoryLeaderboardEntryCard extends StatelessWidget {
  const AdvisoryLeaderboardEntryCard({required this.advisory, required this.score, required this.rank});

  final int rank;
  final String advisory;
  final int score;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              // color: Colors.black.withOpacity(0.125),
              // spreadRadius: 0,
              // blurRadius: 5,
              // offset: const Offset(0, 1), // changes position of shadow
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 15,
              offset: const Offset(0, 2),
            ),
          ]
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.only(left: 10),
        minVerticalPadding: 0,
        horizontalTitleGap: 10,
        visualDensity: const VisualDensity(vertical: 2),
        leading: SizedBox(
          width: MediaQuery.of(context).size.width * 0.125,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                '$rank',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 0),
              AutoSizeText(
                    () {
                  if(rank == 1) {
                    return 'st';
                  }
                  else if(rank == 2) {
                    return 'nd';
                  }
                  else if(rank == 3) {
                    return 'rd';
                  }
                  return 'th';
                }(),
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        title: Text(
          advisory,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        // subtitle: Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     const SizedBox(height: 0),
        //     Text(
        //       leaderboardEntry.advisor,
        //     ),
        //   ],
        // ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            // gradient: LinearGradient(
            //   // colors: [Color(0xFFD4418E), Color(0xFF0652C5)],
            //   colors: [Colors.red.withOpacity(0.9), Colors.orange.withOpacity(0.9)],
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            // ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            '${score} pts',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 14
            ),
          ),
        ),
      ),
    );
  }
}

class UserLeaderboardEntryCard extends StatelessWidget {
  const UserLeaderboardEntryCard({required this.leaderboardAsyncValue, required this.user});

  final PTUser user;
  final AsyncValue<List<LeaderboardEntry>> leaderboardAsyncValue;

  @override
  Widget build(BuildContext context) {
    RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    Function mathFunc = (Match match) => '${match[1]},';
    return leaderboardAsyncValue.when(
      data: (leaderboardEntries) {
        int rank = 0;
        LeaderboardEntry userEntry = const LeaderboardEntry(id: 'id', score: 0, firstName: '-------', lastName: '-------', advisor: '--------');
        for(int i = 0; i < leaderboardEntries.length; i++) {
          if(leaderboardEntries[i].id == user.id) {
            rank = i+1;
            userEntry = leaderboardEntries[i];
            // database.updateLeaderboardEntry(user, state.score);
          }

        }
        return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  // color: Colors.black.withOpacity(0.125),
                  // spreadRadius: 0,
                  // blurRadius: 5,
                  // offset: const Offset(0, 1), // changes position of shadow
                  color: Colors.black.withOpacity(0.15),
                  spreadRadius: 1,
                  blurRadius: 15,
                  offset: const Offset(0, 2),
                ),
              ]
          ),
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          child: ListTile(
            dense: true,
            contentPadding: const EdgeInsets.only(left: 10),
            minVerticalPadding: 15,
            horizontalTitleGap: 10,
            visualDensity: const VisualDensity(vertical: 0),
            leading: SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$rank',
                    style: GoogleFonts.inter(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 0),
                  Text(
                        () {
                      if(rank == 1) {
                        return 'st';
                      }
                      else if(rank == 2) {
                        return 'nd';
                      }
                      else if(rank == 3) {
                        return 'rd';
                      }
                      return 'th';
                    }(),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            title: Text(
              '${userEntry.firstName} ${userEntry.lastName}',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 0),
                Text(
                  userEntry.advisor,
                ),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                '${userEntry.score.toString().replaceAllMapped(reg, mathFunc as String Function(Match))} pts',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 14
                ),
              ),
            ),
          ),
        );
      },
      loading: () {
        return Container();
      },
      error: (_,__) {
        return EmptyContent(message: 'Error loading leaderboard data',);
      }
    );

  }
}