import 'dart:io';

import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/sports/opponent_model.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/services/firestore_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:images_picker/images_picker.dart';


class CreateOpponentView extends StatefulWidget {
  const CreateOpponentView();

  @override
  State<CreateOpponentView> createState() => _CreateOpponentViewState();
}

class _CreateOpponentViewState extends State<CreateOpponentView> {

  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  Map? dataFromGroupSelector;

  final picker = ImagesPicker;

  Future getImageFromPicker() async {
    final List<Media>? pickedFile = await ImagesPicker.pick(
      count: 1,
      pickType: PickType.image,
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile[0].path);
      } else {
        print('No image selected.');
      }
    });
  }

  String? _opponentName;
  String? _opponentLogoURL;
  File? _image;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState!;
    if (form.validate() && _image != null) {
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
        final _opponentLogoURL = await database.uploadFile(_image!, 'opponentLogos');
        final opponent = Opponent(
          id: id,
          name: _opponentName!,
          logoURL: _opponentLogoURL,
        );
        await database.setOpponent(opponent);
        // await Future.delayed(const Duration(seconds: 1));
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
          'Create Opponent',
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
              const SizedBox(height: 10),
              const Divider(height: 0, thickness: 0.5, color: Colors.grey),
              TextFormField(
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  labelText: 'Opponent name',
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
                validator: (value) =>
                (value ?? '').isNotEmpty
                    ? null
                    : 'Opponent name can\'t be empty',
                onSaved: (value) => _opponentName = value,
              ),
              const SizedBox(height: 2),
              Column(
                children: <Widget>[
                  Center(
                      child: _image == null
                          ? const Image(
                          image: AssetImage('assets/noImageSelected.png'),
                          height: 200,
                          width: 250) //Text('No image selected.')
                          : Image(image: FileImage(_image!),
                          height: 200,
                          width: 250) //Image.file(_image),
                  ),
                  const SizedBox(height: 5),
                  TextButton(
                    onPressed: getImageFromPicker,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
                      child: Text(
                        _image == null ? 'Select image' : 'Change image',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(
                height: 0,
                thickness: 0.5,
                color: Colors.grey,
              )
            ],
          ),
        ),
      ),
    );
  }
}