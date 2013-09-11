import QtQuick 2.0
import U1db 1.0 as U1db
import Ubuntu.Components 0.1

Item {

    function setNote(id, title, body, category, tag, archive, view, links, doc) {
        var values
        if (doc === "notes") {
            values = mainView.database.getDoc("notes")
            values["notes"][mainView.database.getDoc("notes").notes.length] = {'id': id, 'title': title, 'body': body,
                                'category': category, 'tag': tag, 'archive': archive, 'view': view, 'links': links}

            mainView.database.putDoc(values, "notes")

            if (mainView.createNote) {
                notesListView.model = mainView.database.getDoc("notes").notes
            }
        }
        else {
            values = mainView.database.getDoc("archive")
            values["notes"][mainView.database.getDoc("archive").notes.length] = {'id': id, 'title': title, 'body': body,
                                'category': category, 'tag': tag, 'archive': archive, 'view': view, 'links': links}

            mainView.database.putDoc(values, "archive")
        }
    }

    function replaceNote(pos, doc, title, body, category, tag, archive, view) {
        pos = parseInt(pos)
        var values = getValues(doc)

        values["notes"][pos].title = title
        values["notes"][pos].body = body
        values["notes"][pos].tag = tag
        values["notes"][pos].category = category
        values["notes"][pos].archive = archive
        values["notes"][pos].view = view

        setValues(values, doc)

        if (mainView.showArchive) {
            notesListView.model = mainView.database.getDoc("archive").notes
        }
        else {
            notesListView.model = mainView.database.getDoc("notes").notes
        }
    }

    function removeNote(id, doc) {

        id = parseInt(id)
        var values = getValues(doc)

        var j = 0
        var newValues = {"notes": []}

        for (var i = 0; i < values.notes.length; i++) {
            if (i !== id) {
                newValues["notes"][j] = values["notes"][i]
                j++
            }
        }

        setValues(newValues, doc)
    }

    function getValues(doc) {
        var values
        if (doc === "notes") {
            values = mainView.database.getDoc("notes")
        }
        else {
            values = mainView.database.getDoc("archive")
        }

        return values
    }

    function setValues(values, doc) {
        if (doc === "notes") {
            mainView.database.putDoc(values, "notes")
        }
        else {
            mainView.database.putDoc(values, "archive")
        }
    }

    function fecthAllNotesWithTag(tag) {
        var res = {"notes": []}
        var archive = mainView.database.getDoc("archive")

        var all = mainView.database.getDoc("notes")
        for (var i = 0; i < archive["notes"].length; i++) {
            all["notes"][all["notes"].length] = archive["notes"][i]
        }

        var j = 0
        for (var i = 0; i < all["notes"].length; i++) {
            if (containTag(tag, all["notes"][i].tag)) {
                res["notes"][j] = all["notes"][i]
                j++
            }
        }

        return res
    }

    function containTag(tag, tags) {
        var t = tags.split(",")
        for (var i = 0; i < t.length; i++) {
            if (tag === t[i]) {
                return true
            }
        }

        return false
    }

    function fetchAllNotesWithCategory(cat) {
        var res = {"notes": []}
        var archive = mainView.database.getDoc("archive")

        var all = mainView.database.getDoc("notes")
        for (var i = 0; i < archive["notes"].length; i++) {
            all["notes"][all["notes"].length] = archive["notes"][i]
        }

        var j = 0
        for (var i = 0; i < all["notes"].length; i++) {
            if (all["notes"][i].category === cat) {
                res["notes"][j] = all["notes"][i]
                j++
            }
        }

        return res
    }

    function deleteArchive() {
        mainView.database.putDoc({"notes" : []}, "archive")
        notesListView.model = mainView.database.getDoc("archive").notes
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
