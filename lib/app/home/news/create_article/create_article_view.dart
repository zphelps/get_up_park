import 'dart:io';
import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/news/article_model.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/services/firestore_database.dart';
import 'package:get_up_park/shared_widgets/loading.dart';
import 'package:images_picker/images_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';


class CreateArticleView extends StatefulWidget {
  const CreateArticleView();

  @override
  State<CreateArticleView> createState() => _CreateArticleViewState();
}

class _CreateArticleViewState extends State<CreateArticleView> {
  //final _formKey = GlobalKey<FormState>();
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];

  final picker = ImagesPicker;

  Map? dataFromGroupSelector;

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
  File? _image;
  String? _group;
  String? _groupLogoURL;
  String? _category;

  bool _validateAndSaveForm() {
    final form = _formKeys[_currentStep].currentState!;
    if (_currentStep == 2) {
      if (_image != null) {
        form.save();
        return true;
      }
      return false;
    }
    else if (_currentStep == 3) {
      if (_group != null) {
        form.save();
        return true;
      }
      return false;
    }
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  int _currentStep = 0;
  bool _formComplete = false;
  bool _loading = false;
  StepperType stepperType = StepperType.vertical;



  switchStepsType() {
    setState(() =>
    stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() async {
    FocusScope.of(context).unfocus();
    if (_validateAndSaveForm() && _currentStep < 3) {
      setState(() => _currentStep += 1);
    }
    else if(_validateAndSaveForm() && _currentStep == 3) {
      setState(() {
        _loading = true;
      });
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _formComplete = true;
        _loading = false;
      });
    }
    return null;
  }

  cancel() {
    _currentStep > 0 ?
    setState(() => _currentStep -= 1) : null;
  }

  Future<void> _submit() async {
    try {
      setState(() {
        _loading = true;
      });
      final database = context.read<FirestoreDatabase>(databaseProvider);
      final _imageURL = await database.uploadFile(_image!, _group ?? 'misc');
      final article = Article(
        id: documentIdFromCurrentDate(),
        title: _title!,
        body: _body!,
        imageURL: _imageURL,
        category: _category!,
        group: _group!,
        groupLogoURL: _groupLogoURL!,
        date: DateTime.now().toString(),
        gameID: '',
        gameDone: 'false'
      );
      await database.setArticle(article);
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
        title: Text(
          _formComplete ? 'Review article' : 'Article Details',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 1,
      ),
      body: _formComplete ? article_preview_widget(context, Article(
        id: documentIdFromCurrentDate(),
        title: _title!,
        body: _body!,
        imageURL: _image!.path,
        category: _category!,
        group: _group!,
        groupLogoURL: _groupLogoURL!,
        date: DateTime.now().toString(),
        gameID: '',
        gameDone: 'false'
      )): _buildContents(),
    );
  }

  Widget _buildContents() {
    return Stack(
      children: [
        Column(children: <Widget>[
          Expanded(
            child: Stepper(
              steps: <Step>[
                Step(
                  title: const Text('Title'),
                  subtitle: const Text('Give your article a descriptive name.'),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 0 ?
                  StepState.complete : StepState.disabled,
                  content: Form(
                    key: _formKeys[0],
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Article title',
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
                          (value ?? '').isNotEmpty
                              ? null
                              : 'Article title can\'t be empty',
                          onSaved: (value) => _title = value,
                        ),
                      ],
                    ),
                  ),
                ),
                Step(
                  isActive: _currentStep >= 1,
                  state: _currentStep >= 1 ?
                  StepState.complete : StepState.disabled,
                  title: const Text('Description'),
                  subtitle: const Text(
                      'Please provide your article\'s details here.'),
                  content: Form(
                    key: _formKeys[1],
                    child: Column(
                      children: <Widget>[
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
                          (value ?? '').isNotEmpty
                              ? null
                              : 'Article description can\'t be empty',
                          onSaved: (value) => _body = value,
                        ),
                      ],
                    ),
                  ),
                ),
                Step(
                  isActive: _currentStep >= 2,
                  state: _currentStep >= 2 ?
                  StepState.complete : StepState.disabled,
                  title: const Text('Image'),
                  subtitle: const Text(
                      "Please choose an image to be displayed with your article."),
                  content: Form(
                    key: _formKeys[2],
                    child: Column(
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
                  ),
                ),
                Step(
                  isActive: _currentStep >= 3,
                  state: _currentStep >= 3 ?
                  StepState.complete : StepState.disabled,
                  title: const Text('Group'),
                  subtitle: const Text("Please choose a group for your article."),
                  content: Form(
                    key: _formKeys[3],
                    child: Column(
                      children: <Widget>[
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
                              };
                              _group = dataFromGroupSelector!['group'];
                              _groupLogoURL =
                              dataFromGroupSelector!['groupLogoURL'];
                              _category = dataFromGroupSelector!['category'];
                            });
                          },
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: _groupLogoURL == null ? Colors
                                  .grey[300] : Colors.transparent,
                              child: () {
                                if (_groupLogoURL != null) {
                                  return CachedNetworkImage(
                                    memCacheHeight: 300,
                                    memCacheWidth: 300,
                                    imageUrl: _groupLogoURL!,
                                    fit: BoxFit.fitHeight,
                                    width: 30,
                                    height: 30,
                                    placeholder: (context, url) =>
                                    const Icon(Icons.group, color: Colors
                                        .black), //Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
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
                        )
                      ],
                    ),
                  ),
                ),
              ],
              currentStep: _currentStep,
              onStepTapped: (step) => tapped(step),
              onStepContinue: continued,
              onStepCancel: cancel,
              type: stepperType,
            ),
          ),
        ]
        ),
            () {
          if(_loading) {
            return const Loading(loadingMessage: 'Preparing for review');
          }
          return const SizedBox(width: 0);
        } (),
      ],
    );
  }

  Widget article_preview_widget(BuildContext context, Article article) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: <Widget>[
            // Add the app bar to the CustomScrollView.
            SliverAppBar(
              automaticallyImplyLeading: false,
              stretch: true,
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 1,
              iconTheme: const IconThemeData(
                color: Colors.black,
              ),
              floating: false,
              // Display a placeholder widget to visualize the shrinking size.
              flexibleSpace: FlexibleSpaceBar(
                background: DecoratedBox(
                  decoration: const BoxDecoration(),
                  child: Image(
                    image: FileImage(File(article.imageURL)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Make the initial height of the SliverAppBar larger than normal.
              expandedHeight: 350,
            ),
            // Next, create a SliverList
            SliverList(
                delegate: SliverChildListDelegate.fixed(
                    [
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15),
                        child: Text(
                          DateFormat.yMMMMd('en_US')
                              .format(DateTime.parse(article.date))
                              .toUpperCase(),
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15),
                        child: SizedBox(
                          child: AutoSizeText(
                            article.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 32,
                              color: Colors.black,
                            ),
                            maxLines: 3,
                          ),
                        ),
                      ),
                      const Divider(height: 25),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15),
                        child: Text(
                          'Written by: ${article.group}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[900],
                          ),
                        ),
                      ),
                      const Divider(height: 25),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15),
                        child: Text(
                          article.body,
                          style: TextStyle(
                            color: Colors.grey[900],
                            fontSize: 16,
                            letterSpacing: -0.1,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      //const SizedBox(height: 15),
                      const Divider(
                        height: 30,
                        thickness: 2,
                      ),
                    ]
                )
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.1,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        setState(() {
                          _loading = true;
                        });
                        await Future.delayed(const Duration(milliseconds: 500));
                        setState(() {
                          _loading = false;
                          _formComplete = false;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 45),
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: MediaQuery.of(context).size.width * 0.18),
                        child: const Text(
                          'Edit',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.red, width: 2),
                          borderRadius: BorderRadius.circular(10),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.grey.withOpacity(0.25),
                          //     spreadRadius: 1,
                          //     blurRadius: 4,
                          //   )
                          // ]
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    InkWell(
                      onTap: () async {
                        _submit();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 45),
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: MediaQuery.of(context).size.width * 0.17),
                        child: const Text(
                          'Publish',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.red, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.65),
              ),
            ),
          ],
        ),
            () {
          if(_loading) {
            return const Loading(loadingMessage: 'One moment');
          }
          return const SizedBox(width: 0);
        } (),
      ],
    );
  }
}

