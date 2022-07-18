// ignore_for_file: use_build_context_synchronously

import 'package:bungie_api/enums/tier_type.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:quria/data/models/Item.model.dart';
import 'package:quria/data/models/bungie_api_dart/destiny_inventory_item_definition.dart';
import 'package:bungie_api/models/destiny_item_component.dart';
import 'package:quria/data/models/ArmorMods.model.dart';
import 'package:quria/data/models/BuildResponse.model.dart';
import 'package:quria/data/providers/characters_provider.dart';
import 'package:quria/data/providers/inventory_provider.dart';
import 'package:quria/data/providers/item_provider.dart';
import 'package:quria/data/services/bungie_api/bungie_api.service.dart';
import 'package:quria/data/services/bungie_api/enums/inventory_bucket_hash.dart';
import 'package:quria/data/services/bungie_api/profile.service.dart';
import 'package:quria/data/services/manifest/manifest.service.dart';

class BungieActionsService {
  final api = BungieApiService();
  final profile = ProfileService();
  static final BungieActionsService _singleton = BungieActionsService._internal();
  factory BungieActionsService() {
    return _singleton;
  }
  BungieActionsService._internal();

  Future<void> transferItem(BuildContext context, String itemId, String? characterId,
      {int? itemHash, int? stackSize}) async {
    try {
      final owner = Provider.of<InventoryProvider>(context, listen: false).getItemOwner(itemId);
      if (owner == characterId || owner == null || characterId == null) {
        await api
            .transferItem(itemId, characterId ?? owner,
                itemHash: itemHash, stackSize: stackSize, transferToVault: characterId == null)
            .then(
                (value) => Provider.of<InventoryProvider>(context, listen: false).moveItem(itemId, characterId, false));
      } else {
        await api
            .transferItem(itemId, owner, itemHash: itemHash, stackSize: stackSize, transferToVault: true)
            .then((value) => Provider.of<InventoryProvider>(context, listen: false).moveItem(itemId, null, false));
        await api
            .transferItem(itemId, characterId, itemHash: itemHash, stackSize: stackSize, transferToVault: false)
            .then(
                (value) => Provider.of<InventoryProvider>(context, listen: false).moveItem(itemId, characterId, false));
      }
    } catch (e) {
      try {
        if (characterId == null) rethrow;
        int slotTypeHash = ManifestService
            .manifestParsed.destinyInventoryItemDefinition[itemHash]!.equippingBlock!.equipmentSlotTypeHash!;
        List<DestinyItemComponent> slotItems =
            (Provider.of<InventoryProvider>(context, listen: false).getItemsForCharacter(characterId, slotTypeHash))
                .toSet()
                .toList();
        if (slotItems.length <= 9) {
          await api
              .transferItem(slotItems.first.itemInstanceId!, characterId,
                  itemHash: slotItems.first.itemHash, stackSize: 1, transferToVault: true)
              .then((value) => Provider.of<InventoryProvider>(context, listen: false)
                  .moveItem(slotItems.first.itemInstanceId!, null, false));
          await api
              .transferItem(itemId, characterId, itemHash: itemHash, stackSize: stackSize, transferToVault: false)
              .then((value) =>
                  Provider.of<InventoryProvider>(context, listen: false).moveItem(itemId, characterId, false));
        }
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<void> equipItem(
    BuildContext context, {
    required String itemId,
    required String characterId,
    required int itemHash,
  }) async {
    try {
      final owner = Provider.of<InventoryProvider>(context, listen: false).getItemOwner(itemId);
      if (owner == characterId) {
        await api.equipItem(itemId, characterId).then(
            (value) => Provider.of<InventoryProvider>(context, listen: false).moveItem(itemId, characterId, true));
      } else {
        await transferItem(context, itemId, characterId, itemHash: itemHash, stackSize: 1);
        await api.equipItem(itemId, characterId).then(
            (value) => Provider.of<InventoryProvider>(context, listen: false).moveItem(itemId, characterId, true));
      }
    } catch (e) {
      try {
        await transferItem(
          context,
          itemId,
          characterId,
          itemHash: itemHash,
          stackSize: 1,
        ).then((value) => Provider.of<InventoryProvider>(context, listen: false).moveItem(itemId, characterId, false));
        await api.equipItem(itemId, characterId).then(
            (value) => Provider.of<InventoryProvider>(context, listen: false).moveItem(itemId, characterId, true));
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<void> equipStoredBuild(
    BuildContext context, {
    required List<Item> items,
  }) async {
    List<String> itemsIds = [];
    List<List<int?>> socketsHashes = [];
    List<DestinyItemComponent> characterInventory = [];
    String characterId = Provider.of<CharactersProvider>(context, listen: false).currentCharacter!.characterId!;

    characterInventory
        .addAll(Provider.of<InventoryProvider>(context, listen: false).getCharacterEquipment(characterId));
    characterInventory
        .addAll(Provider.of<InventoryProvider>(context, listen: false).getCharacterInventory(characterId));

    // transfer all items to character
    for (int i = 0; i < items.length; i++) {
      itemsIds.add(items[i].instanceId);
      if (!characterInventory.map((e) => e.itemInstanceId).contains(items[i].instanceId)) {
        await transferItem(
          context,
          items[i].instanceId,
          characterId,
          itemHash: items[i].itemHash,
          stackSize: 1,
        );
      }
    }
    // equip all items
    await api.equipItems(itemsIds, characterId).then((value) {
      for (final id in itemsIds) {
        Provider.of<InventoryProvider>(context, listen: false).moveItem(id, characterId, false);
      }
    }, onError: (_) => null);
    final exoticInstanceId = items
        .firstWhereOrNull((element) =>
            ManifestService.manifestParsed.destinyInventoryItemDefinition[element.itemHash]?.inventory?.tierType ==
            TierType.Exotic)
        ?.instanceId;
    if (exoticInstanceId != null) {
      await api.equipItem(exoticInstanceId, characterId).then((value) {
        for (final id in itemsIds) {
          Provider.of<InventoryProvider>(context, listen: false).moveItem(id, characterId, false);
        }
      }, onError: (_) => null);
    }

    // get armors from build
    final List<Item> armors =
        items.where((element) => InventoryBucket.armorBucketHashes.contains(element.bucketHash)).toList();
    // remove all mods
    // TODO: what if armor has 5 slots?
    for (int i = 0; i < armors.length; i++) {
      for (int index = 0; index < 4; index++) {
        socketsHashes.add((Provider.of<ItemProvider>(context, listen: false).getItemSockets(items[i].instanceId))
            .map((e) => e.plugHash)
            .toList());
        try {
          int hash = ManifestService.manifestParsed.destinyInventoryItemDefinition[items[i].itemHash]!.sockets!
              .socketEntries![index].singleInitialItemHash!;
          if (socketsHashes[i][index] != hash || socketsHashes[i][index] != armors[i].mods[index]) {
            await api.insertSocketPlugFree(armors[i].instanceId, hash, index, characterId);
          }
        } catch (e) {
          continue;
        }
      }
      for (int index = 0; index < 4; index++) {
        try {
          if (socketsHashes[i][index] != armors[i].mods[index]) {
            await api.insertSocketPlugFree(armors[i].instanceId, armors[i].mods[index], index, characterId);
          }
        } catch (e) {
          continue;
        }
      }
    }
    final subclass = items.firstWhereOrNull((element) => InventoryBucket.subclass == element.bucketHash);
    if (subclass != null) {
      for (int i = 0; i < subclass.mods.length; i++) {
        try {
          await api.insertSocketPlugFree(subclass.instanceId, subclass.mods[i], i, characterId);
        } catch (e) {
          continue;
        }
      }
    }
  }

  Future<void> equipBuild(
    BuildContext context, {
    required Build build,
    required String characterId,
    required List<ModSlots> mods,
    required List<DestinyInventoryItemDefinition> subclassMods,
    String? subclassId,
  }) async {
    List<String> itemsIds = [];
    List<List<int?>> socketsHashes = [];
    List<int?> subclassSocketsHashes = [];
    List<DestinyItemComponent> characterInventory = [];
    characterInventory
        .addAll(Provider.of<InventoryProvider>(context, listen: false).getCharacterEquipment(characterId));
    characterInventory
        .addAll(Provider.of<InventoryProvider>(context, listen: false).getCharacterInventory(characterId));

    if (subclassId != null) {
      itemsIds.add(subclassId);
      if (subclassMods.isNotEmpty) {
        subclassSocketsHashes.addAll((Provider.of<ItemProvider>(context, listen: false).getItemSockets(subclassId))
            .map((e) => e.plugHash)
            .toList());
      }
    }
    // transfer all items to character
    for (int i = 0; i < build.equipement.length; i++) {
      itemsIds.add(build.equipement[i].itemInstanceId);
      socketsHashes.add(
          (Provider.of<ItemProvider>(context, listen: false).getItemSockets(build.equipement[i].itemInstanceId))
              .map((e) => e.plugHash)
              .toList());
      if (!characterInventory.map((e) => e.itemInstanceId).contains(build.equipement[i].itemInstanceId)) {
        await transferItem(
          context,
          build.equipement[i].itemInstanceId,
          characterId,
          itemHash: build.equipement[i].hash,
          stackSize: 1,
        );
      }
    }
    // equip all items
    await api.equipItems(itemsIds, characterId).then((value) {
      for (final id in itemsIds) {
        Provider.of<InventoryProvider>(context, listen: false).moveItem(id, characterId, false);
      }
    }, onError: (_) => null);

    // remove all mods
    // TODO: what if armor has 5 slots?
    for (int i = 0; i < 5; i++) {
      for (int index = 0; index < 4; index++) {
        try {
          int hash = ManifestService.manifestParsed.destinyInventoryItemDefinition[build.equipement[i].hash]!.sockets!
              .socketEntries![index].singleInitialItemHash!;
          if (socketsHashes[i][index] != hash && socketsHashes[i][index] != mods[i].items[index]?.hash) {
            await api.insertSocketPlugFree(build.equipement[i].itemInstanceId, hash, index, characterId);
          }
        } catch (e) {
          continue;
        }
      }
    }
    for (int subclassIndex = 0; subclassIndex < subclassMods.length; subclassIndex++) {
      try {
        if (subclassMods[subclassIndex].hash != subclassSocketsHashes[subclassIndex]) {
          await api.insertSocketPlugFree(subclassId!, subclassMods[subclassIndex].hash!, subclassIndex, characterId);
        }
      } catch (e) {
        continue;
      }
    }

    // add new mods
    for (int i = 0; i < 5; i++) {
      try {
        if (socketsHashes[i][0] != build.equipement[i].mod!.hash!) {
          api.insertSocketPlugFree(
              build.equipement[i].itemInstanceId[i], build.equipement[i].mod!.hash!, 0, characterId);
        }
      } catch (e) {
        continue;
      }
      for (int index = 1; index < 5; index++) {
        try {
          if (socketsHashes[i][index] != mods[i].items[index]?.hash) {
            api.insertSocketPlugFree(
                build.equipement[i].itemInstanceId[i], mods[i].items[index]!.hash!, index, characterId);
          }
        } catch (e) {
          continue;
        }
      }
    }
  }
}
