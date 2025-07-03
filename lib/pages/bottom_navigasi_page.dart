
// =======================
// File: pages/bottom_navigasi_page.dart
// =======================
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'diagram_page.dart';
import 'history_page.dart';

class BottomNavigasiPage extends StatefulWidget {
  @override
  _BottomNavigasiPageState createState() => _BottomNavigasiPageState();
}

class _BottomNavigasiPageState extends State<BottomNavigasiPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [HomePage(), DiagramPage(), HistoryPage()];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Diagram'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
        ],
      ),
    );
  }
}
