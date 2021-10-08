import 'package:flutter/material.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/utils/navigation_helper.dart';
import 'package:frappe_app/views/login/login_view.dart';
import 'package:frappe_app/widgets/padded_card_list_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.8,
        title: Text(
          'Profile',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Column(
          children: [
            // PaddedCardListTile(
            //   onTap: () {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context) => QueueList(),
            //       ),
            //     );
            //   },
            //   title: "Queue",
            // ),
            PaddedCardListTile(
              onTap: () async {
                var issueUrl = "https://github.com/frappe/mobile/issues";
                if (await canLaunch(issueUrl)) {
                  await launch(
                    issueUrl,
                  );
                } else {
                  throw 'Could not launch $issueUrl';
                }
              },
              title: "Report an Issue",
            ),
            PaddedCardListTile(
              onTap: () async {
                await clearLoginInfo();
                NavigationHelper.clearAllAndNavigateTo(
                  context: context,
                  page: Login(),
                );
              },
              title: "Logout",
            ),
          ],
        ),
      ),
    );
  }
}
