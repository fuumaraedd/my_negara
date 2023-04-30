// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:quickalert/quickalert.dart';

// ignore: camel_case_types
class homePage extends StatefulWidget {
  const homePage({super.key});
  @override
  State<homePage> createState() => _homePageState();
}

// ignore: camel_case_types
class _homePageState extends State<homePage> {
  TextEditingController input = TextEditingController();
  String name = '';
  String currencyCode = '';
  String currencyName = '';
  String capital = '';
  String resultiso2 = '';
  String description = "";
  ImageProvider flag = const NetworkImage('');
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 227, 227, 227),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: [
            Image.asset('assets/images/logo.png', scale: 3),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 5, 50, 5),
              child: Column(
                children: [
                  TextField(
                    controller: input,
                    decoration: InputDecoration(
                        hintText: 'Enter Country',
                        hintStyle:
                            const TextStyle(color: Colors.grey, fontSize: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(80),
                        )),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: ElevatedButton(
                      onPressed: search,
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 16, 23, 53),
                          padding: const EdgeInsets.all(5),
                          fixedSize: const Size(300, 50),
                          elevation: 15,
                          shadowColor: Colors.black,
                          side: const BorderSide(style: BorderStyle.solid)),
                      child: const Text(
                        'Search',
                        style: TextStyle(
                            fontFamily: 'San-serif',
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 25,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                      height: 300,
                      width: 400,
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 192, 192, 192)),
                          color: const Color.fromARGB(255, 239, 239, 239)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: flag,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return const Text('');
                            },
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                            child: Text(
                              description,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                  fontFamily: 'San-serif',
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            )
          ],
        )),
      ),
    );
  }

  Future<void> search() async {
    String country = input.text;
    String apiid = "VXbDdlnA9+4cMTVekLcDcQ==AmRnYGozAF91LyWC";
    Uri url = Uri.parse('https://api.api-ninjas.com/v1/country?name=$country');
    var response = await http.get(url, headers: {"X-Api-Key": apiid});
    if (country.isNotEmpty) {
      if (response.statusCode == 200) {
        var jsonData = response.body;
        var parsedJson = json.decode(jsonData);
        if (parsedJson.isNotEmpty) {
          name = parsedJson[0]['name'];
          currencyCode = parsedJson[0]['currency']['code'];
          currencyName = parsedJson[0]['currency']['name'];
          capital = parsedJson[0]['capital'];
          resultiso2 = parsedJson[0]['iso2'];
          description =
              "This country is $name with $capital as capital. Currency used is $currencyCode, $currencyName.";
          flag = NetworkImage('https://flagsapi.com/$resultiso2/shiny/64.png');
          player.play(AssetSource('audios/correct_tone.mp3'));
          QuickAlert.show(
              context: context,
              text: 'Country Found!',
              type: QuickAlertType.success);
          setState(() {});
        } else {
          player.play(AssetSource('audios/error_tone.mp3'));
          QuickAlert.show(
              context: context,
              text: 'Country not found! Please re-enter.',
              type: QuickAlertType.error);
          description = '';
          flag = const NetworkImage('');
          setState(() {});
        }
      }
    } else if (country.isEmpty) {
      player.play(AssetSource('audios/error_tone.mp3'));
      QuickAlert.show(
          context: context,
          text: 'Please enter a country',
          type: QuickAlertType.error);
      description = 'Please enter a country';
      flag = const NetworkImage('');
      setState(() {});
    }
  }
}
