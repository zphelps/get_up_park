import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/services/auth.dart';
import 'package:get_up_park/shared_widgets/loading.dart';

class SignInView extends StatefulWidget with ChangeNotifier {
  SignInView({Key? key}) : super(key: key);

  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;

  //text field state
  String name = '';
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
                      height: MediaQuery.of(context).size.height * 0.175,
                      width: MediaQuery.of(context).size.width * 0.45,
                    ),
                    const SizedBox(height: 35),
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
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 20),
                    () {
                      if(_loading) {
                        return CircularProgressIndicator();
                      }
                      else {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 40,
                          child: RaisedButton(
                            color: Colors.red[600],
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () async {
                              if(_formKey.currentState!.validate()) {
                                setState(() {
                                  _loading = true;
                                });
                                dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                                if(result == null) {
                                  await showAlertDialog(
                                    context: context,
                                    title: 'Oh No!',
                                    content: 'An error occurred while trying to sign you in. Please check your credentials.',
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
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context, rootNavigator: true).pushNamed(
                          AppRoutes.resetPasswordView,
                          arguments: {
                            'email': email,
                          }
                        );
                      },
                      child: const Text(
                        'Forgot password?'
                      ),
                    ),
                    // SizedBox(
                    //   width: MediaQuery.of(context).size.width * 0.8,
                    //   height: 40,
                    //   child: RaisedButton(
                    //     color: Colors.grey[300],
                    //     child: Text(
                    //       'Sign Up',
                    //       style: TextStyle(
                    //         color: Colors.grey[800],
                    //       ),
                    //     ),
                    //     // onPressed: () {
                    //     //   widget.toggleView();
                    //     // },
                    //   ),
                    // ),
                    SizedBox(height: 12),
                    Text(
                      error,
                      style: TextStyle(
                        color: Colors.red[600],
                        fontSize: 14,
                      ),
                    ),
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
