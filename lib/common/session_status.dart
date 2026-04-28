enum SessionStatus {
  notStarted,    // User arrived before appointment time
  inProgress,    // Session is active
  completed,     // Session ended
  expired,       // Session time passed
}

class SessionInfo {
  final SessionStatus status;
  final Duration? remainingToStart;
  final Duration? remainingToEnd;
  final DateTime? sessionStartTime;
  final DateTime? sessionEndTime;

  SessionInfo({
    required this.status,
    this.remainingToStart,
    this.remainingToEnd,
    this.sessionStartTime,
    this.sessionEndTime,
  });
}