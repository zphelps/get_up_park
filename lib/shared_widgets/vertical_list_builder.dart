import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/shared_widgets/loading.dart';
import 'package:shimmer/shimmer.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class VerticalListBuilder<T> extends StatelessWidget {
  const VerticalListBuilder({
    Key? key,
    required this.data,
    required this.itemBuilder,
    this.itemCount = 0,
  }) : super(key: key);
  final AsyncValue<List<T>> data;
  final ItemWidgetBuilder<T> itemBuilder;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return data.when(
      data: (items) =>
      items.isNotEmpty ? _buildList(items) : EmptyContent(),
      // loading: () => const Center(child: CircularProgressIndicator()),
      loading: () {
        return const LoadingEventsScroll();
      },
      error: (_, __) => Center(
        heightFactor: 5,
        child: EmptyContent(
          title: 'Something went wrong',
          // message: 'Can\'t load items right now',
          message: context.toString(),
        ),
      ),
    );
  }

  Widget _buildList(List<T> items) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      itemCount: itemCount == 0 ? items.length + 2 : itemCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      //separatorBuilder: (context, index) => const Divider(height: 0.5),
      itemBuilder: (context, index) {
        if (index == 0 || index == items.length + 1) {
          return Container(); // zero height: not visible
        }
        return itemBuilder(context, items[index - 1]);
      },
    );
  }
}