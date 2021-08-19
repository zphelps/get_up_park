import 'dart:io';
import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/app/daily_trivia/models/question_model.dart';
import 'package:get_up_park/app/home/news/article_model.dart';
import 'package:get_up_park/app/home/sports/game_model.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/services/firestore_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/services/push_notifications.dart';
import 'package:images_picker/images_picker.dart';

class CreateTriviaQuestionView extends StatefulWidget {
  const CreateTriviaQuestionView();

  @override
  State<CreateTriviaQuestionView> createState() => _CreateTriviaQuestionViewState();
}

class _CreateTriviaQuestionViewState extends State<CreateTriviaQuestionView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  String? _question;
  String? _correctAnswer;
  String? _incorrectAnswer1;
  String? _incorrectAnswer2;
  String? _incorrectAnswer3;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState!;
    if((_question ?? '').length > 0 && (_correctAnswer ?? '').length > 0 && (_incorrectAnswer1 ?? '').length > 0 && (_incorrectAnswer2 ?? '').length > 0 && (_incorrectAnswer3 ?? '').length > 0) {
      form.save();
      return true;
    }
    else {
      return false;
    }
  }

  bool _loading = false;


  Future<void> _submit() async {
    if(_validateAndSaveForm()){
      try {
        setState(() {
          _loading = true;
        });
        final database = context.read<FirestoreDatabase>(databaseProvider);

        Question question = Question(
          id: documentIdFromCurrentDate(),
          category: '',
          difficulty: '',
          question: _question!,
          correctAnswer: _correctAnswer!,
          usersAsked: [database.uid],
          answers: [_incorrectAnswer1, _incorrectAnswer2, _incorrectAnswer3],
        );
        await database.setTriviaQuestion(question);

        //await Future.delayed(const Duration(seconds: 1));
        Navigator.of(context).pop();
      } catch (e) {
        showExceptionAlertDialog(
          context: context,
          title: 'Operation failed',
          exception: e,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Create Trivia Question',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          _loading ?
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 25),
            child: SizedBox(width: 25, child: CircularProgressIndicator()),
          ) :
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: _submit,
              child: Chip(
                backgroundColor: () {
                  if((_question ?? '').length > 0 && (_correctAnswer ?? '').length > 0 && (_incorrectAnswer1 ?? '').length > 0 && (_incorrectAnswer2 ?? '').length > 0 && (_incorrectAnswer3 ?? '').length > 0) {
                    return Colors.red;

                  }
                  else {
                    return Colors.red[200];
                  }
                }(),
                label: const Text(
                  'Create',
                  style:
                  TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
        elevation: 1,
      ),
      body: _buildContents(),
    );
  }

  Widget _buildContents() {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // const Divider(height: 0, thickness: 0.5, color: Colors.grey),
              TextFormField(
                autofocus: true,
                autocorrect: true,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  alignLabelWithHint: true,
                  labelText: 'Write your question...',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      )
                  ),
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 0.5,
                      )
                  ),
                  disabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 0.5,
                      )
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      )
                  ),
                ),
                keyboardAppearance: Brightness.light,
                //maxLines: 8,
                minLines: 5,
                maxLines: 30,
                initialValue: _question,
                validator: (value) =>
                (value ?? '').isNotEmpty
                    ? null
                    : 'Question can\'t be empty',
                onChanged: (value) {
                  setState(() {
                    _question = value;
                  });
                },
              ),
              TextFormField(
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    labelText: 'Correct Answer',
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 0.5,
                        )
                    ),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 0.5,
                        )
                    ),
                    disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 0.5,
                        )
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 0.5,
                        )
                    ),
                  ),
                  keyboardAppearance: Brightness.light,
                  initialValue: _correctAnswer,
                  validator: (value) =>
                  (value ?? '').isNotEmpty
                      ? null
                      : 'Correct answer can\'t be empty',
                  onChanged: (value) {
                    setState(() {
                      _correctAnswer = value;
                    });
                  }
              ),
              TextFormField(
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    labelText: 'Incorrect Answer #1',
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 0.5,
                        )
                    ),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 0.5,
                        )
                    ),
                    disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 0.5,
                        )
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 0.5,
                        )
                    ),
                  ),
                  keyboardAppearance: Brightness.light,
                  initialValue: _incorrectAnswer1,
                  validator: (value) =>
                  (value ?? '').isNotEmpty
                      ? null
                      : 'Incorrect answer can\'t be empty',
                  onChanged: (value) {
                    setState(() {
                      _incorrectAnswer1 = value;
                    });
                  }
              ),
              TextFormField(
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    labelText: 'Incorrect Answer #2',
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 0.5,
                        )
                    ),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 0.5,
                        )
                    ),
                    disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 0.5,
                        )
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 0.5,
                        )
                    ),
                  ),
                  keyboardAppearance: Brightness.light,
                  initialValue: _incorrectAnswer2,
                  validator: (value) =>
                  (value ?? '').isNotEmpty
                      ? null
                      : 'Incorrect answer can\'t be empty',
                  onChanged: (value) {
                    setState(() {
                      _incorrectAnswer2 = value;
                    });
                  }
              ),
              TextFormField(
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    labelText: 'Incorrect Answer #3',
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 0.5,
                        )
                    ),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 0.5,
                        )
                    ),
                    disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 0.5,
                        )
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 0.5,
                        )
                    ),
                  ),
                  keyboardAppearance: Brightness.light,
                  initialValue: _incorrectAnswer3,
                  validator: (value) =>
                  (value ?? '').isNotEmpty
                      ? null
                      : 'Incorrect answer can\'t be empty',
                  onChanged: (value) {
                    setState(() {
                      _incorrectAnswer3 = value;
                    });
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}