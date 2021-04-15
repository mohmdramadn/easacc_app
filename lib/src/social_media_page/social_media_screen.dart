import 'package:easacc_test_app/src/custom_widgets/mycard.dart';
import 'package:easacc_test_app/src/setting_page/setting_screen.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:easacc_test_app/src/web_view_page/web_page.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert' show json;
import "package:http/http.dart" as http;


class SocialMediaScreen extends StatefulWidget {
  static final String pageId = 'social';

  @override
  _SocialMediaScreenState createState() => _SocialMediaScreenState();
}

class _SocialMediaScreenState extends State<SocialMediaScreen> {

    static final facebookLogin = FacebookLogin();
    GoogleSignIn _googleSignIn = GoogleSignIn(
      // Optional clientId
      // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
      scopes: <String>[
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    GoogleSignInAccount _currentUser;
    String _contactText = '';

    String _message='Facebook Login';

    Future<Null> _login() async {
      final FacebookLoginResult result =
      await facebookLogin.logInWithReadPermissions(['email']);

      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          final FacebookAccessToken accessToken = result.accessToken;
          _showMessage('''
         Logged in!
         
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');
          break;
        case FacebookLoginStatus.cancelledByUser:
          _showMessage('Login cancelled by the user.');
          break;
        case FacebookLoginStatus.error:
          _showMessage('Something went wrong with the login process.\n'
              'Here\'s the error Facebook gave us: ${result.errorMessage}');
          break;
      }}

      void _showMessage(String message) {
      setState(() {
      _message = message;
      });}

      @override
  void initState() {
        super.initState();
        _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
        setState(() {
        _currentUser = account;
        });
        if (_currentUser != null) {
        _handleGetContact(_currentUser);
        }
        });
        _googleSignIn.signInSilently();
  }

    Future<void> _handleGetContact(GoogleSignInAccount user) async {
      setState(() {
        _contactText = "Loading contact info...";
      });
      final http.Response response = await http.get(
        Uri.parse('https://people.googleapis.com/v1/people/me/connections'
            '?requestMask.includeField=person.names'),
        headers: await user.authHeaders,
      );
      if (response.statusCode != 200) {
        setState(() {
          _contactText = "People API gave a ${response.statusCode} "
              "response. Check logs for details.";
        });
        print('People API ${response.statusCode} response: ${response.body}');
        return;
      }
      final Map<String, dynamic> data = json.decode(response.body);
      final String namedContact = _pickFirstNamedContact(data);
      setState(() {
      if (namedContact != null) {
      _contactText = "I see you know $namedContact!";
      } else {
      _contactText = "No contacts to display.";
      }
      });
    }

    String _pickFirstNamedContact(Map<String, dynamic> data) {
      final List<dynamic>  connections = data['connections'];
      final Map<String, dynamic>  contact = connections?.firstWhere(
      (dynamic contact) => contact['names'] != null,
      orElse: () => null,
      );
      if (contact != null) {
      final Map<String, dynamic>  name = contact['names'].firstWhere(
      (dynamic name) => name['displayName'] != null,
      orElse: () => null,
      );
      if (name != null) {
      return name['displayName'];
      }
      }
      return null;
    }

    Future<void> _handleSignIn() async {
      try {
        await _googleSignIn.signIn();
      } catch (error) {
        print(error);
      }
    }

    Future<void> _handleSignOut() => _googleSignIn.disconnect();

    Widget _buildBody() {
      GoogleSignInAccount user = _currentUser;
      if (user != null) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ListTile(
              leading: GoogleUserCircleAvatar(
                identity: user,
              ),
              title: Text(user.displayName ?? ''),
              subtitle: Text(user.email),
            ),
            const Text("Signed in successfully."),
            Text(_contactText),
            ElevatedButton(
              child: const Text('SIGN OUT'),
              onPressed: _handleSignOut,
            ),
            ElevatedButton(
              child: const Text('REFRESH'),
              onPressed: () => _handleGetContact(user),
            ),
          ],
        );
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const Text("You are not currently signed in."),
            ElevatedButton(
              child: const Text('SIGN IN'),
              onPressed: _handleSignIn,
            ),
          ],
        );
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              child: Icon(Icons.settings),
              onTap: () {
                setState(() {
                  Navigator.pushNamed(context, SettingScreen.pageId);
                });
              },
            ),
          ),
        ],
        title: Text('Social Media Login'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bk5.jpeg"), fit: BoxFit.cover),
        ),
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 50),
          color: Colors.white30,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: (){
                  setState(() {
                    _login();
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyCard(
                    cardColor: Colors.blueAccent,
                    cardName: 'Facebook Login',
                    cardImage: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Image(
                        image: AssetImage('assets/images/fb2.png'),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  _handleSignIn();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyCard(
                    cardColor: Colors.white54,
                    cardName: 'Google Login',
                    cardImage: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Image(
                        image: AssetImage('assets/images/ggl.png'),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      Navigator.pushNamed(context, ShowWebScreen.pageId);
                    });
                  },
                  child: Container(
                    width: 700,
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: ListTile(
                            title: Text('Go to Web Page',style: TextStyle(fontSize: 25),),
                            trailing: Icon(Icons.arrow_forward),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
