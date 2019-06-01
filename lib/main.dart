import 'package:flutter/material.dart';

const int NUM_TILES = 9;

main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  int clickCount;
  String statusText;
  List<String> tileTexts = new List<String>(NUM_TILES);
  List<bool> xTilesPressed = new List<bool>(NUM_TILES);
  List<bool> oTilesPressed = new List<bool>(NUM_TILES);
  List<Color> tileColor = new List<Color>(NUM_TILES);
  bool hasWinner;

  _MyAppState() {
    _resetGame();
  }

  void _gameLogic(int index) {
    if (tileTexts[index] == '') {
      setState(() {
        if (clickCount % 2 == 0) {
          tileTexts[index] = 'X';
          xTilesPressed[index] = true;
        } else {
          tileTexts[index] = 'O';
          oTilesPressed[index] = true;
        }

        _checkWin();

        if (hasWinner) {
          if (clickCount % 2 == 0) {
            statusText = 'Player 1 Wins!';
          } else {
            statusText = 'Player 2 Wins!';
          }
        }

        clickCount++;

        print(this.tileTexts);
        print(this.xTilesPressed);
        print(this.oTilesPressed);
      });
    }
  }

  void _checkWin() {
    for (int i = 0; i < 9; i += 3) {
      if ((xTilesPressed[i] == true &&
              xTilesPressed[i + 1] == true &&
              xTilesPressed[i + 2] == true) ||
          (oTilesPressed[i] == true &&
              oTilesPressed[i + 1] == true &&
              oTilesPressed[i + 2] == true)) {
        hasWinner = true;
        _setWinTilesColor(i, i + 1, i + 2);
      }
    }

    for (int i = 0; i < 3; i++) {
      if ((xTilesPressed[i] == true &&
              xTilesPressed[i + 3] == true &&
              xTilesPressed[i + 6] == true) ||
          (oTilesPressed[i] == true &&
              oTilesPressed[i + 3] == true &&
              oTilesPressed[i + 6] == true)) {
        hasWinner = true;
        _setWinTilesColor(i, i + 3, i + 6);
      }
    }

    if ((xTilesPressed[0] == true &&
            xTilesPressed[4] == true &&
            xTilesPressed[8] == true) ||
        (oTilesPressed[0] == true &&
            oTilesPressed[4] == true &&
            oTilesPressed[8] == true)) {
      hasWinner = true;
      _setWinTilesColor(0, 4, 8);
    }

    if ((xTilesPressed[2] == true &&
            xTilesPressed[4] == true &&
            xTilesPressed[6] == true) ||
        (oTilesPressed[2] == true &&
            oTilesPressed[4] == true &&
            oTilesPressed[6] == true)) {
      hasWinner = true;
      _setWinTilesColor(2, 4, 6);
    }
  }

  void _resetGame() {
    clickCount = 0;
    statusText = 'Begin!';
    hasWinner = false;

    for (int i = 0; i < NUM_TILES; i++) {
      tileTexts[i] = '';
      xTilesPressed[i] = false;
      oTilesPressed[i] = false;
    }
  }

  void _resetTileColor() {
    for (int i = 0; i < NUM_TILES; i++) {
      tileColor[i] = Theme.of(context).buttonColor;
    }
  }

  void _setWinTilesColor(int index1, int index2, int index3) {
    tileColor[index1] = Theme.of(context).primaryColorLight;
    tileColor[index2] = Theme.of(context).primaryColorLight;
    tileColor[index3] = Theme.of(context).primaryColorLight;
  }

  Widget _tile(int index) {
    return new Container(
      height: 100,
      width: 100,
      child: RaisedButton(
        color: tileColor[index],
        child: Text(
          tileTexts[index],
          style: TextStyle(fontSize: 75),
        ),
        onPressed: () {
          if (hasWinner == false) {
            _gameLogic(index);
            print(clickCount);
          }

          if (clickCount == 9 && hasWinner == false) {
            statusText = 'No Winner...';
          }
        },
      ),
    );
  }

  Widget _tileRow(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _tile(index),
        _tile(index + 1),
        _tile(index + 2),
      ],
    );
  }

  Widget _board() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _tileRow(0),
          _tileRow(3),
          _tileRow(6),
        ],
      ),
    );
  }

  Widget _statusText() {
    return Container(
      margin: EdgeInsets.only(top: 35),
      child: Text(
        statusText,
        style: TextStyle(fontSize: 60),
      ),
    );
  }

  Widget _resetButton() {
    return Container(
      width: 200,
      height: 60,
      margin: EdgeInsets.only(bottom: 25),
      child: RaisedButton(
        child: Text(
          'Reset',
          style: TextStyle(fontSize: 35),
        ),
        onPressed: () {
          setState(() {
            _resetGame();
            _resetButton();
            _resetTileColor();
          });
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      _resetTileColor();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tic-Tac-Toe'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _statusText(),
            _board(),
            _resetButton(),
          ],
        ),
      ),
    );
  }
}
