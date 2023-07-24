import 'package:flutter/material.dart';
import 'package:message_app/models/post.dart';
import 'package:message_app/services/database.dart';
import 'package:message_app/common/text_input.dart';
import 'package:message_app/models/post_list.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyHomePage extends StatefulWidget {
  final User user;

  const MyHomePage(this.user, {super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Post> posts = [];

  String createdAtCurrentDate = DateTime.now().toString();
  bool _sortAscending = true;

  void sortPosts(bool ascending) {
    setState(() {
      _sortAscending = ascending;
      posts.sort((a, b) => ascending
          ? a.createdAt.compareTo(b.createdAt)
          : b.createdAt.compareTo(a.createdAt));
    });
  }

  void newPost(String text) {
    var post = Post(
      widget.user.photoURL!,
      widget.user.displayName!,
      text,
      widget.user.uid,
      createdAtCurrentDate,
    );
    post.setId(savePost(post));
    setState(() {
      posts.add(post);
    });
    print(
        '====> home_page | newPost author: ${post.author} body: ${post.body} createdAt: ${post.createdAt} createdAtCurrentDate: $createdAtCurrentDate uid: ${post.uid} liked: {post.userLiked}');
  }

  void updateMessages() async {
    await getAllPosts().then((posts) => {
          setState(
            () => this.posts = posts,
          )
        });
    print('====> home_page | updateMessages: $posts}');
  }

  @override
  void initState() {
    super.initState();
    updateMessages();
    sortPosts(_sortAscending);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Posts'),
            SizedBox(
              height: 30,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(
                  widget.user.photoURL!,
                  // 'https://i.pravatar.cc/200',
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _sortAscending
                  ? ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_downward),
                      label: const Text('Oldest first'),
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.black54),
                        overlayColor: MaterialStateProperty.all(Colors.white),
                        shadowColor: MaterialStateProperty.all(Colors.white),
                        elevation: MaterialStateProperty.all(0),
                      ),
                      onPressed: () {
                        setState(() {
                          sortPosts(false);
                          print(
                              '====> home_page | _sortAscending: $_sortAscending');
                        });
                      },
                    )
                  : ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_upward),
                      label: const Text('Newest first'),
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.black54),
                        overlayColor: MaterialStateProperty.all(Colors.white),
                        shadowColor: MaterialStateProperty.all(Colors.white),
                        elevation: MaterialStateProperty.all(0),
                      ),
                      onPressed: () {
                        setState(() {
                          sortPosts(true);
                          print(
                              '====> home_page | _sortAscending: $_sortAscending');
                        });
                      },
                    ),
            ],
          ),
          Expanded(
              child: PostList(
            posts,
            widget.user,
          )),
          TextInputWidget(newPost),
        ],
      ),
    );
  }
}
