import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:getapidata/quote_item_widget.dart';
import 'package:http/http.dart' as http;





class Content {
  final List<Quote> quotes;

  Content({this.quotes});

  factory Content.fromJson(Map<String, dynamic> json) {
    //print("QUOTE="+json['quotes'].toString());
    var tagObjsJson = json['quotes'] as List;
    return Content(
      quotes: tagObjsJson.map((tagJson) => Quote.fromJson(tagJson)).toList()
    );
  }
}

class QuoteData {
  final Content content;

  QuoteData({this.content});


  factory QuoteData.fromJson(Map<String, dynamic> json) {
    //print("CONTENT="+json['contents'].toString());
    return QuoteData(
      content: Content.fromJson(json['contents'])
    );
  }
}

Future<QuoteData> fetchQuote() async {
  final response =
  await http.get('http://quotes.rest/qod.json?category=inspire');

  if (response.statusCode == 200)
  {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return QuoteData.fromJson(json.decode(response.body));
  }
  else
    {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<QuoteData> futureQuote;

  @override
  void initState() {
    super.initState();
    futureQuote = fetchQuote();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<QuoteData>(
            future: futureQuote,
            builder: (context, snapshot)
            {
              if (snapshot.hasData)
              {
                //QuoteData qData=snapshot.data;
                //print("QUOTE2"+qData.content.quotes[0].quote);

                return QuoteItemWidget(data:snapshot.data.content.quotes[0]);
              }
              else if (snapshot.hasError)
              {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}



