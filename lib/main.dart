import 'package:password/note.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
//глобальные переменные для отображения данных на YourNewPage
String descriptionForNewPage;
String loginForNewPage;
String passwordForNewPage;

String editNoteInformation;

List<Note> data = [];
int tapIndex; 

class _MyHomePageState extends State<MyHomePage> {

  String descripton; 
  String login; 
  String password;
  //создание контроллеров для ввода текста
  TextEditingController _textFieldControllerDescription = TextEditingController();
  TextEditingController _textFieldControllerLogin = TextEditingController();
  TextEditingController _textFieldControllerPassword = TextEditingController();
  // штука ниже не знаю зачем
  @override
  void dispose() {
    _textFieldControllerDescription.dispose();
    _textFieldControllerPassword.dispose();
    _textFieldControllerLogin.dispose();
    super.dispose();
  }
  // функция создаёт новый элемент массива Note по которому создаётся новый ListTile
  void getValueAndCreateListTile() {
    descripton = _textFieldControllerDescription.text;
    login = _textFieldControllerLogin.text;
    password = _textFieldControllerPassword.text;
    
    if (descripton != '' && login != '' && password != '') {
      data.add(Note(descripton: descripton, login: login, password: password));

      Navigator.of(context).pop();

      _textFieldControllerDescription.clear();
      _textFieldControllerLogin.clear();
      _textFieldControllerPassword.clear();

      setState(() {});
    }
  }
  //окно для создания записи. описание, пароль, логин 
  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Create Note'),
            content: Container(
              height: 170,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 15.0),
                    child: TextField(
                      controller: _textFieldControllerDescription,
                      decoration: InputDecoration(hintText: "Description"),
                    ),
                  ),
                  TextField(
                    controller: _textFieldControllerLogin,
                    decoration: InputDecoration(hintText: "Enter login"),
                  ),
                  TextField(
                    controller: _textFieldControllerPassword,
                    decoration: InputDecoration(hintText: "Enter password"),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => getValueAndCreateListTile(),
                child: Text('SUBMIT')),
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
  }






  //создаём список описаний для сортировки

  //!!!!!!!!
  //пофиксить тут осталось много всякого хлама!!!!!!!!!!
  //!!!!!!!!
  //не уверен что это нужно
  void namesForSort(List names) {
    for (var i = 0; i < data.length; i++) {
      names.add(data[i].descripton);
    }
    tmpList = names;
  }
  //не знаю зачем это
  @override
  void initState() {
    this.namesForSort(names);
    super.initState();
  }
  //убрать лишние переменные
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  List names = new List();
  List tmpList = new List();
  List filteredNames = new List();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text( 'Password Keeper' );
  //штука которая постоянно сканит textfield в appbar е
  _MyHomePageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }
  // измененение аппбара под поиск и запуск самого поиска
  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          style: new TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          controller: _filter,
          decoration: new InputDecoration(
            prefixIcon: new Icon(Icons.search,
              color: Colors.white,
            ),
            hintText: 'Search',
            hintStyle: TextStyle(fontSize: 20.0, color: Colors.white),
            enabledBorder: UnderlineInputBorder(      
              borderSide: BorderSide(color: Colors.white),   
            ),  
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),  
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text( 'Password Keeper' );
        filteredNames = names;
        _filter.clear();
      }
    });
  }

  //создаём массив с отсортированными объектами
  //выводим его в случае если идет поиск
  //ВЫводим всё целиком если поиска не проводится
  Widget _buildList() {
    if (!(_searchText.isEmpty)) {
      List<Note> tmpList = [];
      for (var i = 0; i < data.length; i++) {
        if (data[i].descripton.toLowerCase().contains(_searchText.toLowerCase())) {
          tmpList.add(data[i]);
          int tmpIndex = tmpList.lastIndexOf(data[i]);
          print(tmpIndex);
          print(i);
          tmpList[tmpIndex].indexOfObject = i;
        }
      }
      filteredNames = tmpList;
      return ListView(
          scrollDirection: Axis.vertical,
          // генерируем список listtile 
          children: new List.generate(filteredNames.length, (int index){
            return new ListTile(
              title: Text(filteredNames[index].descripton,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              leading: CircleAvatar(child: Text(filteredNames[index].descripton[0].toUpperCase())),
              onTap: () {
                tapIndex = filteredNames[index].indexOfObject;
                // устанавливаем значение для внешних переменных чтобы потом
                // можно было обратиться из класса YourNewPage
                descriptionForNewPage = data[tapIndex].descripton;
                loginForNewPage = data[tapIndex].login;
                passwordForNewPage = data[tapIndex].password;

                Navigator.push(
                  context,
                    MaterialPageRoute(
                      builder: (context) => YourNewPage(),
                  ),
                ); 
              },
            );
          }),
        );
    } else {
      return ListView(
        scrollDirection: Axis.vertical,
          // генерируем список listtile 
        children: new List.generate(data.length, (int index){
          return new ListTile(
            title: Text(data[index].descripton,
              maxLines: 1,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            leading: CircleAvatar(child: Text(data[index].descripton[0].toUpperCase())),
            onTap: () {
              tapIndex = index;
              // устанавливаем значение для внешних переменных чтобы потом
              // можно было обратиться из класса YourNewPage
              descriptionForNewPage = data[tapIndex].descripton;
              loginForNewPage = data[tapIndex].login;
              passwordForNewPage = data[tapIndex].password;

              Navigator.push(
                context,
                  MaterialPageRoute(
                    builder: (context) => YourNewPage(),
                  ),
                ); 
              },
            );
          }),
        );
    }
  }

  //главная страница 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle,
        actions: <Widget>[
          IconButton(
            icon: _searchIcon,
            onPressed: _searchPressed,
          ),
        ],
      ),
      body: Container(
        child: _buildList(), //ListView(
        //   scrollDirection: Axis.vertical,
        //   // генерируем список listtile 
        //   children: new List.generate(data.length, (int index){
        //     return new ListTile(
        //       title: Text(data[index].descripton,
        //         maxLines: 1,
        //         style: TextStyle(
        //           fontSize: 20,
        //         ),
        //       ),
        //       leading: CircleAvatar(child: Text(data[index].descripton[0].toUpperCase())),
        //       onTap: () {
        //         tapIndex = index;
        //         // устанавливаем значение для внешних переменных чтобы потом
        //         // можно было обратиться из класса YourNewPage
        //         descriptionForNewPage = data[tapIndex].descripton;
        //         loginForNewPage = data[tapIndex].login;
        //         passwordForNewPage = data[tapIndex].password;

        //         Navigator.push(
        //           context,
        //             MaterialPageRoute(
        //               builder: (context) => YourNewPage(),
        //           ),
        //         ); 
        //       },
        //     );
        //   }),
        // ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(context),
        child: Icon(Icons.add),
        ),
    );
  }
}








// страница на которую мы переходим для просмотра пароля и так далее
// !!!!! надо сделать её stateful !!!!! 
class YourNewPage extends StatefulWidget {

  @override
  _YourNewPageState createState() => _YourNewPageState();
}

class _YourNewPageState extends State<YourNewPage> {
  TextEditingController _textFieldControllerEdit = TextEditingController();

  // функция для редактирования записи
  void editInformationInNote(int value) {
    editNoteInformation = _textFieldControllerEdit.text;

    if (editNoteInformation != '' && value != 5) {

      if (value == 1) {
        data[tapIndex].descripton = editNoteInformation;
        descriptionForNewPage = editNoteInformation;
      } else if (value == 2) {
        data[tapIndex].login = editNoteInformation;
        loginForNewPage = editNoteInformation;
      } else if (value == 3) {
        data[tapIndex].password = editNoteInformation;
        passwordForNewPage = editNoteInformation;
      } else if (value == 4) {
        data[tapIndex].additionalInformation = editNoteInformation;
      }

      print(editNoteInformation);

      Navigator.of(context).pop();

      _textFieldControllerEdit.clear();

      setState(() {});
    }
  }

  _displayEditDialog(BuildContext context, int value, String addString) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Edit ' + addString.toLowerCase()),
            content: Container(
              height: 100,
              child: Container(
                margin: EdgeInsets.only(bottom: 15.0),
                child: TextField(
                  controller: _textFieldControllerEdit,
                  decoration: InputDecoration(hintText: addString),
                ),
              ), 
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => editInformationInNote(value),
                child: Text('SUBMIT')),
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
  }

  _adaptiveContainerWithComment() {
    if (data[tapIndex].additionalInformation == null) {
      return Container();
    } else {
      return Container(
        alignment: AlignmentDirectional(-1, 0),
        margin: EdgeInsets.fromLTRB(15, 25, 10, 5),
        child: Text(data[tapIndex].additionalInformation,
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 22,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //не знаю как это работает, но key нужен для копирования в clipboard
    final key = new GlobalKey<ScaffoldState>();
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text(descriptionForNewPage.toUpperCase(),
          overflow: TextOverflow.ellipsis,
        ),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 1) {
                String addString = 'Description';
                _displayEditDialog(context, value, addString);
              } else if (value == 2) {
                String addString = 'Login';
                _displayEditDialog(context, value, addString);
              } else if (value == 3) {
                String addString = 'Password';
                _displayEditDialog(context, value, addString);
              } else if (value == 4) {
                String addString = 'Comment';
                _displayEditDialog(context, value, addString);
              } else if (value == 5) {
                _displayConfirmDeleteDialog(context);
                data.removeAt(tapIndex);
              } 
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                  child: Text("Edit description"),
                  value: 1,
              ),
              PopupMenuItem(
                child: Text("Edit login"),
                value: 2,
              ),
              PopupMenuItem(
                child: Text("Edit password"),
                value: 3,
              ),
              PopupMenuItem(
                child: Text("Add comment"),
                value: 4,
              ),
              PopupMenuItem(
                child: Text("Delete note"),
                value: 5,
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[

            Container(
              alignment: AlignmentDirectional(-0.8, 0),
              margin: EdgeInsets.fromLTRB(10, 25, 0, 5),
              child: Row(
                children: <Widget>[
                  Container(
                    child: new Icon(Icons.account_box, color: Colors.black),
                    margin: EdgeInsets.only(right: 10),
                  ),
                  Text("Login:",
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    child: Text(loginForNewPage,
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 20,
                      ),
                    ),
                    onTap: () {
                      //копирование в clipboard
                      Clipboard.setData(new ClipboardData(text: loginForNewPage));
                      key.currentState.showSnackBar(
                        new SnackBar(content: new Text("Text copied to clipboard")),
                      );
                    },
                  ),
                ],
              ),
            ),

            Container(
              alignment: AlignmentDirectional(-0.8, 0),
              margin: EdgeInsets.fromLTRB(10, 18, 0, 5),
              child: Row(
                children: <Widget>[
                  Container(
                    child: new Icon(Icons.lock, color: Colors.black),
                    margin: EdgeInsets.only(right: 10),
                  ),
                  Text("Password:",
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    child: Text(passwordForNewPage,
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 20,
                      ),
                    ),
                    onTap: () {
                      //копирование в clipboard
                      Clipboard.setData(new ClipboardData(text: passwordForNewPage));
                      key.currentState.showSnackBar(
                        new SnackBar(content: new Text("Text copied to clipboard")),
                      );
                    },
                  ),
                ],
              ),
            ),
            //here adaptive container
            _adaptiveContainerWithComment(),
          ],
        ),
      ),
      // Кнопка для удаления записи
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // что бы было вообще по красоте нужно добавить
          // alertDialog с подтверждением 
          _displayConfirmDeleteDialog(context);
          data.removeAt(tapIndex);
        },
        child: Icon(Icons.delete),
      ),
    );
  }

  _displayConfirmDeleteDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Delete this note?"),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Text('SUBMIT')),
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
    }
}