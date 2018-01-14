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
    backNavigation: false
    allowedOrientations: Orientation.PortraitMask
    SilicaFlickable{
        id: stopsMapPageFlickable
        anchors.fill: parent
        PushUpMenu{
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
                    safezoneBottom.height = Theme.itemSizeLarge*5;
                    MyUtils.getLines(ey)
                }
            }
        }
        PositionSource {
            id: src
            updateInterval: 1000
            active: true
        }
        Item{
            id: safezoneTop
            anchors.top: parent.top
            width: parent.width
//            height: (lineCodeLabel.height + lineNameLabel.height)*1.1
            height: 0
        }
        Item{
            id: safezoneBottom
            anchors.bottom: parent.bottom
            width: parent.width
            height: Theme.itemSizeLarge*2
            Label{
                id: lineCodeLabel
                anchors {
                    top: parent.top
                    topMargin: Theme.itemSizeExtraSmall/10
                    left: parent.left
                    leftMargin: Theme.itemSizeExtraSmall/2
                }
                color: Theme.primaryColor
                text: qsTr("Line ")+"3"
                //font.bold: true
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
                    //font.bold: true
                    font.pixelSize: Theme.fontSizeMedium
                }
            }
            Label{
                id: lineScheduleLabel
                anchors {
                    bottom: lineCodeLabel.bottom
                    right: parent.right
                    rightMargin: Theme.itemSizeExtraSmall/2
                }
                color: Theme.secondaryColor
                text: "17:00" + " - " + "22:00"
                //font.bold: true
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
                text: qsTr("De tu casa a la mía")
                truncationMode: TruncationMode.Elide
                //font.bold: true
                font.pixelSize: Theme.fontSizeMedium
            }
            LineList{
                id: testing
                anchors.fill: parent
                model: ListModel{
                    id: ey
                }
            }
        }
}
        Map{
            id: map
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                topMargin: safezoneTop.height
            }
            height: stopsMapPage.height - safezoneBottom.height - safezoneTop.height
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
            MouseArea {
                id:mapMouseArea
                anchors.fill: parent
                preventStealing: true
                onClicked: {
                    console.log("Clic on "+mouseX+", "+mouseY)
                }
            }
        }

    Component.onCompleted: {
        rootPage.current_page = ['StopsMap']
    }
}

