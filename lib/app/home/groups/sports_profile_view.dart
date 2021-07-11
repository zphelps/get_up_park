import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/home/events/group_events_card.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/home/news/widgets/news_vertical_scroll_widget.dart';
import 'package:get_up_park/app/home/sports/cards/recent_score_card.dart';
import 'package:get_up_park/app/home/sports/cards/schedule_card.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/services/firestore_database.dart';
import 'package:get_up_park/shared_widgets/loading.dart';
import 'package:intl/intl.dart';

final userStreamProvider =
StreamProvider.autoDispose((ref) {
  final database = ref.watch(databaseProvider);
  // return database.userStream(userID: userID);
  return database.userStream();

});

class SportsProfile extends ConsumerWidget {
  const SportsProfile({required this.group});

  final Group group;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final userAsyncValue = watch(userStreamProvider);
    return userAsyncValue.when(
      data: (user) {
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
                    if (user.admin == 'true') {
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
                  background: DecoratedBox(
                    decoration: const BoxDecoration(),
                    child: InkWell(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).pushNamed(
                              AppRoutes.fullScreenImageView,
                              arguments: {
                                'imageURL': group.backgroundImageURL,
                              }
                          );
                        },
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image(
                              image: CachedNetworkImageProvider(group.backgroundImageURL, cacheKey: group.backgroundImageURL),
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                                bottom: 20,
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
                                      color: Colors.grey[200],
                                    ),
                                  ),
                                )
                            ),
                          ],
                        )
                    ),
                  ),
                ),
                // Make the initial height of the SliverAppBar larger than normal.
                expandedHeight: 275,
              ),
              // Next, create a SliverList
              SliverList(
                  delegate: SliverChildListDelegate.fixed(
                      [
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
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
                            ),
                            subtitle: Text(
                              group.category,
                              style: TextStyle(
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () async {
                            HapticFeedback.heavyImpact();
                            final database = context.read<FirestoreDatabase>(databaseProvider);
                            user.groupsFollowing.contains(group.name) ? await database.unfollowGroup(user.id, group.name) : await database.followGroup(user.id, group.name);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              user.groupsFollowing.contains(group.name) ? 'Unfollow' : 'Follow',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: user.groupsFollowing.contains(group.name) ? Colors.black : Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: user.groupsFollowing.contains(group.name) ? Colors.grey[200] : Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Divider(height: 0, thickness: 0.65,),
                        SportsProfileView(admin: user.admin, group: group),
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
  const SportsProfileView({required this.admin, required this.group});

  final String admin;
  final Group group;

  @override
  _SportsProfileViewState createState() => _SportsProfileViewState();
}

class _SportsProfileViewState extends State<SportsProfileView> {

  int _selectedCategoryIndex = 0;

  final _controller = ScrollController();

  double offset = 100;

  List<String> selectorOptions = ['Sports', 'Events', 'News'];

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
                    backgroundColor: const Color(0xffEEEDF0),//Color(0xffEBEDF0),//Colors.grey[300],
                    pressElevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                    label: Text(
                      selectorOptions[index],
                    ),
                    selectedColor: Colors.red[100],
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: _selectedCategoryIndex == index ? Colors.red : Colors.black,
                        fontSize: 15
                    ),
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
                return Column(
                  children: [
                    RecentScoresCard(group: widget.group, admin: widget.admin),
                    ScheduleCard(group: widget.group, admin: widget.admin),
                  ],
                );
              }
              if(_selectedCategoryIndex == 1) {
                return GroupEventsCard(group: widget.group, admin: widget.admin);
              }
              if(_selectedCategoryIndex == 2) {
                return NewsVerticalScrollWidget(admin: widget.admin, group: widget.group.name);
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
