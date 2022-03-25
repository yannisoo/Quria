import 'package:flutter/material.dart';
import 'package:quria/constants/styles.dart';
import 'dart:math' as math;

import 'package:quria/data/services/bungie_api/enums/destiny_data.dart';
import 'package:quria/data/services/bungie_api/profile.service.dart';
import 'package:quria/data/services/manifest/manifest.service.dart';
import 'package:quria/presentation/screens/profile/components/vertical_character_stats_listing.dart';

class MobileProfileHeaderInfo extends StatefulWidget {
  final String characterId;
  final Map<String, int>? stats;
  final double fontSize;

  const MobileProfileHeaderInfo(
      {Key? key,
      required this.stats,
      required this.characterId,
      required this.fontSize})
      : super(key: key);

  @override
  State<MobileProfileHeaderInfo> createState() =>
      _MobileProfileHeaderInfoState();
}

class _MobileProfileHeaderInfoState extends State<MobileProfileHeaderInfo> {
  @override
  Widget build(BuildContext context) {
    int superHash =
        ProfileService().getCurrentSuperHashForCharacter(widget.characterId)!;
    String characterSuper = ManifestService
            .manifestParsed
            .destinyInventoryItemDefinition![superHash]
            ?.displayProperties
            ?.icon ??
        ManifestService
            .manifestParsed
            .destinySandboxPerkDefinition![
                DestinyData.superNodeToSandbox[superHash]]
            ?.displayProperties
            ?.icon ??
        "";
    return Padding(
      padding: EdgeInsets.only(bottom: globalPadding(context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle: -math.pi / 4,
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.15,
                  width: MediaQuery.of(context).size.width * 0.15,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.white)),
                ),
              ),
              Image(
                image: NetworkImage(DestinyData.bungieLink + characterSuper),
                height: MediaQuery.of(context).size.width * 0.17,
                width: MediaQuery.of(context).size.width * 0.17,
                fit: BoxFit.fill,
              ),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.width * 0.17,
            child: VerticalCharacterStatsListing(
              stats: widget.stats!,
              characterId: widget.characterId,
              direction: Axis.horizontal,
              fontSize: widget.fontSize,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ],
      ),
    );
  }
}
