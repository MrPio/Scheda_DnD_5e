// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../npc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Npc _$NpcFromJson(Map<String, dynamic> json) => Npc(
      name: json['name'],
      description: json['description'],
      relationship:
          $enumDecodeNullable(_$RelationshipEnumMap, json['relationship']),
    );

Map<String, dynamic> _$NpcToJson(Npc instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'relationship': _$RelationshipEnumMap[instance.relationship],
    };

const _$RelationshipEnumMap = {
  Relationship.alleato: 'alleato',
  Relationship.amico: 'amico',
  Relationship.animale: 'animale',
  Relationship.base: 'base',
  Relationship.boss: 'boss',
  Relationship.divinita: 'divinita',
  Relationship.famiglia: 'famiglia',
  Relationship.locandiere: 'locandiere',
  Relationship.maestro: 'maestro',
  Relationship.mostriciattolo: 'mostriciattolo',
  Relationship.nemesi: 'nemesi',
  Relationship.nemico: 'nemico',
  Relationship.patrono: 'patrono',
};
