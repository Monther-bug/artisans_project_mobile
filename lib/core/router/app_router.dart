import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/exercises/presentation/pages/exercise_details_page.dart';
import '../../features/favorites/presentation/pages/favorites_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/exercises/domain/entities/exercise_entity.dart';
import '../../features/layout/presentation/pages/main_layout_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
      GoRoute(
        path: '/',
        builder: (context, state) => const MainLayoutPage(),
        routes: [
          GoRoute(
            path: 'exercise/:id',
            builder: (context, state) {
              final exercise = state.extra as ExerciseEntity;
              return ExerciseDetailsPage(exercise: exercise);
            },
          ),
          GoRoute(
            path: 'favorites',
            builder: (context, state) => const FavoritesPage(),
          ),
        ],
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
    ],
  );
}
