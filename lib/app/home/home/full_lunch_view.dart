import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/home/lunch_list_widget.dart';
import 'package:intl/intl.dart';

class FullLunchView extends StatelessWidget {
  const FullLunchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        title: Text(
          "${DateFormat.EEEE().format(DateTime.now())}'s Lunch Menu",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),
            LunchListWidget(date: DateTime.now().toString(), itemCount: 0),
          ],
        ),
      ),
    );
  }
}
