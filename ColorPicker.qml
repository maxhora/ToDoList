import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1

Item {
    id: rootId

    width: gridViewId.width
    height: gridViewId.height
    property string  selectedColor: "#d5f7ae"

    ListModel {
        id: colorModelId

        ListElement {
            name: "#d5f7ae"
        }
        ListElement {
            name: "#f5d3bb"
        }
        ListElement {
            name: "#d5d0f8"
        }
        ListElement {
            name: "#dadbda"
        }
        ListElement {
            name: "#ea6d5b"
        }
        ListElement {
            name: "#f25213"
        }
        ListElement {
            name: "pink"
        }
        ListElement {
            name: "#57a9e0"
        }
        ListElement {
            name: "#f0db13"
        }
    }

    ListModel {
        id: selectedColorModelId

        ListElement {
            name: "#d5f7ae"
        }
    }

    GridView {

        id: gridViewId
        property bool selected: true
        width: selected ? 30 : 90
        height: selected ? 30 : 90
        cellWidth: 30; cellHeight: 30
        focus: true
        model: selected ? selectedColorModelId : colorModelId

        Rectangle {
            anchors.fill: parent
            border.color: "black"
            color: "transparent"
        }

        delegate: Item {
            width: 30; height: 30

            Rectangle {
                anchors.fill: parent
                color: gridViewId.selected ? rootId.selectedColor : name
                border.width: 2
                border.color: "white"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("Color " +  name + " clicked")
                        rootId.selectedColor = name
                        gridViewId.selected = !gridViewId.selected
                    }
                }
            }
        }
    }
}
