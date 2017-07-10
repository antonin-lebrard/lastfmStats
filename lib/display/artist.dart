library lastfmStats.artist;

import 'dart:html';
import 'dart:convert';
import 'dart:async';

import 'package:lastfmStats/helper/searchUrlHelper.dart';

class Artist {

  static double delay = 0.0;
  static bool isAlreadyListeningScroll = false;
  static bool _isScrolling = false;
  static bool _hasSetUpWindowListener = false;
  static Artist _artistToBlur = null;

  static void _resetDelay() {
    delay = 0.0;
  }

  static double _incrementDelay() {
    double temp = delay;
    delay += 0.03;
    if (delay > 1.5)
      _resetDelay();
    return temp;
  }

  static void _setUpWindowListener(){
    if (_hasSetUpWindowListener)
      return;
    _hasSetUpWindowListener = true;
    window.onClick.listen((MouseEvent event){
      if (!(event.target is Element) ||
          (event.target is Element && !(event.target as Element).classes.contains("imageWrapper")))
        _artistToBlur?.blur();
    });
  }

  String name;
  String playcount;
  List images;
  String chosenImageUrl;

  DivElement artistDiv;
  DivElement content;
  DivElement metadataWrapperDiv;
  DivElement imageWrapperDiv;
  DivElement clickableWrapperDiv;
  DivElement imageDiv;
  List<DivElement> icons = new List();

  Artist(Map json){
    name = json['name'];
    playcount = json['playcount'];
    images = json['image'];
    if (images != null) {
      for (int i = 0; i < images.length; i++) {
        if (images[i]['size'] == "large") {
          chosenImageUrl = images[i]['#text'];
          break;
        }
      }
    }
    if (!isAlreadyListeningScroll){
      isAlreadyListeningScroll = true;
      window.onScroll.listen((_){
        if (!_isScrolling){
          _resetDelay();
          _isScrolling = true;
          new Timer(new Duration(milliseconds: 10), (){
            _isScrolling = false;
          });
        }
      });
    }
    _setUpWindowListener();
  }

  DivElement createDiv(){
    artistDiv = new DivElement();
    artistDiv.classes.add("artist");
    content = new DivElement();
    content.classes..add("content");
    content.style.animationDelay = "${_incrementDelay()}s";
    artistDiv..append(content..append(_metadataDiv())..append(_imageDiv())..append(_clickableLinksDiv()));
    return artistDiv;
  }

  DivElement _metadataDiv(){
    metadataWrapperDiv = new DivElement();
    metadataWrapperDiv.classes.add("metadataWrapper");
    DivElement nameDiv = new DivElement();
    nameDiv.classes.add("name");
    DivElement playCountDiv = new DivElement();
    playCountDiv.classes.add("playCount");
    nameDiv.text = this.name;
    playCountDiv.text = this.playcount.toString();
    return metadataWrapperDiv..append(nameDiv)..append(playCountDiv);
  }

  DivElement _imageDiv(){
    imageWrapperDiv = new DivElement();
    imageWrapperDiv.classes.add("imageWrapper");
    imageDiv = new DivElement();
    imageDiv.classes.add("image");
    imageDiv.style.backgroundImage = 'url("$chosenImageUrl")';
    imageWrapperDiv.onClick.listen((_) {
      focus();
      _artistToBlur?.blur();
      _artistToBlur = this;
    });
    return imageWrapperDiv..append(imageDiv);
  }

  void blur() {
    icons.forEach((DivElement d){
      d.style.marginTop = "50px";
    });
    clickableWrapperDiv.style.opacity = "";
    new Timer(new Duration(milliseconds: 500), (){
      clickableWrapperDiv.style.zIndex = "";
    });
    imageDiv.style.setProperty("-webkit-filter", "");
    metadataWrapperDiv.style.setProperty("-webkit-filter", "");
  }

  void focus() {
    clickableWrapperDiv.style.zIndex = "1";
    clickableWrapperDiv.style.opacity = "1";
    icons.forEach((DivElement d) {
      d.style.marginTop = "";
    });
    imageDiv.style.setProperty("-webkit-filter", "blur(3px)");
    metadataWrapperDiv.style.setProperty("-webkit-filter", "blur(1px)");
  }

  DivElement _clickableLinksDiv() {
    clickableWrapperDiv = new DivElement();
    clickableWrapperDiv.classes.add("clickableWrapper");
    DivElement googleMusicDiv = new DivElement();
    googleMusicDiv.classes..add("icon")..add("googleMusic");
    googleMusicDiv.style.backgroundImage = "url('https://play-music.gstatic.com/fe/b9659330fe8ab3a7debed69d371b7063/favicon_96x96.png')";
    googleMusicDiv.onClick.listen((_) =>
        window.open(SearchUrlHelper.searchGoogleMusic("$name"), "Search on Google Music"));
    DivElement deezerDiv = new DivElement();
    deezerDiv.classes..add("icon")..add("deezer");
    deezerDiv.style.backgroundImage = "url('https://e-cdns-files.dzcdn.net/images/common/favicon/favicon-96x96-v00400039.png')";
    deezerDiv.onClick.listen((_) =>
        window.open(SearchUrlHelper.searchDeezer("$name"), "Search on Deezer"));
    DivElement spotifyDiv = new DivElement();
    spotifyDiv.classes..add("icon")..add("spotify");
    spotifyDiv.style.backgroundImage = "url('https://play.spotify.edgekey.net/site/e244a4f/images/favicon.png')";
    spotifyDiv.onClick.listen((_) =>
        window.open(SearchUrlHelper.searchSpotify("$name"), "Search on Spotify"));
    icons..add(googleMusicDiv)..add(deezerDiv)..add(spotifyDiv);
    icons.forEach((DivElement d) {
      d.style.marginTop = "50px";
    });
    clickableWrapperDiv..append(googleMusicDiv)..append(deezerDiv)..append(spotifyDiv);
    return clickableWrapperDiv;
  }

  String toString() => "$name : $playcount";

  Map toJSON(){
    return {
      'name': name,
      'playcount': playcount,
      'image': images,
    };
  }

}