import 'package:auto_route/auto_route.dart';
import 'package:raffl/routes/guard/auth_guard.dart';

import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        //Default page so set to initial
        AutoRoute(page: AuthRoute.page, keepHistory: false),
        //keepHistory false means this is removed froms tack when another entry added
        //The following routes are protected as they require Login access
        //AutoRoute(page: HomeRoute.page,guards: [AuthGuard()]),
        AutoRoute(page: AuthenticatedRoutes.page, guards: [
          AuthGuard()
        ], children: [
          AutoRoute(page: HomeRoute.page),
          AutoRoute(page: ProfileRoute.page),
          AutoRoute(page: SearchResultsRoute.page),
          AutoRoute(page: ViewListingRoute.page),
          AutoRoute(page: CreateListingRoute.page),
          AutoRoute(page: InboxRoute.page),
          AutoRoute(page: WinsRoute.page),
          AutoRoute(page: WatchingRoute.page),
          AutoRoute(page: SellingRoute.page),
        ])
        //AutoRoute(page: ProfileRoute.page,guards: [AuthGuard()]),
      ];
}
