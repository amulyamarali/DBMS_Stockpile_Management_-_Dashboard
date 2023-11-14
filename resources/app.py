from flask import Flask, render_template, request
import mysql.connector

app = Flask(__name__)

# Configure your MySQL database connection
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': '1Boston#',
    'database': 'dbms_project'
}


@app.route('/', methods=['GET', 'POST'])
def index():
    # Establish a connection to the database
    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor(dictionary=True)

    # Execute a query to fetch data from the table
    query = "SELECT * FROM customer"
    cursor.execute(query)

    # Fetch all rows from the query result
    data = cursor.fetchall()
    

    # Close the cursor and connection
    cursor.close()
    conn.close()

    return render_template('index.html', data=data)

@app.route('/query', methods=['GET', 'POST'])
def custom_query():
    if request.method == 'POST':
        # Get the user-submitted query
        user_query = request.form.get('query')

        # Establish a connection to the database
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor(dictionary=True)

        # Execute the user-submitted query
        cursor.execute(user_query)

        # Fetch all rows from the query result
        query_result = cursor.fetchall()

        # Close the cursor and connection
        cursor.close()
        conn.close()

        return render_template('query_result.html', query_result=query_result)

    return render_template('query_form.html')

if __name__ == '__main__':
    app.run(debug=True)
