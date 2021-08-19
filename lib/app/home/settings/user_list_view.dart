import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/list_items_builder.dart';
import 'package:get_up_park/app/home/settings/user_tile.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:google_fonts/google_fonts.dart';

// watch database
class UserListView extends ConsumerWidget {

  UserListView({required this.currentUser});

  final PTUser currentUser;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          title: const Text(
            'Select Admins',
            style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.red,
            labelStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelColor: Colors.grey[800],
            unselectedLabelStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w400,
            ),
            tabs: [
              Tab(
                text: 'All Users',
              ),
              Tab(
                text: 'Sport/Club Admins',
              ),
              Tab(
                text: 'Score Reporters',
              ),
              Tab(
                text: 'Super Admins',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildContents(context, watch, 'all'),
            _buildContents(context, watch, userTypes[1]),
            _buildContents(context, watch, userTypes[2]),
            _buildContents(context, watch, userTypes[0]),
          ],
        ),
      ),
    );
    //print(user.uid);
  }

  Widget _buildContents(BuildContext context, ScopedReader watch, String userType) {
    final usersAsyncValue = watch(usersStreamProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListItemsBuilder<PTUser>(
          data: usersAsyncValue,
          itemBuilder: (context, user) {
            if(currentUser.id != user.id) {
              if(userType == 'all') {
                return UserTile(user: user);
              }
              else if(userType == user.admin) {
                return UserTile(user: user);
              }
              else if(userType == user.admin) {
                return UserTile(user: user);
              }
              else if(userType == user.admin) {
                return UserTile(user: user);
              }
            }
            return const SizedBox(height: 0);
          }
      ),
    );
  }
}