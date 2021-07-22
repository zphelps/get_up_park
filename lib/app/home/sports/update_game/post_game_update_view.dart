import 'dart:io';
import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/news/article_model.dart';
import 'package:get_up_park/app/home/sports/game_model.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/services/firestore_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/services/push_notifications.dart';
import 'package:images_picker/images_picker.dart';

class PostGameUpdateView extends StatefulWidget {
  const PostGameUpdateView({required this.game, required this.groupLogoURL});

  final Game game;
  final String groupLogoURL;

  @override
  State<PostGameUpdateView> createState() => _PostGameUpdateViewState();
}

class _PostGameUpdateViewState extends State<PostGameUpdateView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _group = widget.game.group;
    _groupLogoURL = widget.groupLogoURL;
    _gameID = widget.game.id;

  }

  final _formKey = GlobalKey<FormState>();

  final articleCharacterCountMinimum = 300;

  String? _body;
  String? _group;
  String? _groupLogoURL;
  String? _gameID;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState!;
    if((_body ?? '').length > 0) {
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
        final article = Article(
            id: documentIdFromCurrentDate(),
            title: '',
            body: _body!,
            imageURL: '',
            category: 'Sports',
            group: _group!,
            groupLogoURL: _groupLogoURL!,
            date: DateTime.now().toString(),
            gameID: _gameID ?? '',
            gameDone: 'false',
        );
        await database.setArticle(article);
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
          'Game Update',
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
                  if((_body ?? '').length > 0) {
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
                  labelText: 'Write game update...',
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
                initialValue: _body,
                validator: (value) =>
                (value ?? '').isNotEmpty
                    ? null
                    : 'update body can\'t be empty',
                onChanged: (value) {
                  setState(() {
                    _body = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}