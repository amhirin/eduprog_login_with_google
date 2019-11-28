import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:eduprog_login_with_google/util/screen_util.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{

  @override
  void initState() {
    super.initState();
  }

  Future <void> _signOut(){
    _auth.signOut().then((response){
      _googleSignIn.signOut().then((response2){
        print(response2);
      });
    });
  }

  Future<FirebaseUser> _signInGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    return user;
  }


  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;
    final Function hp = Screen(MediaQuery.of(context).size).hp;
    return Scaffold(
      body: SafeArea(
          child: Stack(
            children: <Widget>[
              Container(
                width: wp(100),
                height: hp(100),
                color:  Colors.lightBlue,
              ),
              ListView(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.symmetric(horizontal: wp(8.0), vertical: hp(0.5)),
                children: <Widget>[
                  SizedBox(height: hp(7.0)),
                  Container(
                    width: wp(80.0),
                    height: hp(60.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: AssetImage(
                            'assets/logo-eduprog.png'
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: hp(5.0)),
                  Material(
                    borderRadius: BorderRadius.circular(5),
                    child: InkWell(
                      splashColor: Colors.grey,
                      onTap: (){

                        _signInGoogle().then((user){
                          print("Login dengan google berhasil");
                          String uEmail = user.email;
                          String uDisplayName = user.displayName;
                          String uPhotor = user.photoUrl;
                          //. gunakan informasi tersebut untuk register / bantuan sign-in ke app anda

                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5)
                        ),
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: Row(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0),),
                            Image(image: AssetImage('assets/google_200x200.png',),height: 40, width: 40,),
                            Padding(padding: EdgeInsets.fromLTRB(30, 0, 0, 0),),
                            Text('Sign in with Google', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),)
                          ],
                        ),
                      ),
                    ),

                  )


                ],
              ),
            ],
          )
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
  }

}