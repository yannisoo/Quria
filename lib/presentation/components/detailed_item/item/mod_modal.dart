import 'package:bungie_api/enums/destiny_item_type.dart';
import 'package:quria/data/models/bungie_api_dart/destiny_inventory_item_definition.dart';
import 'package:flutter/material.dart';
import 'package:quria/constants/styles.dart';
import 'package:quria/constants/texts.dart';
import 'package:quria/data/models/bungie_api_dart/destiny_sandbox_perk_definition.dart';
import 'package:quria/data/services/manifest/manifest.service.dart';
import 'package:quria/presentation/components/detailed_item/item/armor_mod_icon_display.dart';
import 'package:quria/presentation/components/detailed_item/item/stat_progress_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ModModal extends StatefulWidget {
  final DestinyInventoryItemDefinition mod;
  final double width;
  final void Function()? onSocketChange;
  const ModModal(
      {required this.mod, this.onSocketChange, Key? key, required this.width})
      : super(key: key);

  @override
  State<ModModal> createState() => _ModModalState();
}

class _ModModalState extends State<ModModal> {
  DestinySandboxPerkDefinition? perkItem;
  @override
  Widget build(BuildContext context) {
    if (widget.mod.perks != null && widget.mod.perks!.isNotEmpty) {
      perkItem = ManifestService.manifestParsed
          .destinySandboxPerkDefinition[widget.mod.perks?[0].perkHash];
    }
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            color: black),
        child: Column(children: [
          Padding(
            padding: EdgeInsets.only(
                top: globalPadding(context),
                left: globalPadding(context),
                right: globalPadding(context)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ArmorModIconDisplay(
                      iconSize: itemSize(context, widget.width),
                      socket: widget.mod,
                    ),
                    SizedBox(width: globalPadding(context)),
                    SizedBox(
                      width: vw(context) -
                          itemSize(context, widget.width) -
                          (globalPadding(context) * 3) -
                          40,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textH3(perkItem?.displayProperties?.name ??
                              widget.mod.displayProperties?.name ??
                              ""),
                          textBodyRegular(widget.mod.itemTypeDisplayName ?? "")
                        ],
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const CircleAvatar(
                    backgroundColor: blackLight,
                    child: Icon(Icons.clear, size: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: blackLight,
            height: 22,
            thickness: 1,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: globalPadding(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textBodyRegular(perkItem?.displayProperties?.description ??
                    widget.mod.displayProperties?.description ??
                    ""),
                const Divider(
                  color: blackLight,
                  height: 22,
                  thickness: 1,
                ),
                Builder(
                  builder: ((context) {
                    List<Widget> list = [];
                    if (widget.mod.investmentStats?.isNotEmpty ?? false) {
                      for (var stat in widget.mod.investmentStats!) {
                        list.add(StatProgressBar(
                            width: vw(context),
                            name: ManifestService
                                    .manifestParsed
                                    .destinyStatDefinition[stat.statTypeHash]!
                                    .displayProperties!
                                    .name ??
                                'error',
                            value: stat.value?.abs() ?? 0,
                            type: DestinyItemType.Armor));
                      }
                      list.add(
                        const Divider(
                          color: blackLight,
                          height: 22,
                          thickness: 1,
                        ),
                      );
                    }
                    return Column(children: list);
                  }),
                ),
                if (widget.onSocketChange != null)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onSocketChange!();
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        fixedSize: Size(
                            vw(context) - globalPadding(context) * 2,
                            (vw(context) - globalPadding(context) * 2) * 0.147),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    child: textBodyMedium(
                      AppLocalizations.of(context)!.equip,
                      color: black,
                      utf8: false,
                    ),
                  ),
                SizedBox(
                  height: globalPadding(context),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
