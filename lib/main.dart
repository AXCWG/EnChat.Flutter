import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}
Future<http.Response> fetchAvatar(var uuid){
  return http.get(Uri.parse("http://localhost:5099/api/User/ProfileGet?uuid="+uuid)); 
}
class _MainAppState extends State<MainApp> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected:
              (value) => {
                setState(() {
                  currentIndex = value;
                }),
              },
          destinations: [
            NavigationDestination(icon: Icon(Icons.contacts), label: "Home"),
            NavigationDestination(
              icon: Icon(Icons.settings),
              label: "Settings",
            ),
          ],
        ),
        appBar: AppBar(
          title: Text("EnChat"),
          actions: [
            IconButton(
              onPressed: () => {},
              icon: Icon(Icons.add),
              tooltip: "Add",
            ),
          ],
        ),
        body:
            [
              Column(
                children: [
                  Card(
                    child: ListTile(
                      title: Text("Contact 1"),
                      subtitle: Text("Stuffs"),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text("Contact 2"),
                      subtitle: Text("Stuffs"),
                    ),
                  ),
                ],
              ),
              const Center(child: Text("Settings")),
            ][currentIndex],
      ),
    );
  }
}
