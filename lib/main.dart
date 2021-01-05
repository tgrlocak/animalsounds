import 'dart:io';

import 'package:animound/models/animal.dart';
import 'package:animound/models/language.dart';
import 'package:animound/models/translation.dart';
import 'package:animound/services/animal.service.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      title: 'Animal Sounds',
      theme: ThemeData(
        primarySwatch: MaterialColor(
          0xFF000000, 
          {
            50: Colors.black.withOpacity(0.05),
            100:Colors.black.withOpacity(0.1),
            200:Colors.black.withOpacity(0.2),
            300:Colors.black.withOpacity(0.3),
            400:Colors.black.withOpacity(0.4),
            500:Colors.black.withOpacity(0.5),
            600:Colors.black.withOpacity(0.6),
            700:Colors.black.withOpacity(0.7),
            800:Colors.black.withOpacity(0.8),
            900:Colors.black.withOpacity(0.9),
          }
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AssetsAudioPlayer _player = AssetsAudioPlayer.newPlayer();
  final _mainScaffold = GlobalKey<ScaffoldState>();

  String selectedAnimal;
  Map<String, String> _t;
  String lang;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _animalService = AnimalService();
    Translation.instance.fillTranslations();

    this.lang = this.lang == null ? Localizations.localeOf(context).languageCode : this.lang;

    _processTranslations(this.lang);

    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: _mainScaffold,
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * (isPortrait ? 0.1 : 0.15),
          backgroundColor: Colors.black,
          leading: GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Image(
                image: AssetImage('assets/images/logo.png'),
              ),
            ),
            onTap: () => _mainScaffold.currentState.openDrawer(),
          ),
          title: Text(_t['title']),
          actions: [
            Center(
              child: DropdownButton<String>(
                value: this.lang,
                icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.white),
                dropdownColor: Colors.grey[300],
                isDense: true,
                iconSize: 36,
                underline: Divider(color: Colors.black),
                items: Language.languages().map((e) {
                  return DropdownMenuItem(
                    child: Text(e.name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    value: e.code
                  );
                }).toList(),
                onChanged: (code) {
                  setState(() {
                    this.lang = code;
                    _processTranslations(code);
                  });
                },
              ),
            )
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                ),
                child: Image(
                  image: AssetImage('assets/images/logo.png'),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10),
            color: Colors.grey[100],
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * (isPortrait ? 0.85 : 0.75),
            ),
            child: FutureBuilder(
              future: _animalService.getAnimals(),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  List<Animal> animals = snapshot.data;
                  
                  return GridView.count(
                    padding: EdgeInsets.all(10),
                    crossAxisCount: isPortrait ? 2 : 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 15,
                    children: animals.map((a) {
                      return GestureDetector(
                        onTap: () { 
                          _play(a);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: a.key == this.selectedAnimal ? Colors.blue : Colors.grey[600],
                              width: 0.3
                            ),
                            borderRadius: BorderRadius.circular(3),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 3,
                                color: a.key == this.selectedAnimal ? Colors.blue : Colors.grey[400],
                                spreadRadius: 2
                              )
                            ]
                          ),
                          child: GridTile(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image(
                                alignment: Alignment.center,
                                image: AssetImage(a.imagePath),
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                            footer: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Icon(
                                      Icons.volume_up_rounded,
                                      color: a.key == this.selectedAnimal ? Colors.blue : Colors.grey,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: Text(
                                      a.names[this.lang], style: TextStyle(fontSize: 13)
                                    )
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Dikkat!'),
        titleTextStyle: TextStyle(color: Colors.grey, fontSize: 24),
        content: new Text('Uygulamadan çıkmak istediğinize emin misiniz?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("İptal", style: TextStyle(fontSize: 13, color: Colors.white),),
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          new FlatButton(
            onPressed: () => exit(0),
            child: Text("Kapat", style: TextStyle(fontSize: 14),),
            color: Colors.black
          ),
        ],
      ),
    ) ?? false;
  }

  bool _isSelected(Animal a) {
    return this.selectedAnimal == a.key;
  }

  _play(Animal a) async {
    setState(() {
      this.selectedAnimal = a.key;
    });

    _player.stop();
    _player.open(
      Audio(a.soundPath),
      showNotification: true
    );
  }

  _processTranslations(String langCode) {
    var items = Translation.instance.translations;
    var tmp = this.lang;
    if(!items.containsKey(tmp)) {
      tmp = 'en';
    }

    setState(() {
      this.lang = tmp;
      this._t = items[this.lang];
    });

  }

}
