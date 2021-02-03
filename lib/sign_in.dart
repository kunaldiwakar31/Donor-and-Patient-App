import 'package:Donate/CustomUser.dart';
import 'package:Donate/loading.dart';
import 'file:///C:/Users/kunal/StudioProjects/Donate/lib/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth=AuthService();
  final _formKey =GlobalKey<FormState>();

  String emailId='';
  String password='';
  String error='';
  bool loading=false;

  @override
  Widget build(BuildContext context) {
    return loading? Loading() : Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[600],
        title: Text('Sign in to Donate'),
      ),
      backgroundColor: Colors.yellow[200],
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 50.0,vertical: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter the email',
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white,width: 2.0)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlueAccent,width: 2.0)
                  ),
                ),
                validator: (val) => val.isEmpty ? 'Enter the email !!' :null,
                onChanged: (val){
                  setState(() {
                    emailId=val;
                  });
                },
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter the password',
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white,width: 2.0)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlueAccent,width: 2.0)
                  ),
                ),
                validator: (val) => val.length<6 ? 'Password must be atleast of 6 character !!' :null,
                obscureText: true,
                onChanged: (val){
                  setState(() {
                    password=val;
                  });
                },
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                  onPressed: () async{
                    if(_formKey.currentState.validate()){
                      setState(() {
                        loading=true;
                      });
                      dynamic result=await _auth.signInWithEmailAndPassword(emailId, password);
                      if(result==null){
                        setState(() {
                          error='Please try again with valid credentials';
                          loading =false;
                        });
                      }
                    }
                  },
                color: Colors.red[600],
                child: Text(
                  'Sign In',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              RichText(
                  text: TextSpan(
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0
                      ),
                      children: <TextSpan>[
                        TextSpan(text: 'Not Registered ? '),
                        TextSpan(
                            text: 'Register',
                            style: TextStyle(
                                color: Colors.lightBlueAccent,
                                fontSize: 16.0
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                widget.toggleView();
                              }),
                      ]
                  )
              ),
              SizedBox(height: 10.0),
              Text(error,style: TextStyle(color: Colors.red[400],fontSize: 14.0)),
            ],
          ),
        ),
      ),
    );
  }
}
