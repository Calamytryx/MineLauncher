import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Grid {
    id: staticGrid
    property int cellWidth: Kirigami.Units.gridUnit * 3.5
    property int cellHeight: Kirigami.Units.gridUnit * 3.5

    readonly property int numCols: 10 // Force 10 columns
    readonly property int numRows: 5 // Force 5 rows
    readonly property int totalCells: numCols * numRows

    columns: numCols
    z: 9999999

    Repeater {
        model: staticGrid.totalCells

        Item {
            width: staticGrid.cellWidth
            height: staticGrid.cellHeight
            
            Rectangle {
                anchors.fill: parent
                color: "transparent"
                border.color: "transparent"
                border.width: 3
                antialiasing: false

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 1
                    color: "transparent"
                    
                    Rectangle {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 2
                        color: "#2a2a2a"
                    }
                    
                    Rectangle {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        width: 2
                        color: "#2a2a2a"
                    }
                    Rectangle {
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 2
                        color: "#f7f7f7"
                    }
                    Rectangle {
                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        width: 2
                        color: "#f7f7f7"
                    }
                }
            }
        }
    }
}
