import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';

/// Result of picking an attachment, so the caller can decide how to
/// describe it to the backend (this backend's /api/chat only accepts a
/// text prompt, so attachments are summarized into the prompt text).
class AttachmentResult {
  final String description;
  final File? file;
  AttachmentResult(this.description, this.file);
}

void showAttachmentSheet(BuildContext context, {required void Function(AttachmentResult) onPicked}) {
  final chat = context.read<ChatProvider>();
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.grey[900],
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  _Tile(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onTap: () async {
                      Navigator.pop(ctx);
                      final img = await ImagePicker().pickImage(source: ImageSource.camera);
                      if (img != null) {
                        onPicked(AttachmentResult('[attached photo: ${img.name}]', File(img.path)));
                      }
                    },
                  ),
                  _Tile(
                    icon: Icons.photo,
                    label: 'Photos',
                    onTap: () async {
                      Navigator.pop(ctx);
                      final img = await ImagePicker().pickImage(source: ImageSource.gallery);
                      if (img != null) {
                        onPicked(AttachmentResult('[attached photo: ${img.name}]', File(img.path)));
                      }
                    },
                  ),
                  _Tile(
                    icon: Icons.attach_file,
                    label: 'Files',
                    onTap: () async {
                      Navigator.pop(ctx);
                      final res = await FilePicker.platform.pickFiles();
                      final path = res?.files.single.path;
                      if (path != null) {
                        onPicked(AttachmentResult('[attached file: ${res!.files.single.name}]', File(path)));
                      }
                    },
                  ),
                ],
              ),
              const Divider(color: Colors.white24, height: 32),
              StatefulBuilder(
                builder: (ctx, setState) => SwitchListTile(
                  value: chat.thinkHarder,
                  onChanged: (v) {
                    chat.toggleThinkHarder(v);
                    setState(() {});
                  },
                  title: const Text('Think harder', style: TextStyle(color: Colors.white)),
                  subtitle: const Text(
                    'Adds a step-by-step reasoning hint to your prompt',
                    style: TextStyle(color: Colors.grey),
                  ),
                  secondary: const Icon(Icons.psychology, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _Tile({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white10,
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
