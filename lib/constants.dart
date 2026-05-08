final moods = [
    {'emoji': '😊', 'label': 'Happy'},
    {'emoji': '😢', 'label': 'Sad'},
    {'emoji': '😌', 'label': 'Calm'},
    {'emoji': '🥳', 'label': 'Excited'},
    {'emoji': '😠', 'label': 'Angry'},
    {'emoji': '😰', 'label': 'Anxious'},
    {'emoji': '🙏', 'label': 'Grateful'},
    {'emoji': '💪', 'label': 'Productive'},
    {'emoji': '😴', 'label': 'Tired'},
    {'emoji': '🥰', 'label': 'Loved'},
  ];
  String feelingEmoji(String feeling) {
    switch (feeling) {
      case 'Happy':
        return '😊';
      case 'Sad':
        return '😢';
      case 'Calm':
        return '😌';
      case 'Angry':
        return '😠';
      case 'Excited':
        return '🥳';
      case 'Anxious':
        return '😰';
      case 'Grateful':
        return '💪';
      case 'Productive':
        return '🙏';
      case 'Tired':
        return '😴';
      case 'Loved':
        return '🥰';
      default:
        return '📝';
    }
  }
