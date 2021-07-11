import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/events/event_model.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/home/sports/game_model.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/services/firestore_database.dart';
import 'package:get_up_park/shared_widgets/loading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CreateGameView extends StatefulWidget {
  const CreateGameView({required this.group});

  final Group group;

  @override
  State<CreateGameView> createState() => _CreateGameViewState();
}

class _CreateGameViewState extends State<CreateGameView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _group = widget.group.name;
  }

  final _formKey = GlobalKey<FormState>();

  Map? dataFromGroupSelector;

  String? _opponentName;
  String? _opponentLogoURL;
  String? _group;
  String? _date = DateTime.now().toString();

  bool _validateAndSaveForm() {
    final form = _formKey.currentState!;
    if (form.validate() && _group != null) {
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
        final id = documentIdFromCurrentDate();
        final game = Game(
          id: id,
          opponentName: _opponentName!,
          opponentLogoURL: _opponentLogoURL!,
          homeScore: '',
          opponentScore: '',
          sport: widget.group.sport,
          group: _group!,
          date: _date!,
          gameDone: 'false',
        );
        await database.setGame(game);
        await Future.delayed(const Duration(seconds: 1));
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
          'New Game',
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
              const SizedBox(height: 12),
              DateTimeField(
                validator: (value) =>
                (value ?? '').toString().isNotEmpty
                    ? null
                    : 'Event date can\'t be empty',
                //decoration: textInputDecoration.copyWith(hintText: 'Select date...'),
                decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Icons.chevron_right,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  hintText: DateTime.now().toString(),
                  labelText: 'Date',
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
                // format: DateFormat("yyyy-MM-dd HH:mm"),
                format: DateFormat("yMMMMEEEEd"),
                onShowPicker: (context, currentValue) async {
                  print(currentValue);
                  final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2021),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2022));
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime:
                      TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                    );
                    _date = DateTimeField.combine(date, time).toString();
                    return DateTimeField.combine(date, time);
                  } else {
                    return currentValue;
                  }
                },
              ),
              InkWell(
                onTap: () async {
                  dynamic result = await Navigator.of(
                      context, rootNavigator: true).pushNamed(
                    AppRoutes.selectOpponentView,
                  );
                  setState(() {
                    dataFromGroupSelector = {
                      'opponent': result['opponent'],
                      'opponentLogoURL': result['opponentLogoURL'],
                    };
                    _opponentName = dataFromGroupSelector!['opponent'];
                    _opponentLogoURL =
                    dataFromGroupSelector!['opponentLogoURL'];
                  });
                },
                child: ListTile(
                  visualDensity: const VisualDensity(vertical: -4),
                  contentPadding: const  EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  leading: CircleAvatar(
                    backgroundColor: _opponentLogoURL == null ? Colors
                        .grey[300] : Colors.transparent,
                    child: () {
                      if (_opponentLogoURL != null) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: CachedNetworkImage(
                            memCacheHeight: 300,
                            memCacheWidth: 300,
                            fadeOutDuration: Duration.zero,
                            placeholderFadeInDuration: Duration.zero,
                            fadeInDuration: Duration.zero,
                            imageUrl: _opponentLogoURL!,
                            fit: BoxFit.fitWidth,
                            width: 35,
                            height: 35,
                            placeholder: (context, url) =>
                            const Icon(Icons.group, color: Colors
                                .black), //Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
                          ),
                        );
                      }
                      return const Icon(Icons.group, color: Colors.black);
                    }(),
                  ),
                  title: Text(
                    _opponentName ?? 'Select',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                  ),
                ),
              ),
              const Divider(
                height: 0,
                thickness: 0.5,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}