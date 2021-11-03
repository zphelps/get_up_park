import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/sign_in/email_verification_view.dart';
import 'package:get_up_park/app/sign_in/follow_groups/follow_groups.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/cover_screen/app_cover_screen.dart';
import 'package:get_up_park/cover_screen/cover_screen_model.dart';

final coverScreenStreamProvider = StreamProvider.autoDispose<CoverScreen>((ref) {
  final database = ref.watch(unauthorizedDatabaseProvider);
  return database.coverScreenStream();
});

class AuthWidget extends ConsumerWidget {
  const AuthWidget({
    Key? key,
    required this.signedInBuilder,
    required this.nonSignedInBuilder,
    // required this.nonVerifiedBuilder
  }) : super(key: key);
  final WidgetBuilder nonSignedInBuilder;
  final WidgetBuilder signedInBuilder;
  // final WidgetBuilder nonVerifiedBuilder;


  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final authStateChanges = watch(authStateChangesProvider);
    return authStateChanges.when(
      data: (user) {
        return _data(context, user, watch);
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (_, __) => const Scaffold(
        body: Center(
          child: Text(
            'Error',
          ),
        ),
      ),
    );
  }

  Widget _data(BuildContext context, User? user, ScopedReader watch) {
    final coverScreenAsyncValue = watch(coverScreenStreamProvider);
    return coverScreenAsyncValue.when(
      data: (value) {
        // if(value.live) {
        //   return AppCoverScreen(coverScreenData: value);
        // }
        if (user != null) {
          if(value.live && !value.usersExcluded.contains(user.uid)) {
            return AppCoverScreen(coverScreenData: value);
          }
          // if(user.emailVerified || user.metadata.creationTime!.isBefore(DateTime(2021, 8, 17))) {
          //   return signedInBuilder(context);
          // }
          return signedInBuilder(context);

        }
        return nonSignedInBuilder(context);
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (_, __) => const Scaffold(
        body: Center(
          child: Text(
            'Error',
          ),
        ),
      ),
    );

  }
}