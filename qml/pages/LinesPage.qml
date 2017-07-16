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
import "../data"

Page{
    id:pageLines
    onStatusChanged: current_page = ['LinesPage']
    SilicaListView{
        anchors.fill: parent
        spacing: 0
        header: PageHeader{
            title: qsTr("Lines")
        }
        model: ListModel {
        id:linesListModel}
        section{
            property: "lineType"
            criteria: ViewSection.FullString
            delegate: Column{
                width: parent.width
                Label{
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: section
                    color: Theme.secondaryColor
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
            Rectangle{
                id: lineIcon
                anchors.left: parent.left
                anchors.leftMargin: Theme.itemSizeExtraSmall/4
                anchors.verticalCenter: parent.verticalCenter
                color: 'transparent'
                height: parent.height*0.95
                width: height
                radius: width*0.5
                border{
                    width: parent.width/100
                    color: lineColor
                }

                Label {
                    anchors.centerIn: parent
                    color: Theme.primaryColor
                    text: lineNumber
                    font.pixelSize: Theme.fontSizeMedium
                    font.bold: true
                }
            }
            Label{
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: lineIcon.right
                anchors.leftMargin: Theme.itemSizeExtraSmall/5
                text: lineName
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeExtraSmall
                truncationMode: TruncationMode.Fade
                width: parent.width*0.75
            }
            onClicked: {
                console.log("Clic on line "+lineNumber)
                pageStack.push("StopsPage.qml", {theLine: lineNumber, theColor: lineColor})
            }
        }
    }
    function getLines(){
        linesListModel.clear()
        var db = LocalStorage.openDatabaseSync("data","1.0","Internal data for hitmemap! app.",1000000)
        db.transaction(
                    function(tx){
                        var r1 = tx.executeSql('SELECT * FROM lines WHERE category=circular')
                        var r2 = tx.executeSql('SELECT * FROM lines WHERE category=largo_recorrdio')
                        var r3 = tx.executeSql('SELECT * FROM lines WHERE category=regular')
                        var r4 = tx.executeSql('SELECT * FROM lines WHERE category=circular')
                        var r5 = tx.executeSql('SELECT * FROM lines WHERE category=especial')
                        var r6 = tx.executeSql('SELECT * FROM lines WHERE category=tranvia')
                        var results = r1.concat(r2).concat(r3).concat(r4).concat(r5).concat(r6)
                        console.log(results)
                        for(var i = 0; i < results.rows.length; i++){
                            linesListModel.append({"lineNumber": results.rows.item(i).label,
                                                      "lineName": results.rows.item(i).name,
                                                      "lineColor": results.rows.item(i).color,
                                                      "lineType": results.rows.item(i).category
                                                  })
                        }
                    }
                    )
    }
}
