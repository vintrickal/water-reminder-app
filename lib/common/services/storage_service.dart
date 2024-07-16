import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:water_reminder_app/common/models/user_model.dart';

class StorageService {
  // Future<String> generateToken() async {
    // var token;
    // token = await FirebaseMessaging.instance.getToken();
    // return token;
  // }

  Future<void> updateDeviceToken(
      {required String id, required Map<String, dynamic> data}) async {
    FirebaseFirestore.instance
        .collection('user')
        .doc(id)
        .update(data)
        .then((value) => print('New device token generated!'));
  }

  // Get the document count
  getCollectionLength({
    required String collectionName,
    required String keyword,
    required String value,
  }) async {
    final QuerySnapshot qSnap = await FirebaseFirestore.instance
        .collection(collectionName)
        .where(keyword, isEqualTo: value)
        .get();
    final int documentCount = qSnap.docs.length;

    return documentCount;
  }

  Future<void> addUserIntake(
      String collectionName, Map<String, dynamic> items) async {
    FirebaseFirestore.instance
        .collection(collectionName)
        .add(items)
        .then((value) {
      FirebaseFirestore.instance
          .collection(collectionName)
          .doc(value.id)
          .set({'id': value.id}, SetOptions(merge: true));
    });
  }

  Future<String> addUserIntakeGoal(
      String collectionName, Map<String, dynamic> items) async {
    var documentId;

    await FirebaseFirestore.instance
        .collection(collectionName)
        .add(items)
        .then((value) {
      documentId = value.id;
      FirebaseFirestore.instance
          .collection(collectionName)
          .doc(value.id)
          .set({'id': value.id}, SetOptions(merge: true));
    });

    return documentId;
  }

  Future<String> addMonthlyUserIntakeGoal(
      String collectionName, Map<String, dynamic> items) async {
    var documentId;

    await FirebaseFirestore.instance
        .collection(collectionName)
        .add(items)
        .then((value) {
      documentId = value.id;
      FirebaseFirestore.instance
          .collection(collectionName)
          .doc(value.id)
          .set({'id': value.id}, SetOptions(merge: true));
    });
    
    return documentId;
  }

  getWaterInTake(String referenceId) {
    var waterIntakeStream;

    waterIntakeStream = FirebaseFirestore.instance
        .collection('water-intake')
        .where('user_water_intake_id', isEqualTo: referenceId)
        .orderBy('time', descending: true)
        .snapshots();

    return waterIntakeStream;
  }

  Future<bool> checkDataExistence(
      {required String collectionName,
      required String keyword,
      required String value}) async {
    try {
      // Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance.collection(collectionName);

      var doc = await collectionRef.where(keyword, isEqualTo: value).get();
      return doc.docs.length != 0 ? true : false;
    } catch (e) {
      throw e;
    }
  }

  Future<bool> checkMultipleDataExistence({
    required String collectionName,
    required String keyword1,
    required String keyword2,
    required String keyword3,
    required dynamic value1,
    required dynamic value2,
    required dynamic value3,
  }) async {
    try {
      // Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance.collection(collectionName);

      var doc = await collectionRef
          .where(keyword1, isEqualTo: value1)
          .where(keyword2, isEqualTo: value2)
          .where(keyword3, isEqualTo: value3)
          .get();
      return doc.docs.length != 0 ? true : false;
    } catch (e) {
      throw e;
    }
  }

  // Get the document
  Future<dynamic> getCollection({
    required String collectionName,
    required String keyword,
    required dynamic value,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collectionName)
        .where(keyword, isEqualTo: value)
        .get();

    List items = querySnapshot.docs.map((doc) => doc.data()).toList();

    return items;
  }

  Future<String> anonymousSignIn() async {
    var userCredential;
    try {
      await FirebaseAuth.instance.signInAnonymously();
      var user = await FirebaseAuth.instance.currentUser;
      userCredential = user!.uid;

      print("Signed in with temporary account. ${userCredential}");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error.");
      }
    }
    return userCredential;
  }

  Future<void> registerAnonymousUser(UserModel model) async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(model.id)
        .set(model.toJson())
        .then((value) => print('Anonymous user successfully registered!'));
  }

  Future<void> updateUserWaterIntake(
      String id, Map<String, dynamic> userWaterIntakeItems) async {
    final ref =
        await FirebaseFirestore.instance.collection('user-water-intake');

    ref.doc(id).update(userWaterIntakeItems).then(
          (value) => print('DocumentSnapshot successfully updated!'),
        );
  }

  Future<void> updateMonthlyUserWaterIntake(
      String id, Map<String, dynamic> userWaterIntakeItems) async {
    final ref = await FirebaseFirestore.instance
        .collection('monthly-user-water-intake');

    ref.doc(id).update(userWaterIntakeItems).then(
          (value) => print('DocumentSnapshot successfully updated!'),
        );
  }

  Future<void> updateWaterIntake(
      String id, Map<String, dynamic> waterIntakeItems) async {
    final ref = await FirebaseFirestore.instance.collection('water-intake');

    ref.doc(id).update(waterIntakeItems).then(
          (value) => print('DocumentSnapshot successfully updated!'),
        );
  }

  Future<void> updateSelectedCup(
      String id, Map<String, dynamic> cupSelectedItem) async {
    final ref = await FirebaseFirestore.instance.collection('user');

    ref.doc(id).update(cupSelectedItem).then(
          (value) => print('DocumentSnapshot successfully updated!'),
        );
  }

  Future<void> updateUserInfomation(
      String id, Map<String, dynamic> userInformation) async {
    final ref = await FirebaseFirestore.instance.collection('user');

    ref.doc(id).update(userInformation).then(
          (value) => print('DocumentSnapshot successfully updated!'),
        );
  }
}
