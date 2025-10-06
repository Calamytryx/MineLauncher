import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.ksvg as KSvg
import org.kde.kirigami as Kirigami

import org.kde.plasma.private.kicker 0.1 as Kicker
import org.kde.plasma.plasma5support 2.0 as P5Support

// Import the local components - add this line
import "." as Local

PlasmoidItem {
    id: root
    
    width: Kirigami.Units.gridUnit * 40
    height: Kirigami.Units.gridUnit * 35
    
    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
    
    preferredRepresentation: (plasmoid.configuration.alwaysExpanded && plasmoid.formFactor == PlasmaCore.Types.Horizontal) ? fullRepresentation : compactRepresentation
    
    compactRepresentation: MouseArea {
        width: Kirigami.Units.gridUnit * 1.5
        height: Kirigami.Units.gridUnit * 1.5
            
        Kirigami.Icon {
            anchors.centerIn: parent
            width: plasmoid.configuration.launcherIconSize || Kirigami.Units.iconSizes.large
            height: plasmoid.configuration.launcherIconSize || Kirigami.Units.iconSizes.large
            source: plasmoid.configuration.launcherIcon || "~/.local/share/plasma/plasmoids/mc_inventory/grass_block.png"
        }
        
        onClicked: root.expanded = !root.expanded
    }
    
    fullRepresentation: Item {
        id: fullRep
        anchors.fill: parent
        
        property int contentWidth: Kirigami.Units.gridUnit * 40
        property int contentHeight: Kirigami.Units.gridUnit * 35
        property int minimumWidth: Kirigami.Units.gridUnit * 30
        property int minimumHeight: Kirigami.Units.gridUnit * 25

        Item {
            id: mainContainer
            width: Math.max(parent.width > contentWidth ? contentWidth : parent.width, fullRep.minimumWidth)
            height: Math.max(parent.height > contentHeight ? contentHeight : parent.height, fullRep.minimumHeight)
            anchors.centerIn: parent

            // Top categories outside the main container
            RowLayout {
                id: topCategoriesRow
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                // Make the top tabs overlap the background by adding bottom margin
                anchors.bottomMargin: -2  // Negative margin creates overlap
                height: Kirigami.Units.gridUnit * 3
                spacing: Kirigami.Units.smallSpacing
                z: 100  // Ensure tabs are above the background
                
                // Top categories
                Repeater {
                model: topCategories
                
                    CategoryTab {
                        Layout.preferredWidth: Kirigami.Units.gridUnit * 3
                        Layout.preferredHeight: Kirigami.Units.gridUnit * 3
                        categoryId: modelData.id
                        categoryName: modelData.name
                        categoryIcon: modelData.icon
                        isActive: currentCategory === modelData.id
                        onClicked: currentCategory = modelData.id

                        Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                        border.color: "transparent"
                        border.width: 3
                        antialiasing: false

                            Rectangle {
                                anchors.fill: parent
                                color: "transparent"
                                
                                Rectangle {
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.right: parent.right
                                height: 2
                                color: "#f7f7f7"
                                }
                                
                                Rectangle {
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.bottom: parent.bottom
                                width: 2
                                color: "#f7f7f7"
                                }
                                Rectangle {
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                anchors.right: parent.right
                                height: 2
                                color: "#c6c6c6"
                                }
                                Rectangle {
                                anchors.top: parent.top
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                width: 2
                                color: "#2a2a2a"
                                }
                            }
                        }
                    }
                }

                Item { Layout.fillWidth: true }
            }
            
            // Minecraft-style background (now smaller, containing only search, inventory grid, favorite bar, and scrollbar)
            Rectangle {
                id: backgroundRect
                // Adjust top anchor to allow tabs to overlap
                anchors.top: topCategoriesRow.bottom
                anchors.topMargin: -2
                anchors.left: parent.left
                anchors.right: parent.right
                // Adjust bottom anchor to allow bottom tabs to overlap
                anchors.bottom: bottomCategoriesRow.top
                anchors.bottomMargin: -2
                color: "#C6C6C6"
                z: 90  // Ensure background is below tabs but above other elements
                
                // Border container
                Item {
                    anchors.fill: parent
                    z: 95  // Make borders appear above background

                    // Top border
                    Rectangle {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 2
                        color: "#f7f7f7"
                        z: 96
                    }
                    
                    // Left border
                    Rectangle {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        width: 2
                        color: "#f7f7f7"
                        z: 96
                    }
                    
                    // Bottom border - make slightly thicker and ensure it's above other elements
                    Rectangle {
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 2
                        color: "#2a2a2a"
                        z: 96
                    }
                    
                    // Right border - make slightly thicker and ensure it's above other elements
                    Rectangle {
                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        width: 2
                        color: "#2a2a2a"
                        z: 96
                    }
                }
                
                // Content container
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Kirigami.Units.smallSpacing * 2
                    spacing: Kirigami.Units.smallSpacing
                    
                    // Search row inside the container
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Kirigami.Units.smallSpacing

                        Text {
                            text: currentCategory
                            font.pixelSize: searchField.height
                            color: "#404040"
                            verticalAlignment: Text.AlignVCenter
                            Layout.alignment: Qt.AlignVCenter
                        }
                        
                        Item { Layout.fillWidth: true }
                        
                        // Search button/field
                        Rectangle {
                            Layout.preferredWidth: Kirigami.Units.gridUnit * 9
                            Layout.preferredHeight: Kirigami.Units.gridUnit * 3
                            color: "#8B8B8B"
                            border.color: "#373737"
                            border.width: Kirigami.Units.devicePixelRatio * 2
                            
                            TextField {
                                id: searchField
                                anchors.fill: parent
                                anchors.margins: Kirigami.Units.smallSpacing
                                placeholderText: "🔍 Search"
                                background: Rectangle {
                                    color: "#000000"
                                    opacity: 0.4
                                }
                                color: "#FFFFFF"
                                font.pixelSize: searchField.height * 0.4
                                horizontalAlignment: Text.AlignHLeft
                                onTextChanged: searchText = text
                            }
                        }
                    }
                    
                    // Inventory grid with custom scrollbar
                    Rectangle {
                        id: inventoryContainer
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "#c6c6c6"

                        readonly property int scrollbarWidth: Kirigami.Units.gridUnit * 3.5 * 0.75
                        readonly property int separatorWidth: Kirigami.Units.gridUnit * 3.5 * 0.25
                        readonly property int gridAreaWidth: width - scrollbarWidth - separatorWidth
                        readonly property int favoriteBarHeight: Kirigami.Units.gridUnit * 3.5
                        readonly property int mainGridHeight: Kirigami.Units.gridUnit * 3.5 * 5

                        StaticGrid {
                            id: staticGridDisplay
                            width: inventoryContainer.gridAreaWidth
                            height: inventoryContainer.mainGridHeight
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.margins: Kirigami.Units.smallSpacing
                        }

                        GridView {
                            id: gridView
                            width: inventoryContainer.gridAreaWidth
                            height: inventoryContainer.mainGridHeight
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.margins: Kirigami.Units.smallSpacing
                            clip: true
                            
                            model: getFilteredApps()
                            
                            cellWidth: Kirigami.Units.gridUnit * 3.5
                            cellHeight: Kirigami.Units.gridUnit * 3.5
                            
                            // Force 10 columns
                            property int columns: 10
                            
                            // Enable interaction on the GridView itself
                            interactive: true 
                            
                            // Make any change to contentY instantaneous
                            Behavior on contentY { NumberAnimation { duration: 0 } }
                            
                            delegate: InventorySlot {
                                appName: modelData.name
                                appIcon: modelData.icon
                                appExec: modelData.desktop
                                category: modelData.category || ""
                                appComment: modelData.comment || ""
                                isFavorite: root.isFavorite(modelData.desktop)
                                isFavoriteRow: false
                                onClicked: launchApp(appExec)
                                onRightClicked: root.toggleFavorite(appExec)
                            }
                        }
                        
                        MouseArea {
                            width: gridView.width
                            height: gridView.height
                            anchors.left: gridView.left
                            anchors.top: gridView.top
                            acceptedButtons: Qt.NoButton 
                            z: 10 // Ensure this is above other elements
                            onWheel: {
                                let newY = gridView.contentY
                                if (wheel.angleDelta.y < 0) { // Scroll down
                                    newY += gridView.cellHeight
                                } else if (wheel.angleDelta.y > 0) { // Scroll up
                                    newY -= gridView.cellHeight
                                }
                                // Clamp the position to prevent overscrolling
                                gridView.contentY = Math.max(0, Math.min(newY, gridView.contentHeight - gridView.height))
                            }
                        }

                        // Static favorite grid background
                        StaticFavoriteGrid {
                            width: inventoryContainer.gridAreaWidth
                            height: inventoryContainer.favoriteBarHeight
                            anchors.left: gridView.left
                            anchors.top: gridView.bottom
                            // Use a more visible gap between grid and favorites
                            anchors.topMargin: inventoryContainer.mainGridHeight * 0.05
                        }

                        // Favorite app bar
                        Grid {
                            id: favoriteBar
                            width: inventoryContainer.gridAreaWidth
                            height: inventoryContainer.favoriteBarHeight
                            anchors.left: gridView.left
                            anchors.top: gridView.bottom
                            // Use a more visible gap between grid and favorites
                            anchors.topMargin: inventoryContainer.mainGridHeight * 0.05
                            columns: 10
                            
                            Repeater {
                                model: 10
                                
                                Local.InventorySlot {
                                    property var favoriteApp: index < favoriteApps.length ? getFavoriteAppData(favoriteApps[index]) : null
                                    
                                    appName: favoriteApp ? favoriteApp.name : ""
                                    appIcon: favoriteApp ? favoriteApp.icon : ""
                                    appExec: favoriteApp ? favoriteApp.desktop : ""
                                    category: favoriteApp ? favoriteApp.category || "" : ""
                                    appComment: favoriteApp ? favoriteApp.comment || "" : ""
                                    isFavorite: true
                                    isFavoriteRow: true
                                    onClicked: {
                                        if (appExec) launchApp(appExec)
                                    }
                                    onRightClicked: {
                                        if (appExec) root.toggleFavorite(appExec)
                                    }
                                }
                            }
                        }

                        // Separator wall
                        Rectangle {
                            id: separatorWall
                            width: ((gridView.height / 5) / 4 )
                            height: parent.height
                            anchors.right: scrollbarArea.left
                            anchors.left: gridView.right
                            color: "#C6C6C6"
                        }

                        // Custom Scrollbar
                        Rectangle {
                            id: scrollbarArea
                            width: inventoryContainer.scrollbarWidth
                            height: favoriteBar.height + gridView.height + ((gridView.height / 5) / 4 )
                            anchors.right: parent.right
                            color: "#8b8b8b"

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

                            Rectangle {
                                id: scrollbarHandle
                                width: parent.width * 0.92
                                height: Kirigami.Units.gridUnit * 3.5
                                color: "#5B5B5B"
                                anchors.horizontalCenter: parent.horizontalCenter

                                Rectangle {
                                    anchors.top: parent.top
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    height: 2
                                    color: "#f7f7f7"
                                }
                                
                                Rectangle {
                                    anchors.top: parent.top
                                    anchors.left: parent.left
                                    anchors.bottom: parent.bottom
                                    width: 2
                                    color: "#f7f7f7"
                                }
                                Rectangle {
                                    anchors.bottom: parent.bottom
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    height: 2
                                    color: "#2a2a2a"
                                }
                                Rectangle {
                                    anchors.top: parent.top
                                    anchors.right: parent.right
                                    anchors.bottom: parent.bottom
                                    width: 2
                                    color: "#2a2a2a"
                                }

                                // Calculate Y position based on GridView's scroll with snapping
                                y: {
                                    let scrollableHeight = Math.max(1, gridView.contentHeight - gridView.height)
                                    let handleScrollableHeight = Math.max(1, scrollbarArea.height - height)
                                    
                                    // Make sure position aligns with rows
                                    let rowPosition = Math.round(gridView.contentY / gridView.cellHeight)
                                    let snappedContentY = rowPosition * gridView.cellHeight
                                    
                                    return Math.min(handleScrollableHeight, (snappedContentY / scrollableHeight) * handleScrollableHeight)
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    drag.target: parent
                                    drag.axis: Drag.YAxis
                                    drag.minimumY: 0
                                    drag.maximumY: scrollbarArea.height - parent.height

                                    // Track when dragging starts and ends
                                    property bool isDragging: false
                                    onPressed: isDragging = true
                                    onReleased: isDragging = false
                                    
                                    // Handle drag movement with row snapping
                                    onPositionChanged: {
                                        if (!isDragging) return
                                        
                                        let scrollableHeight = Math.max(1, gridView.contentHeight - gridView.height)
                                        let handleScrollableHeight = Math.max(1, scrollbarArea.height - parent.height)
                                        
                                        // Calculate the scroll ratio from the handle's drag position
                                        let scrollRatio = parent.y / handleScrollableHeight
                                        let rawContentY = scrollRatio * scrollableHeight
                                        
                                        // Snap to grid rows (like the mousewheel does)
                                        let rowPosition = Math.round(rawContentY / gridView.cellHeight)
                                        let snappedContentY = rowPosition * gridView.cellHeight
                                        
                                        // Apply the snapped position to the GridView
                                        gridView.contentY = snappedContentY
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            // Bottom categories outside the main container
            RowLayout {
                id: bottomCategoriesRow
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                // Make the bottom tabs overlap the background by adding top margin
                anchors.topMargin: -2  // Negative margin creates overlap
                height: Kirigami.Units.gridUnit * 3
                spacing: Kirigami.Units.smallSpacing
                z: 100  // Ensure tabs are above the background
                
                // Bottom categories
                Repeater {
                    model: bottomCategories
                    
                    CategoryTab {
                        Layout.preferredWidth: Kirigami.Units.gridUnit * 3
                        Layout.preferredHeight: Kirigami.Units.gridUnit * 3
                        categoryId: modelData.id
                        categoryName: modelData.name
                        categoryIcon: modelData.icon
                        isActive: currentCategory === modelData.id
                        onClicked: currentCategory = modelData.id

                        Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                        border.color: "transparent"
                        border.width: 3
                        antialiasing: false

                            Rectangle {
                                anchors.fill: parent
                                color: "transparent"
                                
                                Rectangle {
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.right: parent.right
                                height: 2
                                color: "transparent"
                                }
                                
                                Rectangle {
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.bottom: parent.bottom
                                width: 2
                                color: "#f7f7f7"
                                }
                                Rectangle {
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                anchors.right: parent.right
                                height: 2
                                color: "#2a2a2a"
                                }
                                Rectangle {
                                anchors.top: parent.top
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                width: 2
                                color: "#2a2a2a"
                                }
                            }
                        }
                        
                    }
                }

                Item { Layout.fillWidth: true }

                // Close button
                Rectangle {
                    Layout.preferredWidth: Kirigami.Units.gridUnit * 3
                    Layout.preferredHeight: Kirigami.Units.gridUnit * 3
                    color: "#8B8B8B"
                    border.color: "#373737"
                    border.width: Kirigami.Units.devicePixelRatio * 2

                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                        border.color: "transparent"
                        border.width: 3
                        antialiasing: false

                            Rectangle {
                                anchors.fill: parent
                                color: "transparent"
                                
                                Rectangle {
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.right: parent.right
                                height: 2
                                color: "transparent"
                                }
                                
                                Rectangle {
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.bottom: parent.bottom
                                width: 2
                                color: "#f7f7f7"
                                }
                                Rectangle {
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                anchors.right: parent.right
                                height: 2
                                color: "#2a2a2a"
                                }
                                Rectangle {
                                anchors.top: parent.top
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                width: 2
                                color: "#2a2a2a"
                                }
                            }
                        }
                    
                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        color: "#FFFFFF"
                        font.pixelSize: Kirigami.Units.gridUnit
                        font.bold: true
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.expanded = false
                        onEntered: parent.color = "#A0A0A0"
                        onExited: parent.color = "#8B8B8B"
                    }
                }
            }
        }
    }
    
    // Data source for applications
    Plasma5Support.DataSource {
        id: appsSource
        engine: "apps"
        connectedSources: sources
        onSourceAdded: function(source) {
            connectSource(source)
        }
    }
    
    // Category definitions with icons
    property var topCategories: [
        { id: "All", name: "All", icon: "view-grid-symbolic", matches: [] },
        { id: "Favorites", name: "Favorites", icon: "starred-symbolic", matches: [] },
        { id: "System", name: "System", icon: "applications-system-symbolic", matches: ["System", "Settings", "Administration", "Core"] },
        { id: "Utilities", name: "Utilities", icon: "applications-utilities-symbolic", matches: ["Utility", "Accessories", "Accessibility", "TextTools", "Archiving", "Compression", "FileTools", "Calculator", "Clock"] }
    ]
    
    property var bottomCategories: [
        { id: "Games", name: "Games", icon: "applications-games-symbolic", matches: ["Game", "ActionGame", "AdventureGame", "ArcadeGame", "BoardGame", "BlocksGame", "CardGame", "KidsGame", "LogicGame", "RolePlaying", "Shooter", "Simulation", "SportsGame", "StrategyGame"] },
        { id: "Graphics", name: "Graphics", icon: "applications-graphics-symbolic", matches: ["Graphics", "Photography", "RasterGraphics", "VectorGraphics", "2DGraphics", "3DGraphics", "Scanning", "OCR", "ImageProcessing", "Viewer"] },
        { id: "Internet", name: "Internet", icon: "applications-internet-symbolic", matches: ["Network", "WebBrowser", "Email", "InstantMessaging", "Chat", "IRCClient", "FileTransfer", "HamRadio", "News", "P2P", "RemoteAccess", "Telephony", "VideoConference", "WebDevelopment"] },
        { id: "Multimedia", name: "Multimedia", icon: "applications-multimedia-symbolic", matches: ["AudioVideo", "Audio", "Video", "Player", "Recorder", "DiscBurning", "Midi", "Mixer", "Sequencer", "Tuner", "TV", "AudioVideoEditing", "Music"] },
        { id: "Office", name: "Office", icon: "applications-office-symbolic", matches: ["Office", "WordProcessor", "Spreadsheet", "Presentation", "Chart", "ContactManagement", "Database", "Dictionary", "Email", "Finance", "FlowChart", "PDA", "ProjectManagement", "Publishing", "Viewer", "TextEditor", "Publishing"] },
        { id: "Development", name: "Development", icon: "applications-development-symbolic", matches: ["Development", "IDE", "Debugger", "RevisionControl", "GUIDesigner", "Profiling", "Translation", "WebDevelopment", "Building", "Database"] }
    ]
    
    property string currentCategory: "All"
    property string searchText: ""
    property var favoriteApps: []
    
    // Load favorites from config
    Component.onCompleted: {
        let saved = plasmoid.configuration.favoriteApps || ""
        if (saved) {
            favoriteApps = saved.split(",")
        }
    }
    
    function saveFavorites() {
        plasmoid.configuration.favoriteApps = favoriteApps.join(",")
    }
    
    function toggleFavorite(exec) {
        let index = favoriteApps.indexOf(exec)
        if (index !== -1) {
            favoriteApps.splice(index, 1)
        } else {
            favoriteApps.push(exec)
        }
        favoriteApps = favoriteApps // Trigger property change
        saveFavorites()
    }
    
    function isFavorite(exec) {
        return favoriteApps.indexOf(exec) !== -1
    }
    
    function getFavoriteAppData(desktopFile) {
        if (!desktopFile) return null
        
        for (let source in appsSource.data) {
            let appData = appsSource.data[source]
            if ((appData.storageId || source) === desktopFile) {
                // Determine category
                let appCategory = "";
                let categories = appData.categories || "";
                let allCategories = topCategories.concat(bottomCategories);
                
                for (let i = 0; i < allCategories.length; i++) {
                    let categoryObj = allCategories[i];
                    for (let j = 0; j < categoryObj.matches.length; j++) {
                        if (categories.indexOf(categoryObj.matches[j]) !== -1) {
                            appCategory = categoryObj.id;
                            break;
                        }
                    }
                    if (appCategory) break;
                }
                
                return {
                    name: appData.name || appData.genericName || source,
                    icon: appData.iconName || "application-x-executable",
                    desktop: desktopFile,
                    category: appCategory,
                    comment: appData.comment || ""
                }
            }
        }
        return null
    }
    
    function getFilteredApps() {
        let apps = []
        let seenDesktopFiles = {}
        let seenAppNames = {}
        
        // First pass - collect all apps that match our criteria
        for (let source in appsSource.data) {
            let appData = appsSource.data[source]
            if (appData.name && !appData.NoDisplay) {
                let desktopFile = appData.storageId || source
                let displayName = appData.name || appData.genericName || source
                
                // Skip if we've already seen this desktop file or app name
                if (seenDesktopFiles[desktopFile] || seenAppNames[displayName.toLowerCase()]) {
                    continue
                }
                
                // Determine category
                let appCategory = "";
                if (currentCategory !== "All" && currentCategory !== "Favorites") {
                    appCategory = currentCategory;
                } else {
                    // Try to determine category from app data
                    let categories = appData.categories || "";
                    let allCategories = topCategories.concat(bottomCategories);
                    
                    for (let i = 0; i < allCategories.length; i++) {
                        let categoryObj = allCategories[i];
                        for (let j = 0; j < categoryObj.matches.length; j++) {
                            if (categories.indexOf(categoryObj.matches[j]) !== -1) {
                                appCategory = categoryObj.id;
                                break;
                            }
                        }
                        if (appCategory) break;
                    }
                }
                
                let matchesCategory = false
                
                if (currentCategory === "All") {
                    matchesCategory = true
                } else if (currentCategory === "Favorites") {
                    matchesCategory = favoriteApps.includes(desktopFile)
                } else {
                    // Find the category object
                    let categoryObj = null
                    let allCategories = topCategories.concat(bottomCategories)
                    for (let i = 0; i < allCategories.length; i++) {
                        if (allCategories[i].id === currentCategory) {
                            categoryObj = allCategories[i]
                            break
                        }
                    }
                    
                    // Check if app categories match any of the category matches
                    if (categoryObj && categoryObj.matches.length > 0) {
                        let appCategories = appData.categories || ""
                        
                        // Check each match pattern
                        for (let i = 0; i < categoryObj.matches.length; i++) {
                            if (appCategories.indexOf(categoryObj.matches[i]) !== -1) {
                                matchesCategory = true
                                break
                            }
                        }
                    }
                }
                
                let matchesSearch = searchText === "" || 
                    displayName.toLowerCase().includes(searchText.toLowerCase())
                
                if (matchesCategory && matchesSearch) {
                    apps.push({
                        name: displayName,
                        icon: appData.iconName || "application-x-executable",
                        desktop: desktopFile,
                        category: appCategory,
                        comment: appData.comment || ""
                    })
                    seenDesktopFiles[desktopFile] = true
                    seenAppNames[displayName.toLowerCase()] = true
                }
            }
        }
        
        // Sort apps alphabetically for consistent ordering
        apps.sort((a, b) => a.name.localeCompare(b.name));
        
        // Make sure we have at least 50 items (5 rows × 10 columns)
        // but don't limit maximum to allow scrolling when needed
        while (apps.length < 50) {
            apps.push({
                name: "",
                icon: "",
                desktop: ""
            })
        }
        
        // Ensure apps.length is a multiple of 10 (for clean grid layout)
        let remainder = apps.length % 10;
        if (remainder > 0) {
            for (let i = 0; i < (10 - remainder); i++) {
                apps.push({
                    name: "",
                    icon: "",
                    desktop: ""
                });
            }
        }
        
        return apps
    }
    
    function launchApp(desktopFile) {
        // Simple desktop file launch
        executable.connectSource("gtk-launch " + desktopFile)
    }
    
    Plasma5Support.DataSource {
        id: executable
        engine: "executable"
        onNewData: function(sourceName, data) {
            disconnectSource(sourceName)
        }
    }
}