import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lifts_app/view_models/profile_view_model.dart';

import 'onboarding/login_screen.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _imageFile;
  final picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      // Upload the image to Firebase Storage
      print('User UID: ${widget.uid}');

      //My storage Bucket at firestore
      Reference storageReference = FirebaseStorage.instance
          .refFromURL('gs://e-hailing-94d2c.appspot.com')
          .child('profile_images/${widget.uid}');

      print('Storage reference path: ${storageReference.fullPath}');

      UploadTask uploadTask = storageReference.putFile(_imageFile!);
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        print('Upload progress: ${snapshot.bytesTransferred}/${snapshot.totalBytes}');
      }, onError: (error) {
        print('Error uploading image: $error');
      });
      await uploadTask;

      // Get the download URL and update the photoURL field in Firestore
      String downloadURL = await storageReference.getDownloadURL();
      FirebaseFirestore.instance.collection('users').doc(widget.uid).update({
        'photoURL': downloadURL,
      });
    }
  }

  Future<void> _deleteImage() async {
    // Delete the image from Firebase Storage
    FirebaseStorage.instance.ref().child('profile_images/${widget.uid}').delete();

    // Update the photoURL field in Firestore to null
    FirebaseFirestore.instance.collection('users').doc(widget.uid).update({
      'photoURL': null,
    });
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Image'),
          content: Text('Are you sure you want to delete the image?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteImage();
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text('Profile'),
        // ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('users').doc(widget.uid).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
      
            var userData = snapshot.data!.data() as Map<String, dynamic>;
      
            return Center(
              child: ListView(
                padding: EdgeInsets.all(20),
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: userData['photoURL'] != null
                              ? NetworkImage(userData['photoURL'])
                              : _imageFile != null
                              ? FileImage(_imageFile!)
                              : AssetImage('assets/icons/camera.png') as ImageProvider,
                          child: _imageFile == null && userData['photoURL'] == null
                              ? Icon(Icons.person, size: 50)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: _uploadImage,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.edit,
                                color: Colors.blue,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        if (userData['photoURL'] != null)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () => _showDeleteDialog(context),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    title: Text(
                      'Name:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${userData['firstName']} ${userData['lastName']}'),
                  ),
                  ListTile(
                    title: Text(
                      'Email:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(userData['email'] ?? 'N/A'),
                  ),
                  SizedBox(height: 20),
                  Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.blue, // Use your primary color here
                    child: MaterialButton(
                      onPressed: () {
                        _showLogoutDialog(context,widget.uid);
                      },
                      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      minWidth: MediaQuery.of(context).size.width,
                      child: Text(
                        "Logout",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }



  void _showLogoutDialog(BuildContext context,String uid) {
    ProfileViewModel model = ProfileViewModel(uid);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                model.signOut();
                // FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => login_screen()),
                ); // Logout
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }


}
