import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moiverecommend/SelectPage.dart';
class LoginPage extends StatelessWidget {
  // 구글 로그인을 위한 객체
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  //파이어베이스 인증 정보
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black26,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                  'Movie Recommend',
                  style: GoogleFonts.passeroOne(
                      fontSize: 50.0).apply(color: Colors.white)
              ),
              Text(
                  'Service',
                  style: GoogleFonts.passeroOne(
                      fontSize: 50.0).apply(color: Colors.white)
              ),
              SignInButton(
                Buttons.Google,
                onPressed: () {
                  handelSinIn().then((user){
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SelectPage(user)));
                  });
                },
              )
            ],
          ),
        )
    );
  }
  // 구글 로그인을 수행하고 FirebaseUser를 반환
  Future<FirebaseUser> handelSinIn() async{
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    // 구글 로그인으로 인증된 정보를 기반으로 FIrebaseUser 객체를 구성
    FirebaseUser user = (await auth.signInWithCredential(
        GoogleAuthProvider.getCredential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken)))
        .user;
    return user;
  }}
