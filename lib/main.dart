import 'package:cookie_store/cookie_store.dart';
import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;

class Singletons {
  static CookieStore cookieStore = CookieStore();
  static var client = BrowserClient()..withCredentials = true;

  static Future<int> initCookie() async {
    // var req = http.Request("POST", Uri.parse("http://localhost:5099/api/User/Login"));
    // req.body = "{\"username\": \"xie\",\"password\": \"moyingren2015\"}";
    // req.headers["Content-Type"] = "application/json";
    client.get(Uri.parse("http://localhost:5099/api/User/Logout"));
    var res = await client.post(
      Uri.parse("http://localhost:5099/api/User/Login"),
      body: "{\"username\": \"xie\",\"password\": \"moyingren2015\"}",
      headers: {"Content-Type": "application/json"},
    );
    var resUserApi = await client.get(
      Uri.parse("http://localhost:5099/api/User/UserApi"),
    );
    print(resUserApi.body);
    // print((await http.get(Uri.parse("http://localhost:5099/api/User/UserApi") )).body);
    // cookieStore.updateCookies(res.headers["Set-Cookie"], "localhost:5099", "/");

    return 0;
  }

  static Future<Widget> getUserProfile(var uuid) async {
    var res = await client.get(
      Uri.parse(
        "http://localhost:5099/api/User/ProfileGet?uuidDestination=" + uuid,
      ),
    );
    return Image(image: MemoryImage(res.bodyBytes));
  }
}

void main() async {
  await Singletons.initCookie();
  runApp(const MainApp());
}

class Homepage extends StatefulWidget {
  const Homepage();
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: ListTile(
            leading: FutureBuilder(
              future: Singletons.getUserProfile(
                "1d27c50b-3492-4627-b886-2fa615e47f8e",
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Icon(Icons.error);
                  } else {
                    return snapshot.data!;
                  }
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            title: Text("Contact 1"),
            subtitle: Text("Stuffs"),
          ),
        ),
        Card(
          child: ListTile(title: Text("Contact 2"), subtitle: Text("Stuffs")),
        ),
      ],
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
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
        body: IndexedStack(children: [Homepage(), const Center(child: Text("Settings"))], index: currentIndex,),
      ),
    );
  }
}
