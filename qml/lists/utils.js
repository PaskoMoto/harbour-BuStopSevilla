 
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
