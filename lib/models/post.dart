import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:message_app/services/database.dart';

class Post {
  String avatar;
  String author;
  String body;
  String uid;
  String createdAt;
  Set userLiked = {};
  Set userDisLiked = {};
  late DatabaseReference _id;

  Post(
    this.avatar,
    this.author,
    this.body,
    this.uid,
    this.createdAt,
  );

  void likePost(User user) {
    if (userLiked.contains(user.uid)) {
      userLiked.remove(user.uid);
    } else {
      userLiked.add(user.uid);
      if (userDisLiked.contains(user.uid)) userDisLiked.remove(user.uid);
      if (userDisLiked.isEmpty) removeUserDisLiked(this, _id);
    }
    print('====> post | likePost userLiked: ${userLiked.toString()}');
    print('====> post | likePost userDisLiked: ${userDisLiked.toString()}');
    update();
  }

  void dislikePost(User user) {
    if (userDisLiked.contains(user.uid)) {
      userDisLiked.remove(user.uid);
    } else {
      userDisLiked.add(user.uid);
      if (userLiked.contains(user.uid)) userLiked.remove(user.uid);
      if (userLiked.isEmpty) removeUserLiked(this, _id);
    }
    print('====> post | dislikePost userLiked: ${userLiked.toString()}');
    print('====> post | dislikePost userDisLiked: ${userDisLiked.toString()}');
    update();
  }

  void update() {
    updatePost(this, _id);
  }

  void edit(body, id) {
    print('====> post | edit: $body');
    updatePost(this, _id);
  }

  void remove() {
    removePost(this, _id);
  }

  void setId(DatabaseReference id) {
    _id = id;
  }

  Map<String, dynamic> toJson() {
    if (userLiked.toList().isNotEmpty) {
      return {
        'avatar': avatar,
        'author': author,
        'body': body,
        'uid': uid,
        'createdAt': createdAt,
        'userLiked': userLiked.toList(),
      };
    } else if (userDisLiked.toList().isNotEmpty) {
      return {
        'avatar': avatar,
        'author': author,
        'body': body,
        'uid': uid,
        'createdAt': createdAt,
        'userDisLiked': userDisLiked.toList(),
      };
    } else {
      return {
        'avatar': avatar,
        'author': author,
        'body': body,
        'uid': uid,
        'createdAt': createdAt,
      };
    }
  }
}

Post createPost(record) {
  Map<String, dynamic> attributes = {
    'avatar': '',
    'author': '',
    'body': '',
    'uid': '',
    'createdAt': '',
    'userLiked': [],
    'userDisLiked': [],
  };

  record.forEach((key, value) => attributes[key] = value);

  Post post = Post(
    attributes['avatar'],
    attributes['author'],
    attributes['body'],
    attributes['uid'],
    attributes['createdAt'],
  );
  if (attributes['userLiked'].isNotEmpty) {
    post.userLiked = Set.from(attributes['userLiked']);
  }
  if (attributes['userDisLiked'].isNotEmpty) {
    post.userDisLiked = Set.from(attributes['userDisLiked']);
  }
  print('====> post | post: $post');
  return post;
}
