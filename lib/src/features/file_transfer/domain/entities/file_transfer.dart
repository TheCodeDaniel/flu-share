class FileTransfer {
  final String fileName;
  final int fileSize;
  final double progress;
  final String senderId;
  final String receiverId;

  FileTransfer({
    required this.fileName,
    required this.fileSize,
    required this.progress,
    required this.senderId,
    required this.receiverId,
  });
}
