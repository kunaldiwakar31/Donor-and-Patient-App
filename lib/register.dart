import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'auth.dart';
import 'loading.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth=AuthService();
  final _formKey =GlobalKey<FormState>();
  String name='';
  String emailId='';
  String password='';
  String phone='';
  bool loading=false;
  String error='';
  String userType='';
  String address='';

  @override
  Widget build(BuildContext context) {
    return loading? Loading() : Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[600],
        title: Text('Register to Donate'),
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
                  hintText: 'Name',
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white,width: 2.0)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlueAccent,width: 2.0)
                  ),
                ),
                validator: (val) => val.isEmpty ? 'Enter the name !!' :null,
                onChanged: (val){
                  setState(() {
                    name=val;
                  });
                },
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Email Id',
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
                  hintText: 'Phone Number',
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white,width: 2.0)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlueAccent,width: 2.0)
                  ),
                ),
                validator: (val) => val.isEmpty ? 'Enter the phone number !!' :null,
                onChanged: (val){
                  setState(() {
                    phone=val;
                  });
                },
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Address',
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white,width: 2.0)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlueAccent,width: 2.0)
                  ),
                ),
                validator: (val) => val.isEmpty ? 'Enter the Address!!' :null,
                onChanged: (val){
                  setState(() {
                    address=val;
                  });
                },
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Password',
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
              Row(
                children: [
                  Text(
                    '$userType',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(width: 20.0),
                  DropdownButton(
                    items: [
                      DropdownMenuItem<String>(
                          value: '1',
                          child: Center(
                              child: Text('Patient')
                          )
                      ),
                      DropdownMenuItem<String>(
                          value: '2',
                          child: Center(
                              child: Text('Donor')
                          )
                      ),
                    ],
                    onChanged: (value)=>{
                      setState((){
                        if(value=='1'){
                          userType='Patient';
                        }else if(value=='2'){
                          userType='Donor';
                        }
                      })
                    },
                    hint: Text('Select type of user'),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                onPressed: () async{
                  if(_formKey.currentState.validate()){
                    loading=true;
                    dynamic result=await _auth.registerWithEmailAndPassword(emailId,password,name,phone,userType,address);
                    if(result==null){
                      setState(() {
                        error='Please try Again';
                        loading=false;
                      });
                    }
                  }
                },
                color: Colors.red[600],
                child: Text(
                  'Register',
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
                      TextSpan(text: 'Already Registered ? '),
                      TextSpan(
                          text: 'Login',
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
              Text(error,style: TextStyle(color: Colors.red[400],fontSize: 14.0))
            ],
          ),
        ),
      ),
    );
  }
}
