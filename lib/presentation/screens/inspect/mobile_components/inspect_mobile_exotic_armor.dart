import 'package:bungie_api/enums/tier_type.dart';
import 'package:bungie_api/models/destiny_inventory_item_definition.dart';
import 'package:bungie_api/models/destiny_item_socket_state.dart';
import 'package:flutter/material.dart';
import 'package:quria/constants/styles.dart';
import 'package:quria/data/services/manifest/manifest.service.dart';
import 'package:quria/presentation/detailed_item/item/mod_display.dart';

class InspectMobileExoticArmor extends StatelessWidget {
  final List<DestinyItemSocketState>? sockets;
  const InspectMobileExoticArmor({required this.sockets, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DestinyInventoryItemDefinition item =
        ManifestService.manifestParsed.destinyInventoryItemDefinition![sockets
            ?.firstWhere((element) =>
                ManifestService
                        .manifestParsed
                        .destinyInventoryItemDefinition?[element.plugHash]
                        ?.plug
                        ?.plugCategoryHash ==
                    1744546145 &&
                ManifestService
                        .manifestParsed
                        .destinyInventoryItemDefinition?[element.plugHash]
                        ?.inventory
                        ?.tierType ==
                    TierType.Exotic)
            .plugHash]!;
    return ModDisplay(iconSize: mobileItemSize(context), item: item);
  }
}
