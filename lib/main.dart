import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:launchpad/pages/auth_page.dart';
import 'package:launchpad/pages/tab_bar_screen.dart';
import 'package:launchpad/pages/landing_page.dart';
import 'package:launchpad/pages/user_profile.page.dart';
import 'package:launchpad/services/app_comments_service.dart';
import 'package:launchpad/services/auth_service.dart';
import 'package:launchpad/services/feed_service.dart';
import 'package:launchpad/services/platform_services.dart';
import 'package:launchpad/styles/app_styles.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(LaunchpadApp());
}

class LaunchpadApp extends StatelessWidget {
  LaunchpadApp({super.key});

  final bool isMobileApp = PlatformServices.isMobileApp;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthService(),
        ),
        ChangeNotifierProvider.value(
          value: FeedService(),
        ),
        ChangeNotifierProvider(create: (context) => AppCommentsService()),
      ],
      child: Consumer<AuthService>(
        builder: (ctx, auth, _) => GetMaterialApp(
          title: 'Launchpad',
          theme: ThemeData(brightness: Brightness.dark),
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],

          supportedLocales: const [
            Locale('en'),
            Locale('es'),
            Locale('ar'),
            Locale('de'),
            Locale('fr'),
            Locale('hi'),
            Locale('in'),
          ],
          home: auth.isAuth
              ? const TabBarScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: AppStyles.actionButtonColor),
                            )
                          : const LandingPage()),
          // initialRoute: '/',
          routes: {
            // '/': (context) => LandingPage(),

            // When navigating to the "/" route, build the FirstScreen widget.

            // When navigating to the "/second" route, build the SecondScreen widget.
            '/auth': (context) => AuthenticationPage(
                  isWeb: !PlatformServices.isWebMobile,
                  isSignUp: true,
                  onAuthCancel: () {
                    Navigator.of(context).popUntil(ModalRoute.withName('/'));
                  },
                ),
            '/home': (context) => TabBarScreen(),

            '/user_profile': (context) => UserProfile(),
          },
        ),
      ),
    );
  }
}

// class LoggedOutScreen extends StatefulWidget {
//   const LoggedOutScreen({super.key});

//   @override
//   State<LoggedOutScreen> createState() => _LoggedOutScreenState();
// }

// class _LoggedOutScreenState extends State<LoggedOutScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(padding: EdgeInsets.only(top: 20.0), child: LandingPage());
//   }
// }
