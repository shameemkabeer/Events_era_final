from flask import *
from flask_cors import CORS
from dbconnection import Db    

app = Flask(__name__) 
app.secret_key="gfgfhjfghg" 

CORS(app)
    
@app.route('/customreginser', methods=['GET','POST'])
def register_customer():     
          
    db = Db()   
    first_name = request.form['first_name']    
    last_name = request.form['last_name']
    gender = request.form['gender']
    house_name = request.form['house_name']
    place = request.form['place']      
    pincode = request.form['pincode']
    email = request.form['email']    
    phone = request.form['phone']
    uname = request.form['email']  
    psw = request.form['password']                  
               
    qry1 = "INSERT INTO login (username, password,login_type) VALUES (%s,%s,%s)" 
    values = (uname,psw,'customer')        
    ids=db.insert(qry1, values)        
          
    query = "INSERT INTO customer1 (customer_id, login_id, first_name, last_name, gender, house_name, place, pincode, email, phone) VALUES (NULL, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
    values = (ids, first_name, last_name, gender, house_name, place, pincode, email, phone)
    db.insert(query, values)  
    return "true"    


@app.route('/login', methods=['GET','POST'])
def login():

    db = Db()       
      
    data = request.json
    entered_username = data.get('username')
    entered_password = data.get('password')
    
    login_type = None    
   
    query = "SELECT * FROM login WHERE username = %s AND password = %s"
    values = (entered_username, entered_password)
         
    result = db.selectOne(query, values)  # Use selectOne to get a single result
    
    if result:
        lid=result['login_id']
        login_type = result['login_type']     
 
        return jsonify({'message': 'Login successful', 'usertype': login_type,'lid':lid})
       
    else:      
        return jsonify({'message': 'Invalid username or password', 'usertype': None})
    
    
    
@app.route('/addeventteam', methods=['GET','POST'])
def addeventteam():     
                   
    db = Db()   
    first_name = request.form['first_name']    
    last_name = request.form['last_name']
    gender = request.form['gender']    
    house_name = request.form['house_name']
    place = request.form['place']      
    pincode = request.form['pincode']
    email = request.form['email']    
    phone = request.form['phone']
    uname = request.form['email']    
    psw = request.form['password']                  
               
    qry1 = "INSERT INTO login (username, password,login_type) VALUES (%s,%s,%s)" 
    values = (uname,psw,'staff')        
    ids=db.insert(qry1, values)   
          
    query = "INSERT INTO staff (staff_id, login_id, first_name, last_name, gender, house_name, place, pincode, email, phone) VALUES (NULL, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
    values = (ids, first_name, last_name, gender, house_name, place, pincode, email, phone)
    db.insert(query, values)

    qu = "SELECT staff_id FROM staff WHERE first_name = %s"
    values = (first_name,)

    result = db.selectOne(qu, values)  
         
    if result:
            staffid = result['staff_id']
            return jsonify({'message': 'Staff added successfully', 'staffid': staffid})
    

@app.route('/geteventteam', methods=['GET'])
def geteventeam():
    db = Db()
    
    query = "SELECT * FROM staff"
    
    # Fetch event team member data from the database
    event_team_data = db.select(query) 

    # Convert the list of event team members to a list of dictionaries
    event_team_members = [] 
    for row in event_team_data:
        event_team_members.append({
            'staff_id': row['staff_id'],
            'first_name': row['first_name'],
            'last_name': row['last_name'],
            'gender': row['gender'],
            'house_name': row['house_name'],
            'place': row['place'],
            'pincode': row['pincode'],
            'email': row['email'],
            'phone': row['phone']
        })

    # Return the list of event team members as JSON
    return jsonify({'event_team': event_team_members})
    
@app.route('/deleteeventteam', methods=['POST'])
def delteam():

    db = Db()

    try:
  
        data = request.json 
        name = data.get('first_name') 
        
        qu = "SELECT staff_id,login_id FROM staff WHERE first_name = %s"
        values = (name,)
        res = db.selectOne(qu, values)  

        if res:    
            staff_id = res['staff_id']
            login_id = res['login_id']
            print(staff_id,login_id)

        qry1 = "DELETE FROM staff WHERE staff_id = %s"
        val = (staff_id,)
        db.delete(qry1, val)  

        qry2 = "DELETE FROM login WHERE login_id = %s"
        val = (login_id,)
        db.delete(qry2, val)  
        

        return jsonify({'message': 'Staff deleted successfully', 'staff_id': staff_id, 'login_id':login_id})
    
    except Exception as e:
        return jsonify({'message': f'Error: {str(e)}'}), 500
    

@app.route('/updateteam', methods=['POST'])
def updteam():
    db = Db()
   
    try:
        data = request.json
        fname = data.get('first_name')
        new_fname = data.get('new_fname')   
        lname = data.get('last_name') 
        new_lname = data.get('new_lname')
        gen = data.get('gender') 
        new_gend = data.get('new_gen')   
        house = data.get('house_name') 
        new_house = data.get('new_house') 
        pla = data.get('place') 
        new_pl = data.get('new_place') 
        pinc = data.get('pincode')
        new_pinc = data.get('new_pin')
        email = data.get('email')
        new_email = data.get('new_ema') 
        phone = data.get('phone')
        new_pho = data.get('new_ph')
        
        qu = "SELECT staff_id FROM staff WHERE first_name = %s"
        values = (fname,)
        res = db.selectOne(qu, values)
       
        if res:
            staffid = res['staff_id']

        qry1 = "UPDATE staff SET first_name = %s,last_name = %s,gender = %s,house_name = %s,place = %s,pincode = %s,email = %s,phone = %s where staff_id = %s"
        val = (new_fname,new_lname,new_gend,new_house,new_pl,new_pinc,new_email,new_pho,staffid)  
        db.update(qry1, val)  

        return jsonify({'message': 'Staff updated successfully', 'first_name': new_fname, 'last_name': new_lname, 'gender': new_gend, 'house_name': new_house, 'place': new_pl, 'pincode': new_pinc, 'email': new_email, 'phone': new_pho, 'staff_id': staffid})

    except Exception as e:
        return jsonify({'message': f'Error: {str(e)}'}), 500

@app.route('/addeventcategories', methods=['POST'])
def addeventcategory():
    db = Db()
       
    try:
        data = request.json
        category_name = data.get('category_name')
     
        query = "INSERT INTO eventcategories (category_id, category_name) VALUES (NULL, %s)"
        values = (category_name, )
        db.insert(query, values)

        qu = "SELECT category_id FROM eventcategories WHERE category_name = %s"
        values = (category_name,)

        result = db.selectOne(qu, values)  
         
        if result:
            cid = result['category_id']
            return jsonify({'message': 'Event category added successfully', 'cid': cid})
        else:
            return jsonify({'message': 'Category not found after insertion', 'cid': None})
    except Exception as e:
        return jsonify({'message': f'Error: {str(e)}', 'cid': None})
    
    
@app.route('/getcategories', methods=['POST', 'GET'])
def viewcat():

    db = Db()
    query = "SELECT * FROM eventcategories"

    # Fetch food data from the database
    catdata = db.select(query)

    # Convert the list of food items to a list of dictionaries
    categories = []
    for row in catdata:
        categories.append({
            'category_name': row['category_name'],              
        })

    # Return the list of food items as JSON 
    return jsonify({'message': categories})

