import QtQuick 2.0
import U1db 1.0 as U1db
import Ubuntu.Components 0.1

Item {

    function setNote(title, body, tag, category, archive, view, links, doc) {
        var values
        if (doc === "notes") {
            values = mainView.database.getDoc("notes")
            values["notes"][mainView.database.getDoc("notes").notes.length] = {'title': title, 'body': body,
                                'category': category, 'tag': tag, 'archive': archive, 'view': view, 'links': links}

            mainView.database.putDoc(values, "notes")
            console.debug(notesListView.model.length)
            notesListView.model = mainView.database.getDoc("notes").notes
        }
        else {
            values = mainView.database.getDoc("archive")
            values["notes"][mainView.database.getDoc("archive").notes.length] = {'title': title, 'body': body,
                                'category': category, 'tag': tag, 'archive': archive, 'view': view, 'links': links}

            mainView.database.putDoc(values, "archive")
        }
    }

    function removeNote(id, docId) {
        var values
        id = parseInt(id)
        if (docId === "notes") {
            values = mainView.database.getDoc("notes")
        }
        else {
            values = mainView.database.getDoc("archive")
        }

        var j = 0
        var newValues = {"notes": []}

        for (var i = 0; i < values.notes.length; i++) {
            if (i !== id) {
                newValues["notes"][j] = values["notes"][i]
                j++
            }
        }

        replaceValues(newValues, docId)
    }

    function replaceValues(values, doc) {
        if (doc === "notes") {
            mainView.database.putDoc(values, "notes")
        }
        else {
            mainView.database.putDoc(values, "archive")
        }
    }

    function addCategory(name) {
        var values = mainView.database.getDoc("categories")
        values["categories"][values.categories.length] = name
        mainView.database.putDoc(values, "categories")
    }

    function replaceCategory(index, name) {
        var values = mainView.database.getDoc("categories")
        values["categories"][index] = name
        mainView.database.putDoc(values, "categories")
    }

    function removeCategory(index) {
        var values = mainView.database.getDoc("categories")
        var newValues = {"categories": []}
        var j = 0
        for (var i = 0; i < values.categories.length; i++) {
            if (index !== i) {
                newValues["categories"][j] = values["categories"][i]
                j++
            }
        }

        mainView.database.putDoc(newValues, "categories")
    }
}
