import 'package:flutter/services.dart';
import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/app/announcements/announcement_model.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/services/firestore_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddAnnouncement extends StatefulWidget {
  const AddAnnouncement({Key? key}) : super(key: key);
  //final Job? job;

  static Future<void> show(BuildContext context) async {
    await Navigator.of(context, rootNavigator: true).pushNamed(
      AppRoutes.addAnnouncement,
    );
  }

  @override
  _AddAnnouncementState createState() => _AddAnnouncementState();
}

class _AddAnnouncementState extends State<AddAnnouncement> {
  final _formKey = GlobalKey<FormState>();

  String? _title;
  String? _body;
  String? _url;

  @override
  void initState() {
    super.initState();
    // if (widget.job != null) {
    //   _name = widget.job?.name;
    //   _ratePerHour = widget.job?.ratePerHour;
    // }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final database = context.read<FirestoreDatabase>(databaseProvider);
        final id = documentIdFromCurrentDate();
        final announcement = Announcement(id: id, title: _title ?? '', body: _body ?? '', url: _url ?? '', date: DateTime.now().toString());
        await database.setAnnouncement(announcement);
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
      appBar: AppBar(
        brightness: Brightness.light,
        title: const Text(
          'Add Announcement',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          FlatButton(
            child: const Text(
              'Add',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () => _submit(),
          ),
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: const InputDecoration(
          labelText: 'Title',
          labelStyle: TextStyle(
            color: Colors.grey,
          ),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              )
          ),
        ),
        keyboardAppearance: Brightness.light,
        initialValue: _title,
        validator: (value) =>
        (value ?? '').isNotEmpty ? null : 'Title can\'t be empty',
        onSaved: (value) => _title = value,
      ),
      TextFormField(
        decoration: const InputDecoration(
          labelText: 'Description',
          labelStyle: TextStyle(
            color: Colors.grey,
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 2,
            )
          )
        ),
        keyboardAppearance: Brightness.light,
        //expands: true,
        minLines: 3,
        maxLines: 20,
        initialValue: _body,
        validator: (value) =>
        (value ?? '').isNotEmpty ? null : 'Description can\'t be empty',
        onSaved: (value) => _body = value,
      ),
      TextFormField(
        decoration: const InputDecoration(
            labelText: 'URL',
            labelStyle: TextStyle(
              color: Colors.grey,
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 2,
                )
            )
        ),
        keyboardAppearance: Brightness.light,
        initialValue: _url,
        onSaved: (value) => _url = value,
      ),
    ];
  }
}