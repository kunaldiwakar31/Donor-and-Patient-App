import 'package:Donate/Database.dart';
import 'package:Donate/UserTile.dart';
import 'package:Donate/userInfo.dart';
import 'package:flutter/material.dart';

import 'loading.dart';

class FriendList extends StatelessWidget {

  final String uid;
  FriendList({this.uid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserData>>(
      stream: DatabaseService(uid: uid).friendsData,
      builder: (context, snapshot){
        if(snapshot.hasData){
          List<UserData> friends=snapshot.data;

          return ListView.builder(
            itemCount: friends.length ?? 0,
            itemBuilder: (context,index){
              return UserTile(userInfo: friends[index],uid:uid);
            },
          );
        }else{
          return Loading();
        }
      },
    );
  }
}

