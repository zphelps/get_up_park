import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/tab_item.dart';
import 'package:get_up_park/constants/keys.dart';
import 'package:get_up_park/routing/cupertino_tab_view_router.dart';
import 'package:google_fonts/google_fonts.dart';

@immutable
class CupertinoHomeScaffold extends StatelessWidget {
  const CupertinoHomeScaffold({
    Key? key,
    required this.currentTab,
    required this.onSelectTab,
    required this.widgetBuilders,
    required this.navigatorKeys,
  }) : super(key: key);

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;
  final Map<TabItem, WidgetBuilder> widgetBuilders;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        iconSize: 26, //28
        border: Border(top: BorderSide(color: Colors.grey.shade500, width: 0.25)),
        key: const Key(Keys.tabBar),
        items: [
          _buildItem(TabItem.home),
          _buildItem(TabItem.news),
          _buildItem(TabItem.events),
          _buildItem(TabItem.groups),
          // _buildItem(TabItem.houseCup),
        ],
        onTap: (index) => onSelectTab(TabItem.values[index]),
      ),
      tabBuilder: (context, index) {
        final item = TabItem.values[index];
        return CupertinoTabView(
          navigatorKey: navigatorKeys[item],
          builder: (context) => widgetBuilders[item]!(context),
          onGenerateRoute: CupertinoTabViewRouter.generateRoute,
        );
      },
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    final itemData = TabItemData.allTabs[tabItem]!;
    final color = currentTab == tabItem ? Colors.red : Colors.grey[600];
    return BottomNavigationBarItem(
      backgroundColor: Colors.white,
      icon: Icon(
        itemData.icon,
        color: color,
      ),
      title: Text(
        itemData.title,
        key: Key(itemData.key),
        style: GoogleFonts.inter(color: color),
      ),
    );
  }
}