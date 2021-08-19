import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/cover_screen/cover_screen_model.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/services/firestore_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class AppCoverScreen extends StatefulWidget {
  const AppCoverScreen({required this.coverScreenData});

  final CoverScreen coverScreenData;

  @override
  _AppCoverScreenState createState() => _AppCoverScreenState();
}

class _AppCoverScreenState extends State<AppCoverScreen> {

  DateTime estimateTs = DateTime(2021, 12, 10, 8, 5); // set needed date

  @override
  void initState() {
    super.initState();
    if(widget.coverScreenData.countdownDate != '') {
      setState(() {
        estimateTs = DateTime.parse(widget.coverScreenData.countdownDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: widget.coverScreenData.countdownDate == '' ?
      Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.125,),
            const Image(
              image: AssetImage('assets/pantherLaunch.png'),
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 6),
            Text(
              widget.coverScreenData.title,
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.coverScreenData.message,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ) : StreamBuilder(
          stream: Stream.periodic(const Duration(seconds: 1), (i) => i),
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            var timeDiff = estimateTs.difference(DateTime.now()).inSeconds;
            int days = timeDiff ~/ (24 * 60 * 60) % 24;
            int hours = timeDiff ~/ (60 * 60) % 24;
            int minutes = (timeDiff ~/ 60) % 60;
            int seconds = timeDiff % 60;
            if(DateTime.parse(widget.coverScreenData.countdownDate).difference(DateTime.now()).inSeconds <= 0) {
              print('changing');
              final database = context.read<FirestoreDatabase>(databaseProvider);
              database.setAppLive();
            }
            return Center(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.125,),
                  const Image(
                    image: AssetImage('assets/pantherLaunch.png'),
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.coverScreenData.title,
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.coverScreenData.message,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    padding: const EdgeInsets.fromLTRB(15, 8, 15, 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          spreadRadius: 0,
                          blurRadius: 16,
                          offset: const Offset(0, 0),
                        )
                      ]
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                                '$days',
                              style: GoogleFonts.inter(
                                fontSize: 48,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              'DAYS',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.075),
                        Column(
                          children: [
                            Text(
                              '$hours',
                              style: GoogleFonts.inter(
                                fontSize: 48,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              'HOURS',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.075),
                        Column(
                          children: [
                            Text(
                              '$minutes',
                              style: GoogleFonts.inter(
                                fontSize: 48,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              'MINUTES',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.075),
                        Column(
                          children: [
                            Text(
                              '$seconds',
                              style: GoogleFonts.inter(
                                fontSize: 48,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              'SECONDS',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
