import 'package:Donate/friendList.dart';
import 'package:flutter/material.dart';

class MyFriends extends StatefulWidget {
  final uid;
  final userType;
  MyFriends({this.uid,this.userType});

  @override
  _MyFriendsState createState() => _MyFriendsState();
}

class _MyFriendsState extends State<MyFriends> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        title: Text('My '+widget.userType+'s'),
      ),
      backgroundColor: Colors.grey[200],
      body: FriendList(uid:widget.uid),
    );
  }
}
