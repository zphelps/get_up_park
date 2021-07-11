import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/home/events/calendar_event_list_tile.dart';
import 'package:get_up_park/app/home/events/event_list_tile.dart';
import 'package:get_up_park/app/home/events/event_model.dart';
import 'package:get_up_park/app/home/events/group_events_card.dart';
import 'package:get_up_park/app/home/events/upcoming_event_tile.dart';
import 'package:get_up_park/app/home/home/lunch_model.dart';
import 'package:get_up_park/app/home/news/article_model.dart';
import 'package:get_up_park/app/home/news/old_files/large_news_card.dart';
import 'package:get_up_park/shared_widgets/vertical_list_builder.dart';
import 'package:get_up_park/app/top_level_providers.dart';


final lunchStreamProvider = StreamProvider.autoDispose<List<Lunch>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.lunchStream();
});

// watch database
class LunchListWidget extends ConsumerWidget {

  LunchListWidget({required this.date, required this.itemCount});

  final String date;
  final int itemCount;

  bool sortingLunch = true;

  @override
  Widget build(BuildContext context, ScopedReader watch) {

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
        child: _buildContents(context, watch)
    );
  }



  Widget _buildContents(BuildContext context, ScopedReader watch) {
    final lunchAsyncValue = watch(lunchStreamProvider);

    List<dynamic> lunchItems = [];

    lunchAsyncValue.whenData((lunches)  {
      for(Lunch lunch in lunches) {
        if(DateTime.parse(lunch.date).day == DateTime.now().day && DateTime.parse(lunch.date).month == DateTime.now().month) {
          lunchItems = lunch.items;
        }
      }

    });

    if(lunchItems.isEmpty) {
      return EmptyContent(title: 'Lunch menu not available', message: 'Please check back later.', center: true);
    }


    return ListView.separated(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount == 0 ? lunchItems.length : itemCount,
      separatorBuilder: (context, index) {
        return const Divider(height: 8);
      },
      itemBuilder: (context, index) {
        return Text(
            lunchItems[index],
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black
          ),
        );
      },
    );

  }
}
