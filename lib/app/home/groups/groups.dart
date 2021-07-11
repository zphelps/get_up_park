import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/home/groups/group_list_widget.dart';

import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/constants/news_categories.dart';
import 'package:get_up_park/constants/strings.dart';
import 'package:get_up_park/routing/app_router.dart';

final userStreamProvider =
StreamProvider.autoDispose.family<PTUser, String>((ref, userID) {
  print(userID);
  final database = ref.watch(databaseProvider);
  // return database.userStream(userID: userID);
  return database.userStream();

});

// watch database
class Groups extends ConsumerWidget {

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final firebaseAuth = context.read(firebaseAuthProvider);
    final user = firebaseAuth.currentUser!;
    final userAsyncValue = watch(userStreamProvider(user.uid));
    return userAsyncValue.when(
      data: (user) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            brightness: Brightness.light,
            title: const Text(
              Strings.groups,
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
                      if(user.admin == 'true') {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).pushNamed(
                              AppRoutes.createGroupView,
                            );
                          },
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: const Color(0xffE4E5EA).withOpacity(0.75), //Color(0xffEEEDF0),
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
          body: GroupsView(),
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

class GroupsView extends StatefulWidget {
  const GroupsView({this.selectGroup = false});

  final bool selectGroup;

  @override
  _GroupsViewState createState() => _GroupsViewState();
}

class _GroupsViewState extends State<GroupsView> {

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
                     backgroundColor: const Color(0xffE4E5EA).withOpacity(0.75),//const Color(0xffEEEDF0),
                     pressElevation: 0,
                     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                     label: Text(
                       index == 0 ? 'All' : NewsCategories.categories[index-1],
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
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 9),
                _selectedCategoryIndex == 0 ? GroupListWidget(selectGroup: widget.selectGroup) : GroupListWidget(category: NewsCategories.categories[_selectedCategoryIndex-1], selectGroup: widget.selectGroup),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
        //const SizedBox(height: 100),
      ],
    );
  }
}
