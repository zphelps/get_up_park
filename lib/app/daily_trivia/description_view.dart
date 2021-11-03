import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/daily_trivia/leaderboard/advisory_leaderboard_entry_model.dart';
import 'package:get_up_park/app/daily_trivia/leaderboard/leaderboard_entry_cards.dart';
import 'package:get_up_park/app/daily_trivia/leaderboard/leaderboard_entry_model.dart';
import 'package:get_up_park/app/daily_trivia/models/description_model.dart';
import 'package:get_up_park/app/home/settings/user_tile.dart';
import 'package:get_up_park/app/sign_in/register_user_view.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/constants/strings.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/services/firestore_database.dart';
import 'package:get_up_park/shared_widgets/loading.dart';
import 'package:google_fonts/google_fonts.dart';

final descriptionStreamProvider =
StreamProvider.autoDispose<Description>((ref) {
  final database = ref.watch(databaseProvider);
  return database.descriptionStream();
});


// watch database
class DescriptionView extends ConsumerWidget {

  const DescriptionView();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final descriptionAsyncValue = watch(descriptionStreamProvider);
    return descriptionAsyncValue.when(
      data: (description) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              brightness: Brightness.light,
              elevation: 1,
              title: const Text(
                'About Daily Trivia',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              iconTheme: IconThemeData(
                  color: Colors.black
              ),
            ),

            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How it works',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.black
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description.description,
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[700]
                      ),
                    ),
                  ],

                ),
              ),
            )

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
