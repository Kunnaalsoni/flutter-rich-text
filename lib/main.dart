import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notus/notus.dart';
import 'dart:convert';
import 'package:notustohtml/notustohtml.dart';
import 'package:zefyr/zefyr.dart';
import 'package:quill_delta/quill_delta.dart';
import 'Results.dart';

void main() => runApp(RichTextApp());

class RichTextApp extends StatefulWidget {
  @override
  _RichTextAppState createState() => _RichTextAppState();
}

class _RichTextAppState extends State<RichTextApp> {
  final converter = NotusHtmlCodec();
  final document = NotusDocument();
  ZefyrController _controller;
  FocusNode _focusNode;

  String html;
  var serverData;

  void getData() async {
    http.Response response =
        await http.get('https://vmitia.pythonanywhere.com/post/');
    if (response.statusCode == 200) {
      serverData = jsonDecode(response.body)['results'][0]['text'];
    }
    print(serverData);
  }

  @override
  void initState() {
    super.initState();
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
    getData();
  }

  NotusDocument _loadDocument() {
    final Delta delta = Delta()..insert("\n");
    return NotusDocument.fromDelta(delta);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff462872),
            centerTitle: true,
            title: Text("Rich text demo",style: TextStyle(color: Color(0xfff8a002)),),
          ),
          body: Column(
            children: [
              Expanded(
                child: ZefyrScaffold(
                  child:
                  ZefyrEditor(controller: _controller, focusNode: _focusNode),
                ),
              ),
              RaisedButton(
                onPressed: () {
                  html = converter.encode(_controller.document.toDelta());
                  print(html);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Results(
                            html: html,
                          )));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xff462872),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  height: 40,
                  width: double.infinity,
                  child: Center(
                      child: Text(
                        'Next',
                        style: TextStyle(
                            fontSize: 18,
                            color: Color(0xfff8a002),
                            fontWeight: FontWeight.bold),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
