import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Question extends Equatable {
  final String id;
  final String category;
  final String difficulty;
  final String question;
  final String correctAnswer;
  final List<dynamic> answers;
  final List<dynamic> usersAsked;

  const Question({
    required this.id,
    required this.category,
    required this.difficulty,
    required this.question,
    required this.correctAnswer,
    required this.answers,
    required this.usersAsked
  });

  @override
  List<Object> get props => [
    id,
    category,
    difficulty,
    question,
    correctAnswer,
    answers,
    usersAsked,
  ];

  @override
  bool get stringify => true;

  factory Question.fromMap(Map<String, dynamic> map, String id) {
    return Question(
      id: id,
      category: map['category'] ?? '',
      difficulty: map['difficulty'] ?? '',
      question: map['question'] ?? '',
      correctAnswer: map['correctAnswer'] ?? '',
      usersAsked: map['usersAsked'] ?? [],
      answers: List<String>.from(map['answers'] ?? [])
        ..add(map['correctAnswer'] ?? '')
        ..shuffle(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'difficulty': difficulty,
      'question': question,
      'correctAnswer': correctAnswer,
      'usersAsked': usersAsked,
      'answers': answers,
    };
  }
}

