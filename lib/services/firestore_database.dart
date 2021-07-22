import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firestore_service/firestore_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/announcement_model.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/home/events/event_model.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/home/groups/post_modal.dart';
import 'package:get_up_park/app/home/home/lunch_model.dart';
import 'package:get_up_park/app/home/news/article_model.dart';
import 'package:get_up_park/app/home/sports/game_model.dart';
import 'package:get_up_park/app/home/sports/opponent_model.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/services/firestore_path.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';


String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase {
  FirestoreDatabase({required this.uid});
  final String uid;

  //Same thing but I can't figure out why the hell the service wont create new documents
  final _service = FirestoreService.instance;
  final _database = FirebaseFirestore.instance;
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  static Group getGroupFromString(AsyncValue<List<Group>> groups, String groupName) {
    for(final item in groups.data!.value) {
      if(item.name == groupName) {
        return item;
      }
    }
    return groups.data!.value.first;
  }


  Future<String> getImage(String imageURL) async {
    final ref = firebase_storage.FirebaseStorage.instance.ref().child(imageURL);
    // no need of the file extension, the name will do fine.
    return await ref.getDownloadURL();
  }

  Future<String> uploadFile(File filePath, String group) async {
    String returnURL = '';
    firebase_storage.Reference storageReference = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('$group/${basename(filePath.path)}');
    try {
      await storageReference.putFile(filePath).then((value) => value.ref.getDownloadURL().then((value) => returnURL = value));
      print('File uploaded to storage.');
    } catch (e) {
      print('Error in upload try/catch');
      print(e);
      // e.g, e.code == 'canceled'
    }
    return returnURL;
  }


  Future<void> setAnnouncement(Announcement announcement) => _database.collection('announcements').doc(announcement.id).set(announcement.toMap());

  Future<void> setArticle(Article article) => _database.collection('articles').doc(article.id).set(article.toMap());

  Future<void> updateArticle(Article article) => _database.collection('articles').doc(article.id).update(article.toMap());

  Future<void> deleteArticle(Article article) => _database.collection('articles').doc(article.id).delete();

  Future<void> setEvent(Event event) => _database.collection('events').doc(event.id).set(event.toMap());

  Future<void> deleteEvent(Event event) => _database.collection('events').doc(event.id).delete();

  Future<void> updateEvent(Event event) => _database.collection('events').doc(event.id).update(event.toMap());

  Future<void> setGroup(Group group) => _database.collection('groups').doc(group.id).set(group.toMap());

  Future<void> setGroupBackgroundImage(String groupID, String url) => _database.collection('groups').doc(groupID).update(
      {
        'backgroundImageURL': url,
      });

  Future<void> deleteGroup(Group group) => _database.collection('groups').doc(group.id).delete();

  Future<void> followGroup(String userID, String groupName) => _database.collection('users').doc(userID).update(
      {
        'groupsFollowing': FieldValue.arrayUnion([groupName]),
      });

  Future<void> unfollowGroup(String userID, String groupName) => _database.collection('users').doc(userID).update(
      {
        'groupsFollowing': FieldValue.arrayRemove([groupName]),
      });

  Future<void> setAdmin(String userID, String admin) => _database.collection('users').doc(userID).update(
      {
        'admin': admin,
      });

  Future<void> setPost(Post post) => _database.collection('posts').doc(post.id).set(post.toMap());

  Future<void> setGame(Game game) => _database.collection('games').doc(game.id).set(game.toMap());

  Future<void> deleteGame(Game game) => _database.collection('games').doc(game.id).delete();

  Future<void> setOpponent(Opponent opponent) => _database.collection('opponents').doc(opponent.id).set(opponent.toMap());

  Future<void> updateGameScore(String gameID, String opponentScore, String homeScore, String gameDone) => _database.collection('games').doc(gameID).update(
      {
        'opponentScore': opponentScore,
        'homeScore': homeScore,
        'gameDone': gameDone,
      });

  Future<void> updateGameInformation(String gameID, String date, String opponent, String opponentLogoURL) => _database.collection('games').doc(gameID).update(
      {
        'date': date,
        'opponentName': opponent,
        'opponentLogoURL': opponentLogoURL,
      });

  //
  // Future<void> deleteJob(Job job) async {
  //   // delete where entry.jobId == job.jobId
  //   final allEntries = await entriesStream(job: job).first;
  //   for (final entry in allEntries) {
  //     if (entry.jobId == job.id) {
  //       await deleteEntry(entry);
  //     }
  //   }
  //   // delete job
  //   await _service.deleteData(path: FirestorePath.job(uid, job.id));
  // }
  //
  // Stream<Job> jobStream({required String jobId}) => _service.documentStream(
  //   path: FirestorePath.job(uid, jobId),
  //   builder: (data, documentId) => Job.fromMap(data, documentId),
  // );
  //
  Stream<List<Announcement>> announcementsStream() => _service.collectionStream(
    path: 'announcements',
    sort: (a, b) => b.date.compareTo(a.date),
    builder: (data, documentId) => Announcement.fromMap(data, documentId),
  );

  Stream<List<Article>> articleStream() => _service.collectionStream(
    path: FirestorePath.article(),
    sort: (a, b) => b.date.compareTo(a.date),
    builder: (data, documentId) => Article.fromMap(data, documentId),
  );

  Stream<PTUser> userStream() {
    return _service.documentStream(
      path: 'users/$uid',
      builder: (data, documentId) => PTUser.fromMap(data, documentId),
    );
  }

  Stream<List<PTUser>> usersStream() => _service.collectionStream(
    path: 'users',
    sort: (a, b) => b.firstName.compareTo(a.firstName),
    builder: (data, documentId) => PTUser.fromMap(data, documentId),
  );

  Stream<List<Group>> groupsStream() => _service.collectionStream(
    path: 'groups',
    sort: (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    builder: (data, documentId) => Group.fromMap(data, documentId),
  );

  Stream<List<Event>> eventsStream() => _service.collectionStream(
    path: 'events',
    sort: (a, b) => a.date.compareTo(b.date),
    builder: (data, documentId) => Event.fromMap(data, documentId),
  );

  Stream<List<Post>> postsStream() => _service.collectionStream(
    path: 'posts',
    sort: (a, b) => b.date.compareTo(a.date),
    builder: (data, documentId) => Post.fromMap(data, documentId),
  );

  Stream<List<Game>> gamesStream() => _service.collectionStream(
    path: 'games',
    sort: (a, b) => b.date.compareTo(a.date),
    builder: (data, documentId) => Game.fromMap(data, documentId),
  );

  Stream<List<Opponent>> opponentsStream() => _service.collectionStream(
    path: 'opponents',
    sort: (a, b) => a.name.compareTo(b.name),
    builder: (data, documentId) => Opponent.fromMap(data, documentId),
  );

  Stream<List<Lunch>> lunchStream() => _service.collectionStream(
    path: 'lunch',
    sort: (a, b) => a.date.compareTo(b.date),
    builder: (data, documentId) => Lunch.fromMap(data, documentId),
  );
  //
  // Future<void> setEntry(Entry entry) => _service.setData(
  //   path: FirestorePath.entry(uid, entry.id),
  //   data: entry.toMap(),
  // );
  //
  // Future<void> deleteEntry(Entry entry) =>
  //     _service.deleteData(path: FirestorePath.entry(uid, entry.id));
  //
  // Stream<List<Entry>> entriesStream({Job? job}) =>
  //     _service.collectionStream<Entry>(
  //       path: FirestorePath.entries(uid),
  //       queryBuilder: job != null
  //           ? (query) => query.where('jobId', isEqualTo: job.id)
  //           : null,
  //       builder: (data, documentID) => Entry.fromMap(data, documentID),
  //       sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
  //     );
}