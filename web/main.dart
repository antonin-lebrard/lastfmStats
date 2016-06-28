// Copyright (c) 2016, Antonin LEBRARD. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:lastfmStats/display/login.dart';

DivElement output = querySelector("#output");
DivElement login = querySelector("#login-outer");

void main() {
  new Login(login, output);
}