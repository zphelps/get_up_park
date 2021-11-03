import 'dart:async';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/daily_trivia/controllers/quiz/quiz_controller.dart';
import 'package:get_up_park/app/daily_trivia/controllers/quiz/quiz_state.dart';
import 'package:get_up_park/app/daily_trivia/enums/difficulty.dart';
import 'package:get_up_park/app/daily_trivia/models/failure_model.dart';
import 'package:get_up_park/app/daily_trivia/models/question_model.dart';
import 'package:get_up_park/app/daily_trivia/repositories/quiz/quiz_repository.dart';
import 'package:get_up_park/app/daily_trivia/timer_notifier.dart';
import 'package:get_up_park/app/daily_trivia/trivia_results.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/services/firestore_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:html_character_entities/html_character_entities.dart';
import 'package:images_picker/images_picker.dart';

final quizQuestionsProvider = FutureProvider.autoDispose<List<Question>>(
  (ref) => ref.watch(quizRepositoryProvider).getQuestions(
        numQuestions: 5,
        categoryId: Random().nextInt(24) + 9,
        difficulty: Difficulty.any,
      ),
);

final timerProvider = StateNotifierProvider<TimerNotifier, TimerModel>(
      (ref) => TimerNotifier(),
);

final _buttonState = Provider<ButtonState>((ref) {
  return ref.watch(timerProvider).buttonState;
});

final buttonProvider = Provider<ButtonState>((ref) {
  return ref.watch(_buttonState);
});

final _timeLeftProvider = Provider<String>((ref) {
  return ref.watch(timerProvider).timeLeft;
});
final timeLeftProvider = Provider<String>((ref) {
  return ref.watch(_timeLeftProvider);
});

class BeginTriviaView extends StatefulWidget {
  const BeginTriviaView({Key? key}) : super(key: key);

  @override
  _BeginTriviaViewState createState() => _BeginTriviaViewState();
}

class _BeginTriviaViewState extends State<BeginTriviaView> {

