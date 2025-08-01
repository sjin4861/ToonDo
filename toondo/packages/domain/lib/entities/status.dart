enum Status {
  active, // 목표가 진행 중
  paused, // 목표가 일시 정지됨 (보류 상태)
  completed, // 목표를 완료함
  givenUp, // 목표를 포기함
  failed,
  restarted, inProgress, // 목표를 다시 시작함 (포기했다가 재개한 경우)
}