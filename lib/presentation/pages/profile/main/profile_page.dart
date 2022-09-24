import 'package:flutter/material.dart';

import 'components/profile_setting_panel.dart';
import 'components/profile_user_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: const [
        ProfileUserCard(),
        Expanded(child: ProfileSettingPanel()),
      ],
    );
  }
}
