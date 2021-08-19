import 'package:flutter/material.dart';
import 'package:get_up_park/constants/keys.dart';
import 'package:get_up_park/constants/strings.dart';

enum TabItem { home, news, events, groups }

class TabItemData {
  const TabItemData(
      {required this.key, required this.title, required this.icon});

  final String key;
  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.home: TabItemData(
      key: Keys.jobsTab,
      title: Strings.home,
      icon: Icons.home,
    ),
    TabItem.news: TabItemData(
      key: Keys.entriesTab,
      title: Strings.news,
      icon: Icons.article_outlined,
    ),
    TabItem.events: TabItemData(
      key: Keys.accountTab,
      title: Strings.events,
      icon: Icons.event_note_sharp,
    ),
    TabItem.groups: TabItemData(
      key: Keys.accountTab,
      title: Strings.groups,
      icon: Icons.group,
    ),
    // TabItem.settings: TabItemData(
    //   key: Keys.accountTab,
    //   title: Strings.settings,
    //   icon: Icons.settings,
    // ),
    // TabItem.houseCup: TabItemData(
    //   key: Keys.accountTab,
    //   title: 'House Cup',
    //   icon: Icons.emoji_events_outlined,
    // ),
  };
}