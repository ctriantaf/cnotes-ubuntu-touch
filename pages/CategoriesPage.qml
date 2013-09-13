import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import "../images"

Page {
    id: categoriesPage
    title: i18n.tr("Categories")

    property string name
    property int pos
    property string mode

    tools : ToolbarItems {
        ToolbarButton {
            action: Action {
                id: addCategoryAction
                objectName: "addCategoryAction"

                text: i18n.tr("Add")
                iconSource: Qt.resolvedUrl("../images/add.svg")

                onTriggered: {
                    categoriesPage.name = ""
                    categoriesPage.mode = "add"
                    PopupUtils.open(editCategoriesComponent)
                }
            }
        }
    }

    ListView {
        id: categoriesView
        anchors {
            fill: parent
            margins: units.gu(2)
        }

//        model: categoriesModel
        model: mainView.database.getDoc("categories").categories
        delegate: ListItem.Standard {
            text: mainView.database.getDoc("categories").categories[index]

            onClicked: {
                if (index !== 0) {
//                    categoriesPage.name = categoryName
                    categoriesPage.name = mainView.database.getDoc("categories").categories[index]
                    categoriesPage.pos = index
                    categoriesPage.mode = "edit"
                    PopupUtils.open(editCategoriesComponent)
                }
            }
        }

    }


    Component {
        id: editCategoriesComponent

        Dialog {
            id: editCategoriesDialog
            title: {
                if (categoriesPage.mode == "edit")
                    return i18n.tr("Edit ") + categoriesPage.name
                return i18n.tr("Add category")
            }

            TextField {
                id: editCategoryName
                text: categoriesPage.name
            }

            Button {
                text: i18n.tr("Close")
                onClicked: {
                    if (editCategoryName.text == "") {
                        PopupUtils.close(editCategoriesDialog)
                        return
                    }

                    if (mainView.database.getDoc("categories").categories.length !== 1) {
                        if (categoriesPage.mode == "add") {
                            mainView.backend.addCategory(editCategoryName.text)
                        }
                        else {
                            mainView.backend.replaceCategory(categoriesPage.pos, editCategoryName.text)
                        }
                        categoriesView.model = mainView.database.getDoc("categories").categories
                    }

                    PopupUtils.close(editCategoriesDialog)
                }
            }

            Button {
                text: i18n.tr("Delete")
                onClicked: {
                    if (categoriesPage.mode == "edit") {
                        mainView.backend.removeCategory(categoriesPage.pos)
                        categoriesView.model = mainView.database.getDoc("categories").categories
//                        categoriesModel.remove(categoriesPage.pos)
//                        Storage.removeCategory(name)
                    }
                    PopupUtils.close(editCategoriesDialog)
                }
            }
        }
    }
}
