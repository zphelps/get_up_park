

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:get_up_park/app/home/news/article_model.dart';
import 'package:get_up_park/app/home/sports/opponent_model.dart';

Future<void> sendCustomNotification(String title, String message) async {

  await FirebaseFunctions.instance.httpsCallable(
      'sendNotification',
      options: HttpsCallableOptions(
          timeout: const Duration(seconds: 15))).call({
    "title": title,
    "body": message,
  });

}

Future<void> sendNotification(Article article, {String opponent = '', String opponentLogoURL = ''}) async {

  if(article.imageURL == '' && article.gameID == '') {
    await FirebaseFunctions.instance.httpsCallable(
        'sendNotification',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 15))).call({
          "title": article.group,
          "body": article.body,
    });
  }
  else if(article.title == '' && article.imageURL != '') {
    await FirebaseFunctions.instance.httpsCallable(
        'sendNotification',
        options: HttpsCallableOptions(
            timeout: const Duration(seconds: 15))).call({
      "title": article.group,
      "body": article.body,
      // "imageURL": article.imageURL,
    });
  }
  else if(article.title != '' && article.imageURL != '') {
    await FirebaseFunctions.instance.httpsCallable(
        'sendNotification',
        options: HttpsCallableOptions(
            timeout: const Duration(seconds: 15))).call({
      "title": article.title,
      "body": '${article.body.substring(0, 150)}...',
      // "imageURL": article.imageURL,
    });
  }
  else if(article.title == '' && article.imageURL == '' && article.gameID != '') {
    await FirebaseFunctions.instance.httpsCallable(
        'sendNotification',
        options: HttpsCallableOptions(
            timeout: const Duration(seconds: 15))).call({
      "title": 'Park Tudor v.s. $opponent',
      "body": article.body,
      // "imageURL": opponentLogoURL,
    });
  }
}

Future<void> sendNewsNotifications(Article article, {String opponent = '', String opponentLogoURL = ''}) async {
  if(article.imageURL == '' && article.gameID == '') {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecond,
          channelKey: 'news_channel',
          title: article.group,
          body: article.body,
          largeIcon: article.groupLogoURL,
        )
    );
  }
  else if(article.title == '' && article.imageURL != '') {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecond,
          channelKey: 'news_channel',
          title: article.group,
          body: article.body,
          notificationLayout: NotificationLayout.BigPicture,
          bigPicture: article.imageURL,
          largeIcon: article.groupLogoURL,
        )
    );
  }
  else if(article.title != '' && article.imageURL != '') {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecond,
          channelKey: 'news_channel',
          title: article.title,
          body: '${article.body.substring(0, 150)}...',
          bigPicture: article.imageURL,
          notificationLayout: NotificationLayout.BigPicture,
          largeIcon: article.groupLogoURL,
        )
    );
  }
  else if(article.title == '' && article.imageURL == '' && article.gameID != '') {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecond,
          channelKey: 'news_channel',
          title: 'Park Tudor v.s. $opponent',
          body: article.body,
          bigPicture: opponentLogoURL,
          notificationLayout: NotificationLayout.BigPicture,
        )
    );
  }

}