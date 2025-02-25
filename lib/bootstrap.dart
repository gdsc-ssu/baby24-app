import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pickiverse_app/data/repositories/game_repository.dart';
import 'package:pickiverse_app/data/services/dio_client.dart';
import 'package:pickiverse_app/l10n/l10n.dart';
import 'package:pickiverse_app/routing/app_router.dart';
import 'package:pickiverse_app/ui/core/themes/app_theme.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap() async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox('settings');

  // Add cross-flavor configuration here
  final dio = DioClient().dio;

  FlutterNativeSplash.remove();

  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top],
  );

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<GameRepository>(
          create: (context) => GameRepositoryImpl(dio: dio),
        ),
        // 여기에 추가 Repository들을 넣을 수 있습니다.
      ],
      child: MaterialApp.router(
        routerConfig: goRouter,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    ),
  );
}
