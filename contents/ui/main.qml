// Import the local components - add this line
import "." as Local
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.ksvg as KSvg
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.plasma.plasma5support 2.0 as P5Support
import org.kde.plasma.plasmoid
import org.kde.plasma.private.kicker 0.1 as Kicker

PlasmoidItem {
    id: kicker

    anchors.fill: parent

    signal reset

    property bool isDash: true // Force dashboard mode like tt.launchpadPlasma

    // Category definitions with icons
    property var topCategories: [{
        "id": "All",
        "name": "All",
        "icon": Qt.resolvedUrl("../textures/ui/magnifyingGlass.png"),
        "matches": []
        }, {
        "id": "Favorites",
        "name": "Favorites",
        "icon": Qt.resolvedUrl("../textures/ui/permissions_member_star.png"),
        "matches": []
        }, {
        "id": "System",
        "name": "System",
        "icon": Qt.resolvedUrl("../textures/ui/settings_glyph_color_2x.png"),
        "matches": ["System", "Settings", "Administration", "Core"]
        }, {
        "id": "Utilities",
        "name": "Utilities",
        "icon": Qt.resolvedUrl("../textures/ui/Add-Ons_Nav_Icon36x36.png"),
        "matches": ["Utility", "Accessories", "Accessibility", "TextTools", "Archiving", "Compression", "FileTools", "Calculator", "Clock"]
        }]
        property var bottomCategories: [{
        "id": "Games",
        "name": "Games",
        "icon": Qt.resolvedUrl("../textures/ui/controller_glyph_color_switch.png"),
        "matches": ["Game", "ActionGame", "AdventureGame", "ArcadeGame", "BoardGame", "BlocksGame", "CardGame", "KidsGame", "LogicGame", "RolePlaying", "Shooter", "Simulation", "SportsGame", "StrategyGame"]
        }, {
        "id": "Graphics",
        "name": "Graphics",
        "icon": Qt.resolvedUrl("../textures/ui/mashup_PaintBrush.png"),
        "matches": ["Graphics", "Photography", "RasterGraphics", "VectorGraphics", "2DGraphics", "3DGraphics", "Scanning", "OCR", "ImageProcessing", "Viewer"]
        }, {
        "id": "Internet",
        "name": "Internet",
        "icon": Qt.resolvedUrl("../textures/ui/worldsIcon.png"),
        "matches": ["Network", "WebBrowser", "Email", "InstantMessaging", "Chat", "IRCClient", "FileTransfer", "HamRadio", "News", "P2P", "RemoteAccess", "Telephony", "VideoConference", "WebDevelopment"]
        }, {
        "id": "Multimedia",
        "name": "Multimedia",
        "icon": Qt.resolvedUrl("../textures/ui/camera-yo.png"),
        "matches": ["AudioVideo", "Audio", "Video", "Player", "Recorder", "DiscBurning", "Midi", "Mixer", "Sequencer", "Tuner", "TV", "AudioVideoEditing", "Music"]
        }, {
        "id": "Office",
        "name": "Office",
        "icon": Qt.resolvedUrl("../textures/ui/copy.png"),
        "matches": ["Office", "WordProcessor", "Spreadsheet", "Presentation", "Chart", "ContactManagement", "Database", "Dictionary", "Email", "Finance", "FlowChart", "PDA", "ProjectManagement", "Publishing", "Viewer", "TextEditor", "Publishing"]
        }, {
        "id": "Development",
        "name": "Development",
        "icon": Qt.resolvedUrl("../textures/ui/anvil_icon.png"),
        "matches": ["Development", "IDE", "Debugger", "RevisionControl", "GUIDesigner", "Profiling", "Translation", "WebDevelopment", "Building", "Database"]
    }]
    property string currentCategory: "All"
    property string searchText: ""
    property var favoriteApps: []

    switchWidth: isDash || !fullRepresentationItem ? 0 : fullRepresentationItem.Layout.minimumWidth
    switchHeight: isDash || !fullRepresentationItem ? 0 : fullRepresentationItem.Layout.minimumHeight

    // this is a bit of a hack to prevent Plasma from spawning a dialog on its own when we're Dash
    preferredRepresentation: isDash ? fullRepresentation : null

    compactRepresentation: isDash ? null : Qt.createComponent(Qt.resolvedUrl("./CompactRepresentation.qml"))
    fullRepresentation: Qt.createComponent(Qt.resolvedUrl("./CompactRepresentation.qml"))

    Plasmoid.icon: Plasmoid.configuration.launcherIcon || "grass_block.png"

    function action_menuedit() {
        executable.connectSource("kmenuedit");
    }

    // function reset() {
    //     searchText = "";
    //     currentCategory = "All";
    // }

    function saveFavorites() {
        plasmoid.configuration.favoriteApps = favoriteApps.join(",");
    }

    function toggleFavorite(exec) {
        let index = favoriteApps.indexOf(exec);
        if (index !== -1) {
            // Remove from favorites
            favoriteApps.splice(index, 1);
        } else {
            // Add to favorites - no limit anymore
            favoriteApps.push(exec);
        }
        favoriteApps = favoriteApps; // Trigger property change
        saveFavorites();
    }

    function isFavorite(exec) {
        return favoriteApps.indexOf(exec) !== -1;
    }

    function getFavoriteAppData(desktopFile) {
        if (!desktopFile)
            return null;

        for (let source in appsSource.data) {
            let appData = appsSource.data[source];
            let appDesktopFile = appData.storageId || source;
            if (appDesktopFile === desktopFile) {
                return {
                    name: appData.name,
                    icon: appData.iconName,
                    desktop: appDesktopFile,
                    category: appData.categories ? appData.categories.join(", ") : "",
                    comment: appData.comment || ""
                };
            }
        }
        return null;
    }

    width: Kirigami.Units.gridUnit * 1
    height: Kirigami.Units.gridUnit * 1
    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground

    // Load favorites from config
    Component.onCompleted: {
        let saved = plasmoid.configuration.favoriteApps || "";
        if (saved)
            favoriteApps = saved.split(",");
    }

    // Data source for applications
    P5Support.DataSource {
        id: appsSource

        engine: "apps"
        connectedSources: sources
        onSourceAdded: function(source) {
            connectSource(source);
        }
    }

    P5Support.DataSource {
        id: executable

        engine: "executable"
        onNewData: function(sourceName, data) {
            disconnectSource(sourceName);
        }
    }

    // DataSource for user info and power commands
    P5Support.DataSource {
        id: executable2

        engine: "executable"
        connectedSources: ["whoami"]
        onNewData: function(sourceName, data) {
            if (sourceName !== "whoami")
                disconnectSource(sourceName);
        }
    }

    function getFilteredApps() {
        let apps = [];
        let seenDesktopFiles = {};
        let seenAppNames = {};
        // First pass - collect all apps that match our criteria
        for (let source in appsSource.data) {
            let appData = appsSource.data[source];
            if (appData.name && !appData.NoDisplay) {
                let desktopFile = appData.storageId || source;
                let displayName = appData.name || appData.genericName || source;
                // Skip if we've already seen this desktop file or app name
                if (seenDesktopFiles[desktopFile] || seenAppNames[displayName.toLowerCase()])
                    continue;

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
                        if (appCategory)
                            break;

                    }
                }
                let matchesCategory = false;
                if (currentCategory === "All") {
                    matchesCategory = true;
                } else if (currentCategory === "Favorites") {
                    matchesCategory = favoriteApps.includes(desktopFile);
                } else {
                    // Find the category object
                    let allCategories = topCategories.concat(bottomCategories);
                    let categoryObj = null;
                    for (let i = 0; i < allCategories.length; i++) {
                        if (allCategories[i].id === currentCategory) {
                            categoryObj = allCategories[i];
                            break;
                        }
                    }
                    // Check if app categories match any of the category matches
                    if (categoryObj && categoryObj.matches.length > 0) {
                        let appCategories = appData.categories || "";
                        // Check each match pattern
                        for (let i = 0; i < categoryObj.matches.length; i++) {
                            if (appCategories.indexOf(categoryObj.matches[i]) !== -1) {
                                matchesCategory = true;
                                break;
                            }
                        }
                    }
                }
                let matchesSearch = searchText === "" || displayName.toLowerCase().includes(searchText.toLowerCase());
                if (matchesCategory && matchesSearch) {
                    apps.push({
                        "name": displayName,
                        "icon": appData.iconName || "application-x-executable",
                        "desktop": desktopFile,
                        "category": appCategory,
                        "comment": appData.comment || ""
                    });
                    seenDesktopFiles[desktopFile] = true;
                    seenAppNames[displayName.toLowerCase()] = true;
                }
            }
        }
        // Sort apps alphabetically for consistent ordering
        apps.sort(function(a, b) {
            return a.name.localeCompare(b.name);
        });
        
        // Make sure we have at least 45 items (5 rows × 9 columns)
        // but don't limit maximum to allow scrolling when needed
        while (apps.length < 45)
            apps.push({
                "name": "",
                "icon": "",
                "desktop": ""
            });

        // Ensure apps.length is a multiple of 9 (for clean grid layout)
        let remainder = apps.length % 9;
        if (remainder > 0) {
            for (let i = 0; i < (9 - remainder); i++) {
                apps.push({
                    "name": "",
                    "icon": "",
                    "desktop": ""
                });
            }
        }
        return apps;
    }

    function launchApp(desktopFile) {
        // Simple desktop file launch
        executable.connectSource("gtk-launch " + desktopFile);
    }

}
