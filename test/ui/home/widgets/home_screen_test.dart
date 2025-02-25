import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pickiverse_app/data/repositories/game_repository.dart';
import 'package:pickiverse_app/domain/models/game.dart';
import 'package:pickiverse_app/ui/home/view_model/home_view_model.dart';
import 'package:pickiverse_app/ui/home/widgets/home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MockGameRepository extends Mock implements GameRepository {}

class MockHomeViewModel extends MockCubit<HomeState> implements HomeViewModel {}

void main() {
  late MockGameRepository mockGameRepository;
  late MockHomeViewModel mockHomeViewModel;

  final testGame = Game(
    id: 'test-id',
    createdAt: DateTime.now(),
    title: '테스트 게임',
    description: '테스트 설명',
    topItems: [
      GameItem(
        id: 'test-item-id',
        createdAt: DateTime.now(),
        title: '테스트 아이템',
        description: '테스트 아이템 설명',
        imageUrl: 'https://example.com/image1.jpg',
      ),
    ],
    created_at: DateTime.now(),
  );

  setUp(() {
    mockGameRepository = MockGameRepository();
    mockHomeViewModel = MockHomeViewModel();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko'),
      ],
      home: RepositoryProvider<GameRepository>(
        create: (context) => mockGameRepository,
        child: BlocProvider<HomeViewModel>(
          create: (context) => mockHomeViewModel,
          child: const HomeScreen(),
        ),
      ),
    );
  }

  group('HomeScreen', () {
    testWidgets('로딩 중일 때 로딩 인디케이터를 표시합니다', (tester) async {
      when(() => mockHomeViewModel.state).thenReturn(
        const HomeState(isLoading: true),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('에러가 있을 때 에러 메시지를 표시합니다', (tester) async {
      const errorMessage = '에러가 발생했습니다';
      when(() => mockHomeViewModel.state).thenReturn(
        const HomeState(error: errorMessage),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('게임이 없을 때 빈 상태 메시지를 표시합니다', (tester) async {
      when(() => mockHomeViewModel.state).thenReturn(const HomeState());

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('게임이 있을 때 게임 정보를 표시합니다', (tester) async {
      when(() => mockHomeViewModel.state).thenReturn(
        HomeState(games: [testGame]),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text(testGame.title), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byIcon(Icons.shuffle), findsOneWidget);
    });

    testWidgets('랜덤 섞기 버튼을 누르면 loadRandomGame이 호출됩니다', (tester) async {
      when(() => mockHomeViewModel.state).thenReturn(
        HomeState(games: [testGame]),
      );
      when(() => mockHomeViewModel.loadRandomGame()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.shuffle));
      verify(() => mockHomeViewModel.loadRandomGame()).called(1);
    });
  });
}
