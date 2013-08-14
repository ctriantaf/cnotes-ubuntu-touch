import QtQuick 2.0
import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1
import Ubuntu.Components.Popups 0.1

Empty {

    id: root

    property string _id
    property string _title
    property string _body
    property string _category

    Subtitled {
        text: _title
        subText: _body
        anchors {
            top: parent.top
            left: parent.left
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                mainView.id = _id
                mainView.title = _title
                mainView.body = _body
                mainView.category = _category
                mainView.position = model.index

                // Show note page
            }

            onPressAndHold: {
                mainView.id = _id
                mainView.title = _title
                mainView.body = _body
                mainView.category = _category
                mainView.position = model.index
                PopupUtils.open(notePopoverComponent, null)
            }
        }
    }

    CheckBox {
        id: doneCheckBox

        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: units.gu(2)
        }

        onCheckedChanged: {
            if (checked) {
                root.opacity = 0.3
            }
            else {
                root.opacity = 1.0
            }
        }
    }
}
