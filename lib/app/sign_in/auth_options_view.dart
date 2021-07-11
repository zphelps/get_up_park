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
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height*0.15),
            Image(
              image: const AssetImage('assets/pantherHead.png'),
              width: MediaQuery.of(context).size.width * 0.6,
            ),
            // const Text(
            //   'Get Up Park',
            //   style: TextStyle(
            //     color: Colors.black,
            //     fontSize: 26,
            //     fontWeight: FontWeight.w800,
            //   ),
            // ),
            const Spacer(),
            const Text(
              'Welcome!',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'To get started, please sign in or register using your Park Tudor email address. No email addresses outside of Park Tudor will be permitted to register.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 25),
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
    );
  }
}
