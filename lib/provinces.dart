import 'package:flutter/material.dart';
import 'package:basic_api/regency.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//Create a model class for Province
class Province {
  final String id;
  final String name;

  Province({required this.id, required this.name});

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      id: json['id'],
      name: json['name'],
    );
  }
}

//Fetch provinces from API
Future<List<Province>> fetchProvinces() async {
  final response = await http.get(Uri.parse(
      'https://emsifa.github.io/api-wilayah-indonesia/api/provinces.json'));

  if (response.statusCode == 200) {
    List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => Province.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load provinces: ${response.statusCode}');
  }
}

class ProvinceListPage extends StatefulWidget {
  const ProvinceListPage({super.key});

  @override
  ProvinceListPageState createState() => ProvinceListPageState();
}

class ProvinceListPageState extends State<ProvinceListPage> {
  //Late demo using FutureBuilder
  late Future<List<Province>> _provincesFuture;

  @override
  void initState() {
    super.initState();
    _provincesFuture = fetchProvinces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Indonesian Provinces'),
      ),
      body: Expanded(
        child: FutureBuilder<List<Province>>(
          future: _provincesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data![index].name),
                    subtitle: Text('ID: ${snapshot.data![index].id}'),
                    onTap: () {
                      //Navigasi ke RegencyListPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegencyListPage(
                            provinceId: snapshot.data![index].id,
                            provinceName: snapshot.data![index].name,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }
}
