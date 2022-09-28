import 'package:biotite/ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biotite',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Biotite'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String errors = "";
  String script = "";
  String html = "";
  String hello = "";

  void evalRhai(String code) {
    setState(() {
      script = code;
    });
    api.executeRhai(s: script).then((value) => errors = value!);
  }

  void renderHtml(String md) {
    setState(() {
      api.parseMarkdown(md: md).then((value) => html = value);
    });
  }

  void getHello() {
    setState(() {
      api.getHello().then((value) => hello = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              onChanged: (md) => renderHtml(md),
              keyboardType: TextInputType.multiline,
              showCursor: true,
              maxLines: 10,
            ),
            Html(
              data: html,
            ),
          ],
        ),
      ),
      drawer: Drawer(
          child: ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return ListBody(
            children: <Widget>[
              Text("Rhai Scripting Settings"),
              TextFormField(
                initialValue: script,
                onChanged: (script) => evalRhai(script),
                keyboardType: TextInputType.multiline,
                showCursor: true,
                maxLines: 10,
              ),
              Text(
                hello,
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 255)),
              ),
              Text(
                errors,
                style: TextStyle(color: Color.fromARGB(255, 255, 0, 0)),
              )
            ],
          );
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => getHello(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
