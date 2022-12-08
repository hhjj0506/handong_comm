import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:handong_comm/Home.dart';
import 'package:handong_comm/firebase_options.dart';
import 'package:username_gen/username_gen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late UserCredential user;
  bool exist = false;

  Future<bool> checkIfDocExists(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(id)
          .get()
          .then((doc) {
        exist = doc.exists;
      });
      return exist;
    } catch (e) {
      // If any error
      return false;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
            clientId: DefaultFirebaseOptions.currentPlatform.iosClientId)
        .signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> googleLogin() async {
    user = await signInWithGoogle();
    bool check = await checkIfDocExists(user.user!.uid);
    print(check);
    final nickname = UsernameGen().generate(); // generate random username

    if (!check) {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(user.user!.uid)
          .set(<String, dynamic>{
        'email': user.user!.email,
        'name': FirebaseAuth.instance.currentUser!.displayName,
        'nickname': nickname,
        'message': '',
        'uid': user.user!.uid,
        'photo': user.user!.photoURL,
        'dead': 0,
        'bench': 0,
        'squat': 0,
        'stu_num': 0,
        'total': 0,
        'year': 20,
        'major': 'GLS',
        'sex': 'M',
      });
      user.user?.updateDisplayName(nickname);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 160.0),
            Column(
              children: <Widget>[
                const Text(
                  'Strong Handong',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 120.0),
            OverflowBar(
              alignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  onPressed: () async {
                    await googleLogin();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Home()));
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red)),
                  child: const Text(
                    'Google Signin',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
