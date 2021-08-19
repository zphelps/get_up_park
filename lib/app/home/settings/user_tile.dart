import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/services/firestore_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

List<String> userTypes = ['Super Admin', 'Sport/Club Admin', 'Score Reporter', 'User'];

class UserTile extends StatefulWidget {

  final PTUser user;

  const UserTile({required this.user});

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {

  String adminType = 'User';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    adminType = widget.user.admin;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
      child: ListTile(
        onTap: () {
          Navigator.of(context, rootNavigator: true).pushNamed(
            AppRoutes.userPermissionsProfileView,
            arguments: {
              'user': widget.user,
            }
          );
        },
        dense: true,
        visualDensity: const VisualDensity(vertical: -1),
        minVerticalPadding: 0,
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey[600],
          child: Text(
            '${widget.user.firstName.substring(0, 1)}${widget.user.lastName.substring(0, 1)}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        title: Text(
          '${widget.user.firstName} ${widget.user.lastName}',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          widget.user.admin,
        ),
        trailing: const Icon(
          Icons.edit_outlined,
          size: 20,
        ),
        // trailing: PopupMenuButton(
        //   icon: Icon(
        //     Icons.more_vert,
        //     size: 20,
        //     color: Colors.grey[700],
        //   ),
        //   //color: Colors.black,
        //   shape: const RoundedRectangleBorder(
        //       borderRadius: BorderRadius.all(Radius.circular(15.0))
        //   ),
        //   itemBuilder: (BuildContext bc) {
        //     return userTypes.map((e) {
        //       print(e);
        //       return PopupMenuItem(child: Text(e), value: e);
        //     }).toList();
        //   },
        //   onSelected: (value) async {
        //     for (String element in userTypes) {
        //       if(value == element) {
        //         final database = context.read<FirestoreDatabase>(databaseProvider);
        //         await database.setAdmin(widget.user.id, element);
        //         setState(() {
        //           adminType = element;
        //         });
        //       }
        //     }
        //   },
        // ),
        // trailing: CircleAvatar(
        //   radius: 16,
        //   backgroundColor: Colors.white,
        //   child: Icon(
        //     isAdmin ? Icons.check_circle : Icons.check_circle_outline,
        //     color: isAdmin ? Colors.red : Colors.grey,
        //   ),
        // ),
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 24,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ]
      ),
    );
  }
}
