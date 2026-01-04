import 'package:flutter/material.dart';

class SecondAppScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Second Application',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: false,
      ),
      debugShowCheckedModeBanner: false,
      home: SecondAppHomePage(),
    );
  }
}

class SecondAppHomePage extends StatefulWidget {
  @override
  _SecondAppHomePageState createState() => _SecondAppHomePageState();
}

class _SecondAppHomePageState extends State<SecondAppHomePage> {
  @override
  void initState() {
    super.initState();
    // This screen represents the second application
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Application'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 100,
              color: Colors.green,
            ),
            SizedBox(height: 20),
            Text(
              'Second Application',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Successfully Launched!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.green[700],
              ),
            ),
            SizedBox(height: 40),
            Text(
              'This is the second application screen.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

