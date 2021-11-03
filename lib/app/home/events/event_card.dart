import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/events/event_model.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  const EventCard({required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 235,
      // height: 150,
      margin: const EdgeInsets.fromLTRB(15, 5, 15, 10),
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () {
          Navigator.of(context, rootNavigator: true).pushNamed(
              AppRoutes.eventView,
              arguments: {
                'event': event,
              }
          );
        },
        child: Column(
          children: [
            () {
              if(event.imageURL != '') {
                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)), //5
                      child: CachedNetworkImage(
                        memCacheHeight: 3000,
                        memCacheWidth: 3000,
                        imageUrl: event.imageURL,
                        fadeOutDuration: Duration.zero,
                        placeholderFadeInDuration: Duration.zero,
                        fadeInDuration: Duration.zero,
                        fit: BoxFit.fitWidth,
                        // width: 374,
                        width: MediaQuery.of(context).size.width * 0.95,
                        height: 175,
                        placeholder: (context, url) => const Image(image: AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              }
              return const SizedBox(height: 18);
            }(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(
                        DateFormat.d().format(DateTime.parse(event.date)),
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        DateFormat.MMM().format(DateTime.parse(event.date)).toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${DateFormat.MMMEd().format(DateTime.parse(event.date)).toUpperCase()} AT ${DateFormat.jm().format(DateTime.parse(event.date))}',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: AutoSizeText(
                          event.title,
                          maxLines: 2,
                          minFontSize: 18,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      // Text(
                      //   '${DateFormat.MMMEd().format(DateTime.parse(event.date)).toUpperCase()} | ${DateFormat.jm().format(DateTime.parse(event.date))}',
                      //   style: GoogleFonts.inter(
                      //     color: Colors.grey[700],
                      //     fontWeight: FontWeight.w400,
                      //     fontSize: 12,
                      //   ),
                      // ),
                      // const SizedBox(height: 2),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: Text(
                          event.location.contains('www') || event.location.contains('http') ? 'Online' : event.location.split(', ')[0],
                          style: GoogleFonts.inter(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 0),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              // color: Colors.black.withOpacity(0.1),
              // spreadRadius: 1,
              // blurRadius: 5,
              // offset: const Offset(0, 1),
              color: Colors.black.withOpacity(0.115),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ]
      ),
    );
  }
}
