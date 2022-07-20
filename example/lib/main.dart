import 'dart:convert';

import 'package:dialog_search/core/utils/constants_colors.dart';
import 'package:dialog_search/dialog_search.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dialog Search Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // List<Testes> dataItems = json.map((i) => Testes.fromJson(i)).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE4E4E5),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: DialogSearch<Testes>.web(
                  url: 'https://62acd535402135c7acb9ac89.mockapi.io/api/user',
                  fromJson: (response) {
                    final l = json.decode(response.body);
                    List<Testes> list = [Testes.fromJson(l)];
                    return list;
                  },
                  urlInSearch: (search) {
                    return '/$search';
                  },
                  attributeToSearch: (item) {
                    return item.nome;
                  },
                  itemBuilder: (item, selected, searchContrast) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 10),
                      child: selected
                          ? Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.nome,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: DefaultTheme.defaultTextColor),
                                  ),
                                ),
                                const Icon(Icons.check_rounded,
                                    color: DefaultTheme.defaultTextColor)
                              ],
                            )
                          : searchContrast,
                    );
                  },
                  dialogStyle: DialogSearchStyle(
                    mainFieldStyle: FieldStyle(
                      preffixWidget: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Icon(Icons.search_rounded,
                              color: Color(0xFF353638))),
                      suffixWidget: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: DefaultTheme.defaultTextColor),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 16),
                      shadow: [
                        BoxShadow(
                          color: DefaultTheme.defaultTextColor.withOpacity(.05),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        )
                      ],
                      radius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                  ),
                  fieldBuilderExternal: (item) {
                    return Row(
                      children: [
                        const Icon(Icons.close),
                        Expanded(child: Text(item.nome)),
                      ],
                    );
                  },
                  onChange: (value) {},
                  // itemsDefault: user,
                  // itemLabel: (value) {
                  //   return value['name'];
                  // },
                  // onChange: (value) {},
                ),
              ),

              // FutureBuilder(
              //     future: get(Uri.parse(
              //         'https://62acd535402135c7acb9ac89.mockapi.io/api/user')),
              //     builder: (context, AsyncSnapshot snapshot) {
              //       if (snapshot.hasData) {
              //         Response r = snapshot.data;
              //         final user = (json.decode(r.body) as List);
              //         user.add({
              //           'id': 0,
              //           'name': 'icó kkas kemdsn eioapkdssd smjdsas'
              //         });
              //         user.add({'id': 1, 'name': 'icó'});
              //         return Padding(
              //           padding: EdgeInsets.symmetric(
              //               horizontal: MediaQuery.of(context).size.width * .2),
              //           child: DialogSearch<dynamic>.single(
              //             items: user,
              //             onChange: (value) {},

              //             // itemsDefault: user,
              //             // itemLabel: (value) {
              //             //   return value['name'];
              //             // },
              //             // onChange: (value) {},
              //           ),
              //         );
              //       }
              //       return const CircularProgressIndicator();
              //     })
            ],
          ),
        ),
      ),
    );
  }
}

class Testes {
  final String nome;

  Testes({required this.nome});

  factory Testes.fromJson(Map<String, dynamic> json) =>
      Testes(nome: json['name'] ?? '');
}
