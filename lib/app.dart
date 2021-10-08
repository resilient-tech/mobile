import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:frappe_app/lifecycle_manager.dart';
import 'package:frappe_app/model/config.dart';
import 'package:frappe_app/services/connectivity_service.dart';
import 'package:frappe_app/utils/enums.dart';
import 'package:frappe_app/views/home_view.dart';
import 'package:frappe_app/views/login/login_view.dart';
import 'package:frappe_app/widgets/unfocus_wrapper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FrappeApp extends StatefulWidget {
  @override
  _FrappeAppState createState() => _FrappeAppState();
}

class _FrappeAppState extends State<FrappeApp> {
  final config = Config();
  bool _isLoggedIn = false;
  bool _isLoaded = false;

  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }

  void _checkIfLoggedIn() {
    setState(() {
      _isLoggedIn = config.isLoggedIn;
      _isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      textTheme: GoogleFonts.interTextTheme(
        Theme.of(context).textTheme.apply(
            // fontSizeFactor: 0.7,
            ),
      ),
    );

    return Portal(
      child: LifeCycleManager(
        child: StreamProvider<ConnectivityStatus>(
          initialData: ConnectivityStatus.offline,
          create: (context) =>
              ConnectivityService().connectionStatusController.stream,
          child: MaterialApp(
            builder: EasyLoading.init(),
            debugShowCheckedModeBanner: false,
            title: 'Frappe',
            theme: theme,
            home: UnFocusWrapper(
              child: Scaffold(
                body: _isLoaded
                    ? _isLoggedIn
                        ? HomeView()
                        : Login()
                    : Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
