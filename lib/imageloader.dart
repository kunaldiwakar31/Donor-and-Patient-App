import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class ImageCapture extends StatefulWidget {
  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  File _image;
  final picker = ImagePicker();

  Future<void> getImageCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  Future<void> getImageGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _cropImage() async{
    File cropped=await ImageCropper.cropImage(
      sourcePath: _image.path,
    );
    setState(() {
      _image=cropped ?? _image;
    });
  }

  void clear(){
    setState(() {
      _image=null;
    });
  }

  Future uploadToFirebase(BuildContext context) async{
    String fileName = _image.path.split('/').last;

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images/${fileName}');
    await ref.putFile(_image).whenComplete(() async => {
      await ref.getDownloadURL().then((value) => {
        print('url:'+value)
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(
                icon: Icon(Icons.photo_camera),
                onPressed: getImageCamera,
            ),
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: getImageGallery,
            )
          ],
        ),
      ),
      body: ListView(
        children: [
          if(_image!=null) ...[
            Image.file(_image),
            Row(
              children: [
                FlatButton(onPressed: _cropImage, child: Icon(Icons.crop)),
                FlatButton(onPressed: clear, child: Icon(Icons.refresh))
              ],
            ),
            RaisedButton(
              color: Colors.red[400],
              child: Text(
                'Upload Image',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold
                ),
              ),
              onPressed:() {
                uploadToFirebase(context);
              }
            )
          ]
        ],
      ),
    );
  }

}
