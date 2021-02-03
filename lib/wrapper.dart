import 'package:Donate/CustomUser.dart';
import 'package:Donate/authenticate.dart';
import 'package:Donate/homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user=Provider.of<CustomUser>(context);

    if(user==null){
      return Authenticate();
    }else{
      return Home();
    }
  }
}
