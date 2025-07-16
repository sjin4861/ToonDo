/// 슬라임 캐릭터의 인삿말 및 메시지를 관리하는 클래스
class SlimeGreetings {
  static const List<String> morningGreetings = [
    "좋은 아침이야! 오늘도 화이팅! 💪",
    "일찍 일어났네! 멋져! ✨",
    "새로운 하루가 시작됐어! 😊",
    "아침 햇살처럼 밝은 하루 되길! ☀️",
    "오늘도 목표를 향해 달려보자! 🎯"
  ];

  static const List<String> afternoonGreetings = [
    "점심 맛있게 먹었어? 😋",
    "오후도 파이팅! 💪",
    "휴식도 중요해! 잠깐 쉬어가자 ☕",
    "반나절이 지났네! 수고했어! 👏",
    "오후 시간도 알차게 보내자! 📚"
  ];

  static const List<String> eveningGreetings = [
    "하루 종일 고생했어! 🌙",
    "저녁 시간이야! 맛있는 거 먹자! 🍽️",
    "오늘 하루도 수고 많았어! ✨",
    "편안한 저녁 시간 보내! 🛋️",
    "내일을 위해 푹 쉬어! 😴"
  ];

  static const List<String> motivationalMessages = [
    "할 수 있어! 너는 최고야! 🌟",
    "포기하지 마! 조금만 더! 💪",
    "작은 진걸음도 큰 걸음이야! 👣",
    "오늘도 한 걸음 성장했어! 📈",
    "꿈을 향해 계속 나아가자! 🚀",
    "실패는 성공의 어머니라고 했잖아! 💡",
    "너의 노력을 내가 알고 있어! 👀",
    "休息도 성장의 일부야! 🌱"
  ];

  static const List<String> celebrationMessages = [
    "와! 목표를 달성했네! 축하해! 🎉",
    "정말 대단해! 자랑스러워! 🏆",
    "완벽해! 너무 멋져! ✨",
    "이런 걸 해내다니! 놀라워! 😲",
    "최고야! 계속 이런 식으로! 🌟"
  ];

  static const List<String> encouragementMessages = [
    "괜찮아, 다음엔 더 잘할 수 있을 거야! 💪",
    "실수는 배움의 기회야! 😊",
    "포기하지 마! 아직 시간이 있어! ⏰",
    "천천히 해도 괜찮아! 🐌",
    "나는 네가 할 수 있다고 믿어! 🤗"
  ];

  static const List<String> randomGreetings = [
    "안녕! 오늘 기분이 어때? 😊",
    "반가워! 보고 싶었어! 💚",
    "오늘도 함께 할 수 있어서 기뻐! ✨",
    "뭔가 재미있는 일 없을까? 🤔",
    "새로운 도전 준비됐어? 🎯",
    "오늘 날씨가 좋네! 기분도 좋아져! ☀️",
    "뭔가 특별한 일이 생길 것 같아! ✨",
    "함께라면 못할 게 없어! 👫"
  ];

  static const List<String> clickReactionMessages = [
    "어? 날 클릭했네! 반가워! 😊",
    "헤헤, 간지러워~ 😆",
    "놀고 싶어? 나도! 🎮",
    "터치 감사해! 힘이 나! ✨",
    "우리 친구 맞지? 💚",
    "또 만져봐! 재미있어! 😄",
    "깜짝! 깨워줘서 고마워! 😴→😊",
    "클릭할 때마다 기분이 좋아져! 🌟",
    "장난치고 싶구나? 좋아! 😸",
    "이렇게 놀아주니까 즐거워! 🥳"
  ];

  static const List<String> interactionMessages = [
    "뭔가 할 일이 있어? 도와줄게! 💪",
    "집중력이 떨어지면 나를 봐! 👀",
    "잠깐 쉬어가도 괜찮아! 🛌",
    "수고하고 있구나! 멋져! 👏",
    "힘들 때는 나와 이야기해! 💬",
    "오늘도 열심히 하는 모습이 보기 좋아! 📚",
    "가끔은 스트레칭도 해! 🧘‍♀️",
    "물 마시는 것도 잊지 마! 💧"
  ];

  /// 현재 시간에 맞는 인삿말을 반환
  static List<String> getGreetingsByTime() {
    final hour = DateTime.now().hour;
    
    if (hour >= 5 && hour < 12) {
      return morningGreetings;
    } else if (hour >= 12 && hour < 18) {
      return afternoonGreetings;
    } else {
      return eveningGreetings;
    }
  }

  /// 모든 인삿말을 하나의 리스트로 반환
  static List<String> getAllGreetings() {
    return [
      ...morningGreetings,
      ...afternoonGreetings,
      ...eveningGreetings,
      ...motivationalMessages,
      ...celebrationMessages,
      ...encouragementMessages,
      ...randomGreetings,
      ...clickReactionMessages,
      ...interactionMessages,
    ];
  }

  /// 클릭 반응 메시지 반환
  static String getClickReactionMessage() {
    final messages = List<String>.from(clickReactionMessages);
    messages.shuffle();
    return messages.first;
  }

  /// 상호작용 메시지 반환
  static String getInteractionMessage() {
    final messages = List<String>.from(interactionMessages);
    messages.shuffle();
    return messages.first;
  }

  /// 랜덤 인삿말 반환
  static String getRandomGreeting() {
    final allGreetings = List<String>.from(getAllGreetings());
    allGreetings.shuffle();
    return allGreetings.first;
  }

  /// 시간대별 랜덤 인삿말 반환
  static String getTimeBasedGreeting() {
    final greetings = List<String>.from(getGreetingsByTime());
    greetings.shuffle();
    return greetings.first;
  }
}
