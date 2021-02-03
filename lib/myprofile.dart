import 'package:Donate/Database.dart';
import 'package:Donate/imageloader.dart';
import 'package:Donate/loading.dart';
import 'package:Donate/userInfo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'CustomUser.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {

  @override
  Widget build(BuildContext context) {

    final user=Provider.of<CustomUser>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.userId).currentUserData,
        builder: (context,snapshot){
          if(snapshot.hasData){
            UserData userD=snapshot.data;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.red[400],
                title: Text('My Profile'),
              ),
              body: Center(
                child: Column(
                  children: [
                    SizedBox(height: 20.0),
                    CircleAvatar(
                      radius: 100.0,
                      backgroundColor: Colors.blue,
                    ),
                    SizedBox(height: 10.0),
                    RaisedButton(
                      color: Colors.red[400],
                      child: Text(
                        'Upload Profile Picture',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      onPressed:(){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ImageCapture())
                        );
                      }
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      userD.name,
                      style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 50.0),
                    Text(
                      userD.email,
                      style: TextStyle(
                          fontSize: 18.0
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      userD.phone,
                      style: TextStyle(
                          fontSize: 18.0
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      userD.address,
                      style: TextStyle(
                          fontSize: 18.0
                      ),
                    )
                  ],
                ),
              ),
            );
          }else{
            return Loading();
          }
        }
    );
  }
}
