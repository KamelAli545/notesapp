import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesapp/dataBaseHelper.dart';
import 'package:notesapp/noteModel.dart';
import 'package:notesapp/notes_cubit.dart';

class Editscreen extends StatefulWidget {
  final NoteModel? note;
  const Editscreen({super.key, this.note});

  @override
  State<Editscreen> createState() => _EditscreenState();
}

class _EditscreenState extends State<Editscreen> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      bodyController.text = widget.note!.description;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.note != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Row(
              children: [
                if (isEditing)
                  IconButton(
                    onPressed: () async {
                      final cubit = context.read<NotesCubit>();
                      await cubit.deleteNotes({widget.note!.id!});
                      if (!mounted) return;
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.delete_outline, color: Color(0xFF1B2333)),
                  ),
                FilledButton(
                  onPressed: () async {
                    final cubit = context.read<NotesCubit>();
                    final title = titleController.text.trim();
                    final body = bodyController.text.trim();
                    if (title.isEmpty && body.isEmpty) {
                      Navigator.pop(context);
                      return;
                    }

                    final finalTitle = title.isEmpty ? 'Untitled' : title;

                    if (isEditing) {
                      await cubit.updateNote(NoteModel(widget.note!.id, finalTitle, body));
                    } else {
                      await cubit.addNote(NoteModel(null, finalTitle, body));
                    }
                    if (!mounted) return;
                    Navigator.pop(context);
                  },
                  style: FilledButton.styleFrom(backgroundColor: Color(0xFF1B2333)),
                  child: Text("Save"),
                ),
              ],
            ),          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 4, 20, 16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1B2333),
              ),
              decoration: InputDecoration(
                hintText: "Title",
                border: InputBorder.none,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: TextField(
                controller: bodyController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: TextStyle(
                  fontSize: 17,
                  height: 1.5,
                  color: Color(0xFF1B2333),
                ),
                decoration: InputDecoration(
                  hintText: "Start Writing",
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}