@app.route('/deletecategories', methods=['POST'])
def delcategory():

    db = Db() 

    try:
        data = request.json
        category_name = data.get('category_name')
        
        qu = "SELECT category_id FROM eventcategories WHERE category_name = %s"
        values = (category_name,)
        res = db.selectOne(qu, values)

        if res:
            cid = res['category_id']

        qry1 = "DELETE FROM eventcategories WHERE category_id = %s"
        val = (cid,)
        db.delete(qry1, val)

        return jsonify({'message': 'Category deleted successfully', 'category_id': cid})

    except Exception as e:
        return jsonify({'message': f'Error: {str(e)}'}), 500

@app.route('/updatecategories', methods=['POST'])
def upcategory():
    db = Db()

    try:
        data = request.json
        category_name = data.get('category_name')
        new_name = data.get('new_name') 
        
        qu = "SELECT category_id FROM eventcategories WHERE category_name = %s"
        values = (category_name,)
        res = db.selectOne(qu, values)

        if res:
            cid = res['category_id']

        qry1 = "UPDATE eventcategories SET category_name = %s where category_id = %s"
        val = (new_name, cid)  
        db.update(qry1, val)  

        return jsonify({'message': 'Category updated successfully', 'category_name': new_name, 'category_id': cid})

    except Exception as e:
        return jsonify({'message': f'Error: {str(e)}'}), 500

@app.route('/addfoods', methods=['POST'])
def addfoods():

 db = Db()
 try:         

    data = request.json
   
       
    food = data.get('food_name')
    desc = data.get('description')
    qty = data.get('quantity')
    serve = data.get('serving_type')

    query = "INSERT INTO food (food_id, food_name, description,  quantity, serving_type) VALUES (NULL, %s, %s, %s, %s)"
    values = (food, desc, qty, serve)
    
    db.insert(query, values)

    qu = "SELECT food_id FROM food WHERE food_name = %s"
    values = (food,)

    result = db.selectOne(qu, values)  
         
    if result:
            fid = result['food_id']
            return jsonify({'message': 'Food added successfully', 'fid': fid})
    else:
            return jsonify({'message': 'Food not found after insertion', 'fid': None})
    
 except Exception as e:
   return jsonify({'message': f'Error: {str(e)}', 'fid': None})

@app.route('/getfoods', methods=['POST', 'GET'])
def viewf():
    db = Db()
    query = "SELECT * FROM food"

    # Fetch food data from the database
    food_data = db.select(query)

    # Convert the list of food items to a list of dictionaries
    food_items = []
    for row in food_data:
        food_items.append({
            'food_name': row['food_name'],
            'description': row['description'],
            'quantity': row['quantity'],
            'serving_type': row['serving_type']
        })

    # Return the list of food items as JSON
    return jsonify({'message': food_items})


@app.route('/deletefoods', methods=['POST'])
def delfood():

    db = Db()

    try:
        data = request.json
        food_name = data.get('food_name')
        
        qu = "SELECT food_id FROM food WHERE food_name = %s"
        values = (food_name,)
        res = db.selectOne(qu, values)

        if res:
            fid = res['food_id']

        qry1 = "DELETE FROM food WHERE food_id = %s"
        val = (fid,)
        db.delete(qry1, val)

        return jsonify({'message': 'food deleted successfully', 'food_id': fid})

    except Exception as e:
        return jsonify({'message': f'Error: {str(e)}'}), 500
    
@app.route('/updatefoods', methods=['POST'])
def upfood():
    db = Db()

    try:
        data = request.json
        name = data.get('food_name')
        new_name = data.get('new_name')
        des = data.get('description')
        new_des = data.get('new_des') 
        qty = data.get('quantity')
        new_qty = data.get('new_qty')
        serve = data.get('serving_type')
        new_serve = data.get('new_serve')
        
        qu = "SELECT food_id FROM food WHERE food_name = %s"
        values = (name,)
        res = db.selectOne(qu, values)

        if res:
            fid = res['food_id']

        qry1 = "UPDATE food SET food_name = %s,description = %s,quantity = %s,serving_type = %s where food_id = %s"
        val = (new_name,new_des,new_qty,new_serve,fid)  
        db.update(qry1, val)  

        return jsonify({'message': 'Food updated successfully', 'food_name': new_name, 'designation': new_des, 'quantity': new_qty, 'serving_type': new_serve, 'food_id': fid})

    except Exception as e:
        return jsonify({'message': f'Error: {str(e)}'}), 500
    
    
@app.route('/addeventpackages', methods=['POST'])
def addeventpackage():
    try:
        db = Db()
        
        food_ids_str = request.form['foodid']
        food_ids = food_ids_str.split(',')  # Split the comma-separated string into a list of food IDs
        print("food_ids : ", food_ids)
        
        categoryid = request.form['auth']
        packagename = request.form['package_name']
        packagedesc = request.form['package_description']
        packageamnt = request.form['package_amount']

        query = "INSERT INTO eventpackages (package_id, category_id, package_name, package_description, package_amount) VALUES (NULL, %s, %s, %s, %s)"
        values = (categoryid, packagename, packagedesc, packageamnt)
        db.insert(query, values)
  
        qu = "SELECT package_id FROM eventpackages WHERE package_name = %s"
        values = (packagename,)
        result = db.selectOne(qu, values)
        print(result)

        
        for food_id in food_ids:
            query = "INSERT INTO packagefoods(package_food_id, package_id, food_id) VALUES (NULL, %s, %s)"
            values = (result['package_id'],food_id)
            db.insert(query, values) 
        
        

        return jsonify({'message': 'Event package added successfully', 'pid': result})
       
    except Exception as e:
        return jsonify({'message': f'Error: {str(e)}', 'pid': None})
    
@app.route('/getpackage', methods=['GET'])
def getpack():
    db = Db()

    query = """
    SELECT ec.category_name, ep.package_name, ep.package_description, ep.package_amount
    FROM eventpackages AS ep
    INNER JOIN eventcategories AS ec ON ep.category_id = ec.category_id
    """

    pack_data = db.select(query)

    packages = []
    for row in pack_data:
        packages.append({
            # 'category_name': row['category_name'],
            'package_name': row['package_name'],
            'package_description': row['package_description'],
            'package_amount': row['package_amount'],
        })

    return jsonify({'event_package': packages})

@app.route('/deleventpackage', methods=['POST'])
def delpack():
    db = Db()

    try:
        data = request.json
        name = data.get('package_name')  

        # Find the staff member by their email
        query = "SELECT package_id FROM eventpackages WHERE package_name = %s"
        values = (name,)
        result = db.selectOne(query, values)

        if result:
            pack_id = result['package_id']    
            
            delete_query = "DELETE FROM eventpackages WHERE package_id = %s"
            delete_values = (pack_id,)
            db.delete(delete_query, delete_values)

            return jsonify({'message': 'Event package deleted successfully', 'pack_id': pack_id})
        else:
            return jsonify({'message': 'Event package not found'})

    except Exception as e:
        return jsonify({'message': f'Error: {str(e)}'}), 500    

