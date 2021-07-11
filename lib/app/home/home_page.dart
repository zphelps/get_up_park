
import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/cupertino_home_scaffold.dart';
import 'package:get_up_park/app/home/events/events.dart';
import 'package:get_up_park/app/home/groups/groups.dart';
import 'package:get_up_park/app/home/home/home.dart';
import 'package:get_up_park/app/home/news/news.dart';
import 'package:get_up_park/app/home/settings/settings.dart';
import 'package:get_up_park/app/home/sports/sports.dart';
import 'package:get_up_park/app/home/tab_item.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.home;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.news: GlobalKey<NavigatorState>(),
    TabItem.events: GlobalKey<NavigatorState>(),
    TabItem.groups: GlobalKey<NavigatorState>(),
    TabItem.sports: GlobalKey<NavigatorState>(),
  };


  //Link each tab page
  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.home: (_) => Home(),
      TabItem.news: (_) => News(),
      TabItem.events: (_) => Events(),
      TabItem.groups: (_) => Groups(),
      TabItem.sports: (_) => Sports(),
    };
  }

  void _select(TabItem tabItem) {
    if (tabItem == _currentTab) {
      // pop to first route
      navigatorKeys[tabItem]!.currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
      !(await navigatorKeys[_currentTab]!.currentState?.maybePop() ??
          false),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}