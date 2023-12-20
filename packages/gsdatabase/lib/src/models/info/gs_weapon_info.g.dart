// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gs_weapon_info.dart';

// **************************************************************************
// Generator: BuilderGeneratorGen
// **************************************************************************

class GsWeaponInfo extends GsModel<GsWeaponInfo> {
  @override
  final String id;
  final String effectName;
  final String effectDesc;
  final String matWeapon;
  final String matCommon;
  final String matElite;
  final GeWeaponAscStatType ascStatType;
  final String ascAtkValues;
  final String ascStatValues;

  /// Creates a new [GsWeaponInfo] instance.
  GsWeaponInfo({
    required this.id,
    required this.effectName,
    required this.effectDesc,
    required this.matWeapon,
    required this.matCommon,
    required this.matElite,
    required this.ascStatType,
    required this.ascAtkValues,
    required this.ascStatValues,
  });

  /// Creates a new [GsWeaponInfo] instance from the given map.
  GsWeaponInfo.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        effectName = m['effect_name'] as String? ?? '',
        effectDesc = m['effect_desc'] as String? ?? '',
        matWeapon = m['mat_weapon'] as String? ?? '',
        matCommon = m['mat_common'] as String? ?? '',
        matElite = m['mat_elite'] as String? ?? '',
        ascStatType = GeWeaponAscStatType.values.fromId(m['asc_stat_type']),
        ascAtkValues = m['asc_atk_values'] as String? ?? '',
        ascStatValues = m['asc_stat_values'] as String? ?? '';

  /// Copies this model with the given parameters.
  @override
  GsWeaponInfo copyWith({
    String? id,
    String? effectName,
    String? effectDesc,
    String? matWeapon,
    String? matCommon,
    String? matElite,
    GeWeaponAscStatType? ascStatType,
    String? ascAtkValues,
    String? ascStatValues,
  }) {
    return GsWeaponInfo(
      id: id ?? this.id,
      effectName: effectName ?? this.effectName,
      effectDesc: effectDesc ?? this.effectDesc,
      matWeapon: matWeapon ?? this.matWeapon,
      matCommon: matCommon ?? this.matCommon,
      matElite: matElite ?? this.matElite,
      ascStatType: ascStatType ?? this.ascStatType,
      ascAtkValues: ascAtkValues ?? this.ascAtkValues,
      ascStatValues: ascStatValues ?? this.ascStatValues,
    );
  }

  /// Creates a [JsonMap] from this model.
  @override
  JsonMap toMap() {
    return {
      'id': id,
      'effect_name': effectName,
      'effect_desc': effectDesc,
      'mat_weapon': matWeapon,
      'mat_common': matCommon,
      'mat_elite': matElite,
      'asc_stat_type': ascStatType.id,
      'asc_atk_values': ascAtkValues,
      'asc_stat_values': ascStatValues,
    };
  }
}
