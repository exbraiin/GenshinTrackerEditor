import 'package:dartx/dartx.dart';
import 'package:gsdatabase/gsdatabase.dart';

extension GsAchievementGroupExt on GsAchievementGroup {
  bool equalsTo(GsAchievementGroup other) {
    if (this == other) return true;
    return id == other.id &&
        name == other.name &&
        icon == other.icon &&
        version == other.version &&
        namecard == other.namecard &&
        order == other.order &&
        rewards == other.rewards &&
        achievements == other.achievements;
  }
}

extension GsAchievementExt on GsAchievement {
  int get reward => phases.sumBy((element) => element.reward);

  bool equalsTo(GsAchievement other) {
    if (this == other) return true;
    return id == other.id &&
        group == other.group &&
        hidden == other.hidden &&
        name == other.name &&
        type == other.type &&
        version == other.version &&
        phases.length == other.phases.length &&
        phases.compareWith(other.phases, (a, b) => a.equalsTo(b));
  }
}

extension GsAchievementPhaseExt on GsAchievementPhase {
  bool equalsTo(GsAchievementPhase other) {
    if (this == other) return true;
    return id == other.id && desc == other.desc && reward == other.reward;
  }
}

extension IterableExt<E> on Iterable<E> {
  bool compareWith(Iterable<E> other, bool Function(E a, E b) compare) {
    if (length != other.length) return false;
    final itA = iterator;
    final itB = other.iterator;

    while (true) {
      final canMove = itA.moveNext() && itB.moveNext();
      if (!canMove) break;
      if (!compare(itA.current, itB.current)) return false;
    }
    return true;
  }
}
