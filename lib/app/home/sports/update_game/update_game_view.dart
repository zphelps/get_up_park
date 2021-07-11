import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/events/event_model.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/home/news/article_model.dart';
import 'package:get_up_park/app/home/sports/game_model.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/services/firestore_database.dart';
import 'package:get_up_park/services/push_notifications.dart';
import 'package:get_up_park/shared_widgets/loading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';


class UpdateGameView extends StatefulWidget {
  const UpdateGameView({required this.game, required this.group});

  final Game game;
  final Group group;

  @override
  State<UpdateGameView> createState() => _UpdateGameViewState();
}

class _UpdateGameViewState extends State<UpdateGameView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isDone = widget.game.gameDone == 'true' ? true : false;
  }

  final _formKey = GlobalKey<FormState>();

  Map? dataFromGroupSelector;

  String? _homeScore;
  String? _opponentScore;
  bool? _isDone;
  bool _post = true;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  bool _loading = false;

  Future<void> _submit() async {
    if(_validateAndSaveForm()){
      try {
        setState(() {
          _loading = true;
        });
        final database = context.read<FirestoreDatabase>(databaseProvider);
        if(_post) {
          String body = '';
          if(int.parse(_homeScore!) > int.parse(_opponentScore!)) {
            if(_isDone!) {
              body = 'FINAL: Park Tudor won $_homeScore-$_opponentScore against ${widget.game.opponentName}';
            }
            else {
              body = 'UPDATE: Park Tudor is up $_homeScore-$_opponentScore against ${widget.game.opponentName}';
            }
          }
          else {
            if(_isDone!) {
              body = 'FINAL: Park Tudor lost $_homeScore-$_opponentScore against ${widget.game.opponentName}';
            }
            else {
              body = 'UPDATE: Park Tudor is down $_homeScore-$_opponentScore against ${widget.game.opponentName}';
            }
          }
          Article article = Article(title: '', body: body,
              gameID: widget.game.id, date: DateTime.now().toString(), category: 'Sports',
              group: widget.group.name, groupLogoURL: widget.group.logoURL, id: documentIdFromCurrentDate(), imageURL: '');
          await database.setArticle(article);
          sendNotification(article, opponent: widget.game.opponentName, opponentLogoURL: widget.game.opponentLogoURL);
          // sendNewsNotifications(article, opponent: widget.game.opponentName, opponentLogoURL: widget.game.opponentLogoURL);
        }
        await database.updateGameScore(widget.game.id, _opponentScore!, _homeScore!, _isDone! ? 'true' : 'false');
        int count = 0;
        Navigator.of(context).popUntil((_) => count++ >= 2);
        Navigator.of(context, rootNavigator: true).pushNamed(
            AppRoutes.gameView,
          arguments: {
            'game': Game(
              homeScore: _homeScore!,
              opponentScore: _opponentScore!,
              opponentLogoURL: widget.game.opponentLogoURL,
              opponentName: widget.game.opponentName,
              group: widget.game.group,
              id: widget.group.id,
              gameDone: _isDone! ? 'true' : 'false',
              date: widget.game.date,
              sport: widget.game.sport,
            ),
            'group': widget.group,
            'admin': 'true'
          },
        );
        // await Future.delayed(const Duration(milliseconds: 500));
        // Navigator.of(context).pop();
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
    dataFromGroupSelector =
    (dataFromGroupSelector == null ? dataFromGroupSelector : ModalRoute
        .of(context)!
        .settings
        .arguments) as Map?;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Report Score',
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
              child: const Chip(
                backgroundColor: Colors.red,//_text != null ? Colors.red : Colors.red[200],
                label: Text(
                  'Report',
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
              const Divider(height: 0, thickness: 0.5, color: Colors.grey),
              TextFormField(
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  labelText: 'Panther score',
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
                initialValue: widget.game.homeScore,
                keyboardAppearance: Brightness.light,
                validator: (value) =>
                (value ?? '').isNotEmpty
                    ? null
                    : 'Opponent name can\'t be empty',
                onSaved: (value) => _homeScore = value,
              ),
              const SizedBox(height: 2),
              TextFormField(
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  labelText: '${widget.game.opponentName} score',
                  labelStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      )
                  ),
                  border: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 0.5,
                      )
                  ),
                  disabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 0.5,
                      )
                  ),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      )
                  ),
                ),
                initialValue: widget.game.opponentScore,
                keyboardAppearance: Brightness.light,
                validator: (value) =>
                (value ?? '').isNotEmpty
                    ? null
                    : 'Opponent name can\'t be empty',
                onSaved: (value) => _opponentScore = value,
              ),
              const Divider(
                height: 0,
                thickness: 0.5,
                color: Colors.grey,
              ),
              ListTile(
                onTap: () {
                  setState(() {
                    _isDone = !_isDone!;
                  });
                },
                visualDensity: const VisualDensity(vertical: -4),
                contentPadding: const  EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                title: const Text(
                  'Final Score?',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                trailing: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Icon(
                    _isDone! ? Icons.check_circle : Icons.check_circle_outline,
                    color: _isDone! ? Colors.red : Colors.grey,
                  ),
                ),
              ),
              const Divider(
                height: 0,
                thickness: 0.5,
                color: Colors.grey,
              ),
              ListTile(
                visualDensity: const VisualDensity(vertical: -4),
                contentPadding: const  EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                title: const Text(
                  'Create News Post?',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                trailing: Switch(
                  value: _post,
                  onChanged: (value) {
                    setState(() {
                      _post = value;
                    });
                  },
                  activeColor: Colors.red,
                  activeTrackColor: Colors.red[200],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}