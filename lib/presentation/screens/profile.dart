// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'package:bungie_api/models/destiny_inventory_item_definition.dart';
import 'package:bungie_api/models/destiny_item_component.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:quria/cubit/character_cubit.dart';
import 'package:quria/data/services/bungie_api/account.service.dart';
import 'package:quria/data/services/bungie_api/profile.service.dart';
import 'package:quria/data/services/manifest/manifest.service.dart';
import 'package:quria/data/services/storage/storage.service.dart';
import 'package:quria/presentation/components/statisticDisplay.dart';

Map<int, DestinyInventoryItemDefinition> _manifestParsed = {};

class ProfileWidget extends StatelessWidget {
  final manifest = ManifestService();
  final storage = StorageService();
  final account = AccountService();
  final profile = ProfileService();
  ProfileWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getProfileData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return BlocProvider(
              create: (_) => CharacterCubit(),
              child: BlocBuilder<CharacterCubit, CharacterState>(
                builder: (context, state) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: 561,
                            child: ProfileTitleWidget(data: snapshot.data)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ProfileNodeWidget(data: snapshot.data),
                            SizedBox(width: 10),
                            if (state is ShowDetailsState) DetailsItemWidget()
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  getProfileData() async {
    _manifestParsed = await manifest.getManifest();
    final characters = profile.getCharacters();
    final Map<String, dynamic> data = {
      'profile': await account.getMembership(),
      'character': characters[0],
      'characterEquipement':
          profile.getCharacterEquipment(characters[0].characterId!)
    };
    return data;
  }
}

class ProfileNodeWidget extends StatelessWidget {
  final data;
  const ProfileNodeWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          margin: const EdgeInsets.only(left: 20),
          child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.start, // change ici pr le mode detail
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WeaponSectionWidget(data: data),
                CharacterWidget(),
                CharacterStatsWidget(),
                ArmorSectionWidget(data: data)
              ]),
        ),
      ),
    );
  }
}

class ArmorSectionWidget extends StatelessWidget {
  final data;
  const ArmorSectionWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Item(item: data['characterEquipement'][3]),
        Item(item: data['characterEquipement'][4]),
        Item(item: data['characterEquipement'][5]),
        Item(item: data['characterEquipement'][6]),
        Item(item: data['characterEquipement'][7]),
      ],
    );
  }
}

class CharacterStatsWidget extends StatelessWidget {
  const CharacterStatsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Text('55'),
              Image(
                  image: NetworkImage(
                      'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                  width: 20,
                  height: 20)
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [],
          ),
          SizedBox(height: 10),
          // StatisticDisplay(value: widdata.value, i: i),
          SizedBox(height: 10),
          Row(
            children: [
              Text('51'),
              Image(
                  image: NetworkImage(
                      'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                  width: 20,
                  height: 20)
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text('51'),
              Image(
                  image: NetworkImage(
                      'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                  width: 20,
                  height: 20)
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text('51'),
              Image(
                  image: NetworkImage(
                      'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                  width: 20,
                  height: 20)
            ],
          ),
        ],
      ),
    );
  }
}

class CharacterWidget extends StatelessWidget {
  const CharacterWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            child: InkWell(
              onTap: () => context.read<CharacterCubit>().hideDetails(),
              child: Image(
                image: NetworkImage(
                    'https://ae01.alicdn.com/kf/Hf7c8a7d685e848bd84384b6112618286A/Mcfarlane-figurine-Destiny-LORD-SALADIN-figurine-de-luxe-10-pouces-S-Bungie-le-mod-le-de.jpg_q50.jpg'),
              ),
            ),
            margin: const EdgeInsets.only(left: 25, right: 25),
            width: 300,
            height: 500,
            decoration: BoxDecoration(border: Border.all(color: Colors.red))),
        Container(
            width: 250,
            height: 50,
            decoration: BoxDecoration(color: Colors.blueGrey),
            child: Center(
              child: Text(
                'toto',
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
            ))
      ],
    );
  }
}

class WeaponSectionWidget extends StatelessWidget {
  final data;
  const WeaponSectionWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Item(item: data['characterEquipement'][0]),
          Item(item: data['characterEquipement'][1]),
          Item(item: data['characterEquipement'][2]),
        ]);
  }
}

class Item extends StatelessWidget {
  final DestinyItemComponent item;
  const Item({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    inspect(item);
    return Container(
      child: InkWell(
        onTap: () => context.read<CharacterCubit>().showDetails(),
        child: Image(
          image: NetworkImage('https://www.bungie.net' +
              _manifestParsed[item.itemHash]!.displayProperties!.icon!),
          width: 70,
          height: 70,
        ),
      ),
      margin: const EdgeInsets.only(top: 10, bottom: 10),
    );
  }
}

class ProfileTitleWidget extends StatefulWidget {
  final data;

  const ProfileTitleWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  _ProfileTitleState createState() => _ProfileTitleState();
}

class _ProfileTitleState extends State<ProfileTitleWidget> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
          alignment: Alignment.topLeft,
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 33, left: 0),
              ),
              Text('Arcaniste',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              Spacer(),
              Text('${widget.data['character'].stats['1935470627']}',
                  style: TextStyle(color: Colors.yellow, fontSize: 20))
            ],
          ),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage('https://www.bungie.net' +
                      widget.data['character'].emblemBackgroundPath))),
          width: 200,
          height: 50,
          padding: const EdgeInsets.all(8.0)),
    );
  }
}

class DetailsItemWidget extends StatelessWidget {
  const DetailsItemWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: false,
      child: Positioned(
          child: Align(
        alignment: Alignment.centerRight,
        child: Container(
            width: 400,
            height: 400,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(right: 40),
            decoration: BoxDecoration(color: Colors.grey),
            child: Container(
              margin: const EdgeInsets.only(left: 7),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 70,
                        width: 70,
                        child: Image(
                          image: NetworkImage(
                              'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: Column(
                          children: [
                            Text(
                              'nom de l\'arme',
                              style: TextStyle(fontSize: 20),
                            ),
                            Column(
                              children: <Widget>[],
                            ),
                            SizedBox(
                              width: 125,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('data 1',
                                      style: TextStyle(fontSize: 10)),
                                  Text(
                                    'data 2',
                                    style: TextStyle(fontSize: 10),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 125,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('data 1',
                                      style: TextStyle(fontSize: 10)),
                                  Text(
                                    'data 2',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('d'),
                            SizedBox(height: 4.5),
                            Text('datafdsfdsfsd'),
                            SizedBox(height: 4.5),
                            Text('data'),
                            SizedBox(height: 4.5),
                            Text('da'),
                            SizedBox(height: 4.5),
                            Text('datafds'),
                            SizedBox(height: 4.5),
                            Text('datafdsfsdffdsfdsfds'),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          LinearPercentIndicator(
                            percent: 0.5,
                            progressColor: Colors.white,
                            lineHeight: 12,
                            width: 175,
                          ),
                          SizedBox(height: 8),
                          LinearPercentIndicator(
                            percent: 0.5,
                            progressColor: Colors.white,
                            lineHeight: 12,
                            width: 175,
                          ),
                          SizedBox(height: 8),
                          LinearPercentIndicator(
                            percent: 0.5,
                            progressColor: Colors.white,
                            lineHeight: 12,
                            width: 175,
                          ),
                          SizedBox(height: 8),
                          LinearPercentIndicator(
                            percent: 0.5,
                            progressColor: Colors.white,
                            lineHeight: 12,
                            width: 175,
                          ),
                          SizedBox(height: 8),
                          LinearPercentIndicator(
                            percent: 0.5,
                            progressColor: Colors.white,
                            lineHeight: 12,
                            width: 175,
                          ),
                          SizedBox(height: 8),
                          LinearPercentIndicator(
                            percent: 0.5,
                            progressColor: Colors.white,
                            lineHeight: 12,
                            width: 175,
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.only(left: 5),
                    child: Row(
                      children: [
                        SizedBox(
                            height: 40,
                            width: 40,
                            child: Image(
                              image: NetworkImage(
                                  'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                            )),
                        SizedBox(width: 15),
                        SizedBox(
                            height: 40,
                            width: 40,
                            child: Image(
                              image: NetworkImage(
                                  'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                            )),
                        SizedBox(width: 15),
                        SizedBox(
                            height: 40,
                            width: 40,
                            child: Image(
                              image: NetworkImage(
                                  'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                            )),
                        SizedBox(width: 15),
                        SizedBox(
                            height: 40,
                            width: 40,
                            child: Image(
                              image: NetworkImage(
                                  'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.only(left: 5),
                    child: Row(
                      children: [
                        SizedBox(
                            height: 40,
                            width: 40,
                            child: Image(
                              image: NetworkImage(
                                  'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'titre dsdsds',
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(height: 3),
                              Text(
                                ' It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
      )),
    );
  }
}