import 'package:flutter/material.dart';
import 'second_app_screen.dart';

class MultiChoiceQuestionsScreen extends StatefulWidget {
  @override
  _MultiChoiceQuestionsScreenState createState() => _MultiChoiceQuestionsScreenState();
}

class _MultiChoiceQuestionsScreenState extends State<MultiChoiceQuestionsScreen> {
  // List of questions/items
  List<QuestionItem> items = [
    QuestionItem(id: 1, text: 'What is the capital of France?'),
    QuestionItem(id: 2, text: 'Which planet is closest to the Sun?'),
    QuestionItem(id: 3, text: 'What is 2 + 2?'),
    QuestionItem(id: 4, text: 'Which ocean is the largest?'),
    QuestionItem(id: 5, text: 'What is the smallest prime number?'),
    QuestionItem(id: 6, text: 'Which continent is the largest?'),
    QuestionItem(id: 7, text: 'What is the speed of light?'),
    QuestionItem(id: 8, text: 'Which element has the symbol Au?'),
    QuestionItem(id: 9, text: 'What is the largest mammal?'),
    QuestionItem(id: 10, text: 'Which country has the most population?'),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedCount = items.where((item) => item.isSelected).length;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Multi Choice Questions'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          if (selectedCount > 0)
            IconButton(
              icon: Icon(Icons.delete),
              tooltip: 'Delete Selected ($selectedCount)',
              onPressed: _deleteSelectedItems,
            ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            margin: EdgeInsets.only(bottom: 12.0),
            child: CheckboxListTile(
              title: Text(item.text),
              value: item.isSelected,
              onChanged: (value) {
                setState(() {
                  item.isSelected = value ?? false;
                });
              },
              secondary: item.isSelected
                  ? Icon(Icons.radio_button_checked, color: Colors.blue)
                  : Icon(Icons.radio_button_unchecked, color: Colors.grey),
              controlAffinity: ListTileControlAffinity.trailing,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _launchSecondApp,
        icon: Icon(Icons.launch),
        label: Text('Launch 2nd App'),
      ),
    );
  }

  void _deleteSelectedItems() {
    final selectedItems = items.where((item) => item.isSelected).toList();
    setState(() {
      items.removeWhere((item) => item.isSelected);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${selectedItems.length} selected item(s) deleted'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _launchSecondApp() async {
    // Show confirmation dialog
    final shouldLaunch = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Launch Second App'),
        content: Text('This will close the current app and launch the second application.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Launch'),
          ),
        ],
      ),
    );

    if (shouldLaunch == true) {
      // Navigate to second app screen
      // Note: In integration tests, we navigate directly without closing the app
      // In a real scenario with separate apps, you'd use:
      // - Android: Intent to launch another app package
      // - iOS: URL scheme to launch another app
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => SecondAppScreen(),
          ),
          (route) => false,
        );
      }
    }
  }
}

class QuestionItem {
  final int id;
  final String text;
  bool isSelected;

  QuestionItem({
    required this.id,
    required this.text,
    this.isSelected = false,
  });
}
