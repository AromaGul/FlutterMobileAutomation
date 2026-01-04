import 'package:flutter/material.dart';
import 'screens/multi_choice_questions_screen.dart';
import 'screens/second_app_screen.dart';

void main() {
  runApp(CountryListApp());
}

class CountryListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Country List App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CountryHomePage(),
      routes: {
        '/multi-choice': (context) => MultiChoiceQuestionsScreen(),
        '/second-app': (context) => SecondAppScreen(),
      },
    );
  }
}

class CountryHomePage extends StatefulWidget {
  @override
  _CountryHomePageState createState() => _CountryHomePageState();
}

class _CountryHomePageState extends State<CountryHomePage> {
  List<String> countries = [
    'Afghanistan',
    'Nigeria',
    'USA',
    'Canada',
    'UK',
    'Germany',
    'France',
    'Japan',
    'Australia',
  ];

  bool showWrap = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Country List App'),
        actions: [
          IconButton(
            icon: Icon(Icons.wrap_text),
            tooltip: 'Wrap View',
            onPressed: () {
              setState(() {
                showWrap = !showWrap;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Navigation button to Multi choice questions
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/multi-choice');
              },
              icon: Icon(Icons.quiz),
              label: Text('Multi choice questions'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ),
          // Country list
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: showWrap ? buildWrapView() : buildListView(),
            ),
          ),
        ],
      ),
    );
  }

  /// Wrap view
  Widget buildWrapView() {
    return SingleChildScrollView(
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: countries
            .map(
              (country) => Chip(
                label: Text(country),
                deleteIcon: Icon(Icons.close),
                onDeleted: () {
                  setState(() {
                    countries.remove(country);
                  });
                },
              ),
            )
            .toList(),
      ),
    );
  }

  /// Drag & drop + swipe list
  Widget buildListView() {
    return ReorderableListView(
      children: [
        for (final country in countries)
          Dismissible(
            key: ValueKey(country),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              setState(() {
                countries.remove(country);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$country removed')),
              );
            },
            child: ListTile(
              key: ValueKey(country),
              title: Text(country),
              leading: Icon(Icons.drag_handle),
            ),
          ),
      ],
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) newIndex -= 1;
          final item = countries.removeAt(oldIndex);
          countries.insert(newIndex, item);
        });
      },
    );
  }
}
