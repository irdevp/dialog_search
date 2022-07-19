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
  final List<Map<String, dynamic>> json = [
    {
      "nome": "Leandro Mário Iago Gonçalves",
      "idade": 58,
      "cpf": "42760725308",
      "rg": "345019295",
      "data_nasc": "13/07/1964",
      "sexo": "Masculino",
      "signo": "Câncer",
      "mae": "Maria Cristiane",
      "pai": "Thomas Carlos Eduardo Gonçalves",
      "email": "leandro.mario.goncalves@mcexecutiva.com.br",
      "senha": "bjA3UP1cLP",
      "cep": "76913799",
      "endereco": "Rua Xapuri",
      "numero": 685,
      "bairro": "Riachuelo",
      "cidade": "Ji-Paraná",
      "estado": "RO",
      "telefone_fixo": "6937418995",
      "celular": "69983037405",
      "altura": "1,66",
      "peso": 99,
      "tipo_sanguineo": "A-",
      "cor": "vermelho"
    },
    {
      "nome": "César Henrique Marcelo Nogueira",
      "idade": 49,
      "cpf": "26990149310",
      "rg": "324790673",
      "data_nasc": "11/07/1973",
      "sexo": "Masculino",
      "signo": "Câncer",
      "mae": "Kamilly Aline",
      "pai": "Cláudio Igor Nogueira",
      "email": "cesar_nogueira@gruposandino.com.br",
      "senha": "K5qMZ2ECko",
      "cep": "76873468",
      "endereco": "Alameda Bou Gain",
      "numero": 273,
      "bairro": "Setor 04",
      "cidade": "Ariquemes",
      "estado": "RO",
      "telefone_fixo": "6928918200",
      "celular": "69985955893",
      "altura": "1,81",
      "peso": 78,
      "tipo_sanguineo": "A-",
      "cor": "amarelo"
    },
    {
      "nome": "Mariah Gabriela Olivia Novaes",
      "idade": 28,
      "cpf": "22753052549",
      "rg": "375374000",
      "data_nasc": "24/05/1994",
      "sexo": "Feminino",
      "signo": "Gêmeos",
      "mae": "Natália Aline",
      "pai": "Julio Tiago Heitor Novaes",
      "email": "mariahgabrielanovaes@amaralmonteiro.com.br",
      "senha": "LeFdh4jwFD",
      "cep": "35438970",
      "endereco": "Praça Tancredo Neves 35",
      "numero": 622,
      "bairro": "Centro",
      "cidade": "Acaiaca",
      "estado": "MG",
      "telefone_fixo": "3126213268",
      "celular": "31996533076",
      "altura": "1,57",
      "peso": 72,
      "tipo_sanguineo": "O+",
      "cor": "vermelho"
    },
    {
      "nome": "Nair Bárbara Raquel Jesus",
      "idade": 20,
      "cpf": "73898074072",
      "rg": "100528971",
      "data_nasc": "04/01/2002",
      "sexo": "Feminino",
      "signo": "Capricórnio",
      "mae": "Milena Luna Nina",
      "pai": "Renan Iago Victor Jesus",
      "email": "nair_jesus@asproplastic.com.br",
      "senha": "edmiMIIPCz",
      "cep": "40810580",
      "endereco": "Travessa Itaú",
      "numero": 118,
      "bairro": "Paripe",
      "cidade": "Salvador",
      "estado": "BA",
      "telefone_fixo": "7137889992",
      "celular": "71983731307",
      "altura": "1,65",
      "peso": 58,
      "tipo_sanguineo": "A-",
      "cor": "vermelho"
    },
    {
      "nome": "Catarina Nicole Oliveira",
      "idade": 19,
      "cpf": "07035829504",
      "rg": "508972292",
      "data_nasc": "18/07/2003",
      "sexo": "Feminino",
      "signo": "Câncer",
      "mae": "Esther Rebeca",
      "pai": "Otávio Breno Paulo Oliveira",
      "email": "catarina_oliveira@santosferreira.adv.br",
      "senha": "EpouGJFPUF",
      "cep": "78158700",
      "endereco": "Rua Suriname",
      "numero": 747,
      "bairro": "Parque das Nações",
      "cidade": "Várzea Grande",
      "estado": "MT",
      "telefone_fixo": "6528529050",
      "celular": "65991418039",
      "altura": "1,50",
      "peso": 47,
      "tipo_sanguineo": "A-",
      "cor": "amarelo"
    },
    {
      "nome": "Bianca Regina Mariane da Cunha",
      "idade": 73,
      "cpf": "79977115974",
      "rg": "506899676",
      "data_nasc": "12/02/1949",
      "sexo": "Feminino",
      "signo": "Aquário",
      "mae": "Andrea Antonella",
      "pai": "Enzo Victor Pedro da Cunha",
      "email": "biancareginadacunha@icloud.com",
      "senha": "BSrpKreckO",
      "cep": "69087013",
      "endereco": "Rua Rio Tiquê",
      "numero": 417,
      "bairro": "Tancredo Neves",
      "cidade": "Manaus",
      "estado": "AM",
      "telefone_fixo": "9237218411",
      "celular": "92983796671",
      "altura": "1,59",
      "peso": 77,
      "tipo_sanguineo": "AB-",
      "cor": "azul"
    },
    {
      "nome": "Bianca Cláudia da Cruz",
      "idade": 67,
      "cpf": "12428699300",
      "rg": "369496449",
      "data_nasc": "02/07/1955",
      "sexo": "Feminino",
      "signo": "Câncer",
      "mae": "Joana Stella Olivia",
      "pai": "Lorenzo Vinicius João da Cruz",
      "email": "bianca.claudia.dacruz@vetech.vet.br",
      "senha": "Ujazd8CPCK",
      "cep": "21843170",
      "endereco": "Rua Antonio Rainho",
      "numero": 611,
      "bairro": "Senador Camará",
      "cidade": "Rio de Janeiro",
      "estado": "RJ",
      "telefone_fixo": "2137379768",
      "celular": "21997733294",
      "altura": "1,66",
      "peso": 68,
      "tipo_sanguineo": "A-",
      "cor": "laranja"
    },
    {
      "nome": "Bruna Alessandra Mariah Bernardes",
      "idade": 73,
      "cpf": "81582698341",
      "rg": "419008172",
      "data_nasc": "05/02/1949",
      "sexo": "Feminino",
      "signo": "Aquário",
      "mae": "Sabrina Isabelly",
      "pai": "Breno Manuel Bernardes",
      "email": "bruna_alessandra_bernardes@right.com.br",
      "senha": "51fBqWQUUY",
      "cep": "58088680",
      "endereco": "Rua Comerciante José Antônio de Souza",
      "numero": 329,
      "bairro": "Oitizeiro",
      "cidade": "João Pessoa",
      "estado": "PB",
      "telefone_fixo": "8328224187",
      "celular": "83989400678",
      "altura": "1,69",
      "peso": 81,
      "tipo_sanguineo": "AB+",
      "cor": "laranja"
    },
    {
      "nome": "Leonardo Benício Caio Lopes",
      "idade": 54,
      "cpf": "09599191129",
      "rg": "503348107",
      "data_nasc": "25/03/1968",
      "sexo": "Masculino",
      "signo": "Áries",
      "mae": "Jennifer Esther",
      "pai": "Paulo Samuel Lopes",
      "email": "leonardo_lopes@archosolutions.com.br",
      "senha": "bGBlZ2lR7K",
      "cep": "78555586",
      "endereco": "Rua Michelângelo Bucnarroti",
      "numero": 398,
      "bairro": "Residencial Modrian",
      "cidade": "Sinop",
      "estado": "MT",
      "telefone_fixo": "6625703999",
      "celular": "66996461242",
      "altura": "1,81",
      "peso": 77,
      "tipo_sanguineo": "AB-",
      "cor": "amarelo"
    },
    {
      "nome": "Renan Renato Souza",
      "idade": 23,
      "cpf": "14561245600",
      "rg": "427193187",
      "data_nasc": "06/02/1999",
      "sexo": "Masculino",
      "signo": "Aquário",
      "mae": "Bianca Natália Josefa",
      "pai": "Carlos Raimundo Otávio Souza",
      "email": "renan_souza@tursi.com.br",
      "senha": "4ksR8zONdi",
      "cep": "08130210",
      "endereco": "Rua Visconde de Aljezur",
      "numero": 314,
      "bairro": "Vila Jurema",
      "cidade": "São Paulo",
      "estado": "SP",
      "telefone_fixo": "1138516909",
      "celular": "11993473540",
      "altura": "1,65",
      "peso": 68,
      "tipo_sanguineo": "AB+",
      "cor": "vermelho"
    },
    {
      "nome": "Bernardo Severino Santos",
      "idade": 30,
      "cpf": "70620283203",
      "rg": "307913867",
      "data_nasc": "26/03/1992",
      "sexo": "Masculino",
      "signo": "Áries",
      "mae": "Emilly Isis Sarah",
      "pai": "Antonio Erick Santos",
      "email": "bernardo-santos84@com.br",
      "senha": "EyWBeLlJRq",
      "cep": "75130650",
      "endereco": "Rua Guararapes",
      "numero": 658,
      "bairro": "Calixtolândia 2ª Etapa",
      "cidade": "Anápolis",
      "estado": "GO",
      "telefone_fixo": "6225488180",
      "celular": "62983173898",
      "altura": "1,70",
      "peso": 108,
      "tipo_sanguineo": "B-",
      "cor": "roxo"
    },
    {
      "nome": "Benjamin Caio Mendes",
      "idade": 76,
      "cpf": "18637841449",
      "rg": "126130097",
      "data_nasc": "10/07/1946",
      "sexo": "Masculino",
      "signo": "Câncer",
      "mae": "Julia Letícia",
      "pai": "Luís Diogo Mendes",
      "email": "benjamincaiomendes@argosmineracao.com.br",
      "senha": "NLsKdiqfSt",
      "cep": "54080240",
      "endereco": "Rua Dom Pedro II",
      "numero": 178,
      "bairro": "Vista Alegre",
      "cidade": "Jaboatão dos Guararapes",
      "estado": "PE",
      "telefone_fixo": "8135890600",
      "celular": "81982400925",
      "altura": "1,73",
      "peso": 67,
      "tipo_sanguineo": "AB+",
      "cor": "azul"
    },
    {
      "nome": "Luiz Mateus Guilherme da Mata",
      "idade": 48,
      "cpf": "84796496076",
      "rg": "277762145",
      "data_nasc": "01/07/1974",
      "sexo": "Masculino",
      "signo": "Câncer",
      "mae": "Jaqueline Sueli",
      "pai": "Bryan Ruan da Mata",
      "email": "luizmateusdamata@carolpessoa.com.br",
      "senha": "Kkjbgtzukx",
      "cep": "75065710",
      "endereco": "Rua 220",
      "numero": 870,
      "bairro": "Bandeiras",
      "cidade": "Anápolis",
      "estado": "GO",
      "telefone_fixo": "6236609105",
      "celular": "62994396294",
      "altura": "1,79",
      "peso": 85,
      "tipo_sanguineo": "O-",
      "cor": "laranja"
    },
    {
      "nome": "Yuri Benício da Rocha",
      "idade": 44,
      "cpf": "10172518784",
      "rg": "231965990",
      "data_nasc": "22/06/1978",
      "sexo": "Masculino",
      "signo": "Câncer",
      "mae": "Gabriela Jaqueline",
      "pai": "Ricardo Davi Levi da Rocha",
      "email": "yuri-darocha86@coldblock.com.br",
      "senha": "qlRPy4rApH",
      "cep": "76829312",
      "endereco": "Rua Antônio Violão",
      "numero": 347,
      "bairro": "Juscelino Kubitschek",
      "cidade": "Porto Velho",
      "estado": "RO",
      "telefone_fixo": "6927857573",
      "celular": "69988873023",
      "altura": "1,67",
      "peso": 69,
      "tipo_sanguineo": "O-",
      "cor": "laranja"
    },
    {
      "nome": "Gabriel Francisco Barbosa",
      "idade": 27,
      "cpf": "13084910936",
      "rg": "468841350",
      "data_nasc": "10/07/1995",
      "sexo": "Masculino",
      "signo": "Câncer",
      "mae": "Mirella Yasmin Mariah",
      "pai": "Hugo Igor Leandro Barbosa",
      "email": "gabrielfranciscobarbosa@delfrateinfo.com.br",
      "senha": "JffmX4e97r",
      "cep": "60060010",
      "endereco": "Rua Jaguaribara",
      "numero": 195,
      "bairro": "Centro",
      "cidade": "Fortaleza",
      "estado": "CE",
      "telefone_fixo": "8537539190",
      "celular": "85983471473",
      "altura": "1,96",
      "peso": 105,
      "tipo_sanguineo": "B-",
      "cor": "laranja"
    },
    {
      "nome": "Maria Vera Fabiana Brito",
      "idade": 35,
      "cpf": "10833435132",
      "rg": "316728664",
      "data_nasc": "26/05/1987",
      "sexo": "Feminino",
      "signo": "Gêmeos",
      "mae": "Amanda Fernanda",
      "pai": "Bryan Breno Brito",
      "email": "mariaverabrito@kframe.com.br",
      "senha": "FXN3g3BJqF",
      "cep": "39400077",
      "endereco": "Rua Januária",
      "numero": 563,
      "bairro": "Centro",
      "cidade": "Montes Claros",
      "estado": "MG",
      "telefone_fixo": "3825853306",
      "celular": "38994142350",
      "altura": "1,58",
      "peso": 82,
      "tipo_sanguineo": "O-",
      "cor": "azul"
    },
    {
      "nome": "Lara Jéssica Emily Cardoso",
      "idade": 20,
      "cpf": "77338602530",
      "rg": "213485151",
      "data_nasc": "22/03/2002",
      "sexo": "Feminino",
      "signo": "Áries",
      "mae": "Giovanna Camila Beatriz",
      "pai": "Vinicius André Tomás Cardoso",
      "email": "lara-cardoso92@isometro.com.br",
      "senha": "wwLjYUW2lO",
      "cep": "44091280",
      "endereco": "Rua Grandaus",
      "numero": 328,
      "bairro": "Tomba",
      "cidade": "Feira de Santana",
      "estado": "BA",
      "telefone_fixo": "7537425960",
      "celular": "75983990671",
      "altura": "1,70",
      "peso": 52,
      "tipo_sanguineo": "O+",
      "cor": "vermelho"
    },
    {
      "nome": "Ruan Rafael Ricardo Melo",
      "idade": 64,
      "cpf": "44024948938",
      "rg": "482323899",
      "data_nasc": "22/05/1958",
      "sexo": "Masculino",
      "signo": "Gêmeos",
      "mae": "Heloisa Lavínia",
      "pai": "Caleb Lucas Miguel Melo",
      "email": "ruan_melo@slb.com",
      "senha": "O1P3NXxrJ6",
      "cep": "74584100",
      "endereco": "Avenida Perimetral Norte",
      "numero": 291,
      "bairro": "Vila Cristina",
      "cidade": "Goiânia",
      "estado": "GO",
      "telefone_fixo": "6228192349",
      "celular": "62985160269",
      "altura": "1,96",
      "peso": 61,
      "tipo_sanguineo": "B-",
      "cor": "preto"
    },
    {
      "nome": "Luna Luiza Daiane Gomes",
      "idade": 63,
      "cpf": "02682672949",
      "rg": "289805314",
      "data_nasc": "08/02/1959",
      "sexo": "Feminino",
      "signo": "Aquário",
      "mae": "Elza Clarice",
      "pai": "Gabriel Arthur Tomás Gomes",
      "email": "luna.luiza.gomes@jonhdeere.com",
      "senha": "YPHjE6DQRx",
      "cep": "72578690",
      "endereco": "Chácara Chácaras 59",
      "numero": 348,
      "bairro": "Núcleo Rural Hortigranjeiro de Santa Maria",
      "cidade": "Brasília",
      "estado": "DF",
      "telefone_fixo": "6138416676",
      "celular": "61991401460",
      "altura": "1,77",
      "peso": 50,
      "tipo_sanguineo": "A+",
      "cor": "vermelho"
    },
    {
      "nome": "Tiago Raul Daniel Monteiro",
      "idade": 59,
      "cpf": "74361511187",
      "rg": "299074493",
      "data_nasc": "08/07/1963",
      "sexo": "Masculino",
      "signo": "Câncer",
      "mae": "Vitória Sônia Andreia",
      "pai": "João Luan Monteiro",
      "email": "tiago-monteiro89@saojose.biz",
      "senha": "6mQho3IA04",
      "cep": "87020620",
      "endereco": "Rua Pioneiro Alcides Araújo Vargas",
      "numero": 197,
      "bairro": "Vila Esperança",
      "cidade": "Maringá",
      "estado": "PR",
      "telefone_fixo": "4426607933",
      "celular": "44998353994",
      "altura": "1,80",
      "peso": 53,
      "tipo_sanguineo": "O-",
      "cor": "laranja"
    }
  ];

  @override
  Widget build(BuildContext context) {
    List<Testes> dataItems = json.map((i) => Testes.fromJson(i)).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE4E4E5),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: DialogSearch<Testes>.single(
                  items: dataItems,
                  initialValue: dataItems[4],
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
      Testes(nome: json['nome']);
}
