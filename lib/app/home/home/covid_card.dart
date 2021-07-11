import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class CovidCard extends StatelessWidget {
  const CovidCard();

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    return InkWell(
      onTap: () async {
        HapticFeedback.heavyImpact();
        String url = 'https://parktudor.formstack.com/forms/student_covid_19';
        if (await canLaunch(url)) {
          await launch(url);
        }
        else {
          // can't launch url, there is some error
          print('eror');
          throw "Could not launch $url";
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              height: 13,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red, Colors.orange]
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: Row(
                children: [
                  const Image(
                    image: AssetImage('assets/covidForm.png'),
                    height: 75,
                    width: 65,
                  ),
                  const SizedBox(width: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Complete COVID-19 Checklist',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 3),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: const AutoSizeText(
                          'Please complete this form everyday before you arrive at school.',
                          maxLines: 2,
                          maxFontSize: 13,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.25),
              spreadRadius: 2,
              blurRadius: 24,
              offset: const Offset(0, 2),
            )
          ]
        ),
      ),
    );
  }
}
