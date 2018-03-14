import QtQuick 2.2
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "utils.js" as MyUtils

SilicaListView{
        id: stopsListView
        clip: true
        anchors{
            right: parent.right
            left: parent.left
            bottom: parent.bottom
            top: parent.bottom
        }
        spacing: 0
        model: ListModel{
            id: stopsListModel
        }
        section{
            property: "stopSection"
            criteria: ViewSection.FullString
            delegate: Column{
                width: parent.width
                Label{
                    width: parent.width*0.9
                    anchors.left: parent.left
                    anchors.leftMargin: Theme.itemSizeExtraSmall/10
                    text: "> > > "+section
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeLarge
                    truncationMode: TruncationMode.Fade
                }
                Item{
                    width: parent.width
                    height: Theme.itemSizeExtraSmall/10
                }
                Separator {
                    color: Theme.secondaryColor
                    height: Theme.itemSizeExtraSmall/50
                    width: parent.width*0.6
                }
                Item{
                    width: parent.width
                    height: Theme.itemSizeExtraSmall/10
                }
            }
        }
        delegate: ListItem {
            width: ListView.view.width
            Label{
                id: stopLabel
                width: Theme.itemSizeSmall*9/12
                anchors{
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: Theme.itemSizeExtraSmall/6
                }
                text: stopNumber
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeMedium
                font.bold: true
            }

            Label{
                anchors{
                    verticalCenter: parent.verticalCenter
                    left: stopLabel.right
                    leftMargin: Theme.itemSizeExtraSmall/5
                }
                text: stopName
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
                truncationMode: TruncationMode.Fade
                width: parent.width*0.8
            }
            onClicked: {
                console.log("Clic on bus stop "+stopNumber)
                pythonMain.ask(stopNumber);
                pageStack.replaceAbove(pageStack.previousPage(pageStack.previousPage()),"../pages/StopPage.qml", {current_stop: stopNumber})
            }
            menu: ContextMenu {
                MenuItem {
                    text: qsTr("Add to usual stops")
                    onClicked: addUsual(stopNumber, stopName)
                }
            }
        }
        function addUsual(code,name){
        console.log("Adding "+code+" to usual stops")
        var db = LocalStorage.openDatabaseSync("bustopsevillaDB","1.0","Internal data for hitmemap! app.",1000000)
        db.transaction(
          function(tx){
              var r1 = tx.executeSql('INSERT INTO usual_nodes VALUES (NULL,?,?,NULL)',[code,"->"+name])
          }
          )
        isUsual(code);
        }
        function isUsual(code){
        var db = LocalStorage.openDatabaseSync("bustopsevillaDB","1.0","Internal data for hitmemap! app.",1000000)
        db.transaction(
          function(tx){
              var r1 = tx.executeSql('SELECT id FROM usual_nodes WHERE code=?',[code])
              if (r1.rows.length > 0){
                  favIcon.visible = true
                  console.log("Stop "+code+" is a usual stops")
              }
              else{
                  favIcon.visible = false
                  console.log("Stop "+code+" is not a usual stops")
              }
          }
          )
        }
    } 
