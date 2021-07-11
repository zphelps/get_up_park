import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/events/event_list_widget.dart';


class AllUpcomingEventsView extends StatelessWidget {
  const AllUpcomingEventsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        elevation: 1,
        title: const Text(
          'Upcoming Events',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: EventListWidget(),
      ),
    );
  }
}
