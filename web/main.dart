// Copyright (c) 2016, Antonin LEBRARD. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'package:lastfmStats/cache/cache.dart';
import 'package:lastfmStats/display/artist.dart';
import 'package:lastfmStats/display/scrollHandle.dart';

DivElement output = querySelector("#output");

void main() {
  ScrollHandle scrollhandle = new ScrollHandle(new Cache(), output);
}

display(_){
}