/*
 * Copyright (c) 2022 Simform Solutions
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
import 'package:chatview/chatview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

class Message {
  /// Provides id
  final String id;

  /// Used for accessing widget's render box.
  final GlobalKey key;

  /// Provides actual message it will be text or image/audio file path.
  final String message;

  /// Provides message created date time.
  final DateTime createdAt;

  /// Provides id of sender of message.
  final String sendBy;

  /// Provides reply message if user triggers any reply on any message.
  final ReplyMessage replyMessage;

  /// Represents reaction on message.
  final Reaction reaction;

  /// Provides message type.
  final MessageType messageType;

  /// Status of the message.
  final ValueNotifier<MessageStatus> _status;

  /// Provides max duration for recorded voice message.
  Duration? voiceMessageDuration;

  Message({
    this.id = '',
    required this.message,
    required this.createdAt,
    required this.sendBy,
    this.replyMessage = const ReplyMessage(),
    Reaction? reaction,
    this.messageType = MessageType.text,
    this.voiceMessageDuration,
    MessageStatus status = MessageStatus.pending,
  })  : reaction = reaction ?? Reaction(reactions: [], reactedUserIds: []),
        key = GlobalKey(),
        _status = ValueNotifier(status),
        assert(
          (messageType.isVoice
              ? ((defaultTargetPlatform == TargetPlatform.iOS ||
                  defaultTargetPlatform == TargetPlatform.android))
              : true),
          "Voice messages are only supported with android and ios platform",
        );

  /// curret messageStatus
  MessageStatus get status => _status.value;

  /// For [MessageStatus] ValueNotfier which is used to for rebuilds
  /// when state changes.
  /// Using ValueNotfier to avoid usage of setState((){}) in order
  /// rerender messages with new receipts.
  ValueNotifier<MessageStatus> get statusNotifier => _status;

  /// This setter can be used to update message receipts, after which the configured
  /// builders will be updated.
  set setStatus(MessageStatus messageStatus) {
    _status.value = messageStatus;
  }

  Message copyWith({
    String? id,
    String? message,
    DateTime? createdAt,
    String? sendBy,
    ReplyMessage? replyMessage,
    Reaction? reaction,
    MessageType? messageType,
    Duration? voiceMessageDuration,
    MessageStatus? status,
  }) {
    if (status != null) _status.value = status;
    return Message(
      id: id ?? this.id,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      sendBy: sendBy ?? this.sendBy,
      replyMessage: replyMessage ?? this.replyMessage,
      reaction: reaction ?? this.reaction,
      messageType: messageType ?? this.messageType,
      voiceMessageDuration: voiceMessageDuration ?? this.voiceMessageDuration,
      status: this.status,
    );
  }

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json['id'] as String? ?? '',
        message: json['message'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        sendBy: json['sendBy'] as String,
        replyMessage: json['reply_message'] == null
            ? const ReplyMessage()
            : ReplyMessage.fromJson(
                json['reply_message'] as Map<String, dynamic>),
        reaction: json['reaction'] == null
            ? null
            : Reaction.fromJson(json['reaction'] as Map<String, dynamic>),
        messageType:
            $enumDecodeNullable(_$MessageTypeEnumMap, json['message_type']) ??
                MessageType.text,
        voiceMessageDuration: json['voice_message_duration'] == null
            ? null
            : Duration(
                microseconds: (json['voice_message_duration'] as num).toInt()),
        status: $enumDecodeNullable(_$MessageStatusEnumMap, json['status']) ??
            MessageStatus.pending,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'message': message,
        'createdAt': createdAt.toUtc().toIso8601String(),
        'sendBy': sendBy,
        'reply_message': replyMessage.toJson(),
        'reaction': reaction.toJson(),
        'message_type': _$MessageTypeEnumMap[messageType]!,
        'voice_message_duration': voiceMessageDuration?.inMicroseconds,
        'status': _$MessageStatusEnumMap[status]!,
      };
}

const _$MessageTypeEnumMap = {
  MessageType.image: 'image',
  MessageType.text: 'text',
  MessageType.voice: 'voice',
  MessageType.custom: 'custom',
};

const _$MessageStatusEnumMap = {
  MessageStatus.read: 'read',
  MessageStatus.delivered: 'delivered',
  MessageStatus.undelivered: 'undelivered',
  MessageStatus.pending: 'pending',
};
