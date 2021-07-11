import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/home/news/widgets/news_vertical_scroll_widget.dart';
import 'package:get_up_park/app/home/sports/widgets/sports_vertical_scroll_widget.dart';
import 'package:get_up_park/constants/all_sports.dart';
import 'package:get_up_park/app/top_level_providers.dart';
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
class Sports extends ConsumerWidget {

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final userAsyncValue = watch(userStreamProvider);
    return userAsyncValue.when(
      data: (user) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            brightness: Brightness.light,
            title: const Text(
              Strings.sports,
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
                image: AssetImage('assets/pantherHead.png'),
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
                      return const SizedBox(width: 0);
                    }(),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).pushNamed(
                          AppRoutes.settingsView,
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
          body: SportsView(admin: user.admin),
        );
      },
      loading: () =>
          Container(
            color: Colors.transparent,
          ),
      error: (_, __) {
        return EmptyContent();
      },
    );
  }
}

class SportsView extends StatefulWidget {
  const SportsView({required this.admin});

  final String admin;

  @override
  _SportsViewState createState() => _SportsViewState();
}

class _SportsViewState extends State<SportsView> {

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
                AllSports.list.length + 1,
                    (int index) {
                  return ChoiceChip(
                    backgroundColor: const Color(0xffE4E5EA).withOpacity(0.75), //const Color(0xffEEEDF0),//Color(0xffEBEDF0),//Colors.grey[300],
                    pressElevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                    label: Text(
                      index == 0 ? 'All' : AllSports.list[index-1],
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
                        if(_selectedCategoryIndex == 0 || _selectedCategoryIndex == 1) {
                          offset = 0;
                        }
                        else if(_selectedCategoryIndex == 2) {
                          offset = 25;
                        }
                        else if(_selectedCategoryIndex == 3) {
                          offset = 125;
                        }
                        else if(_selectedCategoryIndex == 4) {
                          offset = 215;
                        }
                        else if(_selectedCategoryIndex == 5) {
                          offset = 260;
                        }
                        else if(_selectedCategoryIndex == 6) {
                          offset = 260;
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
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 9),
                // _selectedCategoryIndex == 0 ? GroupListWidget(selectGroup: widget.selectCategory) : GroupListWidget(category: NewsCategories.categories[_selectedCategoryIndex-1], selectGroup: widget.selectCategory),
                _selectedCategoryIndex == 0 ? SportsVerticalScrollWidget(admin: widget.admin) : SportsVerticalScrollWidget(admin: widget.admin, sport: AllSports.list[_selectedCategoryIndex-1]),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
        //const SizedBox(height: 250),
      ],
    );
  }
}