@app.route('/updatepackage', methods=['POST'])
def uppack():
    db = Db()

    try:
        data = request.json
        name = data.get('package_name')
        new_name = data.get('new_package_name')
        des = data.get('package_description')
        new_des = data.get('new_package_description') 
        amt = data.get('package_amount')
        new_amt = data.get('new_package_amount')
        # serve = data.get('serving_type')
        # new_serve = data.get('new_serve')
        
        qu = "SELECT package_id FROM eventpackages WHERE package_name = %s"
        values = (name,)
        res = db.selectOne(qu, values)

        if res:
            pid = res['package_id']

        qry1 = "UPDATE eventpackages SET package_name = %s,package_description = %s,package_amount = %s where package_id = %s"
        val = (new_name,new_des,new_amt,pid)  
        db.update(qry1, val)  

        return jsonify({'message': 'Package updated successfully', 'package_name': new_name, 'package_description': new_des, 'package_amount': new_amt, 'package_id': pid})

    except Exception as e:
        return jsonify({'message': f'Error: {str(e)}'}), 500
    
@app.route('/addmakeup', methods=['POST'])
def addmake():
 
 db = Db()
 try:
    data = request.json

    name = data.get('name')
    loc = data.get('place')
    email = data.get('email')
    mob = data.get('phone')

    query = "INSERT INTO makeup (artist_id, name, place, email, phone) VALUES (NULL, %s, %s, %s, %s)"
    values = (name, loc, email, mob)
    
    db.insert(query, values)
    qu = "SELECT artist_id FROM makeup WHERE name = %s"
    values = (name,)

    result = db.selectOne(qu, values)  
         
    if result:
            aid = result['artist_id']
            return jsonify({'message': 'Artist added successfully', 'aid': aid})
    else:
            return jsonify({'message': 'Artist not found after insertion', 'aid': None})
    
 except Exception as e:
   return jsonify({'message': f'Error: {str(e)}', 'aid': None})
 
 
@app.route('/getmakeups', methods=['POST', 'GET'])
def viewmake():
    db = Db()
    query = "SELECT * FROM makeup"

    # Fetch food data from the database
    makeup = db.select(query)

    # Convert the list of food items to a list of dictionaries
    artists = []
    for row in makeup:
        artists.append({
            'name': row['name'],
            'place': row['place'],
            'email': row['email'],
            'phone': row['phone']
        })

    # Return the list of food items as JSON
    return jsonify({'message': artists})


@app.route('/deleteMakeup', methods=['POST'])
def delmake():

    db = Db()

    try:
        data = request.json
        Artist_name = data.get('name')
        
        qu = "SELECT artist_id FROM makeup WHERE name = %s"
        values = (Artist_name,)
        res = db.selectOne(qu, values)

        if res:
            mid = res['artist_id']

        qry1 = "DELETE FROM makeup WHERE artist_id = %s"
        val = (mid,)
        db.delete(qry1, val)

        return jsonify({'message': 'Artist deleted successfully', 'artist_id': mid})

    except Exception as e:
        return jsonify({'message': f'Error: {str(e)}'}), 500


@app.route('/updatemakeup', methods=['POST'])
def upmakeup():
    db = Db()

    try:
        data = request.json
        name = data.get('name')
        new_name = data.get('new_name')
        place = data.get('place')
        new_place = data.get('new_place') 
        email = data.get('email')
        new_email = data.get('new_email')
        phone = data.get('phone')
        new_phone = data.get('new_phone')
        
        qu = "SELECT artist_id FROM makeup WHERE name = %s"
        values = (name,)
        res = db.selectOne(qu, values)

        if res:
            aid = res['artist_id']

        qry1 = "UPDATE makeup SET name = %s,place = %s,email = %s,phone = %s where artist_id = %s"
        val = (new_name,new_place,new_email,new_phone,aid)  
        db.update(qry1, val)  

        return jsonify({'message': 'Artist updated successfully', 'name': new_name, 'place': new_place, 'email': new_email, 'phone': new_phone, 'artist_id': aid})

    except Exception as e:
        return jsonify({'message': f'Error: {str(e)}'}), 500
    

@app.route('/addcostume', methods=['POST'])
def addcostume():
    db = Db()
    try:
        data = request.json

        name = data.get('name')
        loc = data.get('place')
        email = data.get('email')
        mob = data.get('phone')

        query = "INSERT INTO costume(designer_id, name, place, email, phone) VALUES (NULL, %s, %s, %s, %s)"
        values = (name, loc, email, mob)

        db.insert(query, values)

        qu = "SELECT designer_id FROM costume WHERE name = %s"
        values = (name,)

        result = db.selectOne(qu, values)

        if result:
            deid = result['designer_id']
            return jsonify({'message': 'Designer added successfully', 'deid': deid})
        else:
            return jsonify({'message': 'Designer not found after insertion', 'deid': None})

    except Exception as e:
        return jsonify({'message': f'Error: {str(e)}', 'deid': None})
    

@app.route('/getcostume', methods=['POST', 'GET'])
def viewcostume():
    db = Db()
    query = "SELECT * FROM costume"

    # Fetch food data from the database
    costume = db.select(query)

    # Convert the list of food items to a list of dictionaries
    designers = []
    for row in costume:
        designers.append({
            'name': row['name'],
            'place': row['place'],
            'email': row['email'],
            'phone': row['phone']
        })

    # Return the list of food items as JSON
    return jsonify({'message': designers})


@app.route('/deletecostume', methods=['POST'])
def delcost():

    db = Db()

    try:
        data = request.json
        Designer_name = data.get('name')
        
        qu = "SELECT designer_id FROM costume WHERE name = %s"
        values = (Designer_name,)
        res = db.selectOne(qu, values)

        if res:
            coid = res['designer_id']

        qry1 = "DELETE FROM costume WHERE designer_id = %s"
        val = (coid,)
        db.delete(qry1, val)

        return jsonify({'message': 'Designer deleted successfully', 'designer_id': coid})

    except Exception as e:
        return jsonify({'message': f'Error: {str(e)}'}), 500
    
@app.route('/updatecost', methods=['POST'])
def upcostume():
    db = Db()

    try:
        data = request.json
        name = data.get('name')
        new_name = data.get('new_name')
        place = data.get('place')
        new_place = data.get('new_place') 
        email = data.get('email')
        new_email = data.get('new_email')
        phone = data.get('phone')
        new_phone = data.get('new_phone')
        
        qu = "SELECT designer_id FROM costume WHERE name = %s"
        values = (name,)
        res = db.selectOne(qu, values)

        if res:
            deid = res['designer_id']

        qry1 = "UPDATE costume SET name = %s,place = %s,email = %s,phone = %s where designer_id = %s"
        val = (new_name,new_place,new_email,new_phone,deid)  
        db.update(qry1, val)  

        return jsonify({'message': 'Designer updated successfully', 'name': new_name, 'place': new_place, 'email': new_email, 'phone': new_phone, 'designer_id': deid})

    except Exception as e:
        return jsonify({'message': f'Error: {str(e)}'}), 500
    

# @app.route('/addcustomevent', methods=['POST'])
# def add_custom_event():
#     try:
#         db = Db()
        
#         customer_lid = request.form['authToken']
#         print("customer_lid : ", customer_lid)

#         food_ids_str = request.form['foodid']
#         food_ids = food_ids_str.split(',')  # Split the comma-separated string into a list of food IDs
#         print("food_ids : ", food_ids)
    
#         customeventname = request.form['customeventname']
#         budget_amt = float(request.form['budget_amt'])
#         place = request.form['place']
#         noofpersons = int(request.form['noofpersons'])
#         date = request.form['date']

#         query = "SELECT * FROM customer1 WHERE login_id = %s"
#         values = (customer_lid,)
        
#         result = db.selectOne(query, values)
        
#         if result:
#             query = "INSERT INTO custom_events (custom_event_id, customer_id, event_name, budget, place, no_of_persons, event_date, event_status) VALUES (NULL, %s, %s, %s, %s, %s, %s, 'Pending')"
#             values = (result['customer_id'], customeventname, budget_amt, place, noofpersons, date)
            
#             db.insert(query, values)

#             query = "SELECT custom_event_id FROM custom_events WHERE event_name = %s"
#             values = (customeventname,)
#             res = db.selectOne(query, values)

#             for food_id in food_ids:
#                 query = "INSERT INTO customeventfoods (custom_food_id, custom_event_id, food_id) VALUES (NULL, %s, %s)"
#                 values = (res['custom_event_id'], food_id)
#                 db.insert(query, values)
            
#             return jsonify({'message': 'Custom event created successfully', 'cuseventid': res})
#         else:
#             return jsonify({'message': 'Customer not found'})
#     except Exception as e:
#         return jsonify({'message': f'Error: {str(e)}'})


@app.route('/addcustomevent', methods=['POST'])
def add_custom_event():
    try:
        db = Db()
        
        customer_lid = request.form['authToken']
        print("customer_lid : ", customer_lid)

        food_ids_str = request.form['foodid']
        food_ids = food_ids_str.split(',')  # Split the comma-separated string into a list of food IDs
        print("food_ids : ", food_ids)
    
        customeventname = request.form['customeventname']
        budget_amt = float(request.form['budget_amt'])
        place = request.form['place']
        noofpersons = int(request.form['noofpersons'])
        date = request.form['date']

        # Convert list of food IDs into comma-separated string
        food_ids_csv = ','.join(food_ids)
        
        query = "SELECT * FROM customer1 WHERE login_id = %s"
        values = (customer_lid,)
        
        result = db.selectOne(query, values)
        
        if result:
            query = "INSERT INTO custom_events (custom_event_id, customer_id, event_name, budget, place, no_of_persons, event_date, event_status) VALUES (NULL, %s, %s, %s, %s, %s, %s, 'Pending')"
            values = (result['customer_id'], customeventname, budget_amt, place, noofpersons, date)
            
            db.insert(query, values)

            query = "SELECT custom_event_id FROM custom_events WHERE event_name = %s"
            values = (customeventname,)
            res = db.selectOne(query, values)

            # Insert food IDs as a comma-separated string into the customeventfoods table
          
            for food_ids_csv in food_ids:
                query = "INSERT INTO customeventfoods (custom_food_id, custom_event_id, food_id) VALUES (NULL, %s, %s)"
                values = (res['custom_event_id'],  food_ids_csv)
                db.insert(query, values)
            
            return jsonify({'message': 'Custom event created successfully', 'cuseventid': res})
        else:
            return jsonify({'message': 'Customer not found'})
    except Exception as e:
        return jsonify({'message': f'Error: {str(e)}'})



@app.route('/getcustomevents', methods=['GET', 'POST'])
def getcustomevent():

    db = Db()
    data = request.get_json()

    customer_lid = data.get('authToken')
    query = "SELECT * FROM customer1 WHERE login_id = %s"
    values = (customer_lid,)
    result = db.select(query, values)
      
    if result:
        first_entry = result[0]
        if 'customer_id' in first_entry:
         cus_id = first_entry['customer_id']   

    query = "SELECT * FROM custom_events WHERE customer_id=%s"
    values = (cus_id,)

    custom_data = db.select(query,values) 

    custom_events = []    
    for row in custom_data:
        custom_events.append({
    'custom_event_id': str(row['custom_event_id']),
    'customer_id': str(row['customer_id']),
    'event_name': row['event_name'],
    'budget': str(row['budget']),
    'place': row['place'],
    'no_of_persons': str(row['no_of_persons']),
    'event_date': row['event_date'],
    'event_status': row['event_status']
})

    return jsonify({'custom_event': custom_events})

@app.route('/delcustomevents', methods=['POST'])
def deletecustom():
    db = Db()
    
    try:
        data = request.json
        event_name = data.get('event_name')  

        query = "SELECT custom_event_id FROM custom_events WHERE event_name = %s"
        values = (event_name,)
        result = db.selectOne(query, values)

        if result:
            custom_event_id = result['custom_event_id']

            delete_query = "DELETE FROM custom_events WHERE custom_event_id= %s"
            delete_values = (custom_event_id,)
            db.delete(delete_query, delete_values)

            return jsonify({'message': 'Custom event deleted successfully', 'custom_event_id': custom_event_id})
        else:
            return jsonify({'message': 'custom event not found'})

    except Exception as e:
        return jsonify({'message': f'Error: {str(e)}'}), 500
    
@app.route('/updatecustomevents', methods=['POST'])
def upcostomev():
    db = Db()

    try:
        data = request.json
        name = data.get('event_name')
        new_name = data.get('new_evname')
        budget = data.get('budget')
        new_budget = data.get('new_bud') 
        place = data.get('place')
        new_place = data.get('new_pl') 
        persons = data.get('no_of_persons')
        new_person = data.get('new_per')
        date = data.get('event_date')
        new_da = data.get('new_date')
        
        qu = "SELECT custom_event_id FROM custom_events WHERE event_name = %s"
        values = (name,)
        res = db.selectOne(qu, values)

        if res:
            cuseventid = res['custom_event_id']

        qry1 = "UPDATE custom_events SET event_name = %s,budget = %s,place = %s,no_of_persons = %s,event_date = %s where custom_event_id = %s"
        val = (new_name,new_budget,new_place,new_person,new_da,cuseventid)  
        db.update(qry1, val)  

        return jsonify({'message': 'Costume Event updated successfully', 'event_name': new_name, 'budget': new_budget, 'place': new_place, 'no_of_persons': new_person, 'event_date': new_da, 'custom_event_id': cuseventid})

    except Exception as e:
        return jsonify({'message': f'Error: {str(e)}'}), 500
     
@app.route('/get_category_id', methods=['GET','POST'])
def get_category_id():
    try:
        db = Db()   
        category_name = request.form['category_name']
        query = "SELECT category_id FROM eventcategories WHERE category_name = %s"
        values = (category_name,)
        result = db.selectOne(query, values)

        if result is not None:   
            category_id = result.get('category_id')
            print(category_id)
            return jsonify({'category_id': category_id})
        else:
            return jsonify({'category_id': None})

    except Exception as e:
        return jsonify({'error': str(e), 'category_id': None})  

