import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import "Storage.js" as Storage

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
                iconSource: Qt.resolvedUrl("images/add.svg")

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

        model: categoriesModel
        delegate: ListItem.Standard {
            text: categoryName

            onClicked: {
                if (categoryName !== i18n.tr("None")) {
                    categoriesPage.name = categoryName
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
                    return i18n.tr("Edit ") + name
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
                    if (categoriesModel.count != 0) {
                        if (categoriesPage.mode == "add") {
                            categoriesModel.append({categoryName: editCategoryName.text})
                            Storage.addCategory(editCategoryName.text)
                        }
                        else {
                            categoriesModel.remove(categoriesPage.pos)
                            categoriesModel.insert(categoriesPage.pos, {categoryName: editCategoryName.text})
                            Storage.replaceCategory(name, editCategoryName.text)
                        }
                    }

                    PopupUtils.close(editCategoriesDialog)
                }
            }

            Button {
                text: i18n.tr("Delete")
                onClicked: {
                    if (categoriesPage.mode == "edit") {
                        categoriesModel.remove(categoriesPage.pos)
                        Storage.removeCategory(name)
                    }
                    PopupUtils.close(editCategoriesDialog)
                }
            }
        }
    }
}
