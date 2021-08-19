import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/services/auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class EmailVerificationView extends StatefulWidget {

  @override
  _EmailVerificationViewState createState() => _EmailVerificationViewState();
}

class _EmailVerificationViewState extends State<EmailVerificationView> with WidgetsBindingObserver{

  Timer? _timer;
  bool loading = false;

  bool _isInForeground = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _isInForeground = state == AppLifecycleState.resumed;
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseAuth = context.read(firebaseAuthProvider);
    _timer = Timer.periodic(const Duration(milliseconds: 3000), (timer) async {
      if(firebaseAuth.currentUser != null) {
        firebaseAuth.currentUser!.reload();
        if(firebaseAuth.currentUser!.emailVerified) {
          if(_isInForeground) {
            _timer!.cancel();
            timer.cancel();
            setState(() {
              loading = true;
            });
            await Future.delayed(const Duration(seconds: 3)).then((value) {
              //   _timer!.cancel();
              if(timer.isActive) {
                timer.cancel();
              }
              dispose();
              Navigator.of(context).pushReplacementNamed(AppRoutes.followGroupsView);
            });
          }
        }
      }
    });
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress)
          return false;
        else
          return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.125,),
              const Image(
                image: AssetImage('assets/pantherLaunch.png'),
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: AutoSizeText(
                  "Your email has not been verified",
                  maxLines: 2,
                  minFontSize: 24,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: AutoSizeText(
                  'Please check your email for further instructions.',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  minFontSize: 16,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              RawMaterialButton(
                fillColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                // color: Colors.red,
                child: const Text(
                  'Log Out',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () async {
                  final AuthService _auth = AuthService();
                  await _auth.signOut();
                  Navigator.of(context).popUntil((route) => !route.hasActiveRouteBelow);
                },
              ),
              const SizedBox(height: 15),
              () {
                if(loading) {
                  return const CircularProgressIndicator();
                }
                return const SizedBox(height: 0);
              }(),
            ],
          ),
        ),
      ),
    );
  }
}
