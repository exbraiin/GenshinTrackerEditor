import 'package:dartx/dartx.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:gsdatabase/gsdatabase.dart';

class GsEventExt extends GsModelExt<GsEvent> {
  const GsEventExt();

  @override
  List<DataField<GsEvent>> getFields(String? editId) {
    final vd = ValidateModels<GsEvent>();
    final vdVersion = ValidateModels.versions();
    final vdWeapons = ValidateModels<GsWeapon>();
    final vdCharacters = ValidateModels<GsCharacter>();

    return [
      DataField.textField(
        'ID',
        (item) => item.id,
        (item, value) => item.copyWith(id: value),
        validator: (item) => vd.validateItemId(item, editId),
        refresh: DataButton(
          'Generate Id',
          (ctx, item) => item.copyWith(id: expectedId(item)),
        ),
      ),
      DataField.textField(
        'Name',
        (item) => item.name,
        (item, value) => item.copyWith(name: value),
      ),
      DataField.textImage(
        'Image',
        (item) => item.image,
        (item, value) => item.copyWith(image: value),
      ),
      DataField.singleEnum<GsEvent, GeEventType>(
        'Type',
        GeEventType.values.toChips(),
        (item) => item.type,
        (item, value) => item.copyWith(
          type: value,
          dateEnd:
              value == GeEventType.permanent ? GsModelExt.kPermanentDate : null,
        ),
        invalid: [GeEventType.none],
      ),
      DataField.singleSelect(
        'Version',
        (item) => item.version,
        (item) => vdVersion.filters,
        (item, value) {
          final dates = vdVersion.getDates(item.version);
          return item.copyWith(
            version: value,
            dateStart: dates?.$1,
            dateEnd: dates?.$2,
          );
        },
        validator: (item) => vdVersion.validate(item.version),
      ),
      DataField.dateTime(
        'Date Start',
        (item) => item.dateStart,
        (item, value) => item.copyWith(dateStart: value),
        validator: (item) => vdVersion.validateDate(
          item.version,
          item.dateStart,
        ),
      ),
      DataField.dateTime(
        'Date End',
        (item) => item.dateEnd,
        (item, value) => item.copyWith(dateEnd: value),
        validator: (item) => switch (item.type) {
          GeEventType.login => vdDateInterval(item.dateStart, item.dateEnd),
          GeEventType.quest => vdPermanentDate(item.dateEnd),
          GeEventType.permanent => vdPermanentDate(item.dateEnd),
          _ => [
                vdDateInterval(item.dateStart, item.dateEnd),
                vdVersion.validateDate(item.version, item.dateEnd),
              ].maxBy((e) => e.index) ??
              GsValidLevel.none,
        },
      ),
      DataField.multiSelect<GsEvent, String>(
        'Weapon Rewards',
        (item) => item.rewardsWeapons,
        (item) => vdWeapons.filters,
        (item, value) => item.copyWith(rewardsWeapons: value),
        validator: (item) {
          if (_invalidRewards(item)) {
            return GsValidLevel.warn2;
          }
          return vdWeapons.validateAll(item.rewardsWeapons);
        },
      ),
      DataField.multiSelect<GsEvent, String>(
        'Character Rewards',
        (item) => item.rewardsCharacters,
        (item) => vdCharacters.filters,
        (item, value) => item.copyWith(rewardsCharacters: value),
        validator: (item) {
          if (_invalidRewards(item)) {
            return GsValidLevel.warn2;
          }
          return vdCharacters.validateAll(item.rewardsCharacters);
        },
      ),
    ];
  }
}

bool _invalidRewards(GsEvent item) {
  return item.type == GeEventType.flagship &&
      item.rewardsWeapons.isEmpty &&
      item.rewardsCharacters.isEmpty;
}
