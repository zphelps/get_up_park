import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/home/news/widgets/news_vertical_scroll_widget.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/constants/strings.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_up_park/constants/news_categories.dart';

final userStreamProvider =
StreamProvider.autoDispose((ref) {
  final database = ref.watch(databaseProvider);
  return database.userStream();
});

// watch database
class News extends ConsumerWidget {

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final userAsyncValue = watch(userStreamProvider);
    return userAsyncValue.when(
      data: (user) {
        print('user');
        print(user.groupsFollowing);
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: CustomScrollView(
              // physics: const BouncingScrollPhysics(),
              // backgroundColor: Colors.white,
              slivers: [
                SliverAppBar(
                  forceElevated: true,
                  brightness: Brightness.light,
                  title: const Text(
                    Strings.news,
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
                      image: AssetImage('assets/pantherHeadLowRes.png'),
                      height: 45,
                      width: 45,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  elevation: 1,
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                        children: [
                              () {
                            if(user.admin == 'Admin' || user.admin == 'Student Admin') {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context, rootNavigator: true).pushNamed(
                                    AppRoutes.createNewsView,
                                  );
                                },
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: const Color(0xffE4E5EA).withOpacity(0.75), //Color(0xffEEEDF0), //Colors.grey[300],
                                  child: const Icon(
                                    CupertinoIcons.add_circled_solid,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox(width: 0);
                          }(),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).pushNamed(
                                AppRoutes.settingsView,
                                  arguments: {
                                    'user': user,
                                  }
                              );
                            },
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: const Color(0xffE4E5EA).withOpacity(0.75), //Colors.grey[200],
                              child: const Icon(
                                Icons.settings,
                                color: Colors.black,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SliverList(
                  delegate: SliverChildListDelegate.fixed(
                    [
                      NewsView(user: user),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => //LoadingEventsScroll(),
          Container(
            color: Colors.transparent,
          ),
      error: (_, __) {
        return EmptyContent(title: 'An error has occured', message: 'Try restarting the application.');
      },
    );
  }
}

class NewsView extends StatefulWidget {
  const NewsView({required this.user});

  final PTUser user;

  @override
  _NewsViewState createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {

  int _selectedCategoryIndex = 0;

  final _controller = ScrollController();

  double offset = 100;


  @override
  Widget build(BuildContext context) {
    return Column(
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
                NewsCategories.categories.length + 1,
                    (int index) {
                  return ChoiceChip(
                    backgroundColor: const Color(0xffE4E5EA).withOpacity(0.75),//const Color(0xffEEEDF0),//Color(0xffEBEDF0),//Colors.grey[300],
                    pressElevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                    label: Text(
                      index == 0 ? 'Following' : NewsCategories.categories[index-1],
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
                          offset = 150;
                        }
                        else if(_selectedCategoryIndex == 4) {
                          offset = 175;
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
            const SizedBox(height: 5),
            _selectedCategoryIndex == 0 ? NewsVerticalScrollWidget(admin: widget.user.admin, groupsFollowing: widget.user.groupsFollowing,) : NewsVerticalScrollWidget(groupsFollowing: widget.user.groupsFollowing, admin: widget.user.admin, category: NewsCategories.categories[_selectedCategoryIndex-1]),
            const SizedBox(height: 20),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
