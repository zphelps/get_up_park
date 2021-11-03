import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class AnnouncementTile extends StatelessWidget {

  final String title;
  final String body;
  final String url;
  final String date;

  const AnnouncementTile({required this.title, required this.body, required this.url, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('MMMEd').format(DateTime.parse(date)).toUpperCase(),
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: GoogleFonts.inter(
              fontSize: 13,
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
    );
  }
}
