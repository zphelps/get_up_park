import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firestore_service/firestore_service.dart';
import 'package:get_up_park/app/daily_trivia/enums/difficulty.dart';
import 'package:get_up_park/app/daily_trivia/models/failure_model.dart';
import 'package:get_up_park/app/daily_trivia/models/question_model.dart';
import 'package:get_up_park/app/daily_trivia/repositories/quiz/base_quiz_repository.dart';
import 'package:get_up_park/app/top_level_providers.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meta/meta.dart';

final dioProvider = Provider<Dio>((ref) => Dio());

final quizRepositoryProvider = Provider((ref) {
  return QuizRepository();
  });

class QuizRepository extends BaseQuizRepository {

  QuizRepository();

  @override
  Future<List<Question>> getQuestions({
    int? numQuestions,
    int? categoryId,
    Difficulty? difficulty,
  }) async {

    try{
      final String uid = FirebaseAuth.instance.currentUser!.uid;
      List<Question> questions =  await FirebaseFirestore.instance.collection('questions').get().then((value) => value.docs.map((e) => Question.fromMap(e.data(), e.id)).toList().where((element) => !element.usersAsked.contains(uid)).toList());
      if(questions.length < 5) {
        throw const Failure(message: "Oh no! We do not have any more questions!");
      }
      questions.shuffle();
      questions = questions.sublist(0, 5);
      // for(Question question in questions) {
      //   FirebaseFirestore.instance.collection('questions').doc(question.id).update(
      //       {
      //         'usersAsked': FieldValue.arrayUnion([uid]),
      //       });
      // }
      return questions;
    }
    catch (e) {
      print(e);
      throw const Failure(message: 'Oh no! We do not have any more questions!');
    }


    // final database = context.read<FirestoreDatabase>(databaseProvider);
    // database.collection('questions').limit(5).snapshots().map((event) =>
    //     event.docs.map((e) => Question.fromMap(e.data())).where((element) => !element.usersAsked.contains(uid)).toList());
  //   try {
  //     final queryParameters = {
  //       'type': 'multiple',
  //       'amount': numQuestions,
  //       'category': categoryId,
  //     };
  //
  //     if (difficulty != Difficulty.any) {
  //       queryParameters.addAll(
  //         {'difficulty': EnumToString.convertToString(difficulty)},
  //       );
  //     }
  //
  //     final response = await _read(dioProvider).get(
  //       'https://opentdb.com/api.php',
  //       queryParameters: queryParameters,
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final data = Map<String, dynamic>.from(response.data);
  //       final results = List<Map<String, dynamic>>.from(data['results'] ?? []);
  //       if (results.isNotEmpty) {
  //         return results.map((e) => Question.fromMap(e)).toList();
  //       }
  //     }
  //     return [];
  //   } on DioError catch (err) {
  //     print(err);
  //     throw Failure(
  //       message: err.response?.statusMessage ?? 'Something went wrong!',
  //     );
  //   } on SocketException catch (err) {
  //     print(err);
  //     throw const Failure(message: 'Please check your connection.');
  //   }
  }
}
