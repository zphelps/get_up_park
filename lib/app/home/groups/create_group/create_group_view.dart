import 'dart:io';
import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/home/news/article_model.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/constants/news_categories.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/services/firestore_database.dart';
import 'package:get_up_park/shared_widgets/loading.dart';
import 'package:images_picker/images_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';


class CreateGroupView extends StatefulWidget {
  const CreateGroupView();

  @override
  State<CreateGroupView> createState() => _CreateGroupViewState();
}

class _CreateGroupViewState extends State<CreateGroupView> {
  //final _formKey = GlobalKey<FormState>();
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];

  final picker = ImagesPicker;

  Map? dataFromGroupSelector;

  Future getLogoImageFromPicker() async {
    final List<Media>? pickedFile = await ImagesPicker.pick(
      count: 1,
      pickType: PickType.image,
    );

    setState(() {
      if (pickedFile != null) {
        _logoImage = File(pickedFile[0].path);
      } else {
        print('No image selected.');
      }
    });
  }

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

  String? _name;
  File? _backgroundImage;
  File? _logoImage;
  String? _category;

  bool _validateAndSaveForm() {
    final form = _formKeys[_currentStep].currentState!;
    if (_currentStep == 2) {
      if (_logoImage != null) {
        form.save();
        return true;
      }
      return false;
    }
    else if (_currentStep == 3) {
      if (_backgroundImage != null) {
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
      final _id = documentIdFromCurrentDate();
      final _backgroundImageURL = await database.uploadFile(_backgroundImage!);
      final _logoURL = await database.uploadFile(_logoImage!);
      final group = Group(
        id: _id,
        name: _name!,
        backgroundImageURL: _backgroundImageURL,
        category: _category!,
        logoURL: _logoURL,
        sport: '',
      );
      await database.setGroup(group);
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
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text(
          _formComplete ? 'Review group' : 'Group Details',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 1,
      ),
      body: _formComplete ? group_preview_widget(context, Group(
        id: documentIdFromCurrentDate(),
        name: _name!,
        backgroundImageURL: _backgroundImage!.path,
        category: _category!,
        logoURL: _logoImage!.path,
        sport: '',
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
                  title: const Text('Group Name'),
                  subtitle: const Text('Give your group a descriptive name.'),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 0 ?
                  StepState.complete : StepState.disabled,
                  content: Form(
                    key: _formKeys[0],
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Name',
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
                          initialValue: _name,
                          validator: (value) =>
                          (value ?? '').isNotEmpty
                              ? null
                              : 'Group name can\'t be empty',
                          onSaved: (value) => _name = value,
                        ),
                      ],
                    ),
                  ),
                ),
                Step(
                  isActive: _currentStep >= 1,
                  state: _currentStep >= 1 ?
                  StepState.complete : StepState.disabled,
                  title: const Text('Category'),
                  subtitle: const Text(
                      'Please select a category for your group'),
                  content: Form(
                    key: _formKeys[1],
                    child: Column(
                      children: <Widget>[
                        DropdownButtonFormField(
                          hint: const Text('Select category'),
                          value: _category,
                          onChanged: (value) {
                            setState(() {
                              _category = value as String?;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Group category can\'t be empty';
                            } else {
                              return null;
                            }
                          },
                          // ignore: prefer_const_literals_to_create_immutables
                          items: NewsCategories.categories.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            );
                          }).toList(),
                        ),
                        // TextFormField(
                        //   decoration: const InputDecoration(
                        //       labelText: 'Description',
                        //       labelStyle: TextStyle(
                        //         color: Colors.grey,
                        //       ),
                        //       focusedBorder: UnderlineInputBorder(
                        //           borderSide: BorderSide(
                        //             color: Colors.red,
                        //             width: 2,
                        //           )
                        //       )
                        //   ),
                        //   keyboardAppearance: Brightness.light,
                        //   //expands: true,
                        //   minLines: 3,
                        //   maxLines: 20,
                        //   initialValue: _body,
                        //   validator: (value) =>
                        //   (value ?? '').isNotEmpty
                        //       ? null
                        //       : 'Article description can\'t be empty',
                        //   onSaved: (value) => _body = value,
                        // ),
                      ],
                    ),
                  ),
                ),
                // Step(
                //   isActive: _currentStep >= 1,
                //   state: _currentStep >= 1 ?
                //   StepState.complete : StepState.disabled,
                //   title: const Text('Description'),
                //   subtitle: const Text(
                //       'Please provide your article\'s details here.'),
                //   content: Form(
                //     key: _formKeys[1],
                //     child: Column(
                //       children: <Widget>[
                //         TextFormField(
                //           decoration: const InputDecoration(
                //               labelText: 'Description',
                //               labelStyle: TextStyle(
                //                 color: Colors.grey,
                //               ),
                //               focusedBorder: UnderlineInputBorder(
                //                   borderSide: BorderSide(
                //                     color: Colors.red,
                //                     width: 2,
                //                   )
                //               )
                //           ),
                //           keyboardAppearance: Brightness.light,
                //           //expands: true,
                //           minLines: 3,
                //           maxLines: 20,
                //           initialValue: _body,
                //           validator: (value) =>
                //           (value ?? '').isNotEmpty
                //               ? null
                //               : 'Article description can\'t be empty',
                //           onSaved: (value) => _body = value,
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                Step(
                  isActive: _currentStep >= 2,
                  state: _currentStep >= 2 ?
                  StepState.complete : StepState.disabled,
                  title: const Text('Logo'),
                  subtitle: const Text(
                      "Please choose a logo for your group."),
                  content: Form(
                    key: _formKeys[2],
                    child: Column(
                      children: <Widget>[
                        Center(
                            child: _logoImage == null
                                ? const Image(
                                image: AssetImage('assets/noImageSelected.png'),
                                height: 200,
                                width: 250) //Text('No image selected.')
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(500),
                                    child: Image(
                                      image: FileImage(_logoImage!),
                                      height: 200,
                                      width: 200,
                                      fit: BoxFit.fitWidth,
                                  ),
                                ) ,//Image.file(_image),
                        ),
                        const SizedBox(height: 5),
                        TextButton(
                          onPressed: getLogoImageFromPicker,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 12),
                            child: Text(
                              _logoImage == null ? 'Select image' : 'Change image',
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
                  title: const Text('Background Image'),
                  subtitle: const Text("Please choose a background image for your group."),
                  content: Form(
                    key: _formKeys[3],
                    child: Column(
                      children: <Widget>[
                        Center(
                            child: _backgroundImage == null
                                ? const Image(
                                image: AssetImage('assets/noImageSelected.png'),
                                height: 200,
                                width: 250) //Text('No image selected.')
                                : Image(image: FileImage(_backgroundImage!),
                                height: 200,
                                width: 300,
                              fit: BoxFit.fitWidth,
                            ) //Image.file(_image),
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

  Widget group_preview_widget(BuildContext context, Group group) {
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
                    image: FileImage(File(group.backgroundImageURL)),
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
                        padding: const EdgeInsets.only(left: 15),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          minVerticalPadding: 0,
                          horizontalTitleGap: 10,
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image(
                              image: FileImage(File(group.logoURL)),
                              fit: BoxFit.cover,
                              height: 50,
                              width: 50,
                            ),
                          ),
                          title: Text(
                            group.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            group.category,
                            style: TextStyle(
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      ),
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
                        _submit();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 45),
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: MediaQuery.of(context).size.width * 0.15),
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
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
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
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: MediaQuery.of(context).size.width * 0.15),
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

