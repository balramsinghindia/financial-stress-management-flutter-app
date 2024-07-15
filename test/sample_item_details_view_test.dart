import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:flutter_application/src/sample_feature/sample_item_details_view.dart';

// Mock class for http.Client
class MockClient extends Mock implements http.Client {}

void main() {
  late MockClient client;

  setUp(() {
    client = MockClient();
  });

  testWidgets('Initial state and UI elements', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SampleItemDetailsView(client: client)));

    expect(find.text('Hello, Flutter!'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.text('This is a sample text inside a container.'), findsOneWidget);
    expect(find.byType(Form), findsOneWidget);
  });

  testWidgets('Button tap changes text', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SampleItemDetailsView(client: client)));

    expect(find.text('Hello, Flutter!'), findsOneWidget);
    expect(find.text('Bye, Flutter!'), findsNothing);

    await tester.tap(find.text('Hello, Flutter!'));
    await tester.pump();

    expect(find.text('Hello, Flutter!'), findsNothing);
    expect(find.text('Bye, Flutter!'), findsOneWidget);

    await tester.tap(find.text('Bye, Flutter!'));
    await tester.pump();

    expect(find.text('Hello, Flutter!'), findsOneWidget);
    expect(find.text('Bye, Flutter!'), findsNothing);
  });

  testWidgets('Form validation', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SampleItemDetailsView(client: client)));

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Please enter some text'), findsOneWidget);
    expect(find.text('Please select an option'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'abc');
    await tester.pump();

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Text must not exceed 3 characters'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'ab');
    await tester.pump();

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Form is valid. Submitting data to abc.com'), findsNothing);
  });

  testWidgets('Async data fetch', (WidgetTester tester) async {
    when(client.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1')))
        .thenAnswer((_) async => http.Response('{"title": "mock title"}', 200));

    await tester.pumpWidget(MaterialApp(home: SampleItemDetailsView(client: client)));

    await tester.tap(find.text('This is a sample text inside a container.'));
    await tester.pump();

    expect(find.text('mock title'), findsOneWidget);
  });
}
