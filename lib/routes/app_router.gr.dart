// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:flutter/material.dart' as _i10;
import 'package:raffl/pages/auth_page.dart' as _i1;
import 'package:raffl/pages/authenticated_pages.dart' as _i2;
import 'package:raffl/pages/create_listing_page.dart' as _i3;
import 'package:raffl/pages/home_page.dart' as _i4;
import 'package:raffl/pages/profile_page.dart' as _i5;
import 'package:raffl/pages/search_results_page.dart' as _i6;
import 'package:raffl/pages/splash_page.dart' as _i7;
import 'package:raffl/pages/view_listing_page.dart' as _i8;

abstract class $AppRouter extends _i9.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i9.PageFactory> pagesMap = {
    AuthRoute.name: (routeData) {
      final args = routeData.argsAs<AuthRouteArgs>();
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.AuthPage(
          key: args.key,
          onResult: args.onResult,
        ),
      );
    },
    AuthenticatedRoutes.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.AuthenticatedPages(),
      );
    },
    CreateListingRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.CreateListingPage(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.HomePage(),
      );
    },
    ProfileRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.ProfilePage(),
      );
    },
    SearchResultsRoute.name: (routeData) {
      final args = routeData.argsAs<SearchResultsRouteArgs>();
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i6.SearchResultsPage(
          key: args.key,
          searchInput: args.searchInput,
        ),
      );
    },
    SplashRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.SplashPage(),
      );
    },
    ViewListingRoute.name: (routeData) {
      final args = routeData.argsAs<ViewListingRouteArgs>();
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i8.ViewListingPage(
          key: args.key,
          documentID: args.documentID,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.AuthPage]
class AuthRoute extends _i9.PageRouteInfo<AuthRouteArgs> {
  AuthRoute({
    _i10.Key? key,
    required dynamic Function(bool?) onResult,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          AuthRoute.name,
          args: AuthRouteArgs(
            key: key,
            onResult: onResult,
          ),
          initialChildren: children,
        );

  static const String name = 'AuthRoute';

  static const _i9.PageInfo<AuthRouteArgs> page =
      _i9.PageInfo<AuthRouteArgs>(name);
}

class AuthRouteArgs {
  const AuthRouteArgs({
    this.key,
    required this.onResult,
  });

  final _i10.Key? key;

  final dynamic Function(bool?) onResult;

  @override
  String toString() {
    return 'AuthRouteArgs{key: $key, onResult: $onResult}';
  }
}

/// generated route for
/// [_i2.AuthenticatedPages]
class AuthenticatedRoutes extends _i9.PageRouteInfo<void> {
  const AuthenticatedRoutes({List<_i9.PageRouteInfo>? children})
      : super(
          AuthenticatedRoutes.name,
          initialChildren: children,
        );

  static const String name = 'AuthenticatedRoutes';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i3.CreateListingPage]
class CreateListingRoute extends _i9.PageRouteInfo<void> {
  const CreateListingRoute({List<_i9.PageRouteInfo>? children})
      : super(
          CreateListingRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateListingRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i4.HomePage]
class HomeRoute extends _i9.PageRouteInfo<void> {
  const HomeRoute({List<_i9.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i5.ProfilePage]
class ProfileRoute extends _i9.PageRouteInfo<void> {
  const ProfileRoute({List<_i9.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i6.SearchResultsPage]
class SearchResultsRoute extends _i9.PageRouteInfo<SearchResultsRouteArgs> {
  SearchResultsRoute({
    _i10.Key? key,
    required String searchInput,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          SearchResultsRoute.name,
          args: SearchResultsRouteArgs(
            key: key,
            searchInput: searchInput,
          ),
          initialChildren: children,
        );

  static const String name = 'SearchResultsRoute';

  static const _i9.PageInfo<SearchResultsRouteArgs> page =
      _i9.PageInfo<SearchResultsRouteArgs>(name);
}

class SearchResultsRouteArgs {
  const SearchResultsRouteArgs({
    this.key,
    required this.searchInput,
  });

  final _i10.Key? key;

  final String searchInput;

  @override
  String toString() {
    return 'SearchResultsRouteArgs{key: $key, searchInput: $searchInput}';
  }
}

/// generated route for
/// [_i7.SplashPage]
class SplashRoute extends _i9.PageRouteInfo<void> {
  const SplashRoute({List<_i9.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i8.ViewListingPage]
class ViewListingRoute extends _i9.PageRouteInfo<ViewListingRouteArgs> {
  ViewListingRoute({
    _i10.Key? key,
    required String documentID,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          ViewListingRoute.name,
          args: ViewListingRouteArgs(
            key: key,
            documentID: documentID,
          ),
          initialChildren: children,
        );

  static const String name = 'ViewListingRoute';

  static const _i9.PageInfo<ViewListingRouteArgs> page =
      _i9.PageInfo<ViewListingRouteArgs>(name);
}

class ViewListingRouteArgs {
  const ViewListingRouteArgs({
    this.key,
    required this.documentID,
  });

  final _i10.Key? key;

  final String documentID;

  @override
  String toString() {
    return 'ViewListingRouteArgs{key: $key, documentID: $documentID}';
  }
}
