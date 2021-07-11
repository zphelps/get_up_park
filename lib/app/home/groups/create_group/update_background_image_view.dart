import 'dart:io';

import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/services/firestore_database.dart';
import 'package:get_up_park/shared_widgets/loading.dart';
import 'package:images_picker/images_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class UpdateBackgroundImageView extends StatefulWidget {
  UpdateBackgroundImageView({required this.group});

  final Group group;

  @override
  _UpdateBackgroundImageViewState createState() => _UpdateBackgroundImageViewState();
}

class _UpdateBackgroundImageViewState extends State<UpdateBackgroundImageView> {

  final picker = ImagesPicker;

  Future getBackgroundImageFromPicker() async {
    final List<Media>? pickedFile = await ImagesPicker.pick(
      count: 1,
      pickType: PickType.image,
    );

    setState(() {
      if (pickedFile != null) {
        _backgroundImage = File(pickedFile[0].path);
      } else {
        print('No image selected.');
      }
    });
  }

  File? _backgroundImage;

  bool _loading = false;

  Future<void> _submit() async {
    try {
      setState(() {
        _loading = true;
      });
      final database = context.read<FirestoreDatabase>(databaseProvider);
      final _backgroundImageURL = await database.uploadFile(_backgroundImage!);
      await database.setGroupBackgroundImage(widget.group.id, _backgroundImageURL);
      await Future.delayed(const Duration(seconds: 1));
      Navigator.of(context).popUntil((route) => !route.hasActiveRouteBelow);
    } catch (e) {
      setState(() {
        _loading = false;
      });
      showExceptionAlertDialog(
        context: context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading ? const Loading(loadingMessage: 'Updating') : Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Background Image',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: InkWell(
              onTap: _submit,
              child: const CircleAvatar(
                backgroundColor: Colors.red,
                radius: 15,
                child: Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Center(
              child: _backgroundImage == null
                  ? const Image(
                  image: AssetImage('assets/noImageSelected.png'),
                  height: 200,
                  width: 250) //Text('No image selected.')
                  : Image(image: FileImage(_backgroundImage!),
                  height: 200,
                  width: 250) //Image.file(_image),
          ),
          const SizedBox(height: 5),
          TextButton(
            onPressed: getBackgroundImageFromPicker,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 6, horizontal: 12),
              child: Text(
                _backgroundImage == null ? 'Select image' : 'Change image',
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
    );
  }
}
