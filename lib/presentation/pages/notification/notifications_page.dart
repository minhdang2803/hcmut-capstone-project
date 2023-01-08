import 'package:flutter/material.dart';

import '../../widgets/custom_app_bar.dart';
import 'components/notifications_content.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBody(context),
          const BkEAppBar(label: 'THÔNG BÁO'),
        ],
      ),
    );
  }

  _buildBody(BuildContext context) {
    return const NotificationsContent();
  }
}
