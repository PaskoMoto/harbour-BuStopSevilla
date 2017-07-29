/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.2
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0

Page{
    id:pageStops
    property var theLine
    property bool testing_rectangles: true
    Item{
        id: headerItem
        width: parent.width
        height: Theme.itemSizeMedium
        Label{
            id: lineName
            anchors{
                left: parent.left
                leftMargin: Theme.itemSizeExtraSmall/2
                right: lineIcon.left
                rightMargin: Theme.itemSizeExtraSmall/6
                verticalCenter: parent.verticalCenter
            }
            width: parent.width - lineIcon.width - lineIcon.anchors.rightMargin - anchors.rightMargin - anchors.leftMargin
            truncationMode: TruncationMode.Fade
        }
        Rectangle{
            id: lineIcon
            anchors.right: parent.right
            anchors.rightMargin: Theme.itemSizeExtraSmall/6
            anchors.verticalCenter: parent.verticalCenter
            color: 'transparent'
            height: Theme.itemSizeSmall
            width: height
            radius: width*0.5
            border{
                width: parent.width/100
            }
            Label {
                id: lineLabel
                anchors.centerIn: parent
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeMedium
                font.bold: true
            }
        }
            }
    SilicaListView{
        id: stopsListView
        clip: true
        anchors{
            right: parent.right
            left: parent.left
            bottom: parent.bottom
            top: headerItem.bottom
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
                pageStack.replaceAbove(pageStack.previousPage(pageStack.previousPage()),"StopPage.qml", {current_stop: stopNumber})
            }
            menu: ContextMenu {
                MenuItem {
                    text: "Add to usual stops"
                    onClicked: addUsual(stopNumber, stopName)
                }
            }
        }
    }
    Component.onCompleted: {
        rootPage.current_page = ['StopsPage']
        getStopsData(theLine);
    }
    function getStopsData(line){
        console.log("Asking stops for line "+line)
        var db = LocalStorage.openDatabaseSync("bustopsevillaDB","1.0","Internal data for hitmemap! app.",1000000)
        var section_list = []
        var section_names = []
        var node_list = []
        db.transaction(
                    function(tx){
                        var query = 'SELECT name, label, color, head_name, tail_name FROM lines WHERE code=?'
                        var r1 = tx.executeSql(query,[line])
                        lineName.text = r1.rows.item(0).name;
                        lineLabel.text = r1.rows.item(0).label;
                        lineIcon.border.color = r1.rows.item(0).color;
                        section_names[0] = r1.rows.item(0).head_name;
                        section_names[1] = r1.rows.item(0).tail_name;
                    }
                    )
        db.transaction(
                    function(tx){
                        var query = 'SELECT section, nodes FROM line_nodes WHERE line_code=? ORDER BY section'
                        var r1 = tx.executeSql(query,[line])
                        for(var i = 0; i < r1.rows.length; i++){
                            section_list[i] = r1.rows.item(i).section
                            var nodes = r1.rows.item(i).nodes.replace(/:/g," ")
                            node_list[i] = nodes.trim().split(" ")
                        }
                    }
                    )
        db.transaction(
                    function(tx){
                        for (var j = 0; j < section_list.length; j++){
                            var nodes = node_list[j]
                            for (var m = 0; m < nodes.length; m++){
                                var r1 = tx.executeSql("SELECT * FROM nodes WHERE code=?", [nodes[m]])
                                stopsListModel.append({"stopNumber": nodes[m],
                                                          "stopName": r1.rows.item(0).name,
                                                          "stopSection": section_names[j]
                                                      })
                            }
                        }
                    }
                    )
    }
    function addUsual(code,name){
        console.log("Adding "+code+" top usual stops")
        var db = LocalStorage.openDatabaseSync("bustopsevillaDB","1.0","Internal data for hitmemap! app.",1000000)
        db.transaction(
                    function(tx){
                        var r1 = tx.executeSql('INSERT INTO usual_nodes VALUES (NULL,?,?,NULL)',[code,"->"+name])
                    }
                    )
    }
}
