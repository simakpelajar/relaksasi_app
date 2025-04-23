import 'package:flutter/material.dart';
import 'package:relax_fik/features/journal/models/journal_model.dart';
import 'package:relax_fik/features/journal/widgets/journal_card.dart';

/// A grid view for displaying journal entries
class JournalGrid extends StatelessWidget {
  /// The list of journals to display
  final List<Journal> journals;
  
  /// Callback when a journal is tapped
  final Function(Journal) onJournalTap;

  const JournalGrid({
    Key? key,
    required this.journals,
    required this.onJournalTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: journals.length,
        itemBuilder: (context, index) {
          final journal = journals[index];
          
          return JournalCard(
            journal: journal,
            onTap: () => onJournalTap(journal),
          );
        },
      ),
    );
  }
}