@app.route('/bookevent', methods=['POST'])
def book_event():     
    try:
        db = Db()
        data = request.get_json()
        print(f"Received data from Flutter: {data}")
   
        categoryname = data.get('auth')
        customer_lid = data.get('authToken')
        date = data.get('date')
        time = data.get('time')      
        place = data.get('place')
        noofpersons = data.get('noofpersons')

        print(f"persons:{noofpersons}")

        print(f"category_id: {categoryname}")
        print(f"customer_lid: {customer_lid}")

        query = "SELECT * FROM customer1 WHERE login_id = %s"
        values = (customer_lid,)
        result = db.select(query, values)
        print(result)    
      
        if result:
            first_entry = result[0]
            if 'customer_id' in first_entry:
                cus_id = first_entry['customer_id']
                print(cus_id)
            else:     
                print("Customer not found")
                return jsonify({'message': 'Customer not found', 'category_id': None})


        query = "INSERT INTO booking (booking_id, category_id, customer_id, booking_date, booking_time, booking_venue, no_of_persons, booking_status, booking_type) VALUES (NULL, %s, %s, %s, %s, %s, %s, 'Pending', 'Online')"
        values = (categoryname, cus_id, date, time, place, noofpersons)
        db.insert(query, values)

        query2 = "SELECT booking_id FROM booking WHERE customer_id = %s AND booking_date = %s AND booking_time = %s AND booking_venue = %s"
        values2 = (cus_id, date, time, place)
        result2 = db.selectOne(query2,values2)
        
        if result2:
            bid = result2.get('booking_id')
            return jsonify({'message': 'Event booked successfully', 'category_id': categoryname, 'bid': bid})

        return jsonify({'message': 'Event booked successfully', 'category_id': categoryname, 'bid': None})
       
    except Exception as e:
        return jsonify({'message': f'Error: {str(e)}', 'category_id': categoryname})


@app.route('/viewbooking', methods=['GET','POST'])
def view_bookings():
  
    db = Db()      
   
    qry1="SELECT booking_id, first_name,category_name,booking_date,booking_time,booking_venue,no_of_persons,booking_status FROM booking inner join eventcategories using(category_id) inner join customer1 using(customer_id)"
    result = db.select(qry1)

    if result is not None:      
        return jsonify({'result': result})
    else:
        print("not found")
        return jsonify({'error': 'result not found'}), 404
    
@app.route('/viewcategories', methods=['GET','POST'])
def view_categories():

    db = Db()
   
    qry="SELECT * from eventcategories"
    result = db.select(qry)

    if result is not None:
        return jsonify({'result': result})
    
    else:
        print("not found")  
        return jsonify({'error': 'result not found'}), 404
    
@app.route('/customerviewpackages', methods=['GET','POST'])
def viewpackages():

    db = Db()
   
    qry = "SELECT ec.category_name,ep.package_name,ep.package_description,ep.package_amount,pf.package_food_id,f.food_name,f.quantity,f.serving_type FROM eventcategories AS ec INNER JOIN eventpackages AS ep ON ec.category_id = ep.category_id INNER JOIN packagefoods AS pf ON ep.package_id = pf.package_id INNER JOIN food AS f ON pf.food_id = f.food_id"

    result = db.select(qry)

    if result is not None:
        return jsonify({'result': result})
    
    else:
        print("not found")  
        return jsonify({'error': 'result not found'}), 404
       
@app.route('/viewmakeup', methods=['GET','POST'])
def view_makeup():  

    db = Db()
   
    qry="SELECT * from makeup"
    result = db.select(qry)

    if result is not None:
        return jsonify({'res': result})
    
    else:
        print("not found")
        return jsonify({'error': 'result not found'}), 404
    
@app.route('/viewcostume', methods=['GET','POST'])
def view_costume():

    db = Db()     
   
    qry="SELECT * from costume"
    result = db.select(qry)

    if result is not None:
        return jsonify({'res': result})
    
    else:
        print("not found")
        return jsonify({'error': 'result not found'}), 404
    
@app.route('/payment',methods=['GET','POST'])
def pay():

    db = Db()

    data = request.get_json()
    print(f"Received data from Flutter:{data}")
   
    bookid = request.args.get('authT')
    # print(bookid)
    package_amount = data.get('packageAmount')
    # print(package_amount)

    cleaned_package_amount = ''.join(c for c in package_amount if c.isnumeric())
    
    qry = "INSERT INTO payment1 (payment_id, booking_id, amount, payment_date) VALUES (NULL, %s, %s, CURDATE())"
    val = (bookid,cleaned_package_amount,)
    db.insert(qry, val)  

    qry2 = "UPDATE booking SET booking_status = 'Paid' WHERE booking_id = %s"
    val = (bookid,)   
    db.update(qry2,val)   
  
    return "true"     
      
@app.route('/acceptbooking', methods = ['POST'])
def accept():

    db = Db()   

    data = request.json
    book_id = data.get('id')

    if book_id is not None:

     qry2 = "UPDATE booking SET booking_status = 'Accepted' WHERE booking_id = %s"
     val = (book_id,)   
     db.update(qry2,val)                  

     return "true" 
 
    else:

     return "false"     

@app.route('/rejectbooking', methods = ['POST'])    
def reject():
   
    db = Db()
   
    data = request.json
    booking_id = data.get('id')

    if booking_id is not None:     

     qry = "UPDATE booking SET booking_status = 'Rejected' WHERE booking_id = %s"
     value = (booking_id,)
     db.update(qry, value)
     return "true"
     
    else:
     return "false"

@app.route('/customviewbooking', methods=['POST'])
def view():
    db = Db()         
    data = request.get_json()
    # print(f"Received data from Flutter: {data}")
   
    customer_lid = data.get('authToken')
    print(f"customer_lid: {customer_lid}")

    query = "SELECT * FROM customer1 WHERE login_id = %s"
    values = (customer_lid,)
    result = db.select(query, values)
    # print(result) 
      
    if result:
        first_entry = result[0]
        if 'customer_id' in first_entry:
            cus_id = first_entry['customer_id']
            # print(cus_id)   
        
        else:     
            print("Customer not found")
            return jsonify({'message': 'Customer not found', 'category_id': None})
   
    
    qry1 = "SELECT booking.booking_id, booking.customer_id, eventpackages.package_name, eventcategories.category_name, eventpackages.package_amount, booking.booking_date, booking.booking_time, booking.booking_venue, booking.no_of_persons, booking.booking_status, booking.booking_type FROM booking INNER JOIN eventpackages ON booking.category_id = eventpackages.category_id INNER JOIN eventcategories ON eventpackages.category_id = eventcategories.category_id WHERE booking.customer_id = %s"
    result = db.select(qry1, (cus_id,))       

    if result is not None:
        return jsonify({'result': result})
    else:
        print("not found")

# @app.route('/sendreviews', methods=['POST'])
# def sendreview():

#     db = Db()
  
#     data = request.get_json()

#     review = data.get('feedbac')      
#     customer_lid = data.get('authToken')
   
#     query = "SELECT * FROM customer1 WHERE login_id = %s"
#     values = (customer_lid,)
#     result = db.select(query, values)

#     if result:
#         first_entry = result[0]
#         if 'customer_id' in first_entry:
#             cus_id = first_entry['customer_id']
#             query = "INSERT INTO feedback (feedback_id, customer_id, feedback, feedback_date) VALUES (NULL, %s, %s, CURDATE())"
#             values = (cus_id, review)
#             db.insert(query, values)

#             return jsonify({'message': 'Feedback submitted successfully'})
        
#     return jsonify({'message': 'Failed to submit feedback'})



@app.route('/sendreviews', methods=['POST'])
def sendreview():
    
    print('//////////////////////////')
    db = Db()
    
    data = request.get_json()
    print('%%%%%%%%%%%%%%%%%%%%')
    review = data.get('feedbac')      
    customer_lid = data.get('authToken')
    type = data.get('type')

    print(type)
   
    query = "SELECT * FROM customer1 WHERE login_id = %s"
    values = (customer_lid,)
    result = db.select(query, values)

    if result:
        first_entry = result[0]
        if 'customer_id' in first_entry:
            cus_id = first_entry['customer_id']
            query = "INSERT INTO feedback1 (feedback_id, customer_id, feedback, feedback_date, type) VALUES (NULL, %s, %s, CURDATE(), %s)"
            values = (cus_id, review, type)
            db.insert(query, values)

            return jsonify({'message': 'Feedback submitted successfully'})
        
    return jsonify({'message': 'Failed to submit feedback'})

# @app.route('/ratings', methods=['POST'])
# def rate():

#     db = Db()
  
#     data = request.get_json()

#     rate = data.get('rating')
#     customer_lid = data.get('authToken')
   
#     query = "SELECT * FROM customer1 WHERE login_id = %s"
#     values = (customer_lid,)
#     result = db.select(query, values)

#     if result:
#         res = result[0]
#         if 'customer_id' in res:
#             cus_id = res['customer_id']
#             query = "INSERT INTO rating (rating_id, customer_id, rating_no) VALUES (NULL, %s, %s)"
#             values = (cus_id, rate)
#             db.insert(query, values)

#             return jsonify({'message': 'Rated successfully'})
        
#     return jsonify({'message': 'Failed to Rate'})

@app.route('/ratings', methods=['POST'])
def rate():

    db = Db()
    print('********************')
    data = request.get_json()

    rate = data.get('rating')
    entityType = data.get('type')  # This is the type of service being rated

    customer_lid = data.get('authToken')

    print(entityType)
   
    query = "SELECT * FROM customer1 WHERE login_id = %s"
    values = (customer_lid,)
    result = db.select(query, values)

    if result:
        res = result[0]
        if 'customer_id' in res:
            cus_id = res['customer_id']
            query = "INSERT INTO rating1 (rating_id, customer_id, rating_no, typee) VALUES (NULL, %s, %s, %s)"
            values = (cus_id, rate, entityType)  # Insert entityType into entity_type column
            db.insert(query, values)

            return jsonify({'message': 'Rated successfully'})
        
    return jsonify({'message': 'Failed to Rate'})



@app.route('/sendcomp', methods=['POST']) 
def complan():

    db = Db()
  
    data = request.get_json()

    com = data.get('complaint')
    customer_lid = data.get('authToken')
   
    query = "SELECT * FROM customer1 WHERE login_id = %s"
    values = (customer_lid,)
    result = db.select(query, values)

    if result:
        res = result[0]
        if 'customer_id' in res:
            cus_id = res['customer_id']
            query = "INSERT INTO complaint (complaint_id, customer_id, complaint, reply, complaint_date) VALUES (NULL, %s, %s, 'Pending', CURDATE())"
            values = (cus_id, com)
            db.insert(query, values)

            return jsonify({'message': 'Complaint Submitted successfully'})
        
    return jsonify({'message': 'Failed to Send Complaint'})

@app.route('/viewcomplaints', methods=['POST'])
def view_complaints():

    db = Db()

    qry1 = "SELECT complaint_id, first_name, last_name, complaint, reply, complaint_date FROM complaint INNER JOIN customer1 USING (customer_id)"
    result = db.select(qry1)
    if result is not None:
        return jsonify({'result': result})
    else:
        return jsonify({'message': 'No complaints found for this customer'})


@app.route('/admreply', methods = ['POST'])
def admreplyy():

    db = Db()

    data = request.json

    com_id = data.get('id')
    rep = data.get('repl')

    if com_id is not None:

        qry2 = "UPDATE complaint SET reply = %s WHERE complaint_id = %s"
        val = (rep, com_id,)
        db.update(qry2, val)
               
    return "true"   

@app.route('/viewreplies', methods = ['POST'])
def viewreply():

    db = Db()

    data = request.json
 
    customer_lid = data.get('authToken')

    query = "SELECT * FROM customer1 WHERE login_id = %s"
    values = (customer_lid,)
    result = db.select(query, values)

    if result:
        res = result[0]
        if 'customer_id' in res:
            cus_id = res['customer_id']

        qry2 = "SELECT complaint, reply, complaint_date FROM complaint WHERE customer_id = %s "
        val = (cus_id,)
        res = db.select(qry2, val)
      
    if res is not None:
            return jsonify({'result': res})
    else:
        print("not found")
               
@app.route('/viewrating', methods=['GET','POST'])
def view_ratings():

    db = Db()      
   
    qry1="SELECT * from feedback1 inner join customer1 using(customer_id)"
    result = db.select(qry1)

    if result is not None:
        return jsonify({'result': result})
    else:
        print("not found")
        return jsonify({'error': 'result not found'}), 404
    
@app.route('/staffviewbooking', methods=['GET','POST'])
def stview_bookings():
  
    db = Db()       
        
    qry = "SELECT booking_id, package_id, package_name, booking_date, booking_time, booking_venue, no_of_persons FROM booking INNER JOIN eventpackages USING (category_id)"
    result = db.select(qry,)

    if result is not None:
        return jsonify({'result': result})
    else:
        print("not found")
        return jsonify({'error': 'result not found'}), 404

@app.route('/stpro', methods=['GET','POST'])
def stpro():

    auth_token = request.args.get('authToken')
    db = Db() 

    query = "SELECT * FROM staff WHERE login_id = %s"
    values = (auth_token,)
    result = db.select(query, values) 

    if result:
        res = result[0]
        if 'staff_id' in res:
            staf_id = res['staff_id']

            print(staf_id)
     
    if result is not None:
        return jsonify({'result': result})
    else:
        print("not found")
        return jsonify({'error': 'result not found'}), 404

@app.route('/staffviewdetails', methods=['GET','POST'])
def view_details():
  
    db = Db() 
    pid = request.args.get('pid')
    
    qry1 = "SELECT b.booking_id,ep.package_id,b.booking_time,b.booking_venue,b.no_of_persons,ep.package_name,ec.category_name,c.first_name,c.last_name FROM booking AS b INNER JOIN eventpackages AS ep ON b.category_id = ep.category_id INNER JOIN eventcategories AS ec ON b.category_id = ec.category_id INNER JOIN customer1 AS c ON b.customer_id = c.customer_id WHERE ep.package_id = %s"
    result = db.select(qry1, (pid,))

    if result is not None:
        return jsonify({'result': result})        
    else:
        print("not found")
        return jsonify({'error': 'result not found'}), 404
    

@app.route('/admngetcustomevents', methods=['GET', 'POST'])
def admgetcustomevent():
    db = Db()

    qry3 = "SELECT c.first_name, c.last_name, c.gender, ce.custom_event_id, ce.event_name, ce.place FROM custom_events AS ce INNER JOIN customer1 AS c ON ce.customer_id = c.customer_id;"
    
    custom_data = db.select(qry3,)
      
    custom_events = {}  # Use a dictionary to aggregate custom events
    
    for row in custom_data:
        user = row['first_name']
        cuseventid = row['custom_event_id']
        event_name = row['event_name']
        place = row['place']
        
        # Check if the custom event already exists in the dictionary
        if cuseventid not in custom_events:
            custom_events[cuseventid] = {
                'custom_event_id':cuseventid,
                'user': user,
                'event_name': event_name,
                'place': place,
                'foods': [] 
            }

    # Fetch foods for each custom event
    qry_foods = "SELECT cf.custom_event_id, f.food_name FROM customeventfoods AS cf INNER JOIN food AS f ON cf.food_id = f.food_id;"
    food_data = db.select(qry_foods)
    
    for food_row in food_data:
        cuseventid = food_row['custom_event_id']
        food_name = food_row['food_name']

        print(cuseventid,999999999)
        print(food_name,88888)
        
        # Append the food to the corresponding custom event in the dictionary
        custom_events[cuseventid]['foods'].append(food_name)

    # Convert the dictionary values to a list
    custom_event_list = list(custom_events.values())
    print(custom_event_list)

    return jsonify({'custom_event': custom_event_list})


@app.route('/admviewfood', methods=['GET', 'POST'])
def acti():
    db = Db()

    if request.method == 'POST':
        data = request.get_json()
        cid = data.get('cid')
    elif request.method == 'GET':
        cid = request.args.get('cid')  # Retrieve cid from request arguments

    if cid is not None:  # Check if cid is not None before using it
        # Query to fetch foods associated with the given custom event ID
        qr = "SELECT food_name FROM customeventfoods INNER JOIN food USING(food_id) WHERE custom_event_id = %s"
        values = (cid,)
        result = db.select(qr, values)
        
        if result:
            # Extract the food names from the result
            foods = [row['food_name'] for row in result]
            return jsonify({'foods': foods})  # Return the list of food names
        else:
            return jsonify({'foods': []})  # Return an empty list if no foods found
    else:
        return jsonify({'error': 'No cid parameter provided'})  # Return an error response if cid parameter is missing


@app.route('/getpayment', methods=['GET'])
def getpayment():
    db = Db()

    query = """
    SELECT cu.first_name, cu.last_name, epa.package_name, ec.category_name, ep.amount, ep.payment_date
    FROM payment1 AS ep
    INNER JOIN booking AS b ON ep.booking_id = b.booking_id
    INNER JOIN customer1 AS cu ON b.customer_id = cu.customer_id
    INNER JOIN eventcategories AS ec ON b.category_id = ec.category_id
    INNER JOIN eventpackages AS epa ON ec.category_id = epa.category_id
    """

    payment_data = db.select(query)

    payments = []
    for row in payment_data:
        payments.append({
            'first_name': row['first_name'],
            'last_name': row['last_name'],
            'package_name': row['package_name'],
            'category_name': row['category_name'],
            'amount': row['amount'],
            'payment_date': row['payment_date'],
        })
    return jsonify({'event_payment': payments})

@app.route('/staffgetpayment', methods=['GET','POST'])
def stgetpayment():

    db = Db() 

    pid = request.args.get('pid')

    qry1 = "SELECT * FROM eventpackages WHERE package_id = %s"
    result = db.select(qry1, (pid,))

    if result is not None:
        return jsonify({'result': result})
    else:
        print("not found")
        return jsonify({'error': 'result not found'}), 404
    

@app.route('/sendproposal', methods=['POST'])
def proposal():

    db = Db()
   
    data = request.get_json()

    custeventid = data.get('cuseventid')  
    amount = data.get('amount')      

    query = "SELECT * FROM custom_events WHERE custom_event_id = %s"
    values = (custeventid,)
    result = db.select(query, values)   
      
    if result:       
        first_entry = result[0]
        if 'custom_event_id' in first_entry:
            cus_id = first_entry['custom_event_id'] 
   
            query = "INSERT INTO proposal(proposal_id, custom_event_id, proposal_date, proposal_amount, proposal_status) VALUES (NULL, %s, CURDATE(), %s, 'Pending')"
            values = (cus_id, amount)
            db.insert(query, values)

            qry = "update custom_events set event_status ='proposal send' where custom_event_id = %s"
            values = (cus_id,)
            db.update(qry,values)

            return "true"      
        else:
            print("Custom event not found")
            return jsonify({'message': 'Custom event not found', 'custom_event_id': None})
    else:     
        print("Custom event not found")
        return jsonify({'message': 'Custom event not found', 'custom_event_id': None})

@app.route('/viewproposals', methods=['GET','POST'])
def view_proposal():
  
    db = Db()  

    data=request.json

    customer_lid = data.get('authToken')
    print(customer_lid)
    # custeventid = data.get('cuseventid')  
    # print(custeventid)

    qry = "SELECT * FROM customer1 WHERE login_id = %s"
    values = (customer_lid,)

    result = db.select(qry, values)

    if result:
        res = result[0]     
        if 'customer_id' in res:
            cus_id = res['customer_id']
            print(cus_id)

    qry1 = "SELECT customer1.customer_id, proposal.custom_event_id, proposal.proposal_id, custom_events.custom_event_id, custom_events.event_name, custom_events.place, custom_events.no_of_persons, custom_events.event_date, proposal.proposal_date, proposal.proposal_amount, proposal.proposal_status FROM proposal INNER JOIN custom_events ON proposal.custom_event_id = custom_events.custom_event_id INNER JOIN customer1 ON custom_events.customer_id = customer1.customer_id WHERE customer1.customer_id = %s"
    result = db.select(qry1, (cus_id,))

    if result is not None:      
        return jsonify({'result': result})
    else:
        print("not found")
        return jsonify({'error': 'result not found'}), 404
    
@app.route('/acceptproposal', methods = ['POST'])
def acceptpro():

    cuseventid = request.args.get('cuseventid')
    print("cuseventid : ",cuseventid)

    db = Db()   

    data = request.json
    pro_id = data.get('id')

    if pro_id is not None:  

        qry2 = "UPDATE proposal SET proposal_status = 'Accepted' WHERE proposal_id = %s"
        val = (pro_id,)   
        db.update(qry2,val)
        qry4 = "update custom_events set event_status = 'Accepted' WHERE custom_event_id =%s"
        val = (cuseventid,)
        db.update(qry4,val)              
 
        return "true" 

    else:
        return "false"     

@app.route('/rejectproposal', methods = ['POST'])    
def rejectpro():

    cuseventid = request.args.get('cuseventid')
    print("cuseventid : ",cuseventid)

    db = Db()

    data = request.json
    prop_id = data.get('id')

    if prop_id is not None:     

     qry = "UPDATE proposal SET proposal_status = 'Rejected' WHERE proposal_id = %s"
     value = (prop_id,)

     db.update(qry, value)

     qry4 = "update custom_events set event_status = 'Rejected' WHERE custom_event_id =%s"
     val = (cuseventid,)
     db.update(qry4,val)              
 
     return "true"
     
    else:
     return "false"
    
@app.route('/staviewproposals', methods=['GET','POST'])
def staview_proposal():
  
    db = Db()   

    data = request.get_json()

    cusid = data.get('cuseventid')  
    print(cusid)
    proid = data.get('proposalid')
    print(proid)

    qry1 = """SELECT p.proposal_id, ce.event_name, p.proposal_date, p.proposal_amount, p.proposal_status FROM custom_events ce INNER JOIN proposal p ON ce.custom_event_id = p.custom_event_id WHERE ce.custom_event_id = %s"""
    result = db.select(qry1,(cusid,))

    if result is not None:      
        return jsonify({'result': result})
    else:
        print("not found")
        return jsonify({'error': 'result not found'}), 404
 
