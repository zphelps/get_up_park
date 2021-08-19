import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/daily_trivia/begin_trivia_view.dart';
import 'package:get_up_park/app/home/events/upcoming_events_card.dart';
import 'package:get_up_park/app/home/home/welcome_card.dart';
import 'package:get_up_park/app/home/house_cup/standings_card.dart';
import 'package:get_up_park/app/home/news/cards/featured_news_card.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/constants/strings.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends ConsumerWidget {

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final userAsyncValue = watch(userStreamProvider);

    return userAsyncValue.when(
      data: (user) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
              brightness: Brightness.light,
              title: Text(
                Strings.appName,
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                ),
              ),
              toolbarHeight: 55,
              leadingWidth: 60,
              centerTitle: false,
              leading: const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                child: Image(
                  // fit: BoxFit.fitWidth,
                  image: AssetImage('assets/pantherHeadLowRes.png'),
                  height: 45,
                  width: 45,
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              forceElevated: true,
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).pushNamed(
                          AppRoutes.settingsView,
                          arguments: {
                            'user': user,
                          }
                      );
                    },
                    child: CircleAvatar(
                      radius: 19,
                      backgroundColor: const Color(0xffE4E5EA).withOpacity(0.75),
                      child: const Icon(
                        Icons.settings,
                        color: Colors.black,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ],
                ),
                SliverList(
                  delegate: SliverChildListDelegate.fixed(
                    [
                      _buildContents(context, watch, user),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () {
        return Container(
          color: Colors.transparent,
        );
      },
      error: (e,stack) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                EmptyContent(title: 'Oh No!', message: 'A problem has occurred.'),
                CustomButton(title: 'Debug issue', onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context, rootNavigator: true).popUntil((route) => !route.hasActiveRouteBelow);
                  Navigator.of(context, rootNavigator: true).pushReplacementNamed(AppRoutes.authOptions);
                }
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContents(BuildContext context, ScopedReader watch, PTUser user) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 18),
          // const CovidCard(),
          // const SizedBox(height: 15),
          // const Divider(
          //   height: 1,
          // ),
          // const SizedBox(height: 12),

          WelcomeCard(date: DateTime.now().toString(), user: user),
          const SizedBox(height: 15),
          // const CovidCard(),
          // const SizedBox(height: 20),
          UpcomingEventsCard(user: user),

          const SizedBox(height: 25),
          StandingsCard(user: user),
          const SizedBox(height: 25),
          FeaturedNewsCard(user: user, category: 'Student Council'),
          const SizedBox(height: 25),
          FeaturedNewsCard(user: user, category: 'Clubs'),
          const SizedBox(height: 25),
          FeaturedNewsCard(user: user, category: 'Sports'),
          const SizedBox(height: 25),
          FeaturedNewsCard(user: user, category: 'Administration'),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}