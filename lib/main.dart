import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'data.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'myapp',
      home: WidgetOrigen(),
    );
  }
}

class WidgetOrigen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('recordatorios'),
        ),
        body: Container(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new RaisedButton(
                      color: Colors.lightGreenAccent,
                      child: Text('ver agregados'),
                      onPressed: () {
                        Navigator.push(context, PageRouteBuilder(pageBuilder:
                            (BuildContext context, Animation<double> animation,
                                Animation<double> secAnimaiton) {
                          return WidgetVer();
                        }));
                      }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new RaisedButton(
                      color: Colors.lightGreenAccent,
                      child: Text('agregar'),
                      onPressed: () {
                        Navigator.push(context, PageRouteBuilder(pageBuilder:
                            (BuildContext context, Animation<double> animation,
                                Animation<double> secAnimaiton) {
                          return WidgetAgregar();
                        }));
                      }),
                ],
              )
            ],
          ),
        ));
  }
}

// ignore: must_be_immutable
class WidgetAgregar extends StatelessWidget {
  TextEditingController _palabra = new TextEditingController();
  TextEditingController _sign = new TextEditingController();
  TextEditingController _desc = new TextEditingController();
  TaskDatabase db = TaskDatabase();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Agregar palabra"),
        ),
        body: FutureBuilder(
            future: db.initDB(),
            key: GlobalKey<FormState>(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        TextField(
                          controller: _palabra,
                          decoration: const InputDecoration(
                            hintText: 'ingrese la palabra',
                          ),

                          /*validator: (value) {
              if (value.isEmpty) {
                return 'te olvidaste de ingresarla wn';
              }
              return null;
            },*/
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        TextField(
                          controller: _sign,
                          decoration: const InputDecoration(
                            hintText: 'ingrese el significado',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        TextField(
                          controller: _desc,
                          decoration: const InputDecoration(
                            hintText: 'Descripcion',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      onPressed: () {
                        var _lista =
                            Task(_palabra.text, _sign.text, _desc.text);
                        db.incert(_lista);
                        //print();
                        Navigator.push(context, PageRouteBuilder(pageBuilder:
                            (BuildContext context, Animation<double> animation,
                                Animation<double> secAnimaiton) {
                          return WidgetOrigen();
                        }));
                      },
                      child: Text('Ok boomer'),
                    ),
                  ),
                ],
              );
            }));
  }
}

// ignore: must_be_immutable
class VerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WidgetVer();
}

class _WidgetVer extends State<VerWidget> {
  TaskDatabase db = TaskDatabase();

  update() {
    setState(() {
      //Future<List<Task>> up = db.obtener();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: db.initDB(),
      // ignore: missing_return
      builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return FutureBuilder(
            future: db.obtener(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
              return ListView(
                children: <Widget>[
                  for (Task task in snapshot.data)
                    ListTile(
                        leading: GestureDetector(
                          child: Container(
                            width: 48,
                            height: 48,
                            padding: EdgeInsets.symmetric(vertical: 4.0),
                            alignment: Alignment.center,
                            child: IconButton(
                                icon: Icon(Icons.delete_outline),
                                onPressed: () {
                                  db.delete(task.palabra);
                                  update();
                                  print(snapshot.data);
                                }),
                          ),
                        ),
                        //Icon(Icons.delete),
                        title: Text("palabra: " +
                            task.palabra +
                            " \nsignifica: " +
                            task.significado +
                            "\nDescripcion: " +
                            task.desc)),
                ],
              );
            },
          );
        } else {
          return CircularProgressIndicator();
          //}
        }
      },
    );
  }
}

// ignore: must_be_immutable
class WidgetVer extends StatelessWidget {
  //@override
  //WidgetVerState createState() => WidgetVer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Palabras"),
      ),
      body: VerWidget(),
    );
  }
}
/*
contenedor(p, s, d) {
  return new Container(
    margin: EdgeInsets.all(10),
    //padding: EdgeInsets.all(74),
    color: Colors.cyan,
    height: 90.0,
    width: 380,
    child: Text("hola \nhola \n como andas "),
  );
}

*/
//class WidgetVerState  extends State<WidgetVerState>{}
