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
            (code INTEGER, name TEXT, latitude REAL, longitude REAL, altitude REAL, line_codes TEXT)'''):
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
                    category = 'regular'
                    if 'Circular' in line['nombre']:
                        category = 'circular'
                    elif line['label'] in ['B3','B4','EA','52']:
                        category = 'especial'
                    elif line['label'] in ['T1']:
                        category = 'tranvia'
                    elif line['label'] in ['01','02','03','05','06']:
                        category = 'largo_recorrido'
                    elif line['label'] in ['A1', 'A2', 'A3', 'A4', 'A5', 'A6', 'A7', 'A8']:
                        category = 'nocturno'
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
                
                
    
    
if __name__ == '__main__':
    x = populate_db()
    x.get_tussam_lines()
    #x.get_tussam_nodes()
    x.close_db()
