import 'package:flutter/material.dart';
import 'package:message_app/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:message_app/auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: const Body(),
    );
  }
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // String name = '';
  // TextEditingController controller = TextEditingController();
  late User user;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    signOutGoogle();
  }

  void login() {
    // name = controller.text;
    // String userDisplayName = 'Anonymous';

    signInWithGoogle().then((user) => {
          this.user = user,
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MyHomePage(user)))
        });
    setState(() {
      isLoggedIn = true;
    });
  }

  Widget googleLoginButton() {
    return OutlinedButton(
      onPressed: login,
      autofocus: true,
      style: OutlinedButton.styleFrom(
          foregroundColor: Colors.grey[600],
          backgroundColor: Colors.grey[50],
          fixedSize: const Size(240, 46),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          textStyle:
              const TextStyle(fontSize: 18, fontStyle: FontStyle.normal)),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image(image: AssetImage('images/google_logo.png')),
          Text('Sign In with Google'),
        ],
      ),
    );
  }

  void logout() {
    signOutGoogle();
    setState(() {
      isLoggedIn = false;
    });
  }

  Widget googleLogoutButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          onPressed: login,
          autofocus: true,
          style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green[400],
              fixedSize: const Size(120, 46),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(21),
                      topLeft: Radius.circular(21),
                      topRight: Radius.circular(0),
                      bottomRight: Radius.circular(0))),
              padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
              textStyle:
                  const TextStyle(fontSize: 18, fontStyle: FontStyle.normal)),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.login),
              Text('Login'),
            ],
          ),
        ),
        OutlinedButton(
          onPressed: logout,
          autofocus: true,
          style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              fixedSize: const Size(120, 46),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0),
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(21),
                      bottomRight: Radius.circular(21))),
              padding: const EdgeInsets.fromLTRB(5, 10, 10, 10),
              textStyle:
                  const TextStyle(fontSize: 18, fontStyle: FontStyle.normal)),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.logout),
              Text('Logout'),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: isLoggedIn ? googleLogoutButton() : googleLoginButton(),
    );
  }
}
