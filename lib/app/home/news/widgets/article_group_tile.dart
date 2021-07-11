import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/services/firestore_database.dart';

final groupsStreamProvider = StreamProvider.autoDispose<List<Group>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.groupsStream();
});

class ArticleGroupTile extends ConsumerWidget {

  ArticleGroupTile({required this.group, required this.groupLogoURL});

  final String group;
  final String groupLogoURL;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final groupAsyncValue = watch(groupsStreamProvider);

    return ListTile(
      onTap: () async {
        Navigator.of(context, rootNavigator: true).pushNamed(
            AppRoutes.groupView,
            arguments: {
              'group': FirestoreDatabase.getGroupFromString(groupAsyncValue, group),
            }
        );
      },
      minVerticalPadding: 0,
      horizontalTitleGap: 10,
      contentPadding: const EdgeInsets.only(right: 5),
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: CachedNetworkImage(
          memCacheHeight: 200,
          memCacheWidth: 200,
          imageUrl: groupLogoURL,
          fadeInDuration: Duration.zero,
          placeholderFadeInDuration: Duration.zero,
          fadeOutDuration: Duration.zero,
          fit: BoxFit.fitHeight,
          width: 35,
          height: 35,
          placeholder: (context, url) => const Image(image: AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
        ),
      ),
      title: Text(
        group,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey[800],
      ),
    );
  }
}
