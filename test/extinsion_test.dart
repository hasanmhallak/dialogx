import 'package:dialogx/dialogx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  testWidgets(
    'showToast displays a Material Toast and dispose propely if we did not wait for the toast to disappear by its own',
    (
      WidgetTester tester,
    ) async {
      const toastText = 'Hello World';
      const textButton = Text('show toast');

      final key = GlobalKey();
      // Build a MaterialApp widget that contains a Scaffold.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                // Call showToast method with a message.

                return Center(
                  child: TextButton(
                    onPressed: () {
                      context.showToast(
                        toastText,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        containerKey: key,
                      );
                    },
                    child: textButton,
                  ),
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.byWidget(textButton));
      await tester.pumpAndSettle();
      // Expect to find a toast with the specified background and text colors.
      expect(find.text(toastText), findsOneWidget);
      final toast = find.byKey(key);
      final Container container = tester.widget(toast);
      final Text text = tester.widget(find.text(toastText));
      expect(toast, findsOneWidget);
      expect(text.style?.color, Colors.white);
      expect((container.decoration as BoxDecoration).color, Colors.red);

      // wait for toast to disappear.
      // await tester.pumpAndSettle(const Duration(seconds: 4));
      // expect(find.text(toastText), findsNothing);
    },
  );
  testWidgets(
    'Material Toast will be removed after certian time',
    (
      WidgetTester tester,
    ) async {
      const toastText = 'Hello World';
      const textButton = Text('show toast');

      final key = GlobalKey();
      // Build a MaterialApp widget that contains a Scaffold.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                // Call showToast method with a message.

                return Center(
                  child: TextButton(
                    onPressed: () {
                      context.showToast(
                        toastText,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        containerKey: key,
                      );
                    },
                    child: textButton,
                  ),
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.byWidget(textButton));
      await tester.pumpAndSettle();
      // Expect to find a toast with the specified background and text colors.
      expect(find.text(toastText), findsOneWidget);
      final toast = find.byKey(key);
      final Container container = tester.widget(toast);
      final Text text = tester.widget(find.text(toastText));
      expect(toast, findsOneWidget);
      expect(text.style?.color, Colors.white);
      expect((container.decoration as BoxDecoration).color, Colors.red);

      // wait for toast to disappear.
      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.text(toastText), findsNothing);
    },
  );
  testWidgets(
    'showToast called multipule time and successfully disposed all if we waited for 3 seconds',
    (
      WidgetTester tester,
    ) async {
      const toastText = 'Hello World';
      const textButton = Text('show toast');

      final key = GlobalKey();
      // Build a MaterialApp widget that contains a Scaffold.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                // Call showToast method with a message.

                return Center(
                  child: TextButton(
                    onPressed: () {
                      context.showToast(
                        toastText,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        containerKey: key,
                      );
                    },
                    child: textButton,
                  ),
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.byWidget(textButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byWidget(textButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byWidget(textButton));

      await tester.pumpAndSettle();

      // Expect to find a toast with the specified background and text colors.
      expect(find.text(toastText), findsOneWidget);
      final toast = find.byKey(key);
      final Container container = tester.widget(toast);
      final Text text = tester.widget(find.text(toastText));
      expect(toast, findsOneWidget);
      expect(text.style?.color, Colors.white);
      expect((container.decoration as BoxDecoration).color, Colors.red);

      // wait for toast to disappear.
      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.text(toastText), findsNothing);
    },
  );
}
