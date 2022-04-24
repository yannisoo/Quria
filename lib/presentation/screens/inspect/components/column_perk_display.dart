import 'package:quria/constants/styles.dart';
import 'package:quria/data/models/bungie_api_dart/destiny_inventory_item_definition.dart';
import 'package:bungie_api/models/destiny_item_socket_entry_plug_item_randomized_definition.dart';
import 'package:flutter/material.dart';
import 'package:quria/data/models/helpers/inspectHelper.model.dart';
import 'package:quria/data/services/manifest/manifest.service.dart';
import 'package:quria/presentation/components/detailed_item/item/perk_item_display.dart';

class ColumnPerkDisplay extends StatefulWidget {
  const ColumnPerkDisplay({
    required this.item,
    required this.index,
    required this.selectedPerks,
    Key? key,
  }) : super(key: key);
  final DestinyInventoryItemDefinition item;
  final int index;
  final InspectHelper selectedPerks;

  @override
  State<ColumnPerkDisplay> createState() => _ColumnPerkDisplayState();
}

class _ColumnPerkDisplayState extends State<ColumnPerkDisplay> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final List<DestinyItemSocketEntryPlugItemRandomizedDefinition>? sockets =
        ManifestService
            .manifestParsed
            .destinyPlugSetDefinition[widget.item.sockets!
                .socketEntries?[widget.index].randomizedPlugSetHash]
            ?.reusablePlugItems;
    return Column(
      children: [
        if (widget.item.sockets?.socketEntries?[widget.index]
                .randomizedPlugSetHash !=
            null)
          for (int i = 0; i < sockets!.length; i++)
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: globalPadding(context) / 2),
              child: InkWell(
                onTap: () {
                  setState(() {
                    selectedIndex = i;
                    switch (widget.index) {
                      case 1:
                        widget.selectedPerks.firstColumn = ManifestService
                                .manifestParsed.destinyInventoryItemDefinition[
                            sockets[i].plugItemHash]!;
                        break;
                      case 2:
                        widget.selectedPerks.secondColumn = ManifestService
                                .manifestParsed.destinyInventoryItemDefinition[
                            sockets[i].plugItemHash]!;
                        break;
                      case 3:
                        widget.selectedPerks.thirdColumn = ManifestService
                                .manifestParsed.destinyInventoryItemDefinition[
                            sockets[i].plugItemHash]!;
                        break;
                      case 4:
                        widget.selectedPerks.fourthColumn = ManifestService
                                .manifestParsed.destinyInventoryItemDefinition[
                            sockets[i].plugItemHash]!;
                        break;
                    }
                  });
                },
                child: PerkItemDisplay(
                  selected: selectedIndex == i,
                  perk: ManifestService.manifestParsed
                      .destinyInventoryItemDefinition[sockets[i].plugItemHash]!,
                  iconSize: mobileItemSize(context),
                ),
              ),
            ),
        if (widget.item.sockets?.socketEntries?[widget.index]
                .randomizedPlugSetHash ==
            null)
          PerkItemDisplay(
            perk: ManifestService.manifestParsed.destinyInventoryItemDefinition[
                widget.item.sockets?.socketEntries?[widget.index]
                    .singleInitialItemHash]!,
            iconSize: mobileItemSize(context),
            selected: true,
          )
      ],
    );
  }
}
