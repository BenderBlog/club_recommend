import 'package:club_recommend/club_detail.dart';
import 'package:club_recommend/club_suggestion.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: "mainpage",
      builder: (context, state) => ClubSuggestion(),
      routes: [
        GoRoute(
          path: ':code',
          name: "detail",
          builder: (context, state) {
            final String userIdFromPath = state.pathParameters['code'] ?? "";
            return ClubDetail(code: userIdFromPath);
          },
        ),
      ],
    ),
  ],
);
