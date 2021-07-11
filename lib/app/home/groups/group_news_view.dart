import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/home/news/widgets/news_vertical_scroll_widget.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/shared_widgets/loading.dart';

final userStreamProvider =
StreamProvider.autoDispose((ref) {
  final database = ref.watch(databaseProvider);
  return database.userStream();
});

class GroupNewsView extends ConsumerWidget {

  const GroupNewsView({required this.group});

  final String group;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final userAsyncValue = watch(userStreamProvider);
    return userAsyncValue.when(
      data: (user) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              '$group News',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            elevation: 1,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 15),
                NewsVerticalScrollWidget(admin: user.admin, group: group),
              ],
            ),
          ),
        );
      },
      loading: () => Loading(loadingMessage: 'Loading'),
      error: (_,__) => EmptyContent(),
    );
  }
}
