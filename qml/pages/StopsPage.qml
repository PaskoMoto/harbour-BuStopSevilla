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
        anchors{
            right: parent.right
            left: parent.left
            bottom: parent.bottom
            top: headerItem.bottom
            topMargin: Theme.itemSizeExtraSmall/1.5
        }
        spacing: 0
        model: ListModel{
            id: stopsListModel
        }
        section{
            property: "stopDirection"
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
            height: Theme.itemSizeSmall
            Label{
                id: stopLabel
                width: Theme.itemSizeSmall*9/12
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: Theme.itemSizeExtraSmall/6
                text: stopNumber
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeMedium
                font.bold: true
            }
            Label{
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: stopLabel.right
                anchors.leftMargin: Theme.itemSizeExtraSmall/5
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
        }
    }
    Component.onCompleted: {
        current_page = ['StopsPage']
        getStops(theLine);
        console.log("asdfasdf " +getLineProperties(theLine));
    }
    function getStops(line){
        console.log("Asking stops for line "+line)
        var db = LocalStorage.openDatabaseSync("bustopsevillaDB","1.0","Internal data for hitmemap! app.",1000000)
        db.transaction(
                    function(tx){
                        var query = "SELECT * FROM nodes WHERE line_codes LIKE '%?%'"
                        var r1 = tx.executeSql("SELECT * FROM nodes WHERE line_codes LIKE ?", ['%:'+line+'%:'])
                        for(var i = 0; i < r1.rows.length; i++){
                            stopsListModel.append({"stopNumber": r1.rows.item(i).code,
                                                      "stopName": r1.rows.item(i).name,
                                                      "links": r1.rows.item(i).lines_codes
                                                  })
                        }
                    }
                    )
    }
    function getLineProperties(line){
        console.log("Asking properties of line "+line)
        var db = LocalStorage.openDatabaseSync("bustopsevillaDB","1.0","Internal data for hitmemap! app.",1000000)
        db.transaction(
                    function(tx){
                        var query = 'SELECT name, label, color FROM lines WHERE code=?'
                        var r1 = tx.executeSql(query,[line])
                        lineName.text = r1.rows.item(0).name;
                        lineLabel.text = r1.rows.item(0).label;
                        lineIcon.border.color = r1.rows.item(0).color;

                    }
                    )
    }
}
