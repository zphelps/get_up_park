import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/home/groups/post_modal.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/services/firestore_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/shared_widgets/loading.dart';

class CreatePostView extends StatefulWidget {
  CreatePostView({required this.group});

  final Group group;

  @override
  _CreatePostViewState createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {

  String? _text;

  bool _loading = false;

  Future<void> _submit() async {
    try {
      setState(() {
        _loading = true;
      });
      final database = context.read<FirestoreDatabase>(databaseProvider);
      final _id = documentIdFromCurrentDate();
      final post = Post(
        id: _id,
        text: _text!,
        date: DateTime.now().toString(),
        group: widget.group.name,
        category: widget.group.category,
        groupLogoURL: widget.group.logoURL,
      );
      await database.setPost(post);
      await Future.delayed(const Duration(milliseconds: 500));
      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        _loading = false;
      });
      showExceptionAlertDialog(
        context: context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Create Post',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 1,
        actions: [
          _loading ?
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 25),
            child: SizedBox(width: 25, child: CircularProgressIndicator()),
          ) :
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: _text != null ? _submit : null,
              child: Chip(
                backgroundColor: _text != null ? Colors.red : Colors.red[200],
                label: const Text(
                  'Post',
                  style:
                  TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: CachedNetworkImage(
                memCacheWidth: 3000,
                memCacheHeight: 3000,
                height: 30,
                imageUrl: widget.group.logoURL,
                fit: BoxFit.fitWidth,
                width: 30,
                placeholder: (context, url) =>
                const Image(
                    image: AssetImage('assets/skeletonImage.gif'),
                    fit: BoxFit
                        .cover), //Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: TextFormField(
                autofocus: true,
                autocorrect: true,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500
                ),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(top: 9),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  //labelText: 'Name',
                  hintText: 'Write your post...',
                  // focusedBorder: UnderlineInputBorder(
                  //     borderSide: BorderSide(
                  //       color: Colors.red,
                  //       width: 2,
                  //     )
                  // ),
                ),
                keyboardAppearance: Brightness.light,
                initialValue: _text,
                maxLines: 5,
                validator: (value) =>
                (value ?? '').isNotEmpty
                    ? null
                    : 'Post text can\'t be empty',
                onChanged: (value) {
                  setState(() {
                    _text = value;
                  });
                },
                onSaved: (value) {
                  setState(() {
                    _text = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
