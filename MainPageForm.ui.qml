import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1

import iproapps.besttodolist 1.0

Item {
    id: rootId
    property alias listView: listView
    property alias toolButton: addToDoButton
    property alias toDoTextField: toDoTextField
    property alias newTaskInputRowId: newTaskInputRowId
    property alias createTaskButtonId: createTaskButtonId
    property alias colorPickerId: colorPickerId

    property int colorPickerLeftMargin: 50

    ColumnLayout {
        id: columnLayout
        anchors.fill: parent
        spacing: 30

        ToolButton {
            anchors.leftMargin: 10
            id: addToDoButton
            text: qsTr("+ New To Do")
        }

        Text {
            id: blankListTextId
            anchors.centerIn: parent
            text: qsTr("Good job! Your To-Do list is blank.")
            visible: !listView.count
        }

        RowLayout {
            id: newTaskInputRowId
            visible: false
            anchors.leftMargin: 10
            z: 1
            TextArea {
                id: toDoTextField
                enabled: false
                wrapMode: TextEdit.WordWrap
                Layout.maximumWidth: rootId.width - colorPickerId.width - colorPickerLeftMargin - createTaskButtonId.width
                placeholderText: qsTr("Type new TO DO here...")
            }

            ColorPicker {
                id: colorPickerId
                anchors.leftMargin: colorPickerLeftMargin
                z: 1
            }

            ToolButton {
                id: createTaskButtonId
                text: qsTr("\uE109")
                font.family: "Segoe MDL2 Assets"
                width: 25
                height: 25
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        ListView {
            id: listView
            anchors {left: parent.left; right: parent.right}
            Layout.fillHeight: true
            boundsBehavior: Flickable.StopAtBounds
            highlightRangeMode: ListView.NoHighlightRange
        }
    }
}
