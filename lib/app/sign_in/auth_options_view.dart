import 'package:flutter/material.dart';
import 'package:get_up_park/routing/app_router.dart';


class AuthOptionsView extends StatefulWidget {
  const AuthOptionsView({Key? key}) : super(key: key);

  @override
  _AuthOptionsViewState createState() => _AuthOptionsViewState();
}

class _AuthOptionsViewState extends State<AuthOptionsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.15),
              Image(
                image: const AssetImage('assets/pantherLaunch.png'),
                width: MediaQuery.of(context).size.width * 0.6,
              ),
              const Spacer(),
              FlatButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pushNamed(
                      AppRoutes.signInView,
                  );
                },
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Colors.red,
                height: 50,
                minWidth: MediaQuery.of(context).size.width * 0.9,
              ),
              const SizedBox(height: 12),
              FlatButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pushNamed(
                    AppRoutes.registerUserView,
                  );
                },
                child: const Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                  ),
                ),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(color: Colors.red, width: 2),
                ),
                height: 50,
                minWidth: MediaQuery.of(context).size.width * 0.9,
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.1),
            ],
          ),
        ),
      ),
    );
  }
}
