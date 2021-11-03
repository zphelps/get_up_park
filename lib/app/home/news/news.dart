import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/home/news/widgets/news_vertical_scroll_widget.dart';
import 'package:get_up_park/app/home/settings/user_tile.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/constants/strings.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_up_park/constants/news_categories.dart';
import 'package:google_fonts/google_fonts.dart';

// watch database
class News extends ConsumerWidget {

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final userAsyncValue = watch(userStreamProvider);
    return userAsyncValue.when(
      data: (user) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: CustomScrollView(
              physics: const RangeMaintainingScrollPhysics(),
              // backgroundColor: Colors.white,
              slivers: [
                SliverAppBar(
                  forceElevated: true,
                  brightness: Brightness.light,
                  title: Text(
                    Strings.news,
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                    ),
                  ),
                  toolbarHeight: 55,
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
                  elevation: 0,
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Row(
                        children: [
                              () {
                            if(user.admin == userTypes[0] || user.admin == userTypes[1]) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context, rootNavigator: true).pushNamed(
                                    AppRoutes.createNewsView,
                                  );
                                },
                                child: CircleAvatar(
                                  radius: 19,
                                  backgroundColor: const Color(0xffE4E5EA).withOpacity(0.75), //Color(0xffEEEDF0), //Colors.grey[300],
                                  child: const Icon(
                                    Icons.add_circle,
                                    color: Colors.black,
                                    size: 22,
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
                              radius: 19,
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
        const SizedBox(height: 5),
        const Divider(
          height: 0,
          thickness: 0.175,
          color: Colors.grey,
        ),
        const SizedBox(height: 1),
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
                    backgroundColor: const Color(0xffE4E5EA).withOpacity(0.75),//const Color(0xffEEEDF0),
                    pressElevation: 0,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 13),
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    label: Text(
                      index == 0 ? 'All' : NewsCategories.categories[index-1],
                    ),
                    selectedColor: Colors.red[100],
                    labelStyle: GoogleFonts.inter(
                        fontWeight: _selectedCategoryIndex == index ? FontWeight.w800 : FontWeight.w700,
                        color: _selectedCategoryIndex == index ? Colors.red : Colors.black,
                        fontSize: 14
                    ),
                    shape: StadiumBorder(side: BorderSide(color: _selectedCategoryIndex == index ? Colors.red.shade400 : Colors.grey.shade400, width: 0.125)),
                    selected: _selectedCategoryIndex == index,
                    onSelected: (bool selected) {
                      HapticFeedback.mediumImpact();
                      setState(() {
                        _selectedCategoryIndex = (selected ? index : null)!;
                        if(_selectedCategoryIndex == 0 || _selectedCategoryIndex == 1 || _selectedCategoryIndex == 2) {
                          offset = 0;
                        }
                        else if(_selectedCategoryIndex == 3) {
                          offset = 80;
                        }
                        else if(_selectedCategoryIndex == 4) {
                          offset = 90;
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
        const SizedBox(height: 1),
        const Divider(
          height: 0,
          thickness: 0.175,
          color: Colors.grey,
        ),
        Column(
          children: [
            const SizedBox(height: 3),
            _selectedCategoryIndex == 0 ? NewsVerticalScrollWidget(user: widget.user, groupsFollowing: widget.user.groupsFollowing,) : NewsVerticalScrollWidget(groupsFollowing: widget.user.groupsFollowing, user: widget.user, category: NewsCategories.categories[_selectedCategoryIndex-1]),
            const SizedBox(height: 20),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
