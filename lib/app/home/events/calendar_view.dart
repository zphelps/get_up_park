import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/home/events/calendar_event_list_tile.dart';
import 'package:get_up_park/app/home/events/event_model.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:table_calendar/table_calendar.dart';


/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
        (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kNow = DateTime.now();
final kFirstDay = DateTime(kNow.year, kNow.month - 3, kNow.day);
final kLastDay = DateTime(kNow.year, kNow.month + 3, kNow.day);

class CalendarView extends StatefulWidget {

  CalendarView({required this.events, required this.admin});

  final List<dynamic> events;
  final String admin;

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  // List<Event>? _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    // _selectedEvents = _getEventsForDay(_selectedDay!);
    prevPageEvents = _getEventsForDay(DateTime.now());
  }

  @override
  void dispose() {
    // _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    List<Event> eventsForDay = [];
    for(Event event in widget.events) {
      if(day.isSameDate(DateTime.parse(event.date))) {
        eventsForDay.add(event);
      }
    }
    return eventsForDay;
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  int lastPageIndex = daysInRange(kFirstDay, kLastDay).length ~/ 2;
  List<Event>? prevPageEvents;

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(initialPage: lastPageIndex);
    return Column(
      children: [
        TableCalendar<Event>(
          availableCalendarFormats: {
            CalendarFormat.month: 'month',
            CalendarFormat.week: 'week',
          },
          headerStyle: const HeaderStyle(
            formatButtonTextStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          firstDay: kFirstDay,
          lastDay: kLastDay,
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          rangeStartDay: _rangeStart,
          rangeEndDay: _rangeEnd,
          calendarFormat: _calendarFormat,
          rangeSelectionMode: _rangeSelectionMode,
          eventLoader: _getEventsForDay,
          startingDayOfWeek: StartingDayOfWeek.sunday,
          calendarStyle: CalendarStyle(
            todayTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
            weekendTextStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
            defaultTextStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
            selectedTextStyle: TextStyle(
              color: _selectedDay!.day == DateTime.now().day ? Colors.white : Colors.red,
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
            selectedDecoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _selectedDay!.day == DateTime.now().day ? Colors.red : Colors.transparent,
              border: Border.all(color: Colors.red, width: 2),
            ),
            todayDecoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
            // Use `CalendarStyle` to customize the UI
            markersMaxCount: 2,
            markerSize: 4,
            markerDecoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle
            ),
            markersAnchor: 2.35,
            markerMargin: const EdgeInsets.symmetric(horizontal: 1),
            outsideDaysVisible: false,
          ),
          onDaySelected: _onDaySelected,
          onRangeSelected: _onRangeSelected,
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            setState(() {
              _focusedDay = focusedDay;
            });
            // print(_focusedDay.toString());
          },
        ),
        const Divider(
          thickness: 1,
          height: 0,
        ),
        // Expanded(
        //   child: PageView.builder(
        //     controller: controller,
        //     itemCount: daysInRange(kFirstDay, kLastDay).length,
        //     scrollDirection: Axis.horizontal,
        //     onPageChanged: (index) {
        //       // print(index);
        //       // print(lastPageIndex);
        //       if(lastPageIndex > index) {
        //         setState(() {
        //           _onDaySelected(_selectedDay!.subtract(const Duration(days: 1)), _focusedDay);
        //           // _selectedDay = _selectedDay!.add(const Duration(days: 1));
        //           lastPageIndex = index;
        //         });
        //       }
        //       else {
        //         setState(() {
        //           _onDaySelected(_selectedDay!.add(const Duration(days: 1)), _focusedDay);
        //           lastPageIndex = index;
        //         });
        //       }
        //
        //     },
        //     itemBuilder: (context, index) {
        //       return _selectedEvents!.isEmpty ?
        //       EmptyContent(title: 'No events on this date', message: 'Only groups you are following will appear in the calender', center: false)
        //           : ListView.separated(
        //         itemCount: _selectedEvents!.length,
        //         separatorBuilder: (context, index){
        //           return const Divider(height: 0, thickness: 0.5,);
        //         },
        //         itemBuilder: (context, index) {
        //           return InkWell(
        //             onTap: () {
        //               if(_selectedEvents![index].gameID != '') {
        //                 Navigator.of(context, rootNavigator: true).pushNamed(
        //                     AppRoutes.gameView,
        //                     arguments: {
        //                       'admin': widget.admin,
        //                       'gameID': _selectedEvents![index].gameID,
        //                     }
        //                 );
        //               }
        //               else {
        //                 Navigator.of(context, rootNavigator: true).pushNamed(
        //                     AppRoutes.eventView,
        //                     arguments: {
        //                       'event': _selectedEvents![index],
        //                     }
        //                 );
        //               }
        //             },
        //             child: Container(
        //               padding: const EdgeInsets.fromLTRB(15, 5, 0, 5),
        //               // margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        //               child: Row(
        //                 children: [
        //                   ClipRRect(
        //                     borderRadius: BorderRadius.circular(30),
        //                     child: CachedNetworkImage(
        //                       memCacheHeight: 1000,
        //                       memCacheWidth: 1000,
        //                       fadeInDuration: Duration.zero,
        //                       placeholderFadeInDuration: Duration.zero,
        //                       fadeOutDuration: Duration.zero,
        //                       imageUrl: _selectedEvents![index].groupImageURL,
        //                       fit: BoxFit.fitWidth,
        //                       width: 45,
        //                       height: 45,
        //                       placeholder: (context, url) => const Image(image: AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
        //                     ),
        //                   ),
        //                   Flexible(child: CalendarEventListTile(event: _selectedEvents![index])),
        //                 ],
        //               ),
        //             ),
        //           );
        //         },
        //       );
        //     },
        //   ),
        // )
        Expanded(
          child: ValueListenableBuilder<List<Event>>(
            valueListenable: _selectedEvents,
            builder: (context, value, _) {
              return PageView.builder(
                controller: controller,
                itemCount: daysInRange(kFirstDay, kLastDay).length,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index) {
                  // print(index);
                  // print(lastPageIndex);
                  if(lastPageIndex > index) {
                    setState(() {
                      _onDaySelected(_selectedDay!.subtract(const Duration(days: 1)), _focusedDay);
                      // _selectedDay = _selectedDay!.add(const Duration(days: 1));
                      lastPageIndex = index;
                    });
                  }
                  else {
                    setState(() {
                      _onDaySelected(_selectedDay!.add(const Duration(days: 1)), _focusedDay);
                      lastPageIndex = index;
                    });
                  }

                },
                itemBuilder: (context, index) {
                  return _selectedEvents.value.isEmpty ?
                       EmptyContent(title: 'No events on this date', message: 'Only groups you are following will appear in the calender', center: false)
                  : ListView.separated(
                    itemCount: value.length,
                    separatorBuilder: (context, index){
                      return const Divider(height: 0, thickness: 0.5,);
                    },
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if(_selectedEvents.value[index].gameID != '') {
                            Navigator.of(context, rootNavigator: true).pushNamed(
                                AppRoutes.gameView,
                                arguments: {
                                  'admin': widget.admin,
                                  'gameID': _selectedEvents.value[index].gameID,
                                }
                            );
                          }
                          else {
                            Navigator.of(context, rootNavigator: true).pushNamed(
                                AppRoutes.eventView,
                                arguments: {
                                  'event': _selectedEvents.value[index],
                                }
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(15, 5, 0, 5),
                          // margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: CachedNetworkImage(
                                  memCacheHeight: 1000,
                                  memCacheWidth: 1000,
                                  fadeInDuration: Duration.zero,
                                  placeholderFadeInDuration: Duration.zero,
                                  fadeOutDuration: Duration.zero,
                                  imageUrl: _selectedEvents.value[index].groupImageURL,
                                  fit: BoxFit.fitWidth,
                                  width: 45,
                                  height: 45,
                                  placeholder: (context, url) => const Image(image: AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
                                ),
                              ),
                              Flexible(child: CalendarEventListTile(event: _selectedEvents.value[index])),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month
        && day == other.day;
  }
}