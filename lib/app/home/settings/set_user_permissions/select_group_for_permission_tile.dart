import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/services/firestore_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class SelectGroupForPermissionTile extends StatefulWidget {

  final Group group;
  final PTUser user;

  const SelectGroupForPermissionTile({required this.group, required this.user});

  @override
  State<SelectGroupForPermissionTile> createState() => _SelectGroupForPermissionTileState();
}

class _SelectGroupForPermissionTileState extends State<SelectGroupForPermissionTile> with AutomaticKeepAliveClientMixin{

  bool? hasAccess;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hasAccess = widget.user.groupsUserCanAccess.contains(widget.group.name) ? true : false;
    print(widget.user.groupsUserCanAccess);
    print(widget.group.name);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return InkWell(
      onTap: () async {
        HapticFeedback.heavyImpact();
        setState(() {
          hasAccess = !hasAccess!;
        });
        final database = context.read<FirestoreDatabase>(databaseProvider);
        if(hasAccess!) {
          database.followGroup(widget.user.id, widget.group.name);
        }
        hasAccess! ? database.addGroupUserCanAccess(widget.user.id, widget.group.name) : database.removeGroupUserCanAccess(widget.user.id, widget.group.name);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Row(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: CachedNetworkImage(
                memCacheHeight: 300,
                memCacheWidth: 300,
                placeholderFadeInDuration: Duration.zero,
                fadeOutDuration: Duration.zero,
                fadeInDuration: Duration.zero,
                imageUrl: widget.group.logoURL,
                fit: BoxFit.fitHeight,
                width: 35,
                height: 35,
                placeholder: (context, url) => const Image(image: AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
              ),
            ),
            const SizedBox(width: 15),
            Text(
              widget.group.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              child: Icon(
                hasAccess! ? Icons.check_circle : Icons.check_circle_outline,
                color: hasAccess! ? Colors.red : Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 24,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ]
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
