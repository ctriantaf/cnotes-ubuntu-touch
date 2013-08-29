import QtQuick 2.0
import DirParser 1.0

Rectangle {

    width: 360
    height: 360
    Text {
        text: qsTr("Hello World")
        anchors.centerIn: parent
    }
    DirParser {
        id: dir
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            console.log("Does mydir1 exist? "+dir.dirExists("mydir1"))
            console.log("Did I manage to create mydir1? "+dir.createDirectory("mydir1"))
            console.log("Did I manage to delete mydir1? "+dir.removeDir("mydir1"))
            console.log("What files exist where I stand? "+dir.fetchAllFiles("."))
        }
    }
}
