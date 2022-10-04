import 'package:bke/presentation/theme/app_typography.dart';
import 'package:flutter/material.dart';

import '../../../routes/route_name.dart';
import '../../../theme/app_color.dart';

class ResultToeicPage extends StatelessWidget {
  const ResultToeicPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final finalScore = ModalRoute.of(context)?.settings.arguments as int;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Score ' '$finalScore',
              style: AppTypography.body,
              textAlign: TextAlign.center,
            ), //Text
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed(RouteName.main),
              child: Container(
                color: AppColor.primary,
                padding: const EdgeInsets.all(14),
                child: Text(
                  'Return home',
                  style: AppTypography.body,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
