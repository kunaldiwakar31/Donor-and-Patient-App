import 'package:Donate/userInfo.dart';
import 'package:flutter/material.dart';

import 'Database.dart';
import 'loading.dart';

class UserProfile extends StatefulWidget {

  final String curUid;
  final String uid;
  UserProfile({this.uid,this.curUid});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: widget.uid).currentUserData,
        builder: (context,snapshot){
          if(snapshot.hasData){
            UserData userD=snapshot.data;

            List requestSent=userD.requestSent;
            List requestReceived=userD.requestReceived;
            List friendList=userD.friends;

            if(friendList.contains(widget.curUid)) {  // if donor and patient are friends
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.red[400],
                  title: Text( userD.name+' Profile'),
                ),
                body: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 20.0),
                      CircleAvatar(
                        radius: 100.0,
                        backgroundColor: Colors.blue,
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
                      ),
                      SizedBox(height: 40.0),
                      RequestButton(type: 3,curUid: widget.curUid,uid: widget.uid),
                      SizedBox(height: 20.0),
                      CancelButton(type: 3,curUid: widget.curUid,uid: widget.uid)
                    ],
                  ),
                ),
              );
            }else{// if donor and patient are not friends

              int type=0;
              if(requestSent.contains(widget.curUid)){        // current user received request from other user
                type=1;
              }else if(requestReceived.contains(widget.curUid)){    // current user sent request to other user
                type=2;
              }else if(friendList.contains(widget.curUid)){
                type=3;                                       //Users are friends
              }

              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.red[400],
                  title: Text(userD.name+' Profile'),
                ),
                body: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 20.0),
                      CircleAvatar(
                        radius: 100.0,
                        backgroundColor: Colors.blue,
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        userD.name,
                        style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        userD.address,
                        style: TextStyle(
                            fontSize: 18.0
                        ),
                      ),
                      SizedBox(height: 40.0),
                      RequestButton(type: type,curUid: widget.curUid,uid: widget.uid),
                      SizedBox(height: 20.0),
                      CancelButton(type: type,curUid: widget.curUid,uid: widget.uid)
                    ],
                  ),
                ),
              );
            }
          }else{
            return Loading();
          }
        }
    );
  }
}

class RequestButton extends StatefulWidget {
  final type;
  final curUid;
  final uid;

  RequestButton({this.type,this.curUid,this.uid});

  @override
  _RequestButtonState createState() => _RequestButtonState();
}

class _RequestButtonState extends State<RequestButton> {
  @override
  Widget build(BuildContext context) {
    if(widget.type==1){
      return RaisedButton.icon(
        onPressed: (){
          DatabaseService(uid: widget.curUid).acceptRequest(widget.uid);
        },
        icon: Icon(Icons.person_add),
        label: Text(
          'Accept Request',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Colors.white
          ),
        ),
        color: Colors.lightGreen[400],
      );
    }else if(widget.type==2){
      return RaisedButton.icon(
        onPressed: (){

        },
        icon: Icon(Icons.person_add),
        label: Text(
          'Request Sent',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Colors.white
          ),
        ),
        color: Colors.grey[400],
      );
    }else if(widget.type==3){
      return RaisedButton.icon(
        onPressed: (){

        },
        icon: Icon(Icons.people_rounded),
        label: Text(
          'Friends',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Colors.white
          ),
        ),
        color: Colors.lightGreen[400],
      );
    }else{
      return RaisedButton.icon(
        onPressed: (){
          DatabaseService(uid: widget.curUid).sendRequest(widget.uid);
        },
        icon: Icon(Icons.person_add),
        label: Text(
          'Send Request',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Colors.white
          ),
        ),
        color: Colors.red[400],
      );
    }
  }
}
class CancelButton extends StatefulWidget {
  final type;
  final curUid;
  final uid;

  CancelButton({this.type,this.curUid,this.uid});

  @override
  _CancelButtonState createState() => _CancelButtonState();
}

class _CancelButtonState extends State<CancelButton> {
  @override
  Widget build(BuildContext context) {
    if(widget.type==0){
      return Container();
    }
    if(widget.type==3){
      return RaisedButton.icon(
        onPressed: (){
          DatabaseService(uid: widget.curUid).unfriend(widget.uid);
        },
        icon: Icon(Icons.person_add_disabled_sharp),
        label: Text(
          'UnFriend',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Colors.white
          ),
        ),
        color: Colors.red[400],
      );
    }
    return RaisedButton.icon(
      onPressed: (){
        DatabaseService(uid: widget.curUid).cancelRequest(widget.uid);
      },
      icon: Icon(Icons.person_remove),
      label: Text(
        'Cancel Request',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            color: Colors.white
        ),
      ),
      color: Colors.red[400],
    );
  }
}
