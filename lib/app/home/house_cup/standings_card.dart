import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/events/event_list_widget.dart';
import 'package:get_up_park/app/home/house_cup/standings_list_widget.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class StandingsCard extends StatelessWidget {
  const StandingsCard({required this.user});

  final PTUser user;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15 ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: AutoSizeText(
                      '2021 House Cup!',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    // height: 50,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: AutoSizeText(
                      "Four teams will compete to become the first-ever Park Tudor House Cup Champions!",
                      maxFontSize: 14,
                      maxLines: 3,
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  // const SizedBox(height: 8),
                  // Text(
                  //   'Learn More',
                  //   style: GoogleFonts.inter(
                  //     color: Colors.red,
                  //     fontSize: 16,
                  //     fontWeight: FontWeight.w800,
                  //   ),
                  // ),
                ],
              ),
              Image(
                image: AssetImage('assets/houseCup.jpg'),
                // height: 100,
                width: MediaQuery.of(context).size.width * 0.225,
              ),
            ],
          ),
          const Divider(height: 30, thickness: 0.75,),
          const Text(
            "Current Standings",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          StandingsListWidget(),
        ],
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
    );
  }
}
