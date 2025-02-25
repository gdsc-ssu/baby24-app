abstract class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String game = '/game/:id';
  static const String infiniteGame = '/infinite-game';
  static const String search = '/search';

  static String gameRoute(String id) => '/game/$id';
}
