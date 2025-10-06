import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Grid {
    id: staticFavoriteGrid
    property int cellWidth: Kirigami.Units.gridUnit * 3.5
    property int cellHeight: Kirigami.Units.gridUnit * 3.5

    readonly property int numCols: 10 // Force 10 columns
    readonly property int numRows: 1 // Force 1 row
    readonly property int totalCells: numCols * numRows

    columns: numCols
    z: 10

    Repeater {
        model: staticFavoriteGrid.totalCells

        Item {
            width: staticFavoriteGrid.cellWidth
            height: staticFavoriteGrid.cellHeight
            
            Rectangle {
                anchors.fill: parent
                color: "transparent"
                border.color: "#C6C6C6"
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
