import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vahanar_front/main.dart';  // Importer MyApp depuis main.dart

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());  // Retirer le 'const'

    // Vérifier que le compteur commence à 0
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap sur l'icône '+' et trigger une nouvelle frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Vérifier que le compteur a été incrémenté.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
