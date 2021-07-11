import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class LunchWidget extends StatelessWidget {
  const LunchWidget();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const Divider(
              height: 1,
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                CircleAvatar(
                  child: Icon(
                    Icons.fastfood_outlined,
                    color: Colors.green,
                    size: 18,
                  ),
                  backgroundColor: Colors.green.withOpacity(0.175),
                  radius: 18,
                ),
                const SizedBox(width: 10),
                Text(
                  'Lunch Menu',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            LunchCard(context),
          ],
        ),
      ),
    );
  }
}

Widget LunchCard(BuildContext context) {
  return InkWell(
    onTap: () {
      //Add PDF viewer
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'May 17 - May 21',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              SizedBox(
                height: 36,
                width: MediaQuery.of(context).size.width * 0.5,
                child: const AutoSizeText(
                  "Take a look at this week's lunch options",
                  maxFontSize: 13,
                ),
              ),
              const Text(
                'view all',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Image(
            image: AssetImage('assets/lunchMenuGraphic.png'),
            height: 80,
            width: 80,
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.125),
            spreadRadius: 0,
            blurRadius: 24,
            offset: const Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}