import 'package:Donate/userInfo.dart';
import 'package:Donate/userProfile.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final UserData userInfo;
  final String uid;
  UserTile({this.userInfo,this.uid});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.grey,
          ),
          title: Text(userInfo.name),
          subtitle: Text(userInfo.address),
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfile(uid: userInfo.uid,curUid: uid))
            );
          },
        ),
      ),
    );
  }
}
