import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:notesapp/dataBaseHelper.dart';
import 'package:notesapp/noteModel.dart';

part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit() : super(NotesInitial());
  Future<void> loadNotes() async {
    emit(NotesLoading());
    try {
      final notes = await DatabaseHelper.getNote();
      emit(NotesSuccess(notes));
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> addNote(NoteModel note) async {
    await DatabaseHelper.insertNote(note);
    await loadNotes();
  }

  Future<void> updateNote(NoteModel note) async {
    await DatabaseHelper.updateToNote(note);
    await loadNotes();
  }

  Future<void> deleteNotes(Set<int> ids) async {
    for (final id in ids) {
      await DatabaseHelper.deleteNote(id);
    }
    await loadNotes();
  }
}
