from flask import Flask, render_template, request
import mysql.connector

app = Flask(__name__)

# Configure your MySQL database connection
db_config = {
    'host': 'localhost',
    'user': 'jack',
    'password': '1234jack',
    'database': 'dbms_project'
}

@app.route('/')
def index():
    return render_template('index_2.html')

@app.route('/query', methods=['GET', 'POST'])
def custom_query():
    if request.method == 'POST':
        # Get the user-submitted SQL query
        user_query = request.form.get('query')
        cust_id = request.form.get('cust_id')
        cust_name = request.form.get('cust_name')
        location_id = request.form.get('location_id')
        ph_no = request.form.get('ph_no')
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor(dictionary=True)

        # Execute the user-submitted query
        cursor.execute(user_query)

        data = cursor.fetchall()

        print(data)

        # query to insert data into customer table
        # Query to insert data into the customer table
        query = "INSERT INTO customer (cust_id, cust_name, location_id, ph_no) VALUES (%s, %s, %s, %s)"
        cursor.execute(query, (cust_id, cust_name, location_id, ph_no))
        conn.commit()

        cursor.close()
        conn.close()

        return render_template('query_result2.html', data=data, user_query=user_query)

    return render_template('query_form.html')

if __name__ == '__main__':
    app.run(debug=True)
