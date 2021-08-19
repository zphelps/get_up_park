import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/constants/news_categories.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/services/firestore_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';


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
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: CachedNetworkImage(
                    memCacheHeight: 3000,
                    memCacheWidth: 4000,
                    imageUrl: widget.group.backgroundImageURL,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    height: 275,
                    placeholder: (context, url) => const Image(image: AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          memCacheHeight: 3000,
                          memCacheWidth: 4000,
                          imageUrl: widget.group.logoURL,
                          fit: BoxFit.cover,
                          width: 45,
                          height: 45,
                          placeholder: (context, url) => const Image(image: AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.group.category,
                            style: GoogleFonts.inter(
                              color: NewsCategories.getCategoryColor(widget.group.category, false),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            widget.group.name,
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
            Positioned(
              top: 15,
              left: 15,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Text(
                  'Following',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
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
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 2),
              )
            ]
        ),
      ),
    );
  }
}
