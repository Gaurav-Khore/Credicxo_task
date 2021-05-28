import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:musixmatch/apibloc.dart';
import 'package:musixmatch/screens/tracklyrics.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var apibloc = ApiBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MusixMatch"),
      ),
      body: StreamBuilder(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, snap) {
          apibloc.eventsink.add(ApiAction.Tracklist);

          if (!snap.hasData) {
            return Text("No data");
          }
          if ("${snap.data}" == "ConnectivityResult.none") {
            return Center(child: Text("No Internet Connection"));
          }
          apibloc.eventsink.add(ApiAction.Tracklist);
          return StreamBuilder(
            stream: apibloc.apistream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.data == "ConnectivityResult.none") {
                return Text("No Internet Connection");
              } else {
                return Container(
                  child: ListView.builder(
                      itemCount:
                          snapshot.data['message']['body']['track_list'].length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            shape: Border(
                                bottom: BorderSide(
                                    color: Colors.black, width: 2.5)),
                            elevation: 20.0,
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TrackLyrics(
                                            id: "${snapshot.data['message']['body']['track_list'][index]['track']['track_id']}")));
                              },
                              minVerticalPadding: 15.0,
                              leading: Icon(
                                Icons.library_music,
                                size: 30.0,
                              ),
                              minLeadingWidth: 20,
                              trailing: Text(
                                  "${snapshot.data['message']['body']['track_list'][index]['track']['artist_name']}"),
                              title: Text(
                                  "${snapshot.data['message']['body']['track_list'][index]['track']['track_name']}"),
                              subtitle: Text(
                                  "${snapshot.data['message']['body']['track_list'][index]['track']['album_name']}"),
                              horizontalTitleGap: 5.0,
                            ),
                          ),
                        );
                      }),
                );
              }
            },
          );
        },
      ),
    );
  }
}
