import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memo/features/add_memory/presentation/views/add_memory_view.dart';
import 'package:memo/features/bottom_nav/bottom_nav_view.dart';
import 'package:memo/features/calender/presentation/views/calender_view.dart';
import 'package:memo/features/favorite/presentation/views/favorite_view.dart';
import 'package:memo/features/gallery/presentation/views/gallery_view.dart';
import 'package:memo/features/home/presentation/views/home_view.dart';
import 'package:memo/features/home/presentation/widgets/home_view_body.dart';
import 'package:memo/features/insights/presentation/views/insights_view.dart';

abstract class AppRouter {
  static const String kHomeView = "/home_view";
  static const String kGalleryView = "/gallery_view";
  static const String kCalenderView = "/calender_view";
  static const String kInsightsView = "/insights_view";
  static const String kAddMemoryView = "/add_memory_view";
  static const String kBottomNavView = "/bottom_nav_view";
   static const String kFavoriteView = "/favorite_view";

  static final router = GoRouter(
    initialLocation: kBottomNavView,
    routes: [
      GoRoute(
        path: kBottomNavView,
        builder: (context, state) => const BottomNavView(),
      ),
      GoRoute(
        path: kHomeView,
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: kCalenderView,
        builder: (context, state) => CalenderView(),
      ),
      GoRoute(
        path: kAddMemoryView,
        builder: (context, state) => AddMemoryView(),
      ),
      GoRoute(
        path: kGalleryView,
        builder: (context, state) => GalleryScreen(),
      ),
      GoRoute(
        path: kInsightsView,
        builder: (context, state) => InsightsView(),
      ),
      GoRoute(
  path: kFavoriteView,
  pageBuilder: (context, state) {
    return CustomTransitionPage(
      child: const FavoritesView(),

      transitionsBuilder:
          (context, animation, _, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  },
),
      //   GoRoute(
      //   path: kFavoriteView,
      //   builder: (context, state) => FavoritesView(),
      // ),
    ],
  );
}