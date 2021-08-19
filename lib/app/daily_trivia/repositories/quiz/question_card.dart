import 'package:flutter/material.dart';
import 'package:get_up_park/app/daily_trivia/begin_trivia_view.dart';
import 'package:get_up_park/app/daily_trivia/models/question_model.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/services/firestore_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class QuestionCard extends StatelessWidget {
  const QuestionCard({required this.question});

  final Question question;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      padding: const EdgeInsets.symmetric(vertical: 0),
      decoration: const BoxDecoration(
        border: Border.symmetric(horizontal: BorderSide(color: Colors.grey, width: 0.15)),
        // color: Colors.white,
        // borderRadius: BorderRadius.circular(15),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.15),
        //     spreadRadius: 0,
        //     blurRadius: 10,
        //     offset: const Offset(0, 1),
        //   )
        // ]
      ),
      child: ExpansionTile(
        initiallyExpanded: false,
        title: Text(
          question.question,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        children: <Widget>[
          ListTile(
            leading: const CircularIcon(
              icon: Icons.check,
              color: Colors.green,
            ),
            title: Text(
              question.correctAnswer,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          () {
            if(question.answers[0] != question.correctAnswer) {
              return ListTile(
                leading: const CircularIcon(
                  icon: Icons.close,
                  color: Colors.red,
                ),
                title: Text(
                  question.answers[0],
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              );
            }
            return const SizedBox(height: 0);
          }(),
              () {
            if(question.answers[1] != question.correctAnswer) {
              return ListTile(
                leading: const CircularIcon(
                  icon: Icons.close,
                  color: Colors.red,
                ),
                title: Text(
                  question.answers[1],
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              );
            }
            return const SizedBox(height: 0);
          }(),
              () {
            if(question.answers[2] != question.correctAnswer) {
              return ListTile(
                leading: const CircularIcon(
                  icon: Icons.close,
                  color: Colors.red,
                ),
                title: Text(
                  question.answers[2],
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              );
            }
            return const SizedBox(height: 0);
          }(),
              () {
            if(question.answers[3] != question.correctAnswer) {
              return ListTile(
                leading: const CircularIcon(
                  icon: Icons.close,
                  color: Colors.red,
                ),
                title: Text(
                  question.answers[3],
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              );
            }
            return const SizedBox(height: 0);
          }(),
          InkWell(
            onTap: () async {
              final database = context.read<FirestoreDatabase>(databaseProvider);
              await database.deleteTriviaQuestion(question);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.delete,
                    color: Colors.black,
                    size: 20,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Delete',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
