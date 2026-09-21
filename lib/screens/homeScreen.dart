import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesapp/dataBaseHelper.dart';
import 'package:notesapp/noteModel.dart';
import 'package:notesapp/notes_cubit.dart';
import 'package:notesapp/screens/editScreen.dart';
import 'package:notesapp/screens/widgets/NoteCard.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<NoteModel> notes = [
    ];
  bool isSelecting=false;
  Set<int> selectedIds={};
  final searchController = TextEditingController();
  String searchQuery = '';


  Future<void>loadNotes() async{
    final result=await DatabaseHelper.getNote();
    if(!mounted)return;
    setState(() {
      notes=result;
    });
}
  @override
  void initState() {
    super.initState();
    loadNotes();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.trim().toLowerCase();
      });
    });
  }
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
  List<NoteModel> _filter(List<NoteModel> notes) {
    if (searchQuery.isEmpty) return notes;
    return notes.where((note) {
      return note.title.toLowerCase().contains(searchQuery) ||
          note.description.toLowerCase().contains(searchQuery);
    }).toList();
  }
  void _enterSelectionMode() {
    setState(() {
      isSelecting = true;
    });
  }

  void _toggleSelection(int id) {
    setState(() {
      if (selectedIds.contains(id)) {
        selectedIds.remove(id);
      } else {
        selectedIds.add(id);
      }
    });
  }

  void _cancelSelection() {
    setState(() {
      isSelecting = false;
      selectedIds = {};
    });
  }
  void _deleteSelected() {
    context.read<NotesCubit>().deleteNotes(selectedIds);
    _cancelSelection();
  }
  @override
  Widget build(BuildContext context) {
    List<Widget> left = [];
    List<Widget> right = [];
    final state = context.watch<NotesCubit>().state;
    final notes = state is NotesSuccess ? state.notes : <NoteModel>[];
    final list = _filter(notes);

    for (int i = 0; i < list.length; i++) {
      final note = list[i];
      final id = note.id!;
      final selected = selectedIds.contains(id);
      final card = Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: Notecard(
        note: note,
        isSelected: selected,
        onTap: () {
          if(isSelecting){
            _toggleSelection(id);
            return;
          }
          Navigator.push(
            context, MaterialPageRoute(
              builder: (_)=>Editscreen(note:note)),
          );
        },
        onLongPress: () async{
          if (!isSelecting) {
            _enterSelectionMode();
            _toggleSelection(id);
          }
        },
        )
      );

      if (i.isEven) {
        left.add(card);
      } else {
        right.add(card);
      }
    }
    return Scaffold(
      floatingActionButton: isSelecting?
      null:
      FloatingActionButton.extended(
          onPressed:()async{
            await Navigator.push(
                context, MaterialPageRoute
              (builder: (_)=>Editscreen()));
          },
      backgroundColor: Color(0xFF1B2333),
        foregroundColor: Colors.white,
        icon: Icon(Icons.add),
        label: Text("New Note"),
      ),
      body: SafeArea(
          child: Padding(
              padding: EdgeInsetsGeometry.fromLTRB(16,20,16,0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if(isSelecting)
                    TextButton(onPressed: _cancelSelection,
                        child: Text("Cancel",
                        style: TextStyle(
                          color: Color(0xFF1B2333)
                        ),))
                else
                  Text("Notes",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1B2333),
                ),),
                  if (isSelecting)
                    (selectedIds.isNotEmpty
                        ? TextButton(
                      onPressed: _deleteSelected,
                      child: Text("Delete",
                          style: TextStyle(color: Colors.red)),
                    )
                        : SizedBox.shrink())
                  else if (notes.isNotEmpty)
                    TextButton(
                      onPressed: _enterSelectionMode,
                      child: Text("Select",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1B2333))),
                    ),
                ],
                ),
                if (isSelecting)
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      '${selectedIds.length} selected',
                      style: TextStyle(
                        color: Color(0xFF6B7385),
                        fontSize: 14,
                      ),
                    ),
                  )
                else
                  Text(
                    '${notes.length} notes',
                    style: TextStyle(
                      color: Color(0xFF6B7385),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                SizedBox(height: 20),
                if (!isSelecting)
                  TextField(

                    controller: searchController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Search Notes',
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: searchQuery.isNotEmpty?
                      IconButton(onPressed: ()=>searchController.clear(),
                          icon: Icon(Icons.clear)
                      ):null,
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                SizedBox(height: 30),
                Expanded(
                   child: state is NotesLoading?
    Center(child: CircularProgressIndicator(),
    )
        : state is NotesError?
    Center(child: Text(state.message),):
    (list.isEmpty&& searchQuery.isNotEmpty)?
        Center(child: Text("No notes found",
        style: TextStyle(color: Color(0xFF6B7385)),
        ),
        ):
                   SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 96),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Column(children: left)),
                        SizedBox(width: 12),
                        Expanded(child: Column(children: right)),
                      ],
                    ),
                  ),
                )

              ],
            ),
          )),
    );
  }
}
