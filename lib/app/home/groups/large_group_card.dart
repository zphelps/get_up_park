import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/services/firestore_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class LargeGroupCard extends StatefulWidget {
  const LargeGroupCard({required this.group});

  final Group group;

  @override
  State<LargeGroupCard> createState() => _LargeGroupCardState();
}

class _LargeGroupCardState extends State<LargeGroupCard> {

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        HapticFeedback.heavyImpact();
        Navigator.of(context, rootNavigator: true).pushNamed(
            AppRoutes.groupView,
            arguments: {
              'group':  widget.group,
            }
        );
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(15, 0, 0, 15),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  child: CachedNetworkImage(
                    memCacheHeight: 3000,
                    memCacheWidth: 4000,
                    imageUrl: widget.group.backgroundImageURL,
                    fit: BoxFit.cover,
                    width: 175,
                    height: 80,
                    placeholder: (context, url) => const Image(image: AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
                  ),
                ),
                const SizedBox(height: 45),
                Text(
                  widget.group.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 35),
                  child: const Text(
                    'view',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                // const SizedBox(height: 4),
                // SizedBox(
                //   width: 374,
                //   child: AutoSizeText(
                //     widget.article.title,
                //     minFontSize: 20,
                //     maxFontSize: 20,
                //     maxLines: 3,
                //     overflow: TextOverflow.ellipsis,
                //     style: const TextStyle(
                //       fontSize: 20,
                //       fontWeight: FontWeight.w800,
                //       color: Colors.black,
                //     ),
                //   ),
                // ),
                const SizedBox(height: 10),
              ],
            ),
            Positioned(
              top: 52,
              left: 58,
              child: Container(
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: CachedNetworkImage(
                    memCacheHeight: 100,
                    memCacheWidth: 100,
                    imageUrl: widget.group.logoURL,
                    fit: BoxFit.fitWidth,
                    width: 40,
                    height: 40,
                    placeholder: (context, url) => const Image(image: AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 1),
                      )
                    ]
                ),
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.25),
                spreadRadius: 0,
                blurRadius: 10,
                offset: const Offset(0, 1),
              )
            ]
        ),
      ),
    );
  }
}
