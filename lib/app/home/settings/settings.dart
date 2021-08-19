import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_up_park/app/home/settings/user_profile_icon.dart';
import 'package:get_up_park/app/home/settings/user_tile.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/constants/strings.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/services/auth.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatelessWidget {
  const Settings({required this.user});

  final PTUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: const IconThemeData(
            color: Colors.black
        ),
        title: const Text(
          Strings.settings,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 10),
            onPressed: () async {
              HapticFeedback.heavyImpact();
              String url = 'https://forms.gle/z1T5Acast9kuCtdr9';
              if (await canLaunch(url)) {
                await launch(url);
              }
              else {
                // can't launch url, there is some error
                print('eror');
                throw "Could not launch $url";
              }
            },
            icon: Icon(
              Icons.edit_outlined,
              size: 20,
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: _buildContents(context, user),
    );
  }

  Widget _buildContents(BuildContext context, PTUser user) {
    final AuthService _auth = AuthService();
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),
          UserProfileIcon(firstName: user.firstName, lastName: user.lastName, radius: 65),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              'ACCOUNT',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 2),
          ListTile(
            dense: true,
            visualDensity: const VisualDensity(vertical: 1),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            horizontalTitleGap: 2,
            minVerticalPadding: 0,
            leading: const Icon(
              Icons.email_outlined,
              color: Colors.black,
            ),
            title: Text(
              user.email,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          const Divider(height: 0),
          ListTile(
            dense: true,
            visualDensity: const VisualDensity(vertical: 1),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            horizontalTitleGap: 2,
            minVerticalPadding: 0,
            leading: const Icon(
              Icons.person_outline,
              color: Colors.black,
            ),
            title: Text(
              '${user.firstName} ${user.lastName}',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            // trailing: const Icon(
            //   Icons.chevron_right,
            //   // size: 22,
            // ),
          ),
          const Divider(height: 0),
          ListTile(
            dense: true,
            visualDensity: const VisualDensity(vertical: 1),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            horizontalTitleGap: 2,
            minVerticalPadding: 0,
            leading: const Icon(
              Icons.school_outlined,
              color: Colors.black,
            ),
            title: Text(
              '${user.advisor}',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            // trailing: const Icon(
            //   Icons.launch,
            //   size: 20,
            // ),
          ),
          const Divider(height: 0),

          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              'GENERAL',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 2),
          // ListTile(
          //   onTap: () async {
          //     HapticFeedback.heavyImpact();
          //     String url = 'https://www.parktudor.org';
          //     if (await canLaunch(url)) {
          //       await launch(url);
          //     }
          //     else {
          //       // can't launch url, there is some error
          //       print('eror');
          //       throw "Could not launch $url";
          //     }
          //   },
          //   dense: true,
          //   visualDensity: const VisualDensity(vertical: 1),
          //   contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          //   horizontalTitleGap: 2,
          //   minVerticalPadding: 0,
          //   leading: const Icon(
          //     Icons.info_outline,
          //     color: Colors.black,
          //   ),
          //   title: const Text(
          //     'About',
          //     style: TextStyle(
          //       color: Colors.black,
          //       fontWeight: FontWeight.w600,
          //       fontSize: 16,
          //     ),
          //   ),
          //   trailing: const Icon(
          //     Icons.launch,
          //     size: 20,
          //   ),
          // ),
          // const Divider(height: 0),
          ListTile(
            onTap: () async {
              if(user.admin == userTypes[0]) {
                Navigator.of(context, rootNavigator: true).pushNamed(
                    AppRoutes.userListView,
                    arguments: {
                      'user': user,
                    }
                );
              }
              else {
                HapticFeedback.heavyImpact();
                String url = 'https://docs.google.com/forms/d/e/1FAIpQLSdTjeqSX49CMrRGVxuc9qChktczzf3w3o_eXm_h_WdNGTcxfw/viewform?usp=sf_link';
                if (await canLaunch(url)) {
                  await launch(url);
                }
                else {
                  // can't launch url, there is some error
                  print('eror');
                  throw "Could not launch $url";
                }
              }
            },
            dense: true,
            visualDensity: const VisualDensity(vertical: 1),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            horizontalTitleGap: 2,
            minVerticalPadding: 0,
            leading: const Icon(
              Icons.admin_panel_settings_outlined,
              color: Colors.black,
            ),
            title: Text(
              user.admin == userTypes[3] ? 'Request admin access' : user.admin,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            trailing: Icon(
              user.admin == userTypes[0] ? Icons.chevron_right : Icons.launch,
              size: 22,
            ),
          ),
          const Divider(height: 0),
          ListTile(
            onTap: () async {
              final mailtoLink = Mailto(
                to: ['zach@zachphelps.com'],
                cc: ['zphelps@parktudor.org'],
                subject: 'Get Up Park - Help Request',
                body: 'Zach, ',
              );
              // Convert the Mailto instance into a string.
              // Use either Dart's string interpolation
              // or the toString() method.
              await launch('$mailtoLink');
            },
            dense: true,
            visualDensity: const VisualDensity(vertical: 1),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            horizontalTitleGap: 2,
            minVerticalPadding: 0,
            leading: const Icon(
              Icons.help_outline_outlined,
              color: Colors.black,
            ),
            title: const Text(
              'Send feedback',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            trailing: const Icon(
              Icons.launch,
              size: 20,
            ),
          ),
          const Divider(height: 0),
          ListTile(
            onTap: () async {
              await _auth.signOut();
              Navigator.of(context, rootNavigator: true).popUntil((route) => !route.hasActiveRouteBelow);
              // Navigator.of(context).pushReplacementNamed(AppRoutes.authOptions);
            },
            dense: true,
            visualDensity: const VisualDensity(vertical: 1),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            horizontalTitleGap: 2,
            minVerticalPadding: 0,
            leading: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
            title: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            trailing: const Icon(
              Icons.chevron_right,
            ),
          ),
          const Divider(height: 0),
          const SizedBox(height: 15),
          Center(
            child: Text(
              'Version 1.1.6(1). Created by Zach Phelps.',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w300
              ),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
