import 'package:Donate/userInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  final String uid;
  final String userType;

  DatabaseService({this.uid,this.userType});

  CollectionReference userReference=FirebaseFirestore.instance.collection('Users');


  Future updateUserData(String name,String email,String userType,String phone, String address) async {
    DocumentReference documentReference=userReference.doc(uid);
    return await documentReference.set({
      'name':name,
      'email':email,
      'userType':userType,
      'phone':phone,
      'address':address,
      'uid':uid,
      'requestSent':[],
      'requestRecieved':[],
      'friends':[]
    });
  }

  Future sendRequest(String ruid) async {

    var docRef1 = userReference.doc(uid);
    docRef1.update({
      'requestSent':FieldValue.arrayUnion([ruid])
    });

    var docRef = userReference.doc(ruid);
    docRef.update({
      'requestReceived':FieldValue.arrayUnion([uid])
    });
  }

  Future cancelRequest(String ruid) async {

    var docRef1 = userReference.doc(uid);
    var docSnap1 = await docRef1.get();
    List list1=docSnap1.data()['requestSent'];
    List list2=docSnap1.data()['requestReceived'];

    var docRef2 = userReference.doc(ruid);

    if(list1.contains(ruid)) {
      docRef1.update({
        'requestSent': FieldValue.arrayRemove([ruid])
      });
      docRef2.update({
          'requestReceived': FieldValue.arrayRemove([uid])
        }
      );
    }
    if(list2.contains(ruid)) {
      docRef1.update({
        'requestReceived': FieldValue.arrayRemove([ruid])
      });
      docRef2.update({
        'requestSent': FieldValue.arrayRemove([uid])
      }
      );
    }
  }

  Future acceptRequest(String ruid) async {

    var docRef1 = userReference.doc(uid);

    docRef1.update({
      'requestReceived':FieldValue.arrayRemove([ruid]),
      'friends':FieldValue.arrayUnion([ruid])
    });

    var docRef2 = userReference.doc(ruid);

    docRef2.update({
      'requestSent':FieldValue.arrayRemove([uid]),
      'friends':FieldValue.arrayUnion([uid])
    });
  }
  Future unfriend(String ruid) async {

    var docRef1 = userReference.doc(uid);

    docRef1.update({
      'friends':FieldValue.arrayRemove([ruid])
    });

    var docRef2 = userReference.doc(ruid);

    docRef2.update({
      'friends':FieldValue.arrayRemove([uid])
    });
  }

  List<UserData> _userListfromsnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return UserData(
        name:doc.data()['name'] ?? '',
        email:doc.data()['email'] ?? '',
        phone:doc.data()['phone'] ?? '',
        address:doc.data()['address'] ?? '',
        userType:doc.data()['userType'] ?? '',
        uid:doc.data()['uid'] ?? '',
        requestSent: doc.data()['requestSent'] ?? [],
        requestReceived: doc.data()['requestReceived'] ?? [],
        friends: doc.data()['friends'] ?? []
      );
    }).toList();
  }
  Stream<List<UserData>> get allUserData {
    return userReference.where('userType', isEqualTo:userType).snapshots()
        .map(_userListfromsnapshot);
  }

  Stream<List<UserData>> get friendsData {
    return userReference.where('friends', arrayContains: uid).snapshots()
        .map(_userListfromsnapshot);
  }

  UserData _userDatafromSnapshot(DocumentSnapshot snapshot){

    return UserData(
      name: snapshot.data()['name'],
      email:snapshot.data()['email'],
      phone: snapshot.data()['phone'],
      address:snapshot.data()['address'],
      userType: snapshot.data()['userType'],
        uid:snapshot.data()['uid'],
        requestSent: snapshot.data()['requestSent'] ?? [],
        requestReceived: snapshot.data()['requestReceived'] ?? [],
        friends: snapshot.data()['friends'] ?? []
    );
  }
  Stream<UserData> get currentUserData {
    return userReference.doc(uid).snapshots()
        .map(_userDatafromSnapshot);
  }
}