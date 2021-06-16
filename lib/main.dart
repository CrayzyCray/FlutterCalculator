import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/Parser.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

  final _textController = TextEditingController();

  String _resulMessage = "";
  String _textEntered = "";
  void _textEnteredAddChar(String char){
    setState(() {
      _textEntered += char;
    });
  }
  void _textEnteredClear(){
    setState(() {
      _textEntered = "";
    });
  }
  void _textEnteredBackspace(){
    setState(() {
      if (_textEntered != null && _textEntered.length > 0) {
        _textEntered = _textEntered.substring(0, _textEntered.length - 1);
      }
    });
  }

  Parser parser = Parser();

  void _calculate() {
    setState(() {
      List<Lexeme> lexes = parser.LexAnalyze(_textEntered);
      LexemeBuffer lexemeBuffer = LexemeBuffer(lexes);
      try{
        _resulMessage = parser.expr(lexemeBuffer).toString();
      }on Exception catch(e) {
        _resulMessage = "Ошибка";
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    final calcButtonSize = MediaQuery.of(context).size.width / 6;

    Widget calcButton(String buttonText, Color color, double fontSize, Function func){
      return Container(
        margin: EdgeInsets.all(5),
        height: 72.5,
        //decoration: BoxDecoration(
        //  color: Color(0xFF282b33),
        //  borderRadius: BorderRadius.circular(5)
        //),
        //color: Color(0xFF282b33),
        child: MaterialButton(
          color: Color(0xFF282b33),
          onPressed: (){func();},
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          child: Text(buttonText.toString(), style: TextStyle(color: color, fontSize: fontSize),),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFF22252d),
      body: Column(
        children: [
          Container(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text("$_textEntered", style: TextStyle(color: Colors.white, fontSize: 60)),
            ),
            
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.width - 82,
            padding: EdgeInsets.all(40),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width + 82,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Color(0xFF2a2d37),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))
            ),

            child: Table(
              children: [
                TableRow(
                  children: [
                    calcButton("AC", Color(0xFF53ead3), 25, (){_textEnteredClear();}),
                    calcButton("⌫", Color(0xFF53ead3), 30, (){_textEnteredBackspace();}),
                    calcButton("", Color(0xFFad4c54), 40, (){}),
                    calcButton("÷", Color(0xFFad4c54), 40, (){_textEnteredAddChar("/");})
                  ]
                ),
                TableRow(
                    children: [
                      calcButton("7", Color(0xFF53ead3), 30, (){_textEnteredAddChar("7");}),
                      calcButton("8", Color(0xFF53ead3), 30, (){_textEnteredAddChar("8");}),
                      calcButton("9", Color(0xFF53ead3), 30, (){_textEnteredAddChar("9");}),
                      calcButton("×", Color(0xFFad4c54), 40, (){_textEnteredAddChar("*");})
                    ]
                ),
                TableRow(
                    children: [
                      calcButton("4", Color(0xFF53ead3), 30, (){_textEnteredAddChar("4");}),
                      calcButton("5", Color(0xFF53ead3), 30, (){_textEnteredAddChar("5");}),
                      calcButton("6", Color(0xFF53ead3), 30, (){_textEnteredAddChar("6");}),
                      calcButton("-", Color(0xFFad4c54), 40, (){_textEnteredAddChar("-");})
                    ]
                ),
                TableRow(
                    children: [
                      calcButton("1", Color(0xFF53ead3), 30, (){_textEnteredAddChar("1");}),
                      calcButton("2", Color(0xFF53ead3), 30, (){_textEnteredAddChar("2");}),
                      calcButton("3", Color(0xFF53ead3), 30, (){_textEnteredAddChar("3");}),
                      calcButton("+", Color(0xFFad4c54), 40, (){_textEnteredAddChar("+");})
                    ]
                ),
                TableRow(
                    children: [
                      calcButton("(", Color(0xFF53ead3), 30, (){_textEnteredAddChar("(");}),
                      calcButton("0", Color(0xFF53ead3), 30, (){_textEnteredAddChar("0");}),
                      calcButton(")", Color(0xFF53ead3), 30, (){_textEnteredAddChar(")");}),
                      calcButton("=", Color(0xFFad4c54), 40, (){_calculate(); _textEntered = _resulMessage;})
                    ]
                )
              ],
            )
          )
        ],
      )
    );
  }
}
