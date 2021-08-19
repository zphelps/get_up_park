

import 'package:get_up_park/app/daily_trivia/enums/difficulty.dart';
import 'package:get_up_park/app/daily_trivia/models/question_model.dart';

abstract class BaseQuizRepository {
  Future<List<Question>> getQuestions({
    int numQuestions,
    int categoryId,
    Difficulty difficulty,
  });
}
