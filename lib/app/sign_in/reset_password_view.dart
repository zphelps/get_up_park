import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/services/auth.dart';
import 'package:get_up_park/shared_widgets/loading.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({required this.email});

  final String email;

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();

  String? email;

  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    email = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Reset Password',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Please enter the email associated with your account (example@parktudor.org).',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 20),
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
                    initialValue: email!,
                    validator: (value) =>
                    (value ?? '').isNotEmpty
                        ? null
                        : 'Email can\'t be empty',
                    onChanged: (value) => email = value,
                  ),
                  const SizedBox(height: 20),
                  () {
                    if(loading) {
                      return const CircularProgressIndicator();
                    }
                    else {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 40,
                        child: RaisedButton(
                          color: Colors.red[600],
                          child: const Text(
                            'Send instructions',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              loading = true;
                            });
                            await _auth.sendPasswordResetEmail(email!);
                            setState(() {
                              loading = false;
                            });
                            await showAlertDialog(
                              context: context,
                              title: 'Success!',
                              content: 'Password reset email sent to $email',
                              defaultActionText: 'Ok',
                            );
                            Navigator.pop(context);
                          },
                        ),
                      );
                    }
                  }(),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
