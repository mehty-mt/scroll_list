import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'API Pagination Example',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final List<dynamic> items = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchMoreData();
      }
    });
  }

  Future<void> _fetchData() async {
    try {
      Dio dio = Dio();
      var response =
          await dio.get('https://jsonplaceholder.typicode.com/posts?_start=0&_limit=10');
      items.addAll(response.data);
    } catch (e) {
      print('Error fetching data: $e');
    }
    setState(() {
      
    });
  }

  Future<void> _fetchMoreData() async {
    if (isLoading) return;
    isLoading = true;
    await Future.delayed(Duration(seconds: 2));
    try {
      Dio dio = Dio();
      var response = await dio.get(
          'https://jsonplaceholder.typicode.com/posts?_start=${items.length}&_limit=10');
      items.addAll(response.data);
    } catch (e) {
      print('Error fetching more data: $e');
    } finally {
      isLoading = false;
    }
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Pagination Example'),
      ),
      body:
         ListView.builder(
          controller: _scrollController,
          itemCount: items.length + 1,
          itemBuilder: (context, index) {
            if (index < items.length) {
              return ListTile(
                title: Text(items[index]['title']),
                subtitle: Text(items[index]['body']),
              );
            } else {
              return _buildLoader();
            }
          },
        ),
      
    );
  }

  Widget _buildLoader() {
    return Container(
      padding: EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
  }
}
