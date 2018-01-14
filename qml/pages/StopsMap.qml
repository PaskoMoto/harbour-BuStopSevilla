import QtQuick 2.0
import QtLocation 5.0
import QtPositioning 5.2
import Sailfish.Silica 1.0
import QtGraphicalEffects 1.0
import QtQuick.LocalStorage 2.0
import "../lists"
import "../lists/utils.js" as MyUtils

Page {
    id: stopsMapPage
    backNavigation: true
    allowedOrientations: Orientation.PortraitMask
    transitions: Transition {
        PropertyAnimation { duration: 5; properties: "backNavigation"; easing.type: Easing.InOutQuad }
    }
    SilicaFlickable{
        id: stopsMapPageFlickable
        anchors.fill: parent
        PullDownMenu{
            id: myPullDownMenu
            visible: myLineList.tappedData.length > 0 ? true : false
            transitions: Transition {
                PropertyAnimation { duration: 5; properties: "visible"; easing.type: Easing.Linear }
            }
            MenuItem{
                text: qsTr("See the map")
                onClicked: mapContainer.state = "map open"
            }
        }

        PushUpMenu{
            visible: mapContainer.state === "map open" ? true : false
            MenuItem{
                text: qsTr("Go back")
                onClicked: {
                    stopsMapPage.backNavigation=true
                    pageStack.navigateBack(PageStackAction.Animated)
                }
            }
            MenuItem{
                text: qsTr("Change line")
                onClicked: {
                    mapContainer.state = ""
                }
            }
        }
        PositionSource {
            id: src
            updateInterval: 1000
            active: true
        }
        ListModel{
            id: myStopList
        }
        LineList{
            id: myLineList
            width: parent.width
            height: parent.height
            transitions: Transition {
                PropertyAnimation { duration: 400; properties: "height"; easing.type: Easing.InOutQuad }
            }
            model: ListModel{
                id: ey
            }
            workingMode: 2
            onTappedDataChanged: {
                if (tappedData.length > 0){
                    console.log("tappedData lenght: "+tappedData.length)
                    MyUtils.getStopsData(tappedData[4], myStopList)
                    mapContainer.state = "map open"
                    console.log("Number of stops loaded: "+myStopList.count)
                }
                else{
                    console.log("tappedData still empty")
                }
            }
        }
    }
    Item{
        id: mapContainer
        height: 0
        width: parent.width
        states: [
            State {
                name: "map open"
                PropertyChanges { target: mapContainer; height: parent.height }
                PropertyChanges { target: myLineList; height: 0 }
                PropertyChanges { target: stopsMapPage; backNavigation: false }
                PropertyChanges { target: myPullDownMenu; visible: false }
            }
        ]
        transitions: Transition {
            PropertyAnimation { duration: 400; properties: "height"; easing.type: Easing.InOutQuad }
        }
        Map{
            id: map
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                bottom: safezoneBottom.top
            }
            plugin: Plugin {
                name: "here"
                PluginParameter { name: "app_id"; value: "SATvHCI03dfWJGK1AROi" }
                PluginParameter { name: "app_code"; value: "qsU98SUji0bBsaUhiNJapQ" }
                PluginParameter { name: "proxy"; value: "system" }
            }
            MapCircle{
                id: uncertaintyCircle
                // the center is set by a PressAndHold
                radius: src.position.horizontalAccuracy
                visible: true
                color: 'blue'
                border.width: 0
                opacity: 0.2
                center: src.position.coordinate
            }
            MapQuickItem {
                id:currentPosition
                sourceItem: Item{
                    width: currentPositionIcon.width
                    height: currentPositionIcon.height
                    Image{
                        id:currentPositionIcon
                        source: "image://theme/icon-m-person"
                        visible: false
                    }
                    ColorOverlay{
                        anchors.fill: currentPositionIcon
                        source: currentPositionIcon
                        color: 'red'
                    }
                }
                coordinate: uncertaintyCircle.center
                visible: uncertaintyCircle.visible
                anchorPoint.x: currentPosition.width/2
                anchorPoint.y: currentPosition.height/2
            }
            Component.onCompleted: {
                //                map.center = QtPositioning.coordinate(39.775, -3.845);
                map.center = src.position.coordinate
                console.log("==> "+src.horizontalAccuracy);
                map.zoomLevel = 15;
            }
            MapItemView{
                model: myStopList
                delegate: MapQuickItem {
                    id: stopIconItem
                    sourceItem: BackgroundItem{
                        width: stopIcon.width
                        height: stopIcon.height
                        Image{
                            id: stopIcon
                            source: "image://theme/icon-m-location"
                            visible: false
                        }
                        ColorOverlay{
                            anchors.fill: stopIcon
                            source: stopIcon
                            color: 'blue'
                        }
                        onClicked: {
                            console.log("You clicked on stop "+ stopName + " with stopNumber: " + stopNumber)
                            pythonMain.ask(stopNumber);
                            pageStack.push("StopPage.qml", {current_stop: stopNumber})
                        }
                    }
                    coordinate: QtPositioning.coordinate(latitude, longitude)
                    anchorPoint.x: stopIconItem.width/2
                    anchorPoint.y: stopIconItem.height/2
                }
            }
            MouseArea {
                id:mapMouseArea
                anchors.fill: parent
                preventStealing: true
                onClicked: {
                    console.log("Clic on "+mouseX+", "+mouseY)
                }
            }
        }
        Item{
            id: safezoneBottom
            anchors.bottom: parent.bottom
            width: parent.width
            height: Theme.itemSizeLarge*2
            transitions: Transition {
                PropertyAnimation { duration: 400; properties: "height"; easing.type: Easing.InOutQuad }
            }
            Label{
                id: lineCodeLabel
                anchors {
                    top: parent.top
                    topMargin: Theme.itemSizeExtraSmall/10
                    left: parent.left
                    leftMargin: Theme.itemSizeExtraSmall/2
                }
                color: Theme.primaryColor
                text: qsTr("Line ")+ myLineList.tappedData[0]
                font.pixelSize: Theme.fontSizeLarge
            }
            Item{
                id: resourcesContainer
                visible: false
                anchors{
                    verticalCenter: lineCodeLabel.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }
                width: (busIcon.width+lineResourcesLabel.width)*1.1
                height: lineCodeLabel.height
                Image {
                    id: busIcon
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                    }
                    source: "qrc:///res/bus_icon.png"
                    fillMode: Image.PreserveAspectFit
                    width: Theme.itemSizeExtraSmall/2.2
                }
                Label{
                    id: lineResourcesLabel
                    anchors {
                        right: parent.right
                        bottom: parent.bottom
                    }
                    color: Theme.secondaryColor
                    text: "x "+"3"
                    font.pixelSize: Theme.fontSizeMedium
                }
            }
            Label{
                id: lineScheduleLabel
                anchors {
                    verticalCenter: resourcesContainer.verticalCenter
                    right: parent.right
                    rightMargin: Theme.itemSizeExtraSmall/2
                }
                color: Theme.secondaryColor
                text: "17:00" + " - " + "22:00"
                font.pixelSize: Theme.fontSizeMedium
            }
            Label{
                id: lineNameLabel
                anchors {
                    top: lineCodeLabel.bottom
                    left: parent.left
                    leftMargin: Theme.itemSizeExtraSmall/5
                }
                color: Theme.highlightColor
                text: if (myLineList.tappedData[1]){
                          return myLineList.tappedData[1]
                      }
                      else{
                          return ""
                      }
                truncationMode: TruncationMode.Elide
                font.pixelSize: Theme.fontSizeMedium
            }
        }
    }

    Component.onCompleted: {
        rootPage.current_page = ['StopsMap']
        MyUtils.getLines(ey)
        mapContainer.state = ""
    }
}

