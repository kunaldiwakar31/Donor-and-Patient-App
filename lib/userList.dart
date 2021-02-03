import 'package:Donate/CustomUser.dart';
import 'package:Donate/Database.dart';
import 'package:Donate/UserTile.dart';
import 'package:Donate/userInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'loading.dart';

class UserList extends StatelessWidget {

  final userType;
  final uid;
  UserList({this.userType,this.uid});

  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserData>>(
      stream: DatabaseService(userType: userType).allUserData,
      builder: (context, snapshot){
        if(snapshot.hasData){
          List<UserData> users=snapshot.data;

          return ListView.builder(
            itemCount: users.length ?? 0,
            itemBuilder: (context,index){
              return UserTile(userInfo: users[index],uid:uid);
            },
          );
        }else{
          return Loading();
        }
      },
    );
  }
}
