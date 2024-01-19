import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("User")
        .doc(id)
        .set(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getUserDetails() async {
    return await FirebaseFirestore.instance.collection("User").snapshots();
  }

  Future<Map<String, dynamic>?> getUserDetailsById(String userId) async {
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection("User").doc(userId).get();

    return documentSnapshot.exists
        ? documentSnapshot.data() as Map<String, dynamic>?
        : null;
  }

  Future<void> updateUserDetails(
      String userId, Map<String, dynamic> updatedData) async {
    try {
      await FirebaseFirestore.instance
          .collection("User")
          .doc(userId)
          .update(updatedData);
    } catch (e) {
      print("Error updating user details by ID: $e");
    }
  }

  Future<void> deleteUserById(String userId) async {
    try {
      await FirebaseFirestore.instance.collection("User").doc(userId).delete();
    } catch (e) {
      print("Error deleting user by ID: $e");
    }
  }
}
