import 'package:flutter/material.dart';
import 'package:get_up_park/app/announcements/list_items_builder.dart';
import 'package:get_up_park/app/home/house_cup/team_model.dart';
import 'package:get_up_park/app/home/house_cup/team_tile.dart';
import 'package:google_fonts/google_fonts.dart';

class TeamAdvisoriesView extends StatelessWidget {
  const TeamAdvisoriesView({required this.team});

  final Team team;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        brightness: team.name == 'White' ? Brightness.light : Brightness.dark,
        backgroundColor: getTeamColor(team.name),
        iconTheme: IconThemeData(
          color: team.name == 'White' ? Colors.black : Colors.white,
        ),
        title: Text(
          '${team.name} Team Advisories',
          style: GoogleFonts.inter(
            color: team.name == 'White' ? Colors.black : Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: ListView.separated(
          itemCount: team.advisories.length,
          separatorBuilder: (context, index) {
            return const Divider(height: 30);
          },
          itemBuilder: (context, index) {
            return Text(
              team.advisories[index],
              style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            );
          },
        ),
      )
    );
  }
}
