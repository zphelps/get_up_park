import 'package:flutter/cupertino.dart';
import 'package:get_up_park/app/daily_trivia/begin_trivia_view.dart';
import 'package:get_up_park/app/daily_trivia/controllers/quiz/quiz_state.dart';
import 'package:get_up_park/app/daily_trivia/models/question_model.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

final quizControllerProvider = StateNotifierProvider.autoDispose<QuizController, dynamic>((ref) {
  return QuizController();
  }
);

class QuizController extends StateNotifier<QuizState> {
  QuizController() : super(QuizState.initial());

  void submitAnswer(Question currentQuestion, String answer, String timeLeft) {
    if (state.answered) {
      return;
    }
    if (currentQuestion.correctAnswer == answer) {
      state = state.copyWith(
        score: state.score + int.parse('${timeLeft.substring(1, 2)}${timeLeft.substring(3, 4)}'),
        selectedAnswer: answer,
        correct: state.correct..add(currentQuestion),
        status: QuizStatus.correct,
      );
    } else {
      state = state.copyWith(
        selectedAnswer: answer,
        incorrect: state.incorrect..add(currentQuestion),
        status: QuizStatus.incorrect,
      );
    }
  }

  void nextQuestion(List<Question> questions, int currentIndex, BuildContext context) {

    context.read(timerProvider.notifier).reset();
    context.read(timerProvider.notifier).start();
    if(currentIndex + 1 == questions.length) {
      context.read(timerProvider.notifier).pause();
    }
    state = state.copyWith(
      selectedAnswer: '',
      status: currentIndex + 1 < questions.length
          ? QuizStatus.initial
          : QuizStatus.complete,
    );
  }

  void reset(BuildContext context) {
    context.read(timerProvider.notifier).reset();
    state = QuizState.initial();
  }
}