  bool addUserDataToQuestionData = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text(
            'Daily Trivia!',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
            ),
          ),
          scrollable: true,
          content: Column(
            children: [
              Image(
                image: const AssetImage('assets/trivia.png'),
                fit: BoxFit.fitWidth,
                width: MediaQuery.of(context).size.width * 0.45,
                height: MediaQuery.of(context).size.width * 0.3,
              ),
              const SizedBox(height: 10),
              Text(
                'Answer questions quickly to score more points. The quicker you select a correct answer, the more points you receive. You only answer 5 questions a day!',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  onTap: () {
                    context.read(timerProvider.notifier).reset();
                    context.read(timerProvider.notifier).start();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      border: Border.all(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Text(
                      'Begin',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    Navigator.of(context).popUntil((route) => !route.hasActiveRouteBelow);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
        child: QuizScreen()
    );
  }
}

class QuizScreen extends HookWidget {

  @override
  Widget build(BuildContext context) {
    // context.read(timerProvider).start();
    print('build');
    final quizQuestions = useProvider(quizQuestionsProvider);
    // final quizQuestions = useProvider(quizQuestionsProvider);
    final pageController = usePageController();
    final timeLeft = useProvider(timeLeftProvider);
    final state = useProvider(buttonProvider);
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: quizQuestions.when(
          data: (questions) {
            // if(addUserDataToQuestionData) {
            //   for(Question question in questions) {
            //     FirebaseFirestore.instance.collection('questions').doc(question.id).update(
            //         {
            //           'usersAsked': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
            //         });
            //   }
            // }

            return _buildBody(context, pageController, questions, timeLeft);
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => QuizError(
            message: error is Failure ? error.message : 'Something went wrong!',
          ),
        ),
        bottomSheet: quizQuestions.maybeWhen(
          data: (questions) {
            print('update');
            final quizState = useProvider(quizControllerProvider.notifier).state;
            if (!quizState.answered && state != ButtonState.finished) {
              return const SizedBox.shrink();
            }
            return Container(
              color: Colors.white,
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.01),
              child: CustomButton(
                title: pageController.page!.toInt() + 1 < questions.length
                    ? 'Next Question'
                    : 'See Results',
                onTap: () {
                  context
                      .read(quizControllerProvider.notifier)
                      .nextQuestion(questions, pageController.page!.toInt(), context);
                  if (pageController.page!.toInt() + 1 < questions.length) {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.linear,
                    );
                  }
                },
              ),
            );
          },
          orElse: () => const SizedBox.shrink(),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    PageController pageController,
    List<Question> questions,
      String timeLeft,
  ) {
    if (questions.isEmpty) {
      return QuizError(message: 'No questions found.');
    }

    final quizState = useProvider(quizControllerProvider);
    if(quizState.status == QuizStatus.complete) {
      // if(context.read(timerProvider.notifier).mounted) {
      //   context.read(timerProvider.notifier).reset();
      //   context.read(timerProvider.notifier).pause();
      // }
      return QuizResults(state: quizState, questions: questions);
    }
    else {
      return QuizQuestions(
        pageController: pageController,
        state: quizState,
        questions: questions,
        timeLeft: timeLeft,
      );
    }
    // return quizState.status == QuizStatus.complete
    //     ? QuizResults(state: quizState, questions: questions)
    //     : QuizQuestions(
    //         pageController: pageController,
    //         state: quizState,
    //         questions: questions,
    //   timeLeft: timeLeft,
    //       );
  }
}

class QuizError extends StatelessWidget {
  final String message;

  const QuizError({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          CustomButton(
            title: 'Leaderboard',
            onTap: () => Navigator.of(context, rootNavigator: true).pushReplacementNamed(
              AppRoutes.leaderboardView,
            ),
          ),
          CustomButton(
            title: 'Return home',
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

final List<BoxShadow> boxShadow = const [
  BoxShadow(
    color: Colors.black26,
    offset: Offset(0, 2),
    blurRadius: 4.0,
  ),
];

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const CustomButton({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(20.0),
        height: 50.0,
        width: double.infinity,
        decoration: BoxDecoration(
          // color: Colors.red,
          gradient: const LinearGradient(
            // colors: [Color(0xFFD4418E), Color(0xFF0652C5)],
            colors: [Colors.red, Colors.orange],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: boxShadow,
          borderRadius: BorderRadius.circular(24.0),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18.0,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class QuizQuestions extends StatelessWidget {
  final PageController pageController;
  final QuizState state;
  final List<Question> questions;
  final String timeLeft;

  const QuizQuestions({
    required this.pageController,
    required this.state,
    required this.questions,
    required this.timeLeft,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: questions.length,
      itemBuilder: (BuildContext context, int index) {
        final question = questions[index];
        // print(timeLeft);
        // if(timeLeft == '00:00') {
        //   print('herllo');
        //   return Container(height: 100, width: 100, color: Colors.black,);
        // }
        return SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // SizedBox(
              //   width: MediaQuery.of(context).size.width,
              //   child: FAProgressBar(
              //     direction: Axis.horizontal,
              //     maxValue: 1000,
              //     animatedDuration: Duration(milliseconds: 100),
              //     currentValue: int.parse('${timeLeft.substring(0, 2)}${timeLeft.substring(3)}'),
              //     // displayText: '',
              //   ),
              // ),
              const SizedBox(height: 15),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(right: 8),
                    height: 49,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.timer,
                        color: timeLeft == '00:00' ? Colors.red : Colors.grey.withOpacity(0.75),
                      )
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: timeLeft == '00:00' ? Colors.red : Colors.grey.withOpacity(0.5), width: 3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05 + 3),
                      padding: const EdgeInsets.only(right: 10),
                      // child: Align(
                      //   alignment: Alignment.center,
                      //   child: Text(
                      //     timeLeft.substring(1, 2) == '0' ? '' : timeLeft.substring(1, 2),
                      //     style: GoogleFonts.inter(
                      //       color: Colors.white,
                      //       fontWeight: FontWeight.w700,
                      //       fontSize: 18,
                      //     ),
                      //   ),
                      // ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          // colors: [Color(0xFFD4418E), Color(0xFF0652C5)],
                          colors: [Colors.red, Colors.orange],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        // color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      width: (MediaQuery.of(context).size.width * 0.9 - 6) * (double.parse('${timeLeft.substring(0, 2)}${timeLeft.substring(3)}') / 1000),
                      // color: Colors.grey,
                      height: 43,
                    ),
                  ),
                  Text(
                    timeLeft.substring(0, 2) == '10' ? '10' : timeLeft == '00:00' ? "Time's up!" : timeLeft.substring(1, 2),
                    style: GoogleFonts.inter(
                      color: timeLeft == '00:00' ? Colors.red : int.parse('${timeLeft.substring(0, 2)}${timeLeft.substring(3)}') <= 505 ? Colors.black : Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              // Text(
              //   timeLeft
              //   // '${timeLeft.substring(0, 2)}.${timeLeft.substring(3)}',
              // ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.025),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Question ${index + 1} ',
                      style: GoogleFonts.inter(
                        color: Colors.grey[700],
                        fontSize: 26.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '/ ${questions.length}',
                      style: GoogleFonts.inter(
                        color: Colors.grey[700],
                        fontSize: 22.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: const Color(0xff929CC2).withOpacity(0.35),
                height: MediaQuery.of(context).size.height * 0.03, //45.0,
                thickness: 0.5,
                indent: 20.0,
                endIndent: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 12.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: AutoSizeText(
                    HtmlCharacterEntities.decode(question.question),
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              // Divider(
              //   color: Colors.grey[200],
              //   height: 32.0,
              //   thickness: 2.0,
              //   indent: 20.0,
              //   endIndent: 20.0,
              // ),
              const Spacer(),
              Column(
                children: question.answers
                    .map(
                      (e) => AnswerCard(
                        answer: e,
                        isSelected: e == state.selectedAnswer,
                        isCorrect: e == question.correctAnswer,
                        isDisplayingAnswer: timeLeft == '00:00' ? true : state.answered,
                        timeLeft: timeLeft,
                        onTap: () {
                          HapticFeedback.heavyImpact();
                          context.read(timerProvider.notifier).pause();
                          return context
                              .read(quizControllerProvider.notifier)
                              .submitAnswer(question, e, timeLeft);
                        }
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.16),
            ],
          ),
        );
      },
    );
  }
}

class AnswerCard extends StatelessWidget {
  final String answer;
  final bool isSelected;
  final bool isCorrect;
  final bool isDisplayingAnswer;
  final VoidCallback onTap;
  final String timeLeft;

  const AnswerCard({
    required this.answer,
    required this.isSelected,
    required this.isCorrect,
    required this.isDisplayingAnswer,
    required this.onTap,
    required this.timeLeft,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: timeLeft == '00:00' ? () {} : onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.01, //8.0,
          horizontal: 20.0,
        ),
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.0225, //18.0,
          horizontal: 20.0,
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          // color: Colors.white,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.35),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
          border: Border.all(
            color: () {
              if(isDisplayingAnswer) {
                if(isCorrect && timeLeft != '00:00') {
                  return Colors.green;
                }
                else if(isCorrect) {
                  return Colors.blue;
                }
                else if(isSelected) {
                  return Colors.red;
                }
                else {
                  Colors.white;
                }
              }
              return Colors.white;
            }(),
            width: 3.0,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                HtmlCharacterEntities.decode(answer),
                style: TextStyle(
                  // color: Colors.black,
                  color: isDisplayingAnswer && isCorrect ? Colors.black : Colors.grey[700],
                  fontSize: 16.0,
                  fontWeight: isDisplayingAnswer && isCorrect
                      ? FontWeight.w800
                      : FontWeight.w600,
                ),
              ),
            ),
            if (isDisplayingAnswer)
              isCorrect && timeLeft == '00:00'
                  ? const CircularIcon(icon: Icons.circle, color: Colors.blue)
                  : isCorrect ? const CircularIcon(icon: Icons.check, color: Colors.green) : isSelected
                      ? const CircularIcon(
                          icon: Icons.close,
                          color: Colors.red,
                        )
                      : Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.grey.shade600, width: 2)
                ),
              )
            else
              Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.grey.shade600, width: 2)
                ),
              )
          ],
        ),
      ),
    );
  }
}

class CircularIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const CircularIcon({
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24.0,
      width: 24.0,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: boxShadow,
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 16.0,
      ),
    );
  }
}
