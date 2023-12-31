import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(BasketballMatchApp());
}

class BasketballMatchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basketball Match Scoring App',
      home: BasketballMatchScreen(),
    );
  }
}

class BasketballMatchScreen extends StatefulWidget {
  @override
  _BasketballMatchScreenState createState() => _BasketballMatchScreenState();
}

class _BasketballMatchScreenState extends State<BasketballMatchScreen> {
  int teamAScore = 0;
  int teamBScore = 0;
  int matchDurationInSeconds = 600; // 10 minutes
  bool isTimerRunning = false;
  late Timer _timer;

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (matchDurationInSeconds > 0) {
          matchDurationInSeconds--;
        } else {
          timer.cancel();
          _showGameResults();
        }
      });
    });
  }

  void _scorePoints(int points, String team) {
    setState(() {
      if (team == 'A') {
        teamAScore += points;
      } else if (team == 'B') {
        teamBScore += points;
      }
    });

    if (!isTimerRunning) {
      _startTimer();
      isTimerRunning = true;
    }
  }

  void _resetScore() {
    setState(() {
      teamAScore = 0;
      teamBScore = 0;
      matchDurationInSeconds = 600;
      isTimerRunning = false;
      _timer.cancel();
    });
  }

  void _showGameResults() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('Final Scores:\nTeam A: $teamAScore\nTeam B: $teamBScore'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetScore();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Basketball Match Scoring App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTeamScore('Team A', teamAScore),
                _buildTeamScore('Team B', teamBScore),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _scorePoints(2, 'A'),
                  child: Text('Team A: 2 Points'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _scorePoints(3, 'A'),
                  child: Text('Team A: 3 Points'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _scorePoints(2, 'B'),
                  child: Text('Team B: 2 Points'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _scorePoints(3, 'B'),
                  child: Text('Team B: 3 Points'),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetScore,
              child: Text('Reset Score'),
            ),
            SizedBox(height: 20),
            Text('Time Remaining: ${_formatTime(matchDurationInSeconds)}'),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamScore(String teamName, int score) {
    return Column(
      children: [
        Text(
          '$teamName Score: $score',
          style: TextStyle(fontSize: 20),
        ),
        if (score >= 10) Text('$teamName wins!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
