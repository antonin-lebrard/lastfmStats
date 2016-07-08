library lastfmStats.cache;

import 'dart:html';
import 'dart:convert';
import 'dart:async';
import 'package:lastfmStats/cache/fetch.dart';
import 'package:lastfmStats/display/artist.dart';
import 'package:lastfmStats/display/loading.dart';
import 'package:lastfmStats/cache/datetime.dart';


class Cache {

  static final String ARTISTS_KEY = "artistsCached";
  static final String UPDATE_KEY = "lastUpdate";

  String user;
  List<Artist> artists = new List();

  Stream onFetchComplete;
  StreamController _fetchComplete = new StreamController.broadcast();
  bool fetchComplete = false;
  Stream onCacheLoaded;
  StreamController _onCacheLoaded = new StreamController.broadcast();
  bool _cacheLoaded = false;

  LastFMFetching fetchComp = new LastFMFetching();

  Cache(){
    onFetchComplete = _fetchComplete.stream;
    onCacheLoaded = _onCacheLoaded.stream;
  }

  bool get usernamePresent => window.localStorage.containsKey(this.user);
  Map get _cachedData => JSON.decode(window.localStorage[this.user]);

  load(String user){
    this.user = user;
    fetchComp.user = this.user;
    if (this.user == null || this.user == ""){
      // TODO : display error
      return;
    }

    if (_compareLastUpdateToNow().inDays > 5){
      onFetchComplete.listen((_) {
        cache();
      });
      fetch();
    }
    if (usernamePresent){
      List<String> artistsJson = JSON.decode(_cachedData[ARTISTS_KEY]);
      for (String s in artistsJson){
        artists.add(new Artist(JSON.decode(s)));
      }
      _cacheLoaded = true;
      _onCacheLoaded.add(null);
    } else {
      _cacheLoaded = true;
    }
  }

  fetch(){
    List<Artist> newList = new List();
    fetchComp.getArtists(newList).then((_) {
      if (_cacheLoaded) {
        artists = newList;
        fetchComplete = true;
        _fetchComplete.add(null);
      } else {
        onCacheLoaded.listen((_){
          artists = newList;
          fetchComplete = true;
          _fetchComplete.add(null);
        });
      }
    }).catchError((LastFMError error){});
  }

  cache(){
    List<String> artistsJson = new List();
    for (Artist a in artists){
      artistsJson.add(a.toJSONString());
    }
    DateTimeSerializable now = new DateTimeSerializable.now();
    Map storage = {
      UPDATE_KEY : now.toJson(),
      ARTISTS_KEY : JSON.encode(artistsJson)
    };
    window.localStorage[this.user] = JSON.encode(storage);
  }

  Duration _compareLastUpdateToNow(){
    Duration diff = new Duration(days:365);
    if (usernamePresent){
      DateTime lastUpdate = DateTimeSerializable.fromJson(_cachedData[UPDATE_KEY]);
      DateTime now = new DateTime.now();
      diff = now.difference(lastUpdate);
    }
    return diff;
  }
}