@app.route('/customeventpayment', methods=['POST'])
def eventpay():
     
    db = Db()
    data = request.get_json()
    
    proposalid = data.get('proposalid')

    custom_amount = data.get('cuseventamount')

    cleaned_custom_amount = ''.join(c for c in custom_amount if c.isnumeric())

    qry = "INSERT INTO customeventpay(payment_id, proposal_id, amount, date) VALUES (NULL, %s, %s, CURDATE())"
    val = (proposalid, cleaned_custom_amount,)
    # db.insert(qry, val)
    # return "true"
    payment_id = db.insert(qry, val)

    # Return the payment ID in the response
    response_data = {'payid': payment_id}
    return jsonify(response_data)
    
@app.route('/update_status', methods = ['POST'])
def upsta():

    db = Db()   

    data = request.json

    pro_id = data.get('proposalid')
    
    # cuseventid = data.get('cuseventid')

    if pro_id is not None:  

        qry2 = "UPDATE proposal SET proposal_status = 'Paid' WHERE proposal_id = %s"
        val = (pro_id,)   
        db.update(qry2,val)
        # qry4 = "update custom_events set event_status = 'Paid' WHERE custom_event_id =%s"
        # val = (cuseventid,)
        # db.update(qry4,val)              
 
        return "true" 

    else:
        return "false"    

@app.route('/staffgetproposalpayment', methods=['GET','POST'])
def stgetpropayment():

    db = Db() 
    
    data = request.get_json()

    pro_id = data.get('proposalid')
    print(pro_id)

    qry1 = "SELECT * FROM customeventpay WHERE proposal_id = %s"
    result = db.select(qry1, (pro_id,))

    if result is not None:
        return jsonify({'result': result})
    else:
        print("not found")
        return jsonify({'error': 'result not found'}), 404


@app.route('/getfoods', methods=['POST', 'GET'])
def viewfood():

    db = Db()
    query = "SELECT * FROM food"

    # Fetch food data from the database
    fdata = db.select(query)

    # Convert the list of food items to a list of dictionaries
    foods = []
    for row in fdata:
        foods.append({
            'food_name': row['food_name'],  
            'description': row['description'],
            'quantity': row['quantity'],
            'serving_type': row['serving_type'],                            
        })

    # Return the list of food items as JSON 
    return jsonify({'message': foods})


@app.route('/get_food_id', methods=['GET','POST'])
def get_food_id():
    try:
        db = Db()   
        print('################')
        food_name = request.form['food_name']
        print(food_name)
        query = "SELECT food_id FROM food WHERE food_name = %s"
        values = (food_name,)
        result = db.selectOne(query, values)
        print(result)

        if result is not None:   
            food_id = result.get('food_id')
            print(food_id)
            return jsonify({'food_id': food_id})
        else:
            return jsonify({'food_id': None})

    except Exception as e:
        return jsonify({'error': str(e), 'food_id': None})



# @app.route('/get_food_id', methods=['POST'])
# def get_food_id():
#     try:
#         db = Db()  # Initialize your database connection
        
#         # Getting food name from request
#         food_name = request.form['food_name']
        
#         # Query to fetch food ID based on food name
#         query = "SELECT food_id FROM foods WHERE food_name = %s"
#         values = (food_name,)
#         result = db.selectOne(query, values)
        
#         if result:
#             return jsonify({'food_id': result['food_id']})
#         else:
#             return jsonify({'error': 'Food not found'})
#     except Exception as e:
#         return jsonify({'error': str(e)})
    
    
# @app.route('/forgot', methods=['POST'])
# def forgot():
#     try:
#         db = Db()
#         data = request.get_json()

#         forgot = data.get('forgot')  
#         print(forgot)

#         qry = "SELECT * FROM staff INNER JOIN login USING(login_id) WHERE email=%s"
#         values = (forgot,)
#         print("Query:", qry % values)
#         res=db.select(qry,values)
#         print(res)


#         if res:
#             aa= str(res[0]['login_id'])
#             print(aa, "///////////\\\\\\\\\\\\\\\\\\\\")
#             return jsonify({'bb': aa, 'redirect': '/newpass'}), 200
#         else:
#             return jsonify({'error': 'Information mismatch, provide valid details', 'redirect': '/login'}), 404

#     except Exception as e:
#         print(f"Error: {e}")
#         return jsonify({'error': str(e), 'redirect': None}), 500
    
@app.route('/forgot', methods=['POST'])
def forgot():
    try:
        db = Db()
        data = request.get_json()

        forgot = data.get('forgot')  
        print(forgot)

        mob = data.get('mob')
        print(mob)

        qry = "SELECT * FROM login WHERE username=%s"
        values = (forgot,)
        print("Query:", qry % values)
        res = db.select(qry, values)
        print(res)

        if res:
            login_type = res[0]['login_type']
            print(login_type)

            if login_type == 'staff':
                qry = "SELECT * FROM staff WHERE phone=%s and email=%s"
                values = (mob, forgot)
                print("Query:", qry % values)
                res = db.select(qry, values)
                res2=str(res[0]['login_id'])
                return jsonify({'bb': res2, 'redirect': '/newpass'}), 200

            elif login_type == 'customer':
                qry = "SELECT * FROM customer1 WHERE phone=%s and email=%s"
                values = (mob, forgot)
                print("Query:", qry % values)
                result = db.select(qry, values)
                res1=str(result[0]['login_id'])
                return jsonify({'bb': res1, 'redirect': '/newpass'}), 200
            
            else:
                return jsonify({'error': 'Information mismatch, provide valid details', 'redirect': '/login'}), 404
        else:
            return jsonify({'error': 'Invalid Username', 'redirect': '/login'}), 404

    except Exception as e:
        print(f"Error: {e}")
        return jsonify({'error': str(e), 'redirect': None}), 500



@app.route('/newpass', methods=['POST','GET'])
def newpass():
    try:
        db = Db() 
        data = request.get_json()
        
       
        npass = data.get('pass')
        print(npass)
        cpass = data.get('cpass')
        print(cpass)
        log = data.get('lid')   
        print(log,"pppppppppppppppppppppppppp")


        if npass == cpass:
                print('******************')
                qry1 = "UPDATE login SET password=%s WHERE login_id=%s"
                values = (cpass, log)
                res = db.update(qry1, values)
                print(res)

                return jsonify({'message': 'Successfully Updated', 'redirect': '/login'})
        else:
                return jsonify({'error': 'Password Mismatch', 'redirect': '/newpass'})

    except Exception as e:
        return jsonify({'error': str(e), 'redirect': None})


@app.route('/cusviewrev', methods=['GET','POST'])
def cusviewrevs():

    db = Db()      
   
    ins="SELECT * from customer1 inner join feedback1 using(customer_id) inner join rating1 using(customer_id)"
    reviews = db.select(ins)

    if reviews is not None:
        return jsonify({'result': reviews})
    else:
        print("not found")
        return jsonify({'error': 'result not found'}), 404

    
if __name__ == '__main__':        
    app.run(host='0.0.0.0', port=5000)                        