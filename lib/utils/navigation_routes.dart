import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shopingapp/features/presentation/views/home/home_screen.dart';
import 'package:shopingapp/features/presentation/views/shopping_cart/shopping_cart_view.dart';
import '../features/presentation/views/splash/splash_screen.dart';
import '../features/presentation/views/login/login_screen.dart';
import '../features/presentation/views/user_profile/user_profile_screen.dart';

class Routes {
  static const String kSplashView = "kSplashView";
  static const String kLoginView = "kLoginView";
  static const String kUserProfileView = "kUserProfileView";
  static const String kHomeView = "kHomeView";
  static const String kShoppingCartView = "kShoppingCartView";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.kSplashView:
        return PageTransition(
          child: const SplashScreen(),
          type: PageTransitionType.fade,
          settings: const RouteSettings(name: Routes.kSplashView),
        );
      case Routes.kLoginView:
        return PageTransition(
          child: const LoginScreen(),
          type: PageTransitionType.fade,
          settings: const RouteSettings(name: Routes.kLoginView),
        );
      case Routes.kUserProfileView:
        return PageTransition(
          child: const UserProfileView(),
          type: PageTransitionType.fade,
          settings: const RouteSettings(name: Routes.kUserProfileView),
        );
      case Routes.kHomeView:
        return PageTransition(
          child: const HomeView(),
          type: PageTransitionType.fade,
          settings: const RouteSettings(name: Routes.kHomeView),
        );
      case Routes.kShoppingCartView:
        return PageTransition(
          child: ShoppingCart(
              shoppingCartArgs: settings.arguments as ShoppingCartArgs),
          type: PageTransitionType.fade,
          settings: const RouteSettings(name: Routes.kShoppingCartView),
        );
      default:
        return PageTransition(
          type: PageTransitionType.fade,
          child: const Scaffold(
            body: Center(
              child: Text("Invalid Route"),
            ),
          ),
        );
    }
  }
}
