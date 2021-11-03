
import 'dart:io';

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
import 'package:google_fonts/google_fonts.dart';
import 'package:images_picker/images_picker.dart';
import 'package:intl/intl.dart';


class CreateEventView extends StatefulWidget {
  const CreateEventView();

  @override
  State<CreateEventView> createState() => _CreateEventViewState();
}

class _CreateEventViewState extends State<CreateEventView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final picker = ImagesPicker;

  final _formKey = GlobalKey<FormState>();

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

  File? _image;

  String? _title;
  String? _description;
  String? _group;
  String? _groupLogoURL;
  String? _date; //DateTime.now().toString();
  String? _location;
  String? _sport;
  String? _opponentName;
  String? _opponentLogoURL;
  bool includeEventDetails = true;
  bool online = false;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState!;
    if (form.validate() && _group != null && (_location ?? '').length > 0) {
      form.save();
      return true;
    }
    return false;
  }

  bool _loading = false;

  Future<void> _submit() async {
    if((_location ?? '').length == 0) {
      _location = online ? 'www.parktudor.org' : 'Park Tudor School, North College Avenue, Indianapolis, IN, USA';
    }
    else {

    }
    if(_validateAndSaveForm()){
      try {
        setState(() {
          _loading = true;
        });
        final database = context.read<FirestoreDatabase>(databaseProvider);
        // final id = '${_group}: ${DateFormat.MMMEd().format(DateTime.parse(_date!))} - $_title';

        String? _imageURL;
        if(_image!=null) {
          _imageURL = await database.uploadFile(_image!, _group ?? 'misc');
        }

        if((_opponentName ?? '').length > 0 && (_opponentLogoURL ?? '').length > 0) {
          final id = '${_group}: ${DateFormat.MMMEd().format(DateTime.parse(_date!))} - $_opponentName';
          final game = Game(
            id: id,
            homeScore: '',
            opponentName: _opponentName!,
            opponentLogoURL: _opponentLogoURL!,
            date: _date!,
            gameDone: 'false',
            sport: _sport!,
            group: _group!,
            opponentScore: '',
            liveStreamActive: '',
            numberOfLiveUsers: 0,
          );
          final event = Event(
            id: id,
            title: 'Park Tudor v.s. $_opponentName',
            description: _description ?? '',
            groupImageURL: _groupLogoURL!,
            location: _location!,
            group: _group!,
            date: _date!,
            gameID: id,
            imageURL: _imageURL ?? '',
          );
          await database.setGame(game);
          await database.setEvent(event);
        }
        else {
          final id = '${_group}: ${DateFormat.MMMEd().format(DateTime.parse(_date!))} - $_title';
          final event = Event(
            id: id,
            title: _title!,
            description: _description ?? '',
            groupImageURL: _groupLogoURL!,
            location: _location!,
            group: _group!,
            date: _date!,
            gameID: '',
            imageURL: _imageURL ?? '',
          );
          await database.setEvent(event);
        }

        await Future.delayed(const Duration(milliseconds: 0));
        // Navigator.of(context).pop();
        Navigator.pop(context);
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
          'New Event',
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
                  if(((_title ?? '').length == 0 && (_opponentName ?? '').length == 0) || (_date ?? '').length == 0 || ((_description ?? '').length == 0 && includeEventDetails) || (_date ?? '').length == 0) {
                    return Colors.red[200];
                  }
                  return Colors.red;
                } () ,
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
              // const SizedBox(height: 10),
              // const Divider(height: 0, thickness: 0.5, color: Colors.grey),
              InkWell(
                onTap: () {
                  getImageFromPicker();
                },
                child: Center(
                    child: _image == null
                        ? Container(
                            color:
                      Colors.red.shade50,
                      width: MediaQuery.of(context).size.width,
                      height: 215,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.add_a_photo_outlined,
                            size: 50,
                            color: Colors.red,
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Add Event Image',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                         ) //Text('No image selected.')
                        : Stack(
                      children: [
                        Image(image: FileImage(_image!),
                            fit: BoxFit.fitWidth,
                            height: 200,
                            width: MediaQuery.of(context).size.width),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: InkWell(
                            onTap: () {
                              getImageFromPicker();
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                ),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Event Info',
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        setState(() {
                          _opponentName = null;
                          _opponentLogoURL = null;
                        });
                        dynamic result = await Navigator.of(
                            context, rootNavigator: true).pushNamed(
                          AppRoutes.selectGroup,
                        );
                        setState(() {
                          dataFromGroupSelector = {
                            'group': result['group'],
                            'groupLogoURL': result['groupLogoURL'],
                            'sport': result['sport'],
                          };
                          _group = dataFromGroupSelector!['group'];
                          _groupLogoURL =
                          dataFromGroupSelector!['groupLogoURL'];
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
                          _group ?? 'Select group',
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
                        () {
                      if((_sport ?? '').length > 0) {
                        return InkWell(
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
                              (_opponentName ?? '').length > 0 ? _opponentName! : 'Create a game',
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
                        );
                      }
                      return const SizedBox(height: 0);
                    }(),
                    const Divider(
                      height: 0,
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                        () {
                      if((_opponentName ?? '') == '') {
                        return TextFormField(
                            textInputAction: TextInputAction.done,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                              labelText: 'Event title',
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
                            (value ?? '').isNotEmpty
                                ? null
                                : 'Event title can\'t be empty',
                            onChanged: (value) {
                              setState(() {
                                _title = value;
                              });
                            }
                        );
                      }
                      return const SizedBox(height: 0);
                    }(),
                  ],
                ),
              ),
              Divider(thickness: 8, color: Colors.blueGrey[50]),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date & Time',
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DateTimeField(
                      validator: (value) =>
                      (value ?? '').toString().isNotEmpty
                          ? null
                          : 'Event date can\'t be empty',
                      //decoration: textInputDecoration.copyWith(hintText: 'Select date...'),
                      decoration: InputDecoration(
                        suffixIcon: const Icon(
                          Icons.arrow_drop_down,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                        hintText: DateTime.now().toString(),
                        // labelText: DateFormat.MMMMEEEEd().format(DateTime.now()),
                        labelText: 'Event date',
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
                          print(_date);
                          return DateTimeField.combine(date, time);
                        } else {
                          return currentValue;
                        }
                      },
                    ),
                  ],
                ),
              ),
              Divider(thickness: 8, color: Colors.blueGrey[50]),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location',
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Where is this event taking place?',
                      style: GoogleFonts.inter(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                online = false;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                'Physical Location',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: online ? Colors.white : Colors.red, width: online ? 0 : 2),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.075),
                                    spreadRadius: 1,
                                    blurRadius: 8,
                                    offset: const Offset(0, 0)
                                  )
                                ]
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                online = true;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                'Online',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: online ? Colors.red : Colors.white, width: online ? 2 : 0),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.075),
                                        spreadRadius: 1,
                                        blurRadius: 8,
                                        offset: const Offset(0, 0)
                                    )
                                  ]
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    () {
                      if(!online) {
                        return InkWell(
                          onTap: () async {
                            dynamic result = await Navigator.of(
                                context, rootNavigator: true).pushNamed(
                              AppRoutes.locationSearchView,
                            );
                            setState(() {
                              _location = result['address'];
                            });

                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //     () {
                              //   if(_location != null) {
                              //     return Column(
                              //       children: [
                              //         Text(
                              //           'Location*',
                              //           style: TextStyle(
                              //               color: Colors.grey[600],
                              //               fontWeight: FontWeight.w400
                              //           ),
                              //         ),
                              //         const SizedBox(height: 8),
                              //       ],
                              //     );
                              //   }
                              //   return const SizedBox(height: 0);
                              // }(),
                              const SizedBox(height: 5),
                              Text(
                                'Location',
                                style: TextStyle(
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _location == null ? 'Park Tudor School, North College Avenue, Indianapolis, IN, USA' : _location!,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _location == null ? Colors.grey[600] : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Divider(
                                height: 0,
                                color: Colors.grey,
                                thickness: 0.5,
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox(height: 0);
                    }(),
                    () {
                      if(online) {
                        return TextFormField(
                            textInputAction: TextInputAction.done,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                              labelText: 'Event URL',
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
                            initialValue: 'www.parktudor.org',
                            validator: (value) =>
                            (value ?? '').isNotEmpty && (value ?? '').contains('www')
                                ? null
                                : 'Please enter a valid URL',
                            onChanged: (value) {
                              setState(() {
                                _location = value;
                              });
                            }
                        );
                      }
                      return const SizedBox(height: 0);
                    }(),
                  ],
                ),
              ),
              Divider(thickness: 8, color: Colors.blueGrey[50]),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'About Your Event',
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Switch(
                          value: includeEventDetails,
                          onChanged: (value) {
                            setState(() {
                              includeEventDetails = value;
                              print(includeEventDetails);
                            });
                          },
                          activeTrackColor: Colors.red[100],
                          activeColor: Colors.red,
                        ),
                      ],
                    ),
                    // const SizedBox(height: 5),
                    Text(
                      'Provide any additional event information.',
                      style: GoogleFonts.inter(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 8),
                    () {
                      if(includeEventDetails) {
                        return TextFormField(
                            textInputAction: TextInputAction.done,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 0),
                              alignLabelWithHint: true,
                              labelText: 'Write your description...',
                              labelStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 0.0,
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
                                    color: Colors.white,
                                    width: 0.0,
                                  )
                              ),
                            ),
                            keyboardAppearance: Brightness.light,
                            maxLines: 8,
                            initialValue: _description,
                            validator: (value) =>
                            (value ?? '').isNotEmpty && includeEventDetails
                                ? null
                                : 'Event description can\'t be empty',
                            onChanged: (value) {
                              setState(() {
                                _description = value;
                              });
                            }
                        );
                      }
                      return const SizedBox(height: 0);
                    }(),
                  ],
                ),
              ),
              const SizedBox(height: 175),
            ],
          ),
        ),
      ),
    );
  }
}