import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/list_items_builder.dart';
import 'package:get_up_park/app/daily_trivia/models/question_model.dart';
import 'package:get_up_park/app/daily_trivia/repositories/quiz/question_card.dart';
import 'package:get_up_park/app/home/settings/user_tile.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:google_fonts/google_fonts.dart';

final questionsStreamProvider =
StreamProvider.autoDispose<List<Question>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.questionsStream();
});

class AllQuestionsView extends ConsumerWidget {


  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final questionsAsyncValue = watch(questionsStreamProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 1,
        title: const Text(
          'All Questions',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        iconTheme: const IconThemeData(
            color: Colors.black
        ),
        actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: InkWell(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pushNamed(
                    AppRoutes.createTriviaQuestionView,
                  );
                },
                child: const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.add_circle_outline,
                    color: Colors.black,
                    size: 22,
                  ),
                ),
              ),
          ),
        ],
      ),
      body: ListItemsBuilder<Question>(
          data: questionsAsyncValue,
          itemBuilder: (context, question) {
            return QuestionCard(question: question);
          }
      ),
    );
  }

}