import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/services/auth.dart';

class RegisterUserView extends StatefulWidget with ChangeNotifier {
  RegisterUserView({Key? key}) : super(key: key);

  @override
  _RegisterUserViewState createState() => _RegisterUserViewState();
}

class _RegisterUserViewState extends State<RegisterUserView> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;

  //text field state
  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';
  String error = '';
  String? advisor;
  String? advisorImageURL;

  Map? dataFromGroupSelector;

  @override
  Widget build(BuildContext context) {
    return /*_loading ? const Loading(loadingMessage: 'Logging In') : */Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          brightness: Brightness.light,
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Image (
                      image: const AssetImage('assets/pantherLaunch.png'),
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width * 0.5,
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
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
                      validator: (value) =>
                      (value ?? '').isNotEmpty
                          ? null
                          : 'First name can\'t be empty',
                      onChanged: (value) => firstName = value,
                    ),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
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
                      validator: (value) =>
                      (value ?? '').isNotEmpty
                          ? null
                          : 'Last name can\'t be empty',
                      onChanged: (value) => lastName = value,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
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
                      validator: (value) =>
                      (value ?? '').isNotEmpty
                          ? null
                          : 'Email can\'t be empty',
                      onChanged: (value) => email = value,
                    ),
                    // const SizedBox(height: 20),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password (6+ characters)',
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
                      // initialValue: _name,
                      validator: (value) =>
                      (value ?? '').length > 6
                          ? null
                          : 'Enter a password 6+ chars long',
                      onChanged: (value) => password = value,
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password (6+ characters)',
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
                      // initialValue: _name,
                      validator: (value) =>
                      (value ?? '') == password
                          ? null
                          : 'Passwords must match',
                    ),
                    const SizedBox(height: 5),
                    InkWell(
                      onTap: () async {
                        dynamic result = await Navigator.of(
                            context, rootNavigator: true).pushNamed(
                          AppRoutes.selectAdvisorView,
                        );
                        setState(() {
                          dataFromGroupSelector = {
                            'advisor': result['advisor'],
                            'advisorImageURL': result['advisorImageURL'],
                          };
                          advisor = dataFromGroupSelector!['advisor'];
                          advisorImageURL =
                          dataFromGroupSelector!['advisorImageURL'];
                        });
                      },
                      child: ListTile(
                        visualDensity: const VisualDensity(vertical: -4),
                        contentPadding: const  EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                        leading: CircleAvatar(
                          backgroundColor: advisorImageURL == null ? Colors
                              .grey[300] : Colors.transparent,
                          child: () {
                            if (advisorImageURL != null && advisorImageURL != '') {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: CachedNetworkImage(
                                  memCacheHeight: 300,
                                  memCacheWidth: 300,
                                  fadeOutDuration: Duration.zero,
                                  placeholderFadeInDuration: Duration.zero,
                                  fadeInDuration: Duration.zero,
                                  imageUrl: advisorImageURL!,
                                  fit: BoxFit.fitWidth,
                                  width: 45,
                                  height: 45,
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
                          advisor ?? 'Select advisor',
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
                    const SizedBox(height: 20),
                        () {
                      if(_loading) {
                        return const CircularProgressIndicator();
                      }
                      else {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 50,
                          child: RawMaterialButton(
                            // padding: const EdgeInsets.symmetric(vertical:0),
                            fillColor: Colors.red,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            // color: Colors.red,
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () async {
                              if(_formKey.currentState!.validate()) {
                                setState(() {
                                  _loading = true;
                                });
                                if(EmailValidator.validate(email) && advisor != null) {
                                  if(advisor != 'Parent/Other' && email.substring(email.length - 13) != 'parktudor.org') {
                                    await showAlertDialog(
                                      context: context,
                                      title: 'Please use a Park Tudor email address!',
                                      content: "Only Park Tudor students may select an advisor. If you do not have a PT email, select 'Parent/Other'",
                                      defaultActionText: 'Ok',
                                    );
                                    setState(()  {
                                      // error = 'Please supply valid email';
                                      _loading = false;
                                    });
                                  }
                                  else {
                                    dynamic result = await _auth.registerUserWithEmailAndPassword(email, password, firstName, lastName, ['App Development Team', 'Upper School', 'Middle School', 'Booster Club'], advisor ?? '');
                                    if(result == null) {
                                      await showAlertDialog(
                                        context: context,
                                        title: 'Oh No!',
                                        content: 'An error occurred while trying to register. Please try again.',
                                        defaultActionText: 'Ok',
                                      );
                                      setState(()  {
                                        // error = 'Please supply valid email';
                                        _loading = false;
                                      });
                                    }
                                    else {
                                      await Future.delayed(const Duration(milliseconds: 500));
                                      setState(() {
                                        _loading = false;
                                      });
                                      // Navigator.of(context, rootNavigator: true).pushNamed(
                                      //   AppRoutes.verificationView,
                                      // );
                                      Navigator.of(context, rootNavigator: true).pushNamed(
                                        AppRoutes.followGroupsView,
                                      );
                                    }
                                  }
                                }
                                else {
                                  await showAlertDialog(
                                    context: context,
                                    title: 'Oh No!',
                                    content: advisor == null ? 'Please select an advisor' : 'Please use a valid email address.',
                                    defaultActionText: 'Ok',
                                  );
                                  setState(()  {
                                    // error = 'Please supply valid email';
                                    _loading = false;
                                  });
                                }

                              }
                            },
                          ),
                        );
                      }
                    }(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
