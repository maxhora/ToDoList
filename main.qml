import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.2

ApplicationWindow {
    id: rootId
    visible: true
    width: 640
    height: 480

    header: ToolBar {
        ToolButton {
            text: qsTr("About")
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            onClicked: aboutDialogId.open()
        }
        Text {
            text: pageIndicator.currentIndex == 0 ? qsTr("To-Do") : qsTr("Done")
            anchors.centerIn: parent
            font.bold: true
        }

        ToolButton {
            text: pageIndicator.currentIndex == 0 ? qsTr("Done") : qsTr("To-Do")
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            onClicked: swipeViewId.setCurrentIndex(pageIndicator.currentIndex == 0 ? 1 : 0)
        }
    }

    Dialog {
        id: aboutDialogId
        contentItem: AboutDialog {
            id: aboutContentItemId
            anchors.fill: parent
            okButton.onClicked: {
                aboutDialogId.close()
            }
        }
        standardButtons: StandardButton.Ok
    }

    SwipeView {
        id: swipeViewId

        currentIndex: pageIndicator.currentIndex
        anchors.fill: parent

        MainPage {
        }

        DonePage {

        }
    }

    PageIndicator {
          id: pageIndicator
          interactive: true
          count: swipeViewId.count
          currentIndex: swipeViewId.currentIndex

          anchors.bottom: parent.bottom
          anchors.horizontalCenter: parent.horizontalCenter
      }

}
