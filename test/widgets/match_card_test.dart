import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_choice_application/widgets/match_card.dart';

void main() {
  testWidgets('MatchCard displays name and location ', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MatchCard(
            name: 'The Coffee House',
            location: 'Thamel, Kathmandu',
            imageUrl: '',
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('The Coffee House'), findsOneWidget);
    expect(find.text('Thamel, Kathmandu'), findsOneWidget);
  });

  testWidgets('MatchCard triggers onTap callback when tapped', (tester) async {
    bool wasTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MatchCard(
            name: 'Hike Nepal',
            location: 'Shivapuri',
            imageUrl: '',
            onTap: () => wasTapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(MatchCard));
    await tester.pump();
    expect(wasTapped, isTrue); 
  });
}
