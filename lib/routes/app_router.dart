import 'package:auto_route/auto_route.dart';
import 'package:raffl/routes/guard/auth_guard.dart';

import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true), //Default page so set to initial
    AutoRoute(page: AuthRoute.page, keepHistory: false), //keepHistory false means this is removed froms tack when another entry added
    //The following routes are protected as they require Login access
    AutoRoute(page: HomeRoute.page,guards: [AuthGuard()]), //, guards: [AuthGuard()]

  ];
}