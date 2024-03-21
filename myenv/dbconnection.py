import mysql.connector

class Db:
    def __init__(self):
        self.cnx = mysql.connector.connect(host="localhost",user="root",password="",database="events")
        self.cur = self.cnx.cursor(dictionary=True,buffered=True)

    def select(self, query, values=None):   
        if values:
            self.cur.execute(query, values)
        else:
            self.cur.execute(query)
        return self.cur.fetchall()
         
    def selectOne(self, q, values):
        self.cur.execute(q, values)  
        return self.cur.fetchone()
    
    def insert(self, q, values):
        self.cur.execute(q, values)
        self.cnx.commit()
        return self.cur.lastrowid
    
    def update(self, q, values):
        self.cur.execute(q, values)
        self.cnx.commit()
        return self.cur.rowcount
    
    def delete(self, q, values):
        self.cur.execute(q, values)
        self.cnx.commit()    
        return self.cur.rowcount 
       
    def get_last_inserted_id(self):
        row =  self.cur.fetchone()
        if row is not None:
            return row[0]
        else:
            return None