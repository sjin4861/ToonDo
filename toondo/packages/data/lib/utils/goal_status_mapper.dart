

import 'package:data/models/goal_status_enum.dart';
import 'package:domain/entities/status.dart';

class GoalStatusMapper {
  static GoalStatusEnum fromDomain(Status status) {
    switch (status) {
      case Status.completed:
        return GoalStatusEnum.completed;
      case Status.givenUp:
        return GoalStatusEnum.givenUp;
      case Status.active:
      default:
        return GoalStatusEnum.active;
    }
  }

  static Status toDomain(GoalStatusEnum enumValue) {
    switch (enumValue) {
      case GoalStatusEnum.completed:
        return Status.completed;
      case GoalStatusEnum.givenUp:
        return Status.givenUp;
      case GoalStatusEnum.active:
      default:
        return Status.active;
    }
  }
}
