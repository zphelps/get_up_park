import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/announcement_model.dart';
import 'package:get_up_park/app/home/events/event_model.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/home/home/lunch_model.dart';
import 'package:get_up_park/app/home/house_cup/team_model.dart';
import 'package:get_up_park/app/home/news/article_model.dart';
import 'package:get_up_park/app/home/sports/game_model.dart';
import 'package:get_up_park/app/home/sports/opponent_model.dart';
import 'package:get_up_park/app/sign_in/select_advisor/advisor_model.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/services/firestore_database.dart';
import 'package:logger/logger.dart';

final firebaseAuthProvider =
Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authStateChangesProvider = StreamProvider<User?>(
        (ref) => ref.watch(firebaseAuthProvider).authStateChanges());

final databaseProvider = Provider<FirestoreDatabase>((ref) {
  final auth = ref.watch(authStateChangesProvider);

  if (auth.data?.value?.uid != null) {
    return FirestoreDatabase(uid: auth.data!.value!.uid);
  }
  throw UnimplementedError();
});

final unauthorizedDatabaseProvider = Provider<FirestoreDatabase>((ref) {
  return FirestoreDatabase(uid: '');
});

final loggerProvider = Provider<Logger>((ref) => Logger(
  printer: PrettyPrinter(
    methodCount: 1,
    printEmojis: false,
  ),
));

//Announcements
final announcementsStreamProvider = StreamProvider.autoDispose<List<Announcement>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.announcementsStream();
});

//User
final userStreamProvider =
StreamProvider.autoDispose<PTUser>((ref) {
  final database = ref.watch(databaseProvider);
  return database.userStream();
});

//Users
final usersStreamProvider = StreamProvider.autoDispose<List<PTUser>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.usersStream();
});

//FollowedEvents
final followedEventsStreamProvider = StreamProvider.autoDispose.family<List<Event>, List<dynamic>>((ref, groupsFollowing) {
  final database = ref.watch(databaseProvider);
  return database.followedEventsStream(groupsFollowing);
});

//Events
final eventsStreamProvider = StreamProvider.autoDispose<List<Event>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.eventsStream();
});

//Groups
final groupsStreamProvider = StreamProvider.autoDispose<List<Group>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.groupsStream();
});

//Group
final groupStreamProvider =
StreamProvider.autoDispose.family<Group, Group>((ref, Group group) {
  final database = ref.watch(databaseProvider);
  return database.groupStream(group);
});

//Lunch
final lunchStreamProvider = StreamProvider.autoDispose<List<Lunch>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.lunchStream();
});

//House Cup Standings
final houseCupTeamsStreamProvider = StreamProvider.autoDispose<List<Team>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.houseCupTeamsStream();
});

//News
final newsStreamProvider = StreamProvider.autoDispose<List<Article>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.articleStream();
});

final articleStreamProvider = StreamProvider.autoDispose<List<Article>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.articleStream();
});

//Games
final gamesStreamProvider = StreamProvider.autoDispose<List<Game>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.gamesStream();
});

//Opponents
final opponentsStreamProvider = StreamProvider.autoDispose<List<Opponent>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.opponentsStream();
});

//Advisors
final advisorStreamProvider = StreamProvider.autoDispose<List<Advisor>>((ref) {
  final database = ref.watch(unauthorizedDatabaseProvider);
  return database.advisorStream();
});