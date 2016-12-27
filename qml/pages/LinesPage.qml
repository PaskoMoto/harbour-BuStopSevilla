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

Page{
    SilicaListView{
        anchors.fill: parent
        header: PageHeader{
            title: qsTr("Lines")
        }
        model: ListModel {
            id: linesModel
            ListElement { lineNumber: "01"; lineName: "la uno"; lineType: "Normal" }
            ListElement { lineNumber: "02"; lineName: "la dos"; lineType: "Normal" }
            ListElement { lineNumber: "03"; lineName: "la tres"; lineType: "Normal" }
            ListElement { lineNumber: "06"; lineName: "la seis"; lineType: "Normal" }
            ListElement { lineNumber: "C1"; lineName: "la c1"; lineType: "Circular" }
            ListElement { lineNumber: "C2"; lineName: "la c2"; lineType: "Circular" }
            ListElement { lineNumber: "C4"; lineName: "la c4"; lineType: "Circular" }
            ListElement { lineNumber: "C3"; lineName: "la c3"; lineType: "Circular" }
        }
        section{
            property: "lineType"
            criteria: ViewSection.FullString
            delegate: Column{
                width: parent.width
                Label{
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: section
                }
            }
        }
        delegate: ListItem {
            width: ListView.view.width
            height: Theme.itemSizeMedium
            Rectangle{
                id: lineIcon
                anchors.left: parent.left
                anchors.leftMargin: Theme.itemSizeExtraSmall/4
                color:'red'
                height: parent.height*0.8
                width: height
                radius: width*0.5
                Label {
                    anchors.centerIn: parent
                    text: lineNumber
                    font.pixelSize: Theme.fontSizeMedium
                }
            }
            Label{
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: lineIcon.right
                anchors.leftMargin: Theme.itemSizeExtraSmall/3
                text: lineName
            }
        }
    }
}
