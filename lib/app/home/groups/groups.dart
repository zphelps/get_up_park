import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/home/groups/group_list_widget.dart';
import 'package:get_up_park/app/home/settings/user_tile.dart';

import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/constants/news_categories.dart';
import 'package:get_up_park/constants/strings.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:google_fonts/google_fonts.dart';

// watch database
class Groups extends ConsumerWidget {

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final userAsyncValue = watch(userStreamProvider);
    return userAsyncValue.when(
      data: (user) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            brightness: Brightness.light,
            title: Text(
              Strings.groups,
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
                      if(user.admin == userTypes[0]) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).pushNamed(
                              AppRoutes.createGroupView,
                            );
                          },
                          child: CircleAvatar(
                            radius: 19,
                            backgroundColor: const Color(0xffE4E5EA).withOpacity(0.75), //Color(0xffEEEDF0),
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
          body: GroupsView(user: user),
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
  const GroupsView({this.selectGroup = false, this.followGroup = false, this.setAccessToGroup = false, required this.user, this.showDialog = false});

  final bool selectGroup;
  final bool followGroup;
  final bool setAccessToGroup;
  final PTUser user;
  final bool showDialog;

  @override
  _GroupsViewState createState() => _GroupsViewState();
}

class _GroupsViewState extends State<GroupsView> {

  int _selectedCategoryIndex = 0;

  final _controller = ScrollController();

  double offset = 100;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.showDialog) {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        await showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text(
              'Follow Groups!',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
              ),
            ),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.215,
              child: Column(
                children: [
                  Image(
                    image: const AssetImage('assets/selectGroups.png'),
                    fit: BoxFit.fitWidth,
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: MediaQuery.of(context).size.width * 0.3,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Please select a few groups to follow. Only news and events from groups you following will appear in your feed.',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              // TextButton(
              //   onPressed: () {
              //     Navigator.of(context).pop();
              //   },
              //   child: const Text('Cancel'),
              // ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Get Started  ',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        );
      });
    }
  }

  showInstructions() async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) =>
        AlertDialog(
          title: const Text('Follow Groups!'),
          content: const Text(
              'Please select a few groups to follow. Only news and events from groups you following will appear in your feed.'),
          actions: <Widget>[
            // TextButton(
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            //   child: const Text('Cancel'),
            // ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Get Started',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
    );
  }

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
                         fontWeight: _selectedCategoryIndex == index ? FontWeight.w800 :FontWeight.w700,
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
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 9),
                _selectedCategoryIndex == 0 ?
                GroupListWidget(
                    selectGroup: widget.selectGroup,
                    followGroup: widget.followGroup,
                    setAccessToGroup: widget.setAccessToGroup,
                    user: widget.user,
                ) : GroupListWidget(
                  category: NewsCategories.categories[_selectedCategoryIndex-1],
                  selectGroup: widget.selectGroup,
                  followGroup: widget.followGroup,
                  setAccessToGroup: widget.setAccessToGroup,
                  user: widget.user
                ),
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
