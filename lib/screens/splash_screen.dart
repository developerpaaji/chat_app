import 'package:chat_app/controllers/user_controller.dart';
import 'package:chat_app/widgets/login_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onesignal/onesignal.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoggedIn;
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, statusBarBrightness: Brightness.dark));
    UserController.isLoggedIn().then((val) {
      setState(() {
        isLoggedIn = val;
      });
      if (isLoggedIn) {
        Navigator.of(context).pushNamed('/main');
      }
    });
    WidgetsBinding.instance
        .addObserver(LifecycleEventHandler(resumeCallBack: () async {
      print("Resume");
      UserController.updateUser(true);
    }, suspendingCallBack: () async {
      print("Stopped");
      UserController.updateUser(false);
    }));
    OneSignal.shared.init("48eaffb3-f899-4b01-8de5-c60029af39dc");
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);
  }

  @override
  Widget build(BuildContext context) {
    double imageSize = MediaQuery.of(context).size.width / 3;
    return Scaffold(
      body: Center(
        child: Image.asset(
          "images/logo.png",
          width: imageSize,
          height: imageSize,
          fit: BoxFit.cover,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            isLoggedIn == null
                ? CircularProgressIndicator()
                : !isLoggedIn
                    ? LoginButton("Continue with Facebook",
                        color: Color(0xff3b5998),
                        onPressed: initiateFacebookLogin,
                        leading: Image.network(
                          "http://www.logospng.com/images/16/social-facebook-1489-1488-1494-1500-1497-1491-1505-1493-1499-1504-1493-1514-1508-1512-1505-1493-1501-1491-1497-1490-1497-1496-1500-1497-buzzlead-16424.png",
                          color: Colors.white,
                          width: 24.0,
                          height: 24.0,
                        ))
                    : Container(
                        width: 0.0,
                        height: 0.0,
                      ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                "By continuing, You agree to our Private Policy.",
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }

  void initiateFacebookLogin() async {
    var facebookLogin = FacebookLogin();
    var result = await facebookLogin
        .logInWithReadPermissions(['email', 'public_profile']);
    switch (result.status) {
      case FacebookLoginStatus.error:
        print("Error");
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        break;
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final AuthCredential credential =
            FacebookAuthProvider.getCredential(accessToken: token);
        print("Success");
        final AuthResult authResult =
            await FirebaseAuth.instance.signInWithCredential(credential);
        FirebaseUser user = authResult.user;
        print("User $user");
        setState(() {
          isLoggedIn = true;
        });
        await UserController.updateUser(true);
        if (user != null) {
          Navigator.of(context).pushNamed('/main');
        }
        break;
    }
  }
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  LifecycleEventHandler({this.resumeCallBack, this.suspendingCallBack});

  final Function resumeCallBack;
  final Function suspendingCallBack;

//  @override
//  Future<bool> didPopRoute()

//  @override
//  void didHaveMemoryPressure()

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        await suspendingCallBack();
        break;
      case AppLifecycleState.resumed:
        await resumeCallBack();
        break;
      default:
        return;
    }
  }

//  @override
//  void didChangeLocale(Locale locale)

//  @override
//  void didChangeTextScaleFactor()

//  @override
//  void didChangeMetrics();

//  @override
//  Future<bool> didPushRoute(String route)
}
