import 'package:email_password_sign_in_ui/email_password_sign_in_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/app/announcements/add_announcement.dart';
import 'package:get_up_park/app/announcements/announcements.dart';
import 'package:get_up_park/app/home/events/all_upcoming_events_view.dart';
import 'package:get_up_park/app/home/groups/sports_profile_view.dart';
import 'package:get_up_park/app/home/home/full_lunch_view.dart';
import 'package:get_up_park/app/home/news/create_article/create_news_view.dart';
import 'package:get_up_park/app/home/news/create_article/select_game.dart';
import 'package:get_up_park/app/home/news/edit_article/edit_news_view.dart';
import 'package:get_up_park/app/home/settings/settings.dart';
import 'package:get_up_park/app/home/settings/user_list_view.dart';
import 'package:get_up_park/app/home/sports/all_game_results_view.dart';
import 'package:get_up_park/app/home/sports/create_game/create_game_view.dart';
import 'package:get_up_park/app/home/sports/create_game/edit_game_view.dart';
import 'package:get_up_park/app/home/sports/create_opponent/create_opponent_view.dart';
import 'package:get_up_park/app/home/sports/full_schedule_view.dart';
import 'package:get_up_park/app/home/sports/game_model.dart';
import 'package:get_up_park/app/home/sports/game_view.dart';
import 'package:get_up_park/app/home/sports/select_opponent_view.dart';
import 'package:get_up_park/app/home/sports/update_game/update_game_view.dart';
import 'package:get_up_park/app/sign_in/register_user_view.dart';
import 'package:get_up_park/app/sign_in/reset_password_view.dart';
import 'package:get_up_park/app/sign_in/sign_in_view.dart';
import 'package:get_up_park/app/home/events/create_event/create_event_view.dart';
import 'package:get_up_park/app/home/events/create_event/create_group_event_view.dart';
import 'package:get_up_park/app/home/events/edit_event/edit_group_event_view.dart';
import 'package:get_up_park/app/home/events/event_model.dart';
import 'package:get_up_park/app/home/events/event_view.dart';
import 'package:get_up_park/app/home/events/events_by_date_view.dart';
import 'package:get_up_park/app/home/events/follow_groups_view.dart';
import 'package:get_up_park/app/home/groups/create_group/create_group_view.dart';
import 'package:get_up_park/app/home/groups/create_group/update_background_image_view.dart';
import 'package:get_up_park/app/home/groups/create_post/create_post_view.dart';
import 'package:get_up_park/app/home/groups/group_category_selector_view.dart';
import 'package:get_up_park/app/home/groups/group_events_view.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/home/groups/group_news_view.dart';
import 'package:get_up_park/app/home/groups/group_profile_view.dart';
import 'package:get_up_park/app/home/news/article_model.dart';
import 'package:get_up_park/app/home/news/article_view.dart';
import 'package:get_up_park/app/home/news/categorical_news_view.dart';
import 'package:get_up_park/app/home/news/create_article/create_article_view.dart';
import 'package:get_up_park/app/home/news/create_article/select_group.dart';
import 'package:get_up_park/app/home/news/edit_article/edit_article_view.dart';
import 'package:get_up_park/app/home/news/image_viewer.dart';
import 'package:get_up_park/app/user_model.dart';

class AppRoutes {
  static const emailPasswordSignInPage = '/email-password-sign-in-page';
  static const signInView = '/sign-in-view';
  static const registerUserView = '/register-user-view';
  static const resetPasswordView = '/reset-password-view';
  static const announcements = '/announcements';
  static const addAnnouncement = '/add-announcements';
  static const articleView = '/article-view';
  static const fullScreenImageView = '/fullscreen-image-view';
  static const categoricalNewsView = '/categorical-news-view';
  static const groupNewsView = '/group-news-view';
  static const entryPage = '/entry-page';

  static const selectGroup = '/select-group';
  static const groupView = '/group-view';

  static const selectGame = '/select-game';

  static const selectOpponentView = '/select-opponent-view';
  static const createOpponentView = '/create-opponent-view';

  static const updateGameView = '/update-game-view';
  static const gameView = '/game-view';

  static const sportsProfileView = '/sports-profile-view';

  static const groupCategorySelectorView = '/group-category-selector-view';

  static const eventView = '/event-view';

  static const allUpcomingEventsView = '/all-upcoming-events-view';

  static const allGameResultsView = '/all-game-results-view';
  static const fullScheduleView = '/full-schedule-view';

  static const groupEventsView = '/group-events-view';

  //create article
  static const createArticleView = '/create-article-view';
  static const editArticleView = '/edit-article-view';

  static const editNewsView = '/edit-news-view';

  static const createNewsView = '/create-news-view';

  static const createEventView = '/create-event-view';
  static const createGroupEventView = '/create-group-event-view';
  static const editGroupEventView = '/edit-group-event-view';

  static const createGroupView = '/create-group-view';

  static const createPostView = '/create-post-view';

  static const createGameView = '/create-game-view';

  static const editGameView = '/edit-game-view';

  static const updateGroupBackgroundImageView = '/update-group-background-image-view';

  static const selectGroupsToFollowView = '/select-groups-to-follow-view';

  static const eventsByDateView = '/events-by-date-view';

  static const settingsView = '/settings-view';

  static const fullLunchView = '/full-lunch-view';

  static const userListView = '/user-list-view';
}

class AppRouter {
  static Route<dynamic>? onGenerateRoute(
      RouteSettings settings, FirebaseAuth firebaseAuth) {
    final args = settings.arguments;
    switch (settings.name) {
      case AppRoutes.emailPasswordSignInPage:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => EmailPasswordSignInPage.withFirebaseAuth(firebaseAuth,
              onSignedIn: args as void Function()),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.signInView:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => SignInView(), //pages other than main pages
          settings: settings,
          // fullscreenDialog: true,
        );
      case AppRoutes.registerUserView:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => RegisterUserView(), //pages other than main pages
          settings: settings,
          // fullscreenDialog: true,
        );
      case AppRoutes.resetPasswordView:
        final mapArgs = args as Map<String, dynamic>;
        final email = mapArgs['email'] as String;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => ResetPasswordView(email: email), //pages other than main pages
          settings: settings,
          // fullscreenDialog: true,
        );
      case AppRoutes.announcements:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => Announcements(), //pages other than main pages
          settings: settings,
          //fullscreenDialog: true,
        );
      case AppRoutes.fullLunchView:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => const FullLunchView(), //pages other than main pages
          settings: settings,
          //fullscreenDialog: true,
        );
      case AppRoutes.addAnnouncement:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => const AddAnnouncement(), //pages other than main pages
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.articleView:
        final mapArgs = args as Map<String, dynamic>;
        final article = mapArgs['article'] as Article;
        final admin = mapArgs['admin'] as String;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => ArticleView(article: article, admin: admin), //pages other than main pages
          settings: settings,
          //fullscreenDialog: true,
        );
      case AppRoutes.fullScreenImageView:
        final mapArgs = args as Map<String, dynamic>;
        final imageURL = mapArgs['imageURL'] as String;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => FullscreenImageViewer(imageURL: imageURL), //pages other than main pages
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.categoricalNewsView:
        final mapArgs = args as Map<String, dynamic>;
        final category = mapArgs['category'] as String;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => CategoricalNewsView(category: category), //pages other than main pages
          settings: settings,
          //fullscreenDialog: true,
        );
      case AppRoutes.groupNewsView:
        final mapArgs = args as Map<String, dynamic>;
        final group = mapArgs['group'] as String;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => GroupNewsView(group: group), //pages other than main pages
          settings: settings,
          //fullscreenDialog: true,
        );
      case AppRoutes.sportsProfileView:
        final mapArgs = args as Map<String, dynamic>;
        final group = mapArgs['group'] as Group;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => SportsProfile(group: group), //pages other than main pages
          settings: settings,
          // fullscreenDialog: true,
        );
      case AppRoutes.gameView:
        final mapArgs = args as Map<String, dynamic>;
        final game = mapArgs['game'] as Game;
        final admin = mapArgs['admin'] as String;
        final group = mapArgs['group'] as Group;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => GameView(game: game, admin: admin, group: group), //pages other than main pages
          settings: settings,
        );
      case AppRoutes.createGameView:
        final mapArgs = args as Map<String, dynamic>;
        final group = mapArgs['group'] as Group;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => CreateGameView(group: group), //pages other than main pages
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.editGameView:
        final mapArgs = args as Map<String, dynamic>;
        final game = mapArgs['game'] as Game;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => EditGameView(game: game), //pages other than main pages
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.updateGameView:
        final mapArgs = args as Map<String, dynamic>;
        final game = mapArgs['game'] as Game;
        final group = mapArgs['group'] as Group;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => UpdateGameView(game: game, group: group), //pages other than main pages
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.createOpponentView:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => const CreateOpponentView(), //pages other than main pages
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.groupEventsView:
        final mapArgs = args as Map<String, dynamic>;
        final group = mapArgs['group'] as Group;
        final admin = mapArgs['admin'] as String;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => GroupEventsView(group: group, admin: admin), //pages other than main pages
          settings: settings,
          //fullscreenDialog: true,
        );
      case AppRoutes.allUpcomingEventsView:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => AllUpcomingEventsView(), //pages other than main pages
          settings: settings,
          //fullscreenDialog: true,
        );
      case AppRoutes.createArticleView:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => const CreateArticleView(), //pages other than main pages
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.createNewsView:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => const CreateNewsView(), //pages other than main pages
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.editArticleView:
        final mapArgs = args as Map<String, dynamic>;
        final article = mapArgs['article'] as Article;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => EditArticleView(article: article), //pages other than main pages
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.editNewsView:
        final mapArgs = args as Map<String, dynamic>;
        final article = mapArgs['article'] as Article;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => EditNewsView(article: article), //pages other than main pages
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.createEventView:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => const CreateEventView(), //pages other than main pages
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.createGroupEventView:
        final mapArgs = args as Map<String, dynamic>;
        final group = mapArgs['group'] as Group;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => CreateGroupEventView(group: group), //pages other than main pages
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.editGroupEventView:
        final mapArgs = args as Map<String, dynamic>;
        final event = mapArgs['event'] as Event;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => EditGroupEventView(event: event), //pages other than main pages
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.createGroupView:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => const CreateGroupView(), //pages other than main pages
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.createPostView:
        final mapArgs = args as Map<String, dynamic>;
        final group = mapArgs['group'] as Group;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => CreatePostView(group: group), //pages other than main pages
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.updateGroupBackgroundImageView:
        final mapArgs = args as Map<String, dynamic>;
        final group = mapArgs['group'] as Group;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => UpdateBackgroundImageView(group: group), //pages other than main pages
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.selectGroup:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => SelectGroup(), //pages other than main pages
          settings: settings,
          //fullscreenDialog: true,
        );
      case AppRoutes.selectGame:
        final mapArgs = args as Map<String, dynamic>;
        final selectedGroup = mapArgs['selectedGroup'] as String;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => SelectGame(selectedGroup: selectedGroup), //pages other than main pages
          settings: settings,
          //fullscreenDialog: true,
        );
      case AppRoutes.selectOpponentView:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => SelectOpponentView(), //pages other than main pages
          settings: settings,
          //fullscreenDialog: true,
        );
      case AppRoutes.selectGroupsToFollowView:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => FollowGroupsView(), //pages other than main pages
          settings: settings,
          //fullscreenDialog: true,
        );
      case AppRoutes.groupView:
        final mapArgs = args as Map<String, dynamic>;
        final group = mapArgs['group'] as Group;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => GroupProfile(group: group), //pages other than main pages
          settings: settings,
          //fullscreenDialog: true,
        );
      case AppRoutes.groupCategorySelectorView:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => const GroupCategorySelectorView(), //pages other than main pages
          settings: settings,
          //fullscreenDialog: true,
        );
      case AppRoutes.eventView:
        final mapArgs = args as Map<String, dynamic>;
        final event = mapArgs['event'] as Event;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => EventView(event: event), //pages other than main pages
          settings: settings,
          //fullscreenDialog: true,
        );
      case AppRoutes.allGameResultsView:
        final mapArgs = args as Map<String, dynamic>;
        final group = mapArgs['group'] as Group;
        final admin = mapArgs['admin'] as String;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => AllGameResultsView(group: group, admin: admin), //pages other than main pages
          settings: settings,
          //fullscreenDialog: true,
        );
      case AppRoutes.fullScheduleView:
        final mapArgs = args as Map<String, dynamic>;
        final group = mapArgs['group'] as Group;
        final admin = mapArgs['admin'] as String;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => FullScheduleView(group: group, admin: admin), //pages other than main pages
          settings: settings,
          //fullscreenDialog: true,
        );
      case AppRoutes.eventsByDateView:
        final mapArgs = args as Map<String, dynamic>;
        final groupsFollowing = mapArgs['groupsFollowing'] as List<dynamic>;
        final date = mapArgs['date'] as String;
        final title = mapArgs['title'] as String;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => EventsByDateView(date: date, groupsFollowing: groupsFollowing, title: title), //pages other than main pages
          settings: settings,
          //fullscreenDialog: true,
        );
      case AppRoutes.settingsView:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => Settings(), //pages other than main pages
          settings: settings,
          //fullscreenDialog: true,
        );
      case AppRoutes.userListView:
        final mapArgs = args as Map<String, dynamic>;
        final user = mapArgs['user'] as PTUser;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => UserListView(currentUser: user), //pages other than main pages
          settings: settings,
          //fullscreenDialog: true,
        );
      case AppRoutes.entryPage:
        // final mapArgs = args as Map<String, dynamic>;
        // final job = mapArgs['job'] as Job;
        // final entry = mapArgs['entry'] as Entry?;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => Scaffold(), //EntryPage(job: job, entry: entry),
          settings: settings,
          fullscreenDialog: true,
        );
      default:
      // TODO: Throw
        return null;
    }
  }
}