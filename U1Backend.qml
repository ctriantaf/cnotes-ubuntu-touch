import QtQuick 2.0
import U1db 1.0 as U1db
import Ubuntu.Components 0.1

Item {
    property variant db
//    property variant values: {}

    function setNote(id, title, body, tag, category, archive, view) {
        var _id = "'" + id + "'"
        var value = { 'title': title, 'body': body, 'tag': tag, 'category': category, 'archive': archive, 'view': view };
        var values = {};
        values[id] = value;
        mainView.notesDatabase.putDoc(values, "notes")
        return true
    }

    function getTitle(id) {
        return mainView.notesDatabase.getDoc("notes")[id].title
    }

    function getBody(id) {
        var tempValues = {};
        tempValues = db.getDoc("notes")['id'].body
    }

    function getTag(id) {
        var tempValues = {};
        tempValues = db.getDoc("notes")['id'].tag
    }

    function getCategory(id) {
        var tempValues = {};
        tempValues = db.getDoc("notes")['id'].category
    }

    function getArchive(id) {
        var tempValues = {};
        tempValues = db.getDoc("notes")['id'].archive
    }

    function getView(id) {
        var tempValues = {};
        tempValues = db.getDoc("notes")['id'].view
    }
}
