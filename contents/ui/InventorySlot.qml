import QtQuick
import QtQuick.Layouts
import QtQuick.Controls // Add this import for Popup
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

Item {
    id: slot
    
    property string appName: ""
    property string appIcon: ""
    property string appExec: ""
    property bool hovered: false
    property bool isFavorite: false
    property bool isFavoriteRow: false
    property point cursorPosition: Qt.point(0, 0)
    
    signal clicked()
    signal rightClicked()
    
    width: Kirigami.Units.gridUnit * 3.5
    height: Kirigami.Units.gridUnit * 3.5
    
    // Slot background
    Rectangle {
        id: slotBg
        anchors.fill: parent
        color: "transparent"
        
        Behavior on color {
            ColorAnimation { duration: 100 }
        }
        
        // Inner rectangle
        Rectangle {
            id: innerBorders
            anchors.fill: parent
            anchors.margins: 1  // Small margin to avoid overlap with parent border
            color: "#8B8B8B"
        }
        
        // App icon
        Kirigami.Icon {
            anchors.centerIn: parent
            width: Kirigami.Units.iconSizes.large
            height: Kirigami.Units.iconSizes.large
            source: appIcon
            smooth: true
        }
        
        // Favorite star indicator (only show if not in favorite row)
        Text {
            visible: isFavorite && !isFavoriteRow
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: Kirigami.Units.smallSpacing / 2
            text: "⭐"
            font.pixelSize: Kirigami.Units.gridUnit * 0.7
            z: 10
        }
    }
    
    // Revert to simpler tooltip that works reliably
    Rectangle {
        id: tooltip
        visible: hovered && appName !== ""
        parent: slot.Window.window ? slot.Window.window.contentItem : slot // Position at window level
        
        // Position at bottom left of cursor
        x: slot.Window.window ? 
           cursorPosition.x + 5 : 
           slot.width / 2 - width / 2
           
        y: slot.Window.window ? 
           cursorPosition.y + 15 : 
           -height - Kirigami.Units.smallSpacing
        
        z: 999999
        
        // Make tooltip bigger
        width: Math.max(tooltipText.width + Kirigami.Units.gridUnit, slot.width * 2)
        height: slot.height * 0.75
        
        // Nearly opaque background
        color: "#170817"
        
        // Much more visible border
        border.color: "#290560"
        border.width: 2          // Border width of 2 pixels
        
        // Add a second border for extra visibility
        Rectangle {
            anchors.fill: parent
            anchors.margins: -2  // Negative margin to create outer border
            z: -1
            color: "transparent"
            border.color: "#000000"  // Black outer border
            border.width: 2
            radius: Kirigami.Units.smallSpacing / 2 + 2
        }
        
        radius: Kirigami.Units.smallSpacing / 2
        
        Text {
            id: tooltipText
            anchors.centerIn: parent
            text: appName
            color: "#FFFFFF"
            font.bold: true
            width: Math.min(implicitWidth, Kirigami.Units.gridUnit * 25)
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
        }
    }
    
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        
        onEntered: hovered = true
        onExited: hovered = false
        
        // Track cursor position
        onPositionChanged: {
            if (hovered) {
                // Convert local mouse position to global window coordinates
                let globalPos = mapToItem(slot.Window.window ? slot.Window.window.contentItem : slot, mouse.x, mouse.y)
                cursorPosition = globalPos
            }
        }
        
        onClicked: function(mouse) {
            if (mouse.button === Qt.RightButton) {
                slot.rightClicked()
            } else {
                slot.clicked()
            }
        }
    }
}
