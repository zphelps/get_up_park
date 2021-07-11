import 'dart:io';
import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/news/article_model.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/services/firestore_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/services/push_notifications.dart';
import 'package:images_picker/images_picker.dart';

class EditNewsView extends StatefulWidget {
  const EditNewsView({required this.article});

  final Article article;

  @override
  State<EditNewsView> createState() => _EditNewsViewState();
}

class _EditNewsViewState extends State<EditNewsView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _title = widget.article.title;
    _body = widget.article.body;
    _group = widget.article.group;
    _category = widget.article.category;
    _groupLogoURL = widget.article.groupLogoURL;
    _gameID = widget.article.gameID;
  }

  final _formKey = GlobalKey<FormState>();

  final picker = ImagesPicker;

  Map? dataFromGroupSelector;

  final articleCharacterCountMinimum = 300;

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

  String? _title;
  String? _body;
  String? _group;
  String? _groupLogoURL;
  String? _category;
  File? _image;
  String? _gameID;
  String? _sport;
  String? _opponentName;
  String? _opponentLogoURL;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState!;
    if((_title ?? '').length > 0) {
      if(_body != null && _group != null && _image != null && _title!.length > 35) {
        form.save();
        return true;
      }
      return false;
    }
    else {
      if(_body != null && _group != null) {
        form.save();
        return true;
      }
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
        String? _imageURL;
        if(_image!=null) {
          _imageURL = await database.uploadFile(_image!);
        }
        final article = Article(
          id: widget.article.id,
          title: _title ?? '',
          body: _body!,
          imageURL: _imageURL ?? '',
          category: _category!,
          group: _group!,
          groupLogoURL: _groupLogoURL!,
          date: widget.article.date,
          gameID: _gameID ?? '',
        );
        await database.updateArticle(article);
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
          'Update News',
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
                  if((_title ?? '').length > 0) {
                    if(_body != null && _group != null && _image != null && _title!.length > 35) {
                      return Colors.red;
                    }
                    return Colors.red[200];
                  }
                  else {
                    if(_body != null && _group != null) {
                      return Colors.red;
                    }
                    return Colors.red[200];
                  }
                }(),
                label: const Text(
                  'Update',
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
                  labelText: 'Write your news...',
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
                    : 'News body can\'t be empty',
                onChanged: (value) {
                  setState(() {
                    _body = value;
                  });
                },
              ),
              () {
                if((_body ?? '').length > articleCharacterCountMinimum) {
                  return Column(
                    children: [
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                          labelText: 'Title',
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
                        initialValue: _title,
                        validator: (value) =>
                        (value ?? '').length > 35
                            ? null
                            : 'Title must be longer than 35 characters.',
                        onChanged: (value) {
                          setState(() {
                            _title = value;
                          });
                        },
                      ),
                      const SizedBox(height: 2),
                    ],
                  );
                }
                return const SizedBox(height: 0);
              }(),
              InkWell(
                onTap: () async {
                  dynamic result = await Navigator.of(
                      context, rootNavigator: true).pushNamed(
                    AppRoutes.selectGroup,
                  );
                  setState(() {
                    dataFromGroupSelector = {
                      'group': result['group'],
                      'groupLogoURL': result['groupLogoURL'],
                      'category': result['category'],
                      'sport': result['sport'],
                    };
                    _group = dataFromGroupSelector!['group'];
                    _groupLogoURL =
                    dataFromGroupSelector!['groupLogoURL'];
                    _category = dataFromGroupSelector!['category'];
                    _sport = dataFromGroupSelector!['sport'];
                  });
                },
                child: ListTile(
                  visualDensity: const VisualDensity(vertical: -4),
                  contentPadding: const  EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  leading: CircleAvatar(
                    backgroundColor: _groupLogoURL == null ? Colors
                        .grey[300] : Colors.transparent,
                    child: () {
                      if (_groupLogoURL != null) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: CachedNetworkImage(
                            memCacheHeight: 300,
                            memCacheWidth: 300,
                            fadeOutDuration: Duration.zero,
                            placeholderFadeInDuration: Duration.zero,
                            fadeInDuration: Duration.zero,
                            imageUrl: _groupLogoURL!,
                            fit: BoxFit.fitWidth,
                            width: 40,
                            height: 40,
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
                    _group ?? 'Select',
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
              const Divider(height: 0, color: Colors.grey, thickness: 0.5),
            () {
              if((_sport ?? '').length > 0) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        dynamic result = await Navigator.of(
                            context, rootNavigator: true).pushNamed(
                          AppRoutes.selectGame,
                          arguments: {
                            'selectedGroup': _group,
                          }
                        );
                        setState(() {
                          dataFromGroupSelector = {
                            'opponentName': result['opponentName'],
                            'opponentLogoURL': result['opponentLogoURL'],
                            'gameID': result['gameID'],
                          };
                          _opponentName = dataFromGroupSelector!['opponentName'];
                          _opponentLogoURL =
                          dataFromGroupSelector!['opponentLogoURL'];
                          _gameID = dataFromGroupSelector!['gameID'];
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
                                  width: 40,
                                  height: 40,
                                  placeholder: (context, url) =>
                                  const Icon(Icons.sports, color: Colors
                                      .black), //Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
                                ),
                              );
                            }
                            return const Icon(Icons.sports, color: Colors.black);
                          }(),
                        ),
                        title: Text(
                          _opponentName ?? 'Link to $_group game',
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
                    const Divider(height: 0, color: Colors.grey, thickness: 0.5),
                  ],
                );
              }
              else {
                return const SizedBox(height: 0);
              }
            }(),
              () {
                if(_image == null) {
                  return ListTile(
                    onTap: () {
                      getImageFromPicker();
                    },
                    visualDensity: const VisualDensity(vertical: -4),
                    contentPadding: const  EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: const Icon(Icons.image_outlined, color: Colors.black),
                    ),
                    title: const Text(
                      'Add image',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                    ),
                  );
                }
                return const SizedBox(height: 0);
              }(),
              () {
                if(_image != null) {
                  return Column(
                    children: <Widget>[
                      Center(
                          child: _image == null
                              ? const Image(
                              image: AssetImage('assets/noImageSelected.png'),
                              height: 200,
                              width: 250) //Text('No image selected.')
                              : Image(image: FileImage(_image!),
                              height: MediaQuery.of(context).size.width*0.75,
                              width: MediaQuery.of(context).size.width*0.9) //Image.file(_image),
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
                  );
                }
                return const SizedBox(height: 0);
              }(),
              const Divider(height: 0, color: Colors.grey, thickness: 0.5),
              const Divider(
                height: 0,
                thickness: 0.5,
                color: Colors.grey,
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}