// Copyright 2023-2025 BenderBlog Rodriguez and contributors
// Copyright 2025 Traintime PDA authors.
// SPDX-License-Identifier: MPL-2.0

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:result_dart/functions.dart';
import 'package:result_dart/result_dart.dart';

import 'club_info.dart';

final url = Uri(
  scheme: "https",
  host: "legacy.superbart.top",
  pathSegments: ["traintime_pda_backend"],
);

Future<ResultDart<List<ClubInfo>, Exception>> getClubList() async {
  try {
    var data = await http
        .get(url.replace(pathSegments: ["traintime_pda_backend", "club.json"]))
        .then((value) => value.body);
    return (jsonDecode(data) as List<dynamic>)
        .map<ClubInfo>((value) => ClubInfo.fromJson(value))
        .toList()
        .toSuccess();
  } on Exception catch (e) {
    return failureOf(e);
  } catch (e) {
    return failureOf(Exception(e.toString()));
  }
}

Future<String> getClubArticle(String code) {
  return http
      .get(
        url.replace(
          pathSegments: [
            "traintime_pda_backend",
            "club_introduction",
            code,
            "index.html",
          ],
        ),
      )
      .then(
        (value) => value.body.replaceAll(
          "<img src=\"",
          "<img src=\"$url/club_introduction/$code/",
        ),
      );
}

String getClubAvatar(String code) => "$url/poster/$code.jpg";

String getClubImage(String code, int index) => "$url/poster/$code-$index.jpg";

// class LoadingException implements Exception {}
