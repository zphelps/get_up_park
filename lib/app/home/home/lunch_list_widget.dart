import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/home/home/lunch_model.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:google_fonts/google_fonts.dart';


// watch database
class LunchListWidget extends ConsumerWidget {

  LunchListWidget({required this.date, required this.itemCount});

  final String date;
  final int itemCount;

  bool sortingLunch = true;

  @override
  Widget build(BuildContext context, ScopedReader watch) {

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10),
        child: _buildContents(context, watch)
    );
  }



  Widget _buildContents(BuildContext context, ScopedReader watch) {
    final lunchAsyncValue = watch(lunchStreamProvider);

    List<dynamic> grillItems = [];
    List<dynamic> deliItems = [];
    List<dynamic> grabngoItems = [];
    List<dynamic> hemisphereItems = [];

    lunchAsyncValue.whenData((lunches)  {
      for(Lunch lunch in lunches) {
        print(lunch.id);
        for(String date in lunch.dates) {
          print(date);
          if(DateTime.parse(date).isSameDate(DateTime.now())) {
            grillItems = lunch.grillItems;
            deliItems = lunch.deliItems;
            grabngoItems = lunch.grabgoItems;
            hemisphereItems = lunch.hemisphereItems;
          }
        }
      }

    });

    if(grillItems.isEmpty && deliItems.isEmpty && grabngoItems.isEmpty && hemisphereItems.isEmpty) {
      return EmptyContent(title: 'Lunch menu not available', message: 'Please check back later.', center: true);
    }


    return Column(
      children: [
        () {
          if(grillItems.isNotEmpty) {
            return Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: const Image(
                        image: AssetImage('assets/grill.png'),
                        height: 45,
                        width: 45,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Grill',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: itemCount == 0 ? grillItems.length : itemCount,
                  separatorBuilder: (context, index) {
                    return const Divider(height: 20);
                  },
                  itemBuilder: (context, index) {
                    return Text(
                      grillItems[index],
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                      ),
                    );
                  },
                ),
                const Divider(height: 30, thickness: 0.85,),
              ],
            );
          }
          return const SizedBox(height: 0);
        }(),

            () {
          if(deliItems.isNotEmpty) {
            return Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: const Image(
                        image: AssetImage('assets/deli.png'),
                        height: 45,
                        width: 45,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Deli',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: itemCount == 0 ? deliItems.length : itemCount,
                  separatorBuilder: (context, index) {
                    return const Divider(height: 20);
                  },
                  itemBuilder: (context, index) {
                    return Text(
                      deliItems[index],
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                      ),
                    );
                  },
                ),
                const Divider(height: 30, thickness: 0.85,),
              ],
            );
          }
          return const SizedBox(height: 0);
        }(),

            () {
          if(grabngoItems.isNotEmpty) {
            return Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: const Image(
                        image: AssetImage('assets/grabngo.png'),
                        height: 45,
                        width: 45,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Grab 'n Go",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: itemCount == 0 ? grabngoItems.length : itemCount,
                  separatorBuilder: (context, index) {
                    return const Divider(height: 20);
                  },
                  itemBuilder: (context, index) {
                    return Text(
                      grabngoItems[index],
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                      ),
                    );
                  },
                ),
                const Divider(height: 30, thickness: 0.85,),
              ],
            );
          }
          return const SizedBox(height: 0);
        }(),

            () {
          if(hemisphereItems.isNotEmpty) {
            return Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: const Image(
                        image: AssetImage('assets/hemisphere.png'),
                        height: 45,
                        width: 45,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Hemisphere',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: itemCount == 0 ? hemisphereItems.length : itemCount,
                  separatorBuilder: (context, index) {
                    return const Divider(height: 20);
                  },
                  itemBuilder: (context, index) {
                    return Text(
                      hemisphereItems[index],
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                      ),
                    );
                  },
                ),
                const Divider(height: 30, thickness: 0.85,),
              ],
            );
          }
          return const SizedBox(height: 0);
        }(),
        const SizedBox(height: 30),
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