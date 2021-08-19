import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/home/settings/user_profile_icon.dart';
import 'package:get_up_park/app/home/settings/user_tile.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/constants/strings.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/services/auth.dart';
import 'package:get_up_park/services/firestore_database.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';

class UserPermissionsProfileView extends StatefulWidget {
  const UserPermissionsProfileView({required this.user});

  final PTUser user;

  @override
  State<UserPermissionsProfileView> createState() => _UserPermissionsProfileViewState();
}

class _UserPermissionsProfileViewState extends State<UserPermissionsProfileView> {

  String? userType;

  @override
  void initState() {
    super.initState();
    userType = widget.user.admin;
  }

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
          'Set User Permissions',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        // actions: [
        //   IconButton(
        //     padding: const EdgeInsets.only(right: 10),
        //     onPressed: () async {
        //       HapticFeedback.heavyImpact();
        //       String url = 'https://forms.gle/z1T5Acast9kuCtdr9';
        //       if (await canLaunch(url)) {
        //         await launch(url);
        //       }
        //       else {
        //         // can't launch url, there is some error
        //         print('eror');
        //         throw "Could not launch $url";
        //       }
        //     },
        //     icon: Icon(
        //       Icons.edit_outlined,
        //       size: 20,
        //     ),
        //   ),
        // ],
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: _buildContents(context, widget.user),
    );
  }

  Widget _buildContents(BuildContext context, PTUser user) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const SizedBox(height: 25),
          // UserProfileIcon(firstName: user.firstName, lastName: user.lastName, radius: 65),
          // const SizedBox(height: 25),
          // Padding(
          //   padding: const EdgeInsets.only(left: 15),
          //   child: Text(
          //     'USER TYPE',
          //     style: TextStyle(
          //       color: Colors.grey[600],
          //       fontWeight: FontWeight.w600,
          //       fontSize: 12,
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 2),
          // const Divider(height: 0, color: Colors.grey, thickness: 0.5,),
          DropdownButtonFormField(
            hint: const Text(
              'Select advisory',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            value: user.admin,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              labelStyle: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  )
              ),
            ),
            onChanged: (value) async {
              final database = context.read<FirestoreDatabase>(databaseProvider);
              await database.setAdmin(user.id, value.toString());
              setState(() {
                userType = (value as String?)!;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Admin type can\'t be empty';
              } else {
                return null;
              }
            },
            // ignore: prefer_const_literals_to_create_immutables
            items: userTypes.map((e) {
              return DropdownMenuItem(
                value: e,
                child: Text(e),
              );
            }).toList(),
          ),
          () {
            if(userType == userTypes[1] || userType == userTypes[2]) {
              return Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).pushNamed(
                        AppRoutes.selectGroupsUserCanAccessView,
                        arguments: {
                          'user': user,
                        }
                      );
                    },
                    dense: true,
                    visualDensity: const VisualDensity(vertical: 1),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    // horizontalTitleGap: 10,
                    minVerticalPadding: 0,
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: const Icon(
                        Icons.group,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      'Set permissions for ${user.firstName}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                    ),
                  ),
                  const Divider(height: 0, color: Colors.grey, thickness: 0.5,),
                ],
              );
            }
            return const SizedBox(height: 0);
          }(),

          // ListTile(
          //   dense: true,
          //   visualDensity: const VisualDensity(vertical: 1),
          //   contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          //   horizontalTitleGap: 2,
          //   minVerticalPadding: 0,
          //   leading: const Icon(
          //     Icons.person_outline,
          //     color: Colors.black,
          //   ),
          //   title: Text(
          //     '${user.firstName} ${user.lastName}',
          //     style: const TextStyle(
          //       color: Colors.black,
          //       fontWeight: FontWeight.w600,
          //       fontSize: 16,
          //     ),
          //   ),
          //   // trailing: const Icon(
          //   //   Icons.chevron_right,
          //   //   // size: 22,
          //   // ),
          // ),
          // const Divider(height: 0),
          // ListTile(
          //   dense: true,
          //   visualDensity: const VisualDensity(vertical: 1),
          //   contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          //   horizontalTitleGap: 2,
          //   minVerticalPadding: 0,
          //   leading: const Icon(
          //     Icons.school_outlined,
          //     color: Colors.black,
          //   ),
          //   title: Text(
          //     '${user.advisor}',
          //     style: const TextStyle(
          //       color: Colors.black,
          //       fontWeight: FontWeight.w600,
          //       fontSize: 16,
          //     ),
          //   ),
          //   // trailing: const Icon(
          //   //   Icons.launch,
          //   //   size: 20,
          //   // ),
          // ),
          // const Divider(height: 0),
          // ListTile(
          //   onTap: () async {
          //     if(user.admin == userTypes[0]) {
          //       Navigator.of(context, rootNavigator: true).pushNamed(
          //           AppRoutes.userListView,
          //           arguments: {
          //             'user': user,
          //           }
          //       );
          //     }
          //     else {
          //       HapticFeedback.heavyImpact();
          //       String url = 'https://docs.google.com/forms/d/e/1FAIpQLSdTjeqSX49CMrRGVxuc9qChktczzf3w3o_eXm_h_WdNGTcxfw/viewform?usp=sf_link';
          //       if (await canLaunch(url)) {
          //         await launch(url);
          //       }
          //       else {
          //         // can't launch url, there is some error
          //         print('eror');
          //         throw "Could not launch $url";
          //       }
          //     }
          //   },
          //   dense: true,
          //   visualDensity: const VisualDensity(vertical: 1),
          //   contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          //   horizontalTitleGap: 2,
          //   minVerticalPadding: 0,
          //   leading: const Icon(
          //     Icons.admin_panel_settings_outlined,
          //     color: Colors.black,
          //   ),
          //   title: Text(
          //     user.admin,
          //     style: const TextStyle(
          //       color: Colors.black,
          //       fontWeight: FontWeight.w600,
          //       fontSize: 16,
          //     ),
          //   ),
          //   trailing: Icon(
          //     user.admin == userTypes[0] ? Icons.chevron_right : Icons.launch,
          //     size: 22,
          //   ),
          // ),
          // const Divider(height: 0),
          //
          // const SizedBox(height: 25),
          // Padding(
          //   padding: const EdgeInsets.only(left: 15),
          //   child: Text(
          //     'GENERAL',
          //     style: TextStyle(
          //       color: Colors.grey[600],
          //       fontWeight: FontWeight.w600,
          //       fontSize: 12,
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 2),
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
          // ListTile(
          //   onTap: () async {
          //     final mailtoLink = Mailto(
          //       to: ['zach@zachphelps.com'],
          //       cc: ['zphelps@parktudor.org'],
          //       subject: 'Get Up Park - Help Request',
          //       body: 'Zach, ',
          //     );
          //     // Convert the Mailto instance into a string.
          //     // Use either Dart's string interpolation
          //     // or the toString() method.
          //     await launch('$mailtoLink');
          //   },
          //   dense: true,
          //   visualDensity: const VisualDensity(vertical: 1),
          //   contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          //   horizontalTitleGap: 2,
          //   minVerticalPadding: 0,
          //   leading: const Icon(
          //     Icons.help_outline_outlined,
          //     color: Colors.black,
          //   ),
          //   title: const Text(
          //     'Help',
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
          // ListTile(
          //   onTap: () async {
          //     await _auth.signOut();
          //     Navigator.of(context, rootNavigator: true).popUntil((route) => !route.hasActiveRouteBelow);
          //     // Navigator.of(context).pop();
          //   },
          //   dense: true,
          //   visualDensity: const VisualDensity(vertical: 1),
          //   contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          //   horizontalTitleGap: 2,
          //   minVerticalPadding: 0,
          //   leading: const Icon(
          //     Icons.logout,
          //     color: Colors.black,
          //   ),
          //   title: const Text(
          //     'Logout',
          //     style: TextStyle(
          //       color: Colors.black,
          //       fontWeight: FontWeight.w600,
          //       fontSize: 16,
          //     ),
          //   ),
          //   trailing: const Icon(
          //     Icons.chevron_right,
          //   ),
          // ),
          // const Divider(height: 0),
          // const SizedBox(height: 15),
          // Center(
          //   child: Text(
          //     'Beta release 1.1.0. Created by Zach Phelps.',
          //     style: TextStyle(
          //         fontSize: 12,
          //         color: Colors.grey[600],
          //         fontWeight: FontWeight.w300
          //     ),
          //   ),
          // ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
