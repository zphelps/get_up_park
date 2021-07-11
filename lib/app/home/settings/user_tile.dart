import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/services/firestore_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class UserTile extends StatefulWidget {

  final PTUser user;

  const UserTile({required this.user});

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {

  bool isAdmin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isAdmin = widget.user.admin == 'true' ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        HapticFeedback.heavyImpact();
        final database = context.read<FirestoreDatabase>(databaseProvider);
        isAdmin ? await database.setAdmin(widget.user.id, 'false') : await database.setAdmin(widget.user.id, 'true');
        setState(() {
          isAdmin = !isAdmin;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: ListTile(
          dense: true,
          visualDensity: const VisualDensity(vertical: -1),
          minVerticalPadding: 0,
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey[600],
            child: Text(
              '${widget.user.firstName.substring(0, 1)}${widget.user.lastName.substring(0, 1)}',
              style: const TextStyle(
                fontSize: 18,
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
            widget.user.email,
          ),
          trailing: CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white,
            child: Icon(
              isAdmin ? Icons.check_circle : Icons.check_circle_outline,
              color: isAdmin ? Colors.red : Colors.grey,
            ),
          ),
        ),
        // child: Row(
        //   //crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     UserProfileIcon(firstName: user.firstName, lastName: user.lastName, radius: 18),
        //     const SizedBox(width: 15),
        //     Text(
        //       user.firstName,
        //       style: const TextStyle(
        //         fontWeight: FontWeight.bold,
        //         fontSize: 16,
        //       ),
        //     ),
        //     const SizedBox(height: 4),
        //   ],
        // ),
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
      ),
    );
  }
}
