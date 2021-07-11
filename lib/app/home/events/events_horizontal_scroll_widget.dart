import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/home/events/event_card.dart';
import 'package:get_up_park/app/home/events/event_model.dart';
import 'package:get_up_park/app/home/news/article_model.dart';
import 'package:get_up_park/app/home/news/cards/small_news_card.dart';
import 'package:get_up_park/shared_widgets/horizontal_list_builder.dart';
import 'package:get_up_park/app/top_level_providers.dart';


// final userStreamProvider =
// StreamProvider.autoDispose.family<PTUser, String>((ref, userID) {
//   print(userID);
//   final database = ref.watch(databaseProvider);
//   return database.userStream(userID: userID);
// });


final eventsStreamProvider = StreamProvider.autoDispose<List<Event>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.eventsStream();
});

// watch database
class EventsHorizontalScrollWidget extends ConsumerWidget {
  // Future<void> _delete(BuildContext context, Job job) async {
  //   try {
  //     final database = context.read<FirestoreDatabase>(databaseProvider);
  //     await database.deleteJob(job);
  //   } catch (e) {
  //     unawaited(showExceptionAlertDialog(
  //       context: context,
  //       title: 'Operation failed',
  //       exception: e,
  //     ));
  //   }
  // }

  EventsHorizontalScrollWidget({this.group = 'none', this.excludedEventID = 'none'});

  final String group;
  final String excludedEventID;

  @override
  Widget build(BuildContext context, ScopedReader watch) {

    return Column(
      children: [
        //const SizedBox(height: 15),
        SizedBox(
          height: 170,
          width: MediaQuery.of(context).size.width,
          child: _buildContents(context, watch)
        ),
      ],
    );
    //print(user.uid);
  }

  Widget _buildContents(BuildContext context, ScopedReader watch) {
    final eventsAsyncValue = watch(eventsStreamProvider);
    return HorizontalListBuilder<Event>(
      data: eventsAsyncValue,
      itemBuilder: (context, event) {
        if(event.group == group && event.id != excludedEventID) {
          return EventCard(event: event);
        }
        return const SizedBox(width: 0);
      }
    );
  }
}