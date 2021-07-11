import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/services/auth.dart';
import 'package:get_up_park/services/firestore_database.dart';
import 'package:get_up_park/shared_widgets/loading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                      image: const AssetImage('assets/pantherHead.png'),
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width * 0.5,
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
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
                        labelText: 'Password',
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
                        labelText: 'Confirm Password',
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
                    const SizedBox(height: 20),
                        () {
                      if(_loading) {
                        return const CircularProgressIndicator();
                      }
                      else {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 40,
                          child: RaisedButton(
                            color: Colors.red[600],
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
                                dynamic result = await _auth.registerUserWithEmailAndPassword(email, password, firstName, lastName, ['Panther Robotics']);
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
                                  setState(() {
                                    _loading = false;
                                  });
                                  Navigator.of(context).pop();
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
