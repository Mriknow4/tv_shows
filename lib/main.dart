import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:core';
void main() => runApp(MaterialApp(

  home: Home()
));

class Home extends StatefulWidget {


  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> MyTVshows = [];
// https://www.tvmaze.com/search?q=full+house
// just because it is an awesome show i'll initialize it with it

void setfav(String show_name){}
  Future<void> get_data(String show_name) async {
    print("okay");

    String category;
    String language;
    String rating;
    String image;
    String status;
    var url = 'http://api.tvmaze.com/search/shows?q=$show_name';


    var response = await http.get(Uri.parse(url));

    print("waiting");
    if (response.statusCode == 200) {
      var data = convert.jsonDecode(response.body);
      var info = data[0]['show'];
      category = info['genres'][0];
      language = info['language'];
      status = info['status'];
      rating = info['rating']['average'].toString();
      image = info['image']['original'].toString();
      print("$category - $language - $status - $rating");
      MyTVshows.add(
        ListTile(
          leading: Image.network(image),
          title: Text('$show_name'),
          subtitle: Text('$category | $language | $status'),
          trailing: Text('$rating'),
          onLongPress: () { setfav(show_name);},
          tileColor: Colors.grey[200],
        )
      );
    } else {
      print('Request failed: ${response.statusCode}');
    }
setState(() {

});

}

  TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('TV Shows Finder 3000'),
        centerTitle: true,
        backgroundColor: Colors.yellow,

      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              child: TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Enter a TV show",
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(
                    fontSize: 24,
                    color: Colors.white
                  ),
                    fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: MyTVshows.reversed.toList(),
          )

        ]
      ),




      floatingActionButton: FloatingActionButton(
        onPressed:() {get_data(_nameController.text);
        _nameController.clear();},
        child: Text('Add'),
        backgroundColor: Colors.grey[800],
      ),
    );

  }
}


