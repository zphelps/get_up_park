import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/home/events/event_card.dart';
import 'package:get_up_park/app/home/events/upcoming_events_widget.dart';
import 'package:get_up_park/app/home/home/covid_card.dart';
import 'package:get_up_park/app/home/home/lunch_card.dart';
import 'package:get_up_park/app/home/home/lunch_widget.dart';
import 'package:get_up_park/app/home/news/cards/featured_news_card.dart';
import 'package:get_up_park/app/home/news/widgets/news_horizontal_scroll_widget.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/constants/strings.dart';
import 'package:get_up_park/routing/app_router.dart';

final userStreamProvider =
StreamProvider.autoDispose<PTUser>((ref) {
  final database = ref.watch(databaseProvider);
  return database.userStream();

});
class Home extends ConsumerWidget {

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final userAsyncValue = watch(userStreamProvider);

    return userAsyncValue.when(
      data: (user) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            brightness: Brightness.light,
            title: const Text(
              Strings.appName,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            toolbarHeight: 65,
            leadingWidth: 60,
            centerTitle: false,
            leading: const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: Image(
                image: AssetImage('assets/pantherHead.png'),
                height: 45,
                width: 45,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 1,
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pushNamed(
                      AppRoutes.settingsView,
                    );
                  },
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.grey[200],
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
          body: _buildContents(context, watch, user),
        );
      },
      loading: () {
        return Container(
          color: Colors.transparent,
        );
      },
      error: (_,__) {
        return EmptyContent();
      },
    );
  }

  Widget _buildContents(BuildContext context, ScopedReader watch, PTUser user) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          // const CovidCard(),
          // const SizedBox(height: 15),
          // const Divider(
          //   height: 1,
          // ),
          // const SizedBox(height: 12),
          LunchPreviewCard(date: DateTime.now().toString(), user: user),
          const SizedBox(height: 10),
          FeaturedNewsCard(admin: user.admin, category: 'Sports'),
          const SizedBox(height: 20),
          const UpcomingEventsWidget(),
          const SizedBox(height: 20),
          FeaturedNewsCard(admin: user.admin, category: 'Clubs'),
          const SizedBox(height: 20),
          FeaturedNewsCard(admin: user.admin, category: 'Administration'),
          const SizedBox(height: 20),
          FeaturedNewsCard(admin: user.admin, category: 'Student Council'),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}