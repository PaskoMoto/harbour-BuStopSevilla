
function getLines(namelistModel){
    namelistModel.clear()
    var db = LocalStorage.openDatabaseSync("bustopsevillaDB","1.0","Internal data for hitmemap! app.",1000000)
    db.transaction(
                function(tx){
                    var query = 'SELECT * FROM lines ORDER BY category ASC, label ASC'
                    var r1 = tx.executeSql(query)
                    var category = ''
                    for(var i = 0; i < r1.rows.length; i++){
                        switch (r1.rows.item(i).category){
                        case '0circular':
                            category = qsTr("Circular");
                            break;
                        case '1largo_recorrido':
                            category = qsTr("Long Line");
                            break;
                        case '2regular':
                            category = qsTr("Regular");
                            break;
                        case '3tranvia':
                            category = qsTr("Trolley Car");
                            break;
                        case '4especial':
                            category = qsTr("Special");
                            break;
                        case '5nocturno':
                            category = qsTr("Nighttime");
                            break;
                        default:
                            category = qsTr("Other");
                        }
                        namelistModel.append({"lineNumber": r1.rows.item(i).label,
                                                 "lineName": r1.rows.item(i).name,
                                                 "lineColor": r1.rows.item(i).color,
                                                 "lineType": category,
                                                 "code": r1.rows.item(i).code
                                             })
                    }
                }
                )
}

function getStopsData(line, stopsListModel){
    stopsListModel.clear()
    console.log("Asking stops for line "+line)
    var db = LocalStorage.openDatabaseSync("bustopsevillaDB","1.0","Internal data for hitmemap! app.",1000000)
    var section_names = []
    var node_list = []
    var output = []
    db.transaction(
                function(tx){
                    var query = 'SELECT name, label, color, head_name,head_number, tail_name, tail_number FROM lines WHERE code=?'
                    var r1 = tx.executeSql(query,[line])
                    output = [r1.rows.item(0).name, r1.rows.item(0).label, r1.rows.item(0).color]
//                    lineName.text = r1.rows.item(0).name;
//                    lineLabel.text = r1.rows.item(0).label;
//                    lineIcon.border.color = r1.rows.item(0).color;
                    section_names[0] = [r1.rows.item(0).head_number,r1.rows.item(0).head_name];
                    section_names[1] = [r1.rows.item(0).tail_number,r1.rows.item(0).tail_name];
                }
                )
    db.transaction(
                function(tx){
                    var query = 'SELECT section, nodes FROM line_nodes WHERE line_code=? ORDER BY section'
                    var r1 = tx.executeSql(query,[line])
                    for(var i = 0; i < r1.rows.length; i++){
                        var nodes = r1.rows.item(i).nodes.replace(/:/g," ")
                        node_list[i] = [r1.rows.item(i).section, nodes.trim().split(" ")]
                    }
                }
                )
    db.transaction(
                function(tx){
                    for (var j = 0; j < node_list.length; j++){
                        var nodes = node_list[j][1]
                        var section = node_list[j][0]
                        var section_name = ''
                        for (var n = 0; n < section_names.length; n++){
                            if (section_names[n][0] === section){
                                section_name = section_names[n][1]
                            }
                        }

                        for (var m = 0; m < nodes.length; m++){
                            var r1 = tx.executeSql("SELECT * FROM nodes WHERE code=?", [nodes[m]])
                            stopsListModel.append({"stopNumber": nodes[m],
                                                      "stopName": r1.rows.item(0).name,
                                                      "stopSection": section_name,
                                                      "latitude": r1.rows.item(0).latitude,
                                                      "longitude": r1.rows.item(0).longitude
                                                  })
                        }
                    }
                }
                )
    return output
}
