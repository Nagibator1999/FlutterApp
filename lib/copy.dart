import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(title: 'Simply Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _selectedIndex = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        _counter = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),   
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(context, PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (BuildContext context,_,__) => MyWindow(),
                  transitionsBuilder: (__, Animation<double> animation,___, Widget child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  } 
                ));
                },
              child: 
                Icon(Icons.add),
            )
          ],
        ),
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.refresh),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            // activeIcon: ,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            title: Text('School'),
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        onTap: _onItemTapped,
      ),
    );
  }
}



class MyWindow extends StatefulWidget {
  MyWindow({Key key}) : super(key: key);
  @override
  _MyWindowState createState() => _MyWindowState();
}

class _MyWindowState extends State<MyWindow> {
  String value;

  //тут список ListTile который собирается по нашему массиву Note эта часть уже не нужна
  //пока не убираю, мало ли что
  // List<Widget> _buildList() {
  //   return data.map((Note f) => ListTile(
  //     title: Text(f.descripton),
  //     subtitle: Text(f.login),
  //     leading: CircleAvatar(child: Text(f.descripton[0])),
  //     onTap: () {
  //       print("index");
  //       Navigator.push(
  //         context,
  //           MaterialPageRoute(
  //             builder: (context) => YourNewPage(),
  //           ),
  //         ); 
  //       }
  //     )
  //   ).toList();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      constraints: BoxConstraints(
        maxHeight: 400,
        maxWidth: 400,
        minHeight: 100,
        minWidth: 100, 
      ),
      child: Column(children: <Widget>[
        FlatButton(
          color: Colors.orange,
          padding: EdgeInsets.all(10.0),
          onPressed: () {
            Navigator.pop(context);
          },
        child: Text("Close window"),
        ),
        Container(
          width: 300,
          child: Material(
            child: TextField(
              cursorColor: Colors.orange,
            ),
          ),
        ),
      ],),
    );
  }
}


// class MyWindow extends StatelessWidget {
//   @override   
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text("Your answer"),
//       actions: <Widget>[
//         FlatButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: Text("Close"),
//         ),
//         FlatButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: Text("Close there"),
//         ),
//       ],
//     );
//   }
// }