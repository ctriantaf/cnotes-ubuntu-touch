import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1
import Ubuntu.Components.Popups 0.1
import "../Storage.js" as Storage
import "../view"

Subtitled {

    id: root
    removable: true
    backgroundIndicator: Label {
        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }

        text: {
            if (_view === "main")
                return i18n.tr("Note will be moved to archive")
            return i18n.tr("Note will be moved back")
        }
    }

//    visible: {
//        print ("_Archive " + _archive + " - showArchive " + mainView.showArchive)
//        print("Condition: " + (_archive === mainView.showArchive))
//        if (_archive === mainView.showArchive) {
//            print('Visible true')
//            return true
//        }
//        print('Visible false')
//        return false
//    }


    property string _id
    property string _title
    property string _body
    property string _tag
    property string _category
    property string _archive
    property string _view
    property string _links

    text: getHtmlText(_title)
    subText: getHtmlText(_body)

    onItemRemoved: {
        if (_view === "main") {
            _archive = 'true'
            _view = "archive"
            Storage.setNote(_id, _title, _body, _category, _tag, _archive, _view, _links)
            archivesModel.append({id:_id, title:_title, body:_body, category:_category, tag:_tag, archive:_archive, view:_view, links:_links})
//            print(notes.count + ' - ' + notesListView.currentIndex)
//            notes.get(notesListView.currentIndex).archive = _archive
//            print("Note archive value (archive): " + notes.get(notesListView.currentIndex).archive)
//            notes.get(notesListView.currentIndex).view = _view
//            notesListView.update()
            notes.remove(notesListView.currentIndex)
            console.debug("Note moved to archive, count: " + archivesModel.count)
        }
        else {
            _archive = 'false'
            _view = "main"
            Storage.setNote(_id, _title, _body, _category, _tag, _archive, _view, _links)
            archivesModel.remove(notesListView.currentIndex)
            notes.insert(_id, {id:_id, title:_title, body:_body, category:_category, tag:_tag, archive:_archive, view:_view, links:_links})
//            notes.get(notesListView.currentIndex).archive = _archive
//            print("Note archive value (back): " + note.get(notesListView.currentIndex).archive)
//            notes.get(notesListView.currentIndex).view = _view
//            notesListView.update()
             console.debug("Note moved back, count: " + notes.count)
        }
    }

    onClicked: {
        mainView.mode = "view"
        mainView.id = _id
        mainView.title = _title
        mainView.body = _body
        mainView.category = _category
        mainView.tag = _tag
        mainView.position = model.index
        mainView.archive = _archive

        if (mainView.wideAspect)
            return

        pageStack.push (Qt.resolvedUrl("../view/NoteView.qml"))
    }
}
