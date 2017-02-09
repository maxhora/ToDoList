import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1
import QtQml.Models 2.2

Item {
    property alias visualModel: visualModelId
    property ListView listView

    DelegateModel {
            id: visualModelId
            delegate: dragDelegate
        }

    Component {
            id: dragDelegate

            MouseArea {
                id: dragArea

                property bool held: false
                property string itemcolor: object.color
                property real backgroundOpacity: 0.8

                anchors { left: parent.left; right: parent.right }
                height: content.height

                drag.target: held ? content : undefined
                drag.axis: Drag.YAxis
                drag.minimumY: 0
                drag.maximumY: listView.contentHeight - dragArea.height

                onPressAndHold: held = true
                onReleased: held = false
                onClicked: {
                    textAreaId.inEditMode = false
                    Qt.inputMethod.hide()
                }

                Rectangle {
                    id: content
                    height: textAreaId.height
                    width: parent.width
                    color: itemcolor
                    opacity: dragArea.backgroundOpacity

                    anchors {
                        verticalCenter: parent.verticalCenter
                    }

                    Drag.active: dragArea.held
                    Drag.source: dragArea
                    Drag.hotSpot.x: width / 2
                    Drag.hotSpot.y: height / 2

                    states: State {
                        when: dragArea.held

                        ParentChange { target: content; parent: listView }
                        AnchorChanges {
                            target: content
                            anchors { horizontalCenter: undefined; verticalCenter: undefined }
                        }
                    }

                    RowLayout {
                        id: rowId
                        anchors.verticalCenter: parent.verticalCenter

                        CheckBox {
                            id: checkboxId
                            checked: object.done

                            onCheckStateChanged: {
                                object.done = checked
                            }
                        }

                        TextArea {
                            id: textAreaId
                            property bool inEditMode: false

                            font.bold: true
                            font.strikeout: checkboxId.checked
                            text: object.title
                            readOnly: !inEditMode
                            wrapMode: TextEdit.WordWrap
                            Layout.maximumWidth: dragArea.width - checkboxId.width - deleteTaskButtonId.width - dragIndicatorTextId.width

                            background: Rectangle {
                                border.color: textAreaId.readOnly ?  "transparent" : "#000000"
                                color: "transparent"
                            }

                            MouseArea {
                                anchors.fill: parent
                                enabled: textAreaId.inEditMode !== true
                                visible: textAreaId.inEditMode !== true

                                onPressAndHold: {
                                    dragArea.held = true
                                }

                                onReleased: dragArea.held = false

                                drag.target: dragArea.held ? content : undefined
                                drag.axis: Drag.YAxis
                                drag.minimumY: 0
                                drag.maximumY: listView.contentHeight - dragArea.height
                            }

                            onEditingFinished: {
                                inEditMode = false
                                object.title = text
                                Qt.inputMethod.hide()
                            }
                        }
                    }

                    Button {
                        id: editTaskButtonId
                        text: textAreaId.inEditMode ? qsTr("\uE8FB") : qsTr("\uE104")
                        font.family: "Segoe MDL2 Assets"
                        visible: !object.done
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: dragIndicatorTextId.right
                        anchors.rightMargin: 40
                        background: Rectangle {
                                  anchors.fill: parent
                                  color: editTaskButtonId.down ? "#99eeeeee" : "transparent"
                        }
                        onReleased: {
                            if (textAreaId.inEditMode) {
                                textAreaId.inEditMode = false
                                object.title = textAreaId.text
                                Qt.inputMethod.hide()
                            } else {
                                textAreaId.inEditMode = true
                                textAreaId.selectAll()
                                listView.positionViewAtIndex(index, ListView.Beginning)
                            }
                        }
                    }

                    Button {
                        id: deleteTaskButtonId
                        text: qsTr("\uE74D")
                        font.family: "Segoe MDL2 Assets"
                        visible: object.done
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: dragIndicatorTextId.right
                        anchors.rightMargin: 40
                        background: Rectangle {
                                  anchors.fill: parent
                                  color: deleteTaskButtonId.down ? "#99eeeeee" : "transparent"
                              }
                        onReleased: {
                            backend.deleteCompletedTask(object)
                        }
                    }

                    Text {
                        id: dragIndicatorTextId
                        text: qsTr("\uE700")
                        font.family: "Segoe MDL2 Assets"
                        anchors.right: parent.right
                        width: 40
                        height: 40
                        horizontalAlignment: Qt.AlignHCenter
                        verticalAlignment: Qt.AlignVCenter

                        anchors.verticalCenter: parent.verticalCenter
                        color: dragArea.held ? "white" : "black"
                        Behavior on color { ColorAnimation { duration: 100 } }
                    }
                }
                DropArea {
                    anchors { fill: parent }

                    onEntered: {
                        object.order = drag.source.DelegateModel.itemsIndex
                        visualModel.items.move(
                                drag.source.DelegateModel.itemsIndex,
                                dragArea.DelegateModel.itemsIndex)
                    }
                }
            }
        }

}
