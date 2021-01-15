import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatelessWidget {
  final CollectionReference _jobsRef =
  FirebaseFirestore.instance.collection("Jobs");

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _jobsRef.orderBy("Date", descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Text("Loading..."),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text("Jobs"),
            backgroundColor: Color(0xff204161),
          ),
          body: ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];

              var date = ds["Date"];
              return Padding(
                padding: EdgeInsets.all(2.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  color: Colors.white70,
                  elevation: 10.0,
                  child: Column(
                    children: [
                      Divider(
                        height: 5.0,
                      ),
                      Text(
                        "${ds["JobTitle"]}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Color(0xff204161)),
                      ),
                      Divider(
                        height: 5.0,
                        thickness: 2.0,
                        color: Color(0xff204161),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${ds["Location"]}",
                              style: TextStyle(color: Color(0xff204161)),
                            ),
                            Text(
                              "${ds["Salary"]}",
                              style: TextStyle(color: Color(0xff204161)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                        EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${TimeAgo.timeAgoSinceDate(date)}",
                              style: TextStyle(color: Color(0xff204161)),
                            ),
                            Text(
                              "${ds["Timing"]}",
                              style: TextStyle(color: Color(0xff204161)),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "${ds["Qualification"]}",
                        style: TextStyle(color: Color(0xff204161)),
                      ),
                      Text(
                        "${ds["Contact"]}",
                        style: TextStyle(color: Color(0xff204161)),
                      ),
                      Text(
                        "${ds["Email"]}",
                        style: TextStyle(color: Color(0xff204161)),
                      ),
                      Divider(
                        height: 10.0,
                        thickness: 0.5,
                        color: Color(0xff2a457f),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 5.0, bottom: 10.0),
                        child: Text(
                          "${ds["Description"]}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                          style: TextStyle(color: Color(0xff204161)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class TimeAgo{
  static String timeAgoSinceDate(String dateString, {bool numericDates = true}) {
    DateTime notificationDate = DateFormat("dd-MM-yyyy h:mma").parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);

    if (difference.inDays > 8) {
      return dateString;
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
}
