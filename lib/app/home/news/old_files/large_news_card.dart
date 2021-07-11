import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/news/article_model.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/shared_widgets/loading.dart';
import 'package:intl/intl.dart';

class LargeNewsCard extends StatefulWidget {
  const LargeNewsCard({required this.article});

  final Article article;

  @override
  State<LargeNewsCard> createState() => _LargeNewsCardState();
}

class _LargeNewsCardState extends State<LargeNewsCard> {

  Color? getCategoryColor(String category, bool lighterShade) {
    if(category == 'Sports') {
      return lighterShade ? Colors.red[100] : Colors.red;
    }
    else if(category == 'Clubs') {
      return lighterShade ? Colors.blue[100] : Colors.blue;
    }
    else {
      return Colors.grey;
    }
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context, rootNavigator: true).pushNamed(
            AppRoutes.articleView,
            arguments: {
              'article': widget.article,
            }
        );
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                memCacheHeight: 3000,
                memCacheWidth: 4000,
                imageUrl: widget.article.imageURL,
                fadeOutDuration: Duration.zero,
                placeholderFadeInDuration: Duration.zero,
                fadeInDuration: Duration.zero,
                fit: BoxFit.fitWidth,
                width: 374,
                height: 190,
                placeholder: (context, url) => const LoadingCard(height: 190),//const Image(image: AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.article.category,
                  style: TextStyle(
                    color: getCategoryColor(widget.article.category, false),
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 374,
                  child: AutoSizeText(
                    widget.article.title,
                    minFontSize: 22,
                    maxFontSize: 22,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CachedNetworkImage(
                      memCacheHeight: 100,
                      memCacheWidth: 100,
                      imageUrl: widget.article.groupLogoURL,
                      fit: BoxFit.fitWidth,
                      fadeOutDuration: Duration.zero,
                      placeholderFadeInDuration: Duration.zero,
                      fadeInDuration: Duration.zero,
                      width: 20,
                      height: 20,
                      placeholder: (context, url) => const Image(image: AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${widget.article.group} • ${DateFormat.yMMMMd('en_US').format(DateTime.parse(widget.article.date))}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 25,
                  thickness: 0.8,
                  color: Colors.grey[400],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

