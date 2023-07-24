import 'package:flutter/material.dart';
import 'package:message_app/models/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lit_relative_date_time/lit_relative_date_time.dart';

class PostList extends StatefulWidget {
  final List<Post> listItems;
  final User user;

  const PostList(
    this.listItems,
    this.user, {super.key},
  );

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  void like(Function callback) {
    setState(() {
      callback();
    });
  }

  final controller = TextEditingController();
  late List<Post> listItems;

  @override
  void initState() {
    super.initState();
    listItems = widget.listItems;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
        itemCount: widget.listItems.length,
        itemBuilder: (context, index) {
          final post = widget.listItems[index];
          final DateTime createdAtDateTime =
              DateTime.parse(post.createdAt).toLocal();
          return GestureDetector(
            onTap: () {
              setState(() {
                // controller.text = post.body;
              });
              // print('====> post_list | widget.user: ${widget.user}');
              // print('====> post_list | widget.user.uid: ${widget.user.uid}');
              print('====> post_list | post.uid: ${post.body}');
            },
            child: Column(
              children: [
                Card(
                    child: Row(children: <Widget>[
                  Expanded(
                      child: ListTile(
                    title: Row(
                      children: [
                        Text(
                          post.author,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const Text(' | '),
                        AnimatedRelativeDateTimeBuilder(
                          date: createdAtDateTime,
                          builder: (relDateTime, formatted) {
                            return Text(formatted,
                                style: const TextStyle(fontSize: 12));
                          },
                        ),
                      ],
                    ),
                    subtitle: Text(
                      post.body,
                      style: const TextStyle(fontSize: 16),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(
                        post.avatar,
                        // 'https://i.pravatar.cc/200',
                      ),
                    ),
                  )),
                ])),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          iconSize: 18.0,
                          onPressed: () => like(() => {
                                setState(() {
                                  post.likePost(widget.user);
                                }),
                              }),
                          splashColor: Colors.orange[200],
                          color: post.userLiked.contains(widget.user.uid)
                              ? Colors.green
                              : Colors.black87,
                          icon: const Icon(Icons.thumb_up_alt_outlined),
                        ),
                        Text(
                          post.userLiked.length.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          iconSize: 18.0,
                          onPressed: () => like(() => {
                                setState(() {
                                  post.dislikePost(widget.user);
                                }),
                              }),
                          splashColor: Colors.red[200],
                          color: post.userDisLiked.contains(widget.user.uid)
                              ? Colors.red
                              : Colors.black87,
                          icon: const Icon(Icons.thumb_down_alt_outlined),
                        ),
                        Text(
                          post.userDisLiked.length.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    if (post.uid == widget.user.uid)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            iconSize: 18.0,
                            onPressed: () => {
                              setState(() {
                                controller.text = post.body;
                              }),
                            },
                            padding: const EdgeInsets.all(0.0),
                            splashColor: Colors.orange,
                            color: Colors.black,
                            icon: const Icon(Icons.edit_outlined),
                          ),
                          IconButton(
                            iconSize: 18.0,
                            onPressed: () {
                              setState(() {
                                post.remove();
                                widget.listItems.removeAt(index);
                                print('====> post_list | index: $index');
                              });
                            },
                            padding: const EdgeInsets.all(0.0),
                            splashColor: Colors.red[200],
                            color: Colors.red,
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
