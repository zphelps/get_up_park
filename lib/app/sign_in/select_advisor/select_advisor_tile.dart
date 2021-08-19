import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/home/sports/opponent_model.dart';
import 'package:get_up_park/app/sign_in/select_advisor/advisor_model.dart';

class SelectAdvisorTile extends StatelessWidget {

  final Advisor advisor;

  const SelectAdvisorTile({required this.advisor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        HapticFeedback.heavyImpact();
        Navigator.pop(context, {
          'advisor': advisor.name,
          'advisorImageURL': advisor.imageURL,
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
        child: Row(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            () {
              if(advisor.imageURL != '') {
                return Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        memCacheHeight: 1000,
                        memCacheWidth: 1000,
                        fadeInDuration: Duration.zero,
                        fadeOutDuration: Duration.zero,
                        placeholderFadeInDuration: Duration.zero,
                        imageUrl: advisor.imageURL,
                        fit: BoxFit.fitWidth,
                        width: 55,
                        height: 55,
                        placeholder: (context, url) => const Image(image: AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
                      ),
                    ),
                    const SizedBox(width: 15),
                  ],
                );
              }
              return const SizedBox(width: 0);
            }(),
            Text(
              advisor.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
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
