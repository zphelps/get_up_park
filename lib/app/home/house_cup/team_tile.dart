import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/house_cup/team_model.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:google_fonts/google_fonts.dart';

Color? getTeamColor(String teamName) {
  if(teamName == 'Red') {
    return Colors.red;
  }
  else if(teamName == 'Black') {
    return Colors.black;
  }
  else if(teamName == 'Green') {
    return Colors.green;
  }
  else if(teamName == 'White') {
    return Colors.grey[100];
  }
  return Colors.white;
}

class TeamTile extends StatelessWidget {
  const TeamTile({required this.team, required this.rank});

  final Team team;
  final int rank;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        dense: true,
        onTap: () {
          Navigator.of(context, rootNavigator: true).pushNamed(
            AppRoutes.houseCupTeamAdvisoriesView,
            arguments: {
              'team': team,
            }
          );
        },
        contentPadding: const EdgeInsets.only(left: 10),
        minVerticalPadding: 0,
        horizontalTitleGap: 0,
        visualDensity: const VisualDensity(vertical: -4),
        leading: SizedBox(
          width: MediaQuery.of(context).size.width * 0.1,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$rank',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              // const SizedBox(width: 15),
              const Spacer(),
              Container(
                width: 5,
                color: getTeamColor(team.name),
              ),
              const SizedBox(width: 10),
              // const SizedBox(width: 0),
              // Text(
              //       () {
              //     if(rank == 1) {
              //       return 'st';
              //     }
              //     else if(rank == 2) {
              //       return 'nd';
              //     }
              //     else if(rank == 3) {
              //       return 'rd';
              //     }
              //     return 'th';
              //   }(),
              //   style: GoogleFonts.inter(
              //     fontSize: 12,
              //     fontWeight: FontWeight.w800,
              //     color: Colors.black,
              //   ),
              // ),
            ],
          ),
        ),
        title: Text(
          '${team.name}',
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
        trailing: SizedBox(
          width: MediaQuery.of(context).size.width * 0.35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  '${team.score} pts',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 14
                  ),
                ),
              ),
              Icon(
                  Icons.chevron_right
              ),
            ],
          ),
        ),
      ),
    );
  }
}
