#! vevn/bin/python
from suds.client import Client
import uuid
import os
import sqlite3

class populate_db:
    def __init__(self):
        self.db = self.init_db()
        self.create_tables_db()
        self.tussam_connect()
    
    def init_db(self):
        self.db_conn = sqlite3.connect('../db/7e3f3d4078aa797ff831e9bc3fbbfe46.sqlite')
        c = self.db_conn.cursor()
        return c
    
    def close_db(self):
        self.db_conn.close()
        return 1
        
    def create_tables_db(self):
        if not self.db.execute('''CREATE TABLE IF NOT EXISTS lines
             (code INTEGER, name TEXT, label TEXT, color TEXT, category TEXT,
             head_name TEXT, head_number INTEGER, head_start_time TEXT, head_end_time TEXT,
             tail_name TEXT, tail_number INTEGER, tail_start_time TEXT, tail_end_time TEXT, PRIMARY KEY (code, label))'''):
            return 0

        if not self.db.execute('''CREATE TABLE IF NOT EXISTS nodes
            (code INTEGER UNIQUE PRIMARY KEY, name TEXT, latitude REAL, longitude REAL, altitude REAL, line_codes TEXT)'''):
            return 0
        
        if not self.db.execute('''CREATE TABLE IF NOT EXISTS line_nodes
            (id INTEGER UNIQUE PRIMARY KEY AUTOINCREMENT, line_code INTEGER NOT NULL, line_label TEXT, section INTEGER, nodes TEXT, distance INTEGER)'''):
            return 0
        
        if not self.db.execute('''CREATE TABLE IF NOT EXISTS usual_nodes
            (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, code INTEGER, custom_label TEXT, custom_color TEXT)'''):
            return 0
        
        if not self.db.execute('''CREATE TABLE IF NOT EXISTS metadata
            (field TEXT, data TEXT)'''):
            return 0
        
        return 1
    
    def tussam_connect(self):
        self.tussam = Client("http://www.infobustussam.com:9005/InfoTusWS/services/InfoTus?wsdl", username="infotus-usermobile", password="2infotus0user1mobile2", headers={"deviceid":str(uuid.uuid4())})
        return 1
        
    def get_tussam_lines(self):
        # Download lines from API to DB
        lines = self.tussam.service.getLineas()[0][0]
        for line in lines:
            if line not in ["", None, "None", []]:
                self.db.execute("SELECT * FROM lines WHERE label = ?",(line['label'],))
                if self.db.fetchone() == None:
                    category = '2regular'
                    if line['label']  in ['C1', 'C2', 'C3', 'C4', 'C5', 'C6A']:
                        category = '0circular'
                    elif line['label'] in ['B3','B4','EA','52','53']:
                        category = '4especial'
                    elif line['label'] in ['T1']:
                        category = '3tranvia'
                    elif line['label'] in ['01','02','03','05','06']:
                        category = '1largo_recorrido'
                    elif line['label'] in ['A1', 'A2', 'A3', 'A4', 'A5', 'A6', 'A7', 'A8']:
                        category = '5nocturno'
                    data = (int(line['macro']),line['nombre'],line['label'],line['color'],category)
                    if type(line['secciones'][0]) == list:
                        for seccion in line['secciones'][0]:
                            data = data + (seccion['nombreSeccion'],int(seccion['numeroSeccion']), seccion['horaInicio'],seccion['horaFin'],)
                    else:
                        seccion = line['secciones'][0]
                        data = data + (seccion['nombreSeccion'],int(seccion['numeroSeccion']), seccion['horaInicio'],seccion['horaFin'],
                                       None, None, None, None,)
                    print("Adding line",line['label'])
                    self.db.execute('INSERT INTO lines VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)',data)
        if self.db_conn.commit():
            return 1
        else:
            return 0
                
         
    def get_tussam_nodes(self):
        for i in range(4000):
            if i % 40 == 0:
                self.tussam_connect()
                self.db_conn.commit()
            self.db.execute("SELECT * FROM nodes WHERE code = ?",(i,))
            if self.db.fetchone() == None:
                node = self.tussam.service.getInfoNodo(i)
                if node not in ["", None, "None", []]:
                    data = (int(node['codigo']), node['descripcion'], node['posicion']['latitud'], node['posicion']['longitud'], node['posicion']['altura'])
                    lines = ':'
                    for line in node['lineasCoincidentes'][0]:
                        lines += str(line['macro'])+':'
                    data = data + (lines,)
                    print("Adding node",node['codigo'])
                    self.db.execute('INSERT INTO nodes VALUES (?,?,?,?,?,?)',data)
                
    def get_tussam_nodes2(self):
        self.tussam_connect()
        self.db.execute("SELECT label, code, head_number, tail_number FROM lines")
        for line, code, head, tail in self.db.fetchall():
            for section in [head,tail]:
                if section != None:
                    node_list = []
                    distance_list = []
                    way = str(code)+"."+str(section)
                    raw_data = self.tussam.service.getNodosSeccion(code,section)
                    if len(raw_data) > 0:
                        for remote_node in raw_data[0]:
                            node_list.append(str(remote_node['codigoNodo']))
                            distance_list.append(str(remote_node['distancia']))
                            self.db.execute("SELECT * FROM nodes WHERE code = ?",(remote_node[0],))
                            local_node = self.db.fetchone()
                            if local_node != None:
                                # Already existing node
                                coincident_lines = local_node[-1].strip(":").split(":")
                                if way not in coincident_lines:
                                    coincident_lines.append(way)
                                    #print(":"+":".join(coincident_lines)+":")
                                    print("Existing node:", local_node)
                                    print("\tUpdating line_codes to:", coincident_lines)
                                    self.db.execute('UPDATE nodes SET line_codes=? WHERE code=?',(":"+":".join(coincident_lines)+":",remote_node[0],))
                                else:
                                    #print("\tNothing to update.")
                                    pass
                            else:
                                # New node
                                stop_name = remote_node['descripcion']
                                if '(' in stop_name and not ')' in stop_name:
                                    if 'Castillo de Marcheni' in stop_name:
                                        stop_name += 'lla)'
                                    else:
                                        stop_name += ')'
                                data = (int(remote_node['codigoNodo']), stop_name, remote_node['posicion']['latitud'], remote_node['posicion']['longitud'], remote_node['posicion']['altura'], ":"+way+":")
                                print("Adding new node:", data,"\n")
                                self.db.execute('INSERT INTO nodes VALUES (?,?,?,?,?,?)',data)
                                pass
                    temp = (code, line, int(section),)
                    self.db.execute('SELECT nodes, distance FROM line_nodes WHERE line_code=? AND line_label=? AND section=?', temp)
                    local_data = self.db.fetchone()
                    if local_data == None or local_data[0] == "::" or local_data[1] == "::":
                        data = (code, line, int(section), ":"+":".join(node_list)+":",":"+":".join(distance_list)+":",)
                        print("Adding data:", data)
                        self.db.execute('INSERT INTO line_nodes VALUES (NULL,?,?,?,?,?)', data)
                self.db_conn.commit()
                
                        
        
        
        
    
if __name__ == '__main__':
    x = populate_db()
    x.get_tussam_lines()
    x.get_tussam_nodes2()
    x.close_db()
