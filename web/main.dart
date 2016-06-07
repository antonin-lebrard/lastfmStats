// Copyright (c) 2016, Antonin LEBRARD. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'package:lastfmStats/cache/cache.dart';
import 'package:lastfmStats/display/artist.dart';

DivElement output = querySelector("#output");

Cache cache = new Cache();

void main() {
  cache.onCacheLoaded.listen(display);
  cache.onFetchComplete.listen(display);
  cache.load();
}

display(_){
  output.children.clear();
  for (Artist a in cache.artists){
    output.append(a.createDiv());
  }
}