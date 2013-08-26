import QtQuick 2.0
import "../components"
import "../pages"

ListView {
    id: archivesView
    anchors {
        fill: parent
        margins: units.gu(2)
    }

    onCurrentIndexChanged: mainView.archivePos = archivesView.currentIndex

    model: archivesModel
    delegate: NoteItem {
        _id: id
        _title: title
        _body: {
            if (body.length > 80)
                return body.substring(0, 80) + "..."
            return body
        }

        _tag: tag
        _category: category
        _archive: archive

        onPressAndHold: {
            PopupUtils.open(archiveRemoveComponent, null)
        }
    }
}
