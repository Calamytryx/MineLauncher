import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.ksvg as KSvg
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root
    
    width: Kirigami.Units.gridUnit * 40
    height: Kirigami.Units.gridUnit * 35
    
    Plasmoid.backgroundHints: PlasmaCore.Types.DefaultBackground
    
    preferredRepresentation: fullRepresentation
    
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
    
    function getFilteredApps() {
        let apps = []
        let seenDesktopFiles = {}
        
        for (let source in appsSource.data) {
            let appData = appsSource.data[source]
            if (appData.name && !appData.NoDisplay) {
                let desktopFile = appData.storageId || source
                
                // Skip if we've already seen this desktop file
                if (seenDesktopFiles[desktopFile]) {
                    continue
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
                
                let displayName = appData.name || appData.genericName || source
                let matchesSearch = searchText === "" || 
                    displayName.toLowerCase().includes(searchText.toLowerCase())
                
                if (matchesCategory && matchesSearch) {
                    apps.push({
                        name: displayName,
                        icon: appData.iconName || "application-x-executable",
                        desktop: desktopFile
                    })
                    seenDesktopFiles[desktopFile] = true
                }
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
    
    fullRepresentation: Item {
        Layout.preferredWidth: Kirigami.Units.gridUnit * 40
        Layout.preferredHeight: Kirigami.Units.gridUnit * 35
        Layout.minimumWidth: Kirigami.Units.gridUnit * 30
        Layout.minimumHeight: Kirigami.Units.gridUnit * 25
        
        // Minecraft-style background
        Rectangle {
            anchors.fill: parent
            color: "#C6C6C6"
            border.color: "#373737"
            border.width: Kirigami.Units.devicePixelRatio * 2
            
            // Inner shadow effect
            Rectangle {
                anchors.fill: parent
                anchors.margins: Kirigami.Units.devicePixelRatio * 2
                color: "transparent"
                border.color: "#FFFFFF"
                border.width: Kirigami.Units.devicePixelRatio
                opacity: 0.3
            }
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Kirigami.Units.smallSpacing * 2
                spacing: Kirigami.Units.smallSpacing
                
                // Top row: categories + search
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Kirigami.Units.smallSpacing
                    
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
                        }
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
                            font.pixelSize: Kirigami.Theme.defaultFont.pixelSize
                            horizontalAlignment: Text.AlignHLeft
                            onTextChanged: searchText = text
                        }
                    }
                }
                
                // Inventory grid
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#8B8B8B"
                    border.color: "#373737"
                    border.width: 2
                    
                    ScrollView {
                        id: scrollView
                        anchors.fill: parent
                        anchors.margins: Kirigami.Units.smallSpacing
                        clip: true
                        
                        Flow {
                            width: scrollView.availableWidth
                            spacing: 0
                            
                            Repeater {
                                model: getFilteredApps()
                                
                                InventorySlot {
                                    appName: modelData.name
                                    appIcon: modelData.icon
                                    appExec: modelData.desktop
                                    isFavorite: root.isFavorite(modelData.desktop)
                                    onClicked: launchApp(appExec)
                                    onRightClicked: root.toggleFavorite(appExec)
                                }
                            }
                        }
                    }
                }

                // Bottom row: other categories + close
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Kirigami.Units.smallSpacing
                    
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
                            anchors.margins: Kirigami.Units.devicePixelRatio
                            color: "transparent"
                            border.color: "#7B7B7B"
                            border.width: Kirigami.Units.devicePixelRatio
                            opacity: 0.5
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
    }
}