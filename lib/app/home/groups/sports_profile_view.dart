import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/home/events/event_list_widget.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/home/news/widgets/news_vertical_scroll_widget.dart';
import 'package:get_up_park/app/home/settings/user_tile.dart';
import 'package:get_up_park/app/home/sports/widgets/game_schedule_list_widget.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/constants/news_categories.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/services/firestore_database.dart';
import 'package:google_fonts/google_fonts.dart';

class SportsProfile extends ConsumerWidget {
  const SportsProfile({required this.group});

  final Group group;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    Group grp = group;
    final userAsyncValue = watch(userStreamProvider);
    final groupAsyncValue = watch(groupStreamProvider(group));
    return userAsyncValue.when(
      data: (user) {
        groupAsyncValue.whenData((g) {
          if(g != group) {
            grp = g;
          }
        });
        return Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            slivers: <Widget>[
              // Add the app bar to the CustomScrollView.
              SliverAppBar(
                brightness: Brightness.light,
                stretch: true,
                pinned: true,
                backgroundColor: Colors.white,
                elevation: 1,
                toolbarHeight: 50,
                iconTheme: const IconThemeData(
                  color: Colors.black,
                ),
                leading: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 15,
                      child: Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                ),
                actions: [
                      () {
                    if (user.admin == userTypes[0]) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          //radius: 20,
                          child: PopupMenuButton(
                            icon: const Icon(
                              Icons.more_horiz_outlined,
                              color: Colors.black,
                            ),
                            //color: Colors.black,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(15.0))
                            ),
                            itemBuilder: (BuildContext bc) =>
                            [
                              const PopupMenuItem(
                                  child: Text("Delete"), value: "delete"),
                              // const PopupMenuItem(
                              //     child: Text("Edit"), value: "edit"),
                              //const PopupMenuItem(child: Text("Settings"), value: "/settings"),
                            ],
                            onSelected: (value) async {
                              // print(value);
                              if (value == 'delete') {
                                final database = context.read<FirestoreDatabase>(databaseProvider);
                                await database.deleteGroup(group);
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        ),
                      );
                    }
                    return const SizedBox(width: 0);
                  }(),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin, // to make radius remain if scrolled
                  titlePadding: const EdgeInsets.all(30),
                  centerTitle: true,
                  stretchModes: [
                    StretchMode.zoomBackground, // zoom effect
                  ],
                  background: Container(
                    color: Colors.white,
                    child: Stack(
                      fit: StackFit.expand, // expand stack
                      children: [
                        ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.05),
                            BlendMode.srcOver,
                          ),
                          child: Image(
                            image: CachedNetworkImageProvider(grp.backgroundImageURL, cacheKey: grp.backgroundImageURL),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          child: Container(
                            height: 82,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 0,
                                )),
                          ),
                          bottom: -1,
                          left: 0,
                          right: 0,
                        ),
                        Positioned(
                          bottom: 0,
                          left: 15,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              minVerticalPadding: 0,
                              horizontalTitleGap: 10,
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image(
                                  image: CachedNetworkImageProvider(group.logoURL, cacheKey: group.logoURL),
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                              title: Text(
                                group.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22,
                                  color: Colors.black,
                                ),
                                maxLines: 1,
                              ),
                              subtitle: Text(
                                group.category,
                                style: TextStyle(
                                  // color: Colors.grey[800],
                                  color: NewsCategories.getCategoryColor(group.category, false),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                            () {
                          if(user.admin == userTypes[0]) {
                            return Positioned(
                                bottom: 95,
                                right: 20,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context, rootNavigator: true).pushNamed(
                                        AppRoutes.updateGroupBackgroundImageView,
                                        arguments: {
                                          'group': group,
                                        }
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                      size: 18,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                            );
                          }
                          return const SizedBox(height: 0);
                        }()
                      ],
                    ),
                  ),
                ),
                // Make the initial height of the SliverAppBar larger than normal.
                expandedHeight: 350, //250
              ),
              // Next, create a SliverList
              SliverList(
                  delegate: SliverChildListDelegate.fixed(
                      [
                        const SizedBox(height: 5),
                        InkWell(
                          onTap: () async {
                            if(!user.groupsUserCanAccess.contains(group.name) && user.admin != userTypes[0]) {
                              HapticFeedback.heavyImpact();
                              final database = context.read<FirestoreDatabase>(databaseProvider);
                              user.groupsFollowing.contains(group.name) ? await database.unfollowGroup(user.id, group.name) : await database.followGroup(user.id, group.name);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              user.groupsUserCanAccess.contains(group.name) || user.admin == userTypes[0] ? 'Admin' : user.groupsFollowing.contains(group.name) ? 'Unfollow' : 'Follow',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: user.groupsUserCanAccess.contains(group.name) || user.admin == userTypes[0] ? Colors.grey[400] : user.groupsFollowing.contains(group.name) ? Colors.black : Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: user.groupsUserCanAccess.contains(group.name) || user.admin == userTypes[0] ? Colors.grey[100] : user.groupsFollowing.contains(group.name) ? Colors.grey[200] : Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        // const Divider(height: 0, thickness: 0.65,),
                        SportsProfileView(user: user, group: group),
                        const SizedBox(height: 50),
                      ]
                  )
              ),
            ],
          ),
        );
      },
      loading: () => Container(color: Colors.transparent,),
      error: (_, __) => EmptyContent(),
    );
  }
}


class SportsProfileView extends StatefulWidget {
  const SportsProfileView({required this.user, required this.group});

  final PTUser user;
  final Group group;

  @override
  _SportsProfileViewState createState() => _SportsProfileViewState();
}

class _SportsProfileViewState extends State<SportsProfileView> {

  int _selectedCategoryIndex = 0;

  final _controller = ScrollController();

  double offset = 100;

  List<String> selectorOptions = ['Schedule', 'News', 'Events'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 3),
        SingleChildScrollView(
          controller: _controller,
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Wrap(
              spacing: 6,
              children: List<Widget>.generate(
                selectorOptions.length,
                    (int index) {
                  return ChoiceChip(
                    backgroundColor: const Color(0xffE4E5EA).withOpacity(0.75),//const Color(0xffEEEDF0),
                    pressElevation: 0,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 13),
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    label: Text(
                      selectorOptions[index],
                    ),
                    selectedColor: Colors.red[100],
                    labelStyle: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: _selectedCategoryIndex == index ? Colors.red : Colors.black,
                        fontSize: 14
                    ),
                    shape: StadiumBorder(side: BorderSide(color: Colors.grey.shade400, width: 0.125)),
                    selected: _selectedCategoryIndex == index,
                    onSelected: (bool selected) {
                      HapticFeedback.mediumImpact();
                      setState(() {
                        _selectedCategoryIndex = (selected ? index : null)!;
                        if(_selectedCategoryIndex == 0 || _selectedCategoryIndex == 1 || _selectedCategoryIndex == 2) {
                          offset = 0;
                        }
                        else if(_selectedCategoryIndex == 3) {
                          offset = 100;
                        }
                        else if(_selectedCategoryIndex == 4) {
                          offset = 120;
                        }
                        _controller.animateTo(offset, duration: const Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
                      });
                    },
                  );
                },
              ).toList(),
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Divider(
          height: 0,
          thickness: 0.6,
        ),
        Column(
          children: [
            const SizedBox(height: 9),
            () {
              if(_selectedCategoryIndex == 0) {
                // return Column(
                //   children: [
                //     // RecentScoresCard(group: widget.group, admin: widget.admin),
                //     ScheduleCard(group: widget.group, admin: widget.admin),
                //   ],
                // );
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          'Upcoming Games',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(height: 0),
                      GameScheduleListWidget(group: widget.group, groupName: widget.group.name, user: widget.user, selectGame: false),
                      const Divider(height: 0),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          'Past Games',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(height: 0),
                      GameScheduleListWidget(group: widget.group, groupName: widget.group.name, user: widget.user, selectGame: false, past: true),
                    ],
                  ),
                );
              }
              if(_selectedCategoryIndex == 1) {
                return NewsVerticalScrollWidget(user: widget.user, group: widget.group.name);
              }
              if(_selectedCategoryIndex == 2) {
                // return GroupEventsCard(group: widget.group, admin: widget.admin);
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Upcoming Events',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true).pushNamed(
                                    AppRoutes.groupEventsView,
                                    arguments: {
                                      'group': widget.group,
                                      'user': widget.user,
                                      'past': false,
                                    }
                                );
                              },
                              child: Text(
                                'view all',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 20),
                      EventListWidget(group: widget.group.name, user: widget.user, itemCount: 6, emptyTitle: 'No upcoming events found.',),
                      const Divider(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Past Events',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true).pushNamed(
                                    AppRoutes.groupEventsView,
                                    arguments: {
                                      'group': widget.group,
                                      'user': widget.user,
                                      'past': true,
                                    }
                                );
                              },
                              child: Text(
                                'view all',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 20),
                      EventListWidget(group: widget.group.name, user: widget.user, itemCount: 15, past: true, emptyTitle: 'No past events found.',),
                    ],
                  ),
                );
              }
              return const SizedBox(height: 0);
            }(),
            // _selectedCategoryIndex == 0 ? GroupListWidget(selectGroup: widget.selectCategory) : GroupListWidget(category: NewsCategories.categories[_selectedCategoryIndex-1], selectGroup: widget.selectCategory),
            // _selectedCategoryIndex == 0 ? NewsVerticalScrollWidget(admin: widget.admin) : NewsVerticalScrollWidget(admin: widget.admin, category: NewsCategories.categories[_selectedCategoryIndex-1]),
            const SizedBox(height: 20),
          ],
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}

