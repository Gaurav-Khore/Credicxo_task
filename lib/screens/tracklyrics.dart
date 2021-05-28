import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:musixmatch/apibloc.dart';

class TrackLyrics extends StatefulWidget {
  final id;

  const TrackLyrics({Key key, this.id}) : super(key: key);

  @override
  _TrackLyricsState createState() => _TrackLyricsState();
}

class _TrackLyricsState extends State<TrackLyrics> {
  var trackbloc;
  var lyrics;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      trackbloc = ApiBloc(id: "${widget.id}");
      lyrics = ApiBloc(id: "${widget.id}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lyrics"),
      ),
      body: StreamBuilder(
        initialData: ConnectivityResult.wifi,
        stream: Connectivity().onConnectivityChanged,
        builder: (context, AsyncSnapshot<ConnectivityResult> con) {
          trackbloc.eventsink.add(ApiAction.TrackInfo);
          lyrics.eventsink.add(ApiAction.Lyrics);

          if (!con.hasData) {
            return Text("No data");
          }
          if ("${con.data}" == "ConnectivityResult.none") {
            return Center(child: Text("No Internet Connection"));
          }
          return StreamBuilder(
            stream: trackbloc.apistream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              lyrics.eventsink.add(ApiAction.Lyrics);
              return ListView(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                        Text(
                          "${snapshot.data['message']['body']['track']['track_name']}",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Artist",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                        Text(
                          "${snapshot.data['message']['body']['track']['artist_name']}",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Album Name",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                        Text(
                          "${snapshot.data['message']['body']['track']['album_name']}",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Explicit",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                        Text(
                          snapshot.data['message']['body']['track']
                                      ['explicit'] ==
                                  0
                              ? "False"
                              : "True",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Rating",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                        Text(
                          "${snapshot.data['message']['body']['track']['track_rating']}",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder(
                      stream: lyrics.apistream,
                      builder: (context, snap) {
                        if (!snap.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return Container(
                          padding: EdgeInsets.all(6.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Lyrics:-",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                              Text(
                                "${snap.data['message']['body']['lyrics']['lyrics_body']}",
                                style: TextStyle(fontSize: 20.0),
                              )
                            ],
                          ),
                        );
                      }),
                ],
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    trackbloc.dispose();
    lyrics.dispose();
  }
}
