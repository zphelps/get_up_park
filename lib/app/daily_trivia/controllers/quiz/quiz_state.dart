import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_up_park/app/daily_trivia/begin_trivia_view.dart';
import 'package:get_up_park/app/daily_trivia/models/question_model.dart';
import 'package:meta/meta.dart';

enum QuizStatus { initial, correct, incorrect, complete }

class QuizState extends Equatable {
  final String selectedAnswer;
  final int score;
  final List<Question> correct;
  final List<Question> incorrect;
  final QuizStatus status;

  bool get answered =>
      status == QuizStatus.incorrect || status == QuizStatus.correct;

  const QuizState({
    required this.selectedAnswer,
    required this.score,
    required this.correct,
    required this.incorrect,
    required this.status,
  });

  factory QuizState.initial() {
    return QuizState(
      selectedAnswer: '',
      score: 0,
      correct: [],
      incorrect: [],
      status: QuizStatus.initial,
    );
  }

  @override
  List<Object> get props => [
        selectedAnswer,
        correct,
        incorrect,
        status,
      ];

  QuizState copyWith({
    String? selectedAnswer,
    int? score,
    List<Question>? correct,
    List<Question>? incorrect,
    QuizStatus? status,
  }) {
    return QuizState(
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      score: score ?? this.score,
      correct: correct ?? this.correct,
      incorrect: incorrect ?? this.incorrect,
      status: status ?? this.status,
    );
  }
}
