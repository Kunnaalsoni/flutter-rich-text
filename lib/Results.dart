import 'package:flutter/material.dart';
import 'package:notustohtml/notustohtml.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

class Results extends StatefulWidget {
  @override
  _ResultsState createState() => _ResultsState();
  String html;

  Results({this.html});
}

class _ResultsState extends State<Results> {

  final converter = NotusHtmlCodec();
  Delta delta;
  NotusDocument document;

  @override
  void initState() {
    super.initState();
    delta = converter.decode(widget.html);
    document = NotusDocument.fromDelta(delta);
    print(document);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff462872),
        title: Text('Result text', style: TextStyle(color: Color(0xfff8a002)),),
        centerTitle: true,
      ),
      body: ZefyrScaffold(
        child: ZefyrView(document: document),
      ),
    );
  }
}
