import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';

class SelectGroupTile extends StatelessWidget {

  final Group group;

  const SelectGroupTile({required this.group});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        HapticFeedback.heavyImpact();
        Navigator.pop(context, {
          'group': group.name,
          'groupLogoURL': group.logoURL,
          'category': group.category,
          'sport': group.sport,
        });
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
                imageUrl: group.logoURL,
                fit: BoxFit.fitHeight,
                width: 35,
                height: 35,
                placeholder: (context, url) => const Image(image: AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
              ),
            ),
            const SizedBox(width: 15),
            Text(
              group.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
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
}
