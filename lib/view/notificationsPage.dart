import 'package:Runbhumi/services/NotificationService.dart';
import 'package:Runbhumi/view/otherUserProfile.dart';
import 'package:Runbhumi/widget/widgets.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  Stream notification;

  void initState() {
    super.initState();
    getUserNotifications();
  }

  getUserNotifications() async {
    NotificationServices().getNotification().then((snapshots) {
      setState(() {
        notification = snapshots;
        print("we got the data");
      });
    });
  }

  Widget notificationList() {
    return StreamBuilder(
      stream: notification,
      builder: (context, asyncSnapshot) {
        print("Working " + asyncSnapshot.hasData.toString());
        return asyncSnapshot.hasData
            ? ListView.builder(
                itemCount: asyncSnapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var data = asyncSnapshot.data.documents[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 4.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtherUserProfile(
                              // userID:
                              //     Constants.prefs.getString('userId'),
                              // TODO: I need this feild in DB
                              userID: data.get('userId'),
                            ),
                          ),
                        );
                      },
                      child: Card(
                        shadowColor: Color(0x44393e46),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        elevation: 20,
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              child: Image(
                                  height: 75,
                                  image:
                                      NetworkImage(data.get("profileImage"))),
                            ),
                            Text(data.get('name'),
                                style: Theme.of(context).textTheme.headline5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SmallButton(
                                  myText: "decline",
                                  myColor: Theme.of(context).accentColor,
                                  //decline funtionality
                                  onPressed: () {},
                                ),
                                SmallButton(
                                  myText: "accept",
                                  myColor: Theme.of(context).primaryColor,
                                  //aceept friend funtionality
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : Loader();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: buildTitle(context, "Notifications"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            child: Stack(
              children: <Widget>[
                notificationList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
