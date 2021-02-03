import 'file:///C:/Users/kunal/StudioProjects/Donate/lib/auth.dart';
import 'package:Donate/CustomUser.dart';
import 'package:Donate/Database.dart';
import 'package:Donate/MyFriends.dart';
import 'package:Donate/friendList.dart';
import 'package:Donate/myprofile.dart';
import 'package:Donate/userInfo.dart';
import 'package:Donate/userList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'loading.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth=AuthService();

  @override
  Widget build(BuildContext context) {
    final user=Provider.of<CustomUser>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.userId).currentUserData,
         builder:(context,snapshot) {
           if(snapshot.hasData){

             UserData userData=snapshot.data;
             var userType=userData.userType;
             userType=(userType=='Donor')?'Patient':'Donor';

             return Scaffold(
               appBar: AppBar(
                 backgroundColor: Colors.red[400],
                 title: Text(userType+'s'),
               ),
               drawer: Drawer(
                 child: Column(
                   children: <Widget>[
                     DrawerHeader(
                       padding: EdgeInsets.only(top: 30.0),
                       decoration: BoxDecoration(
                           image: DecorationImage(
                               image: AssetImage('assets/donate.png'),
                               fit: BoxFit.fitHeight
                           )
                       ),
                     ),
                     SizedBox(height: 40.0),
                     ListTile(
                       leading: Icon(Icons.group_sharp),
                       title: Text('My '+userType+'s'),
                       onTap: () {
                         Navigator.push(
                             context,
                             MaterialPageRoute(builder: (context) => MyFriends(uid: user.userId,userType:userType))
                         );
                       },
                     ),
                     ListTile(
                       leading: Icon(Icons.account_box),
                       title: Text('My Profile'),
                       onTap: () {
                         Navigator.push(
                             context,
                             MaterialPageRoute(builder: (context) => MyProfile())
                         );
                       },
                     ),
                     ListTile(
                       leading: Icon(Icons.logout),
                       title: Text('Log out'),
                       onTap: () async {
                         await _auth.signout();
                       },
                     ),
                   ],
                 ),
               ),
               backgroundColor: Colors.grey[200],
               body: UserList(userType: userType, uid:user.userId),
             );
           }else{
             return Loading();
           }
         }
    );
  }
}

