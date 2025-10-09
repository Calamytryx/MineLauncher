import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
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
    property string category: "" // New property for category
    property string appComment: "" // New property for app comment/description
    
    // Function to determine color based on category
    function categoryColor(category) {
        if (category.includes("Games")) return "#FFFF00"; // Yellow
        if (category.includes("Development")) return "#FF00FF"; // Magenta
        if (category.includes("Internet")) return "#00FFFF"; // Cyan
        if (category.includes("Multimedia")) return "#FF7F00"; // Orange
        if (category.includes("Office")) return "#00FF00"; // Green
        if (category.includes("Graphics")) return "#FF00FF"; // Magenta
        if (category.includes("System")) return "#AAAAFF"; // Light blue
        if (category.includes("Utilities")) return "#AAFFAA"; // Light green
        return "#FFFFFF"; // Default white
    }
    
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
    
    // Enhanced tooltip with color coding and comment
    Rectangle {
        id: tooltip
        visible: hovered && appName !== ""
        parent: slot.Window.window ? slot.Window.window.contentItem : slot
        
        // Position at bottom left of cursor
        x: slot.Window.window ? 
           cursorPosition.x + 5 : 
           slot.width / 2 - width / 2
           
        y: slot.Window.window ? 
           cursorPosition.y + 15 : 
           -height - Kirigami.Units.smallSpacing
        
        z: 999999
        
        // Dynamic width based on content
        width: Math.max(
            Math.min(tooltipNameText.implicitWidth, Kirigami.Units.gridUnit * 25),
            Math.min(tooltipCommentText.implicitWidth, Kirigami.Units.gridUnit * 25)
        ) + Kirigami.Units.gridUnit
        
        // Dynamic height to accommodate both name and comment
        height: tooltipNameText.height + (appComment ? tooltipCommentText.height + Kirigami.Units.smallSpacing : 0) + Kirigami.Units.gridUnit
        
        color: "#170817"
        border.color: "#290560"
        border.width: 5
        
        // Add a second border for extra visibility
        Rectangle {
            anchors.fill: parent
            anchors.margins: -2
            z: -1
            color: "transparent"
            border.color: "#000000"
            border.width: 2
            radius: Kirigami.Units.smallSpacing / 2 + 2
        }
        
        radius: Kirigami.Units.smallSpacing / 2
        
        Column {
            anchors.centerIn: parent
            width: parent.width - Kirigami.Units.gridUnit
            spacing: Kirigami.Units.smallSpacing / 2
            
            Text {
                id: tooltipNameText
                width: parent.width
                text: appName
                color: categoryColor(category)
                font.bold: true
                font.pixelSize: Math.max(Kirigami.Theme.defaultFont.pixelSize * 1.2, slot.height * 0.2)
                horizontalAlignment: Text.AlignLeft
                elide: Text.ElideRight
                wrapMode: Text.NoWrap
            }
            
            Text {
                id: tooltipCommentText
                width: parent.width
                visible: appComment !== ""
                text: appComment
                color: "#AAAAAA" // Gray color for comments
                font.pixelSize: Math.max(Kirigami.Theme.defaultFont.pixelSize * 0.9, slot.height * 0.15)
                horizontalAlignment: Text.AlignLeft
                elide: Text.ElideRight
                wrapMode: Text.WordWrap
                maximumLineCount: 4
            }
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
        onPositionChanged: function(mouse) {
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
