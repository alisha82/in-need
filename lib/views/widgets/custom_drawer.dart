import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inneed_practice/views/auth/login_screen.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  File? _imageFile;
  String _fullName = 'Loading...';
  String _email = '';
  String _phone = 'Not available';
  String _location = 'Lahore, Pakistan';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Firebase aur Firestore se user ka data fetch karne ka method
  void _loadUserData() async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      setState(() {
        _email = currentUser.email ?? '';
        _phone = currentUser.phoneNumber ?? 'Not available';
      });

      try {
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists && userDoc.data() != null) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          setState(() {
            _fullName = data['fullName'] ?? currentUser.displayName ?? 'User';
            if (data['phone'] != null && data['phone'].toString().isNotEmpty) {
              _phone = data['phone'];
            }
          });
        } else {
          setState(() {
            _fullName = currentUser.displayName ?? 'User';
          });
        }
      } catch (e) {
        setState(() {
          _fullName = currentUser.displayName ?? 'User';
        });
      }
    } else {
      setState(() {
        _fullName = 'Guest User';
        _email = 'Not logged in';
        _phone = '';
      });
    }
  }

  // Gallery se image select karne ke liye
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;

    return Drawer(
      backgroundColor: const Color(0xFFFFFBFB),
      child: Column(
        children: [
          // Top Red Header Section with Avatar & Camera Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 24, left: 16, right: 16),
            decoration: const BoxDecoration(
              color: Color(0xFFE53935), // Red Theme Color
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.white,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : (currentUser?.photoURL != null
                          ? NetworkImage(currentUser!.photoURL!)
                          : null) as ImageProvider?,
                      child: (_imageFile == null && currentUser?.photoURL == null)
                          ? const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey,
                      )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade300, width: 1.5),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 16,
                            color: Color(0xFFE53935),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _fullName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _email,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          // Body Details List (Phone, Email, Current Location)
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              children: [
                ListTile(
                  leading: const Icon(Icons.phone_outlined, color: Color(0xFFE53935)),
                  title: const Text(
                    'Phone',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  subtitle: Text(
                    _phone,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, size: 18, color: Colors.black54),
                    onPressed: () {
                      // Edit phone action
                    },
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.email_outlined, color: Color(0xFFE53935)),
                  title: const Text(
                    'Email',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  subtitle: Text(
                    _email.isNotEmpty ? _email : 'Not available',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.location_on_outlined, color: Color(0xFFE53935)),
                  title: const Text(
                    'Current Location',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  subtitle: Text(
                    _location,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Sign Out Section
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Color(0xFFE53935)),
              title: const Text(
                'Sign Out',
                style: TextStyle(
                  color: Color(0xFFE53935),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              onTap: () async {
                await _auth.signOut();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                        (route) => false,
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}