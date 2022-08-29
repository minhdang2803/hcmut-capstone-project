import 'package:capstone_project_hcmut/utils/shared_preference_wrapper.dart';
import 'package:capstone_project_hcmut/view_models/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);
  static const String routeName = 'SettingScreen';
  static MaterialPage page() {
    return const MaterialPage(
      child: SettingScreen(),
      key: ValueKey(routeName),
      name: routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
            height: size.height,
            width: size.width,
            child: TextButton(
              child: Text('Loggout'),
              onPressed: () async {
                final SharedPreferencesWrapper sharedPreferencesWrapper =
                    SharedPreferencesWrapper.instance;
                await sharedPreferencesWrapper.remove('isLoggedIn');
                Provider.of<AppRouter>(context, listen: false).isLoggedIn =
                    false;
                context.goNamed('root');
              },
            )),
      ),
    );
  }
}
