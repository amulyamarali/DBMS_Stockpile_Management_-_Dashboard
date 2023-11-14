"""
This script connects to two different MySQL databases, one for customers and one for admins. It allows admins to execute custom SQL queries and view the results, while customers can insert data into the customer table. The script uses the Streamlit library to create a simple web app interface for users to interact with the databases. 

The script first defines the database configurations for both the customer and admin databases, and then connects to them using the mysql.connector library. It then creates a selectbox in the sidebar of the Streamlit app to allow users to choose between the customer and admin pages.

If the user selects the admin page, they are presented with a form to enter a custom SQL query. When the user clicks the "Execute" button, the script executes the query and displays the results in a dataframe. If there is an error executing the query, the script displays an error message.

If the user selects the customer page, they are presented with a form to insert data into the customer table. When the user clicks the "Insert Data" button, the script inserts the data into the customer table in the admin database. If there is an error inserting the data, the script displays an error message.

Finally, the script closes the database connections.
"""

import streamlit as st
import mysql.connector
from time import sleep
import time
import pandas as pd
import matplotlib.pyplot as plt

# st.session_state['count'] = 0

# Define CSS for some styling
st.markdown(
    """
    <style>
    .stApp {
        background-color: #FFCD4B;
    }
    .stSelectbox {
        
        color: #FFCD4B;
    }
    .stButton{
        
        color: #557C55;
    }
    .sidebar  {
        background-color: #557C55;
        color: #FFCD4B;
    }
    </style>
    """,
    unsafe_allow_html=True,
)


# Display a remote image in the corneer of sidebar
st.sidebar.image("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTNL-SNuafApI5-ARxWSrFC2ccbk0fCeT4y6Q&usqp=CAU", width=270)


# *********** CUSTOMER *************
# Configure your MySQL database connection
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': '1Boston#',
    'database': 'dbms_project'
}

# Connect to the MySQL database
conn = mysql.connector.connect(**db_config)
cursor = conn.cursor(dictionary=True)


# ************** ADMIN *************
# Configure your MySQL database connection
db_config_jack = {
    'host': 'localhost',
    'user': 'jack',
    'password': '1234jack',
    'database': 'dbms_project'
}

# Connect to the MySQL database
conn_jack = mysql.connector.connect(**db_config_jack)
cursor_jack = conn_jack.cursor(dictionary=True)

# add button

add_selectbox = st.sidebar.selectbox(
    "Choose your page",
    ("customer", "admin", "Order", "Dashboard")
)

if add_selectbox == 'Dashboard':
    # Query the data from the MySQL database
    query = "SELECT * FROM supply_chain"
    cursor.execute(query)
    data = cursor.fetchall()

    # Convert the data to a Pandas DataFrame
    df = pd.DataFrame(data)


    # Create a bar chart to visualize the aggregated data
    fig, ax = plt.subplots()
    ax.bar(df['prod_id'], df['sold'], label='sold', color='#557C55')
    # ax.bar(df_aggregated.index, df_aggregated['quantity'], label='Quantity')
    ax.set_title('Product Sales')
    ax.set_xlabel('prod_id')
    ax.set_ylabel('Sales')
    ax.legend()

    # Rotate the x-axis labels vertically
    ax.set_xticklabels(ax.get_xticklabels(), rotation=90)

    # Display the bar chart in Streamlit
    st.pyplot(fig)

    # Close the MySQL connection
    cursor.close()
    conn.close()
    

# admin page
if add_selectbox == "admin":
    # Title and description
    st.title("MySQL Table Viewer and Query Executor")
    st.markdown("Enter your custom SQL query or use the form to insert data into the customer table.")

    # Custom query section
    st.header("Execute Custom Query")
    user_query = st.text_area("Enter your SQL query:")

    if st.button("Execute"):
        try:
            cursor.execute(user_query)
            data = cursor.fetchall()
            st.success("Query executed successfully!")
            st.subheader("Query Results:")
            st.dataframe(data)
        except mysql.connector.Error as e:
            st.error("Error executing query: {}".format(e))

# customer login page
if add_selectbox == "customer":
     # Insert data section
    st.header("Insert Data into Customer Table")
    cust_id = st.text_input("Customer ID:")
    cust_name = st.text_input("Customer Name:")
    location_id = st.text_input("Location ID:")
    ph_no = st.text_input("Phone Number:")

    st.session_state['cust_id'] = cust_id  

    if st.button("Insert Data"):
        try:
            query = "INSERT INTO customer (cust_id, cust_name, location_id, ph_no) VALUES (%s, %s, %s, %s)"
            cursor_jack.execute(query, (cust_id, cust_name, location_id, ph_no))
            conn_jack.commit()
            st.success("Data inserted successfully!")
            st.balloons()


        except mysql.connector.Error as e:
            st.error("Error inserting data: {}".format(e))

if add_selectbox == "Order":
    details = {}

    date = time.strftime("%y-%m-%d")


    st.header("select storage to order from:")
    query = "SELECT storage_id FROM storages"
    cursor.execute(query)
    data = cursor.fetchall()

    cust_id = st.text_input("Customer ID:")

    details['cust_id'] = cust_id

    # add in selectbos using for loop
    d = []
    for i in range(len(data)):
        d.append(data[i]['storage_id'])

    add_selectbox_1 = st.selectbox(
                            "Storage ID",
                            (d)
                        )  
    st.write(f'You selected: {add_selectbox_1}')
    details['storage_id'] = add_selectbox_1

    query = "SELECT storage_id, prod_id, quantity FROM supply_chain WHERE storage_id = %s"
    cursor.execute(query, (add_selectbox_1,))
    data = cursor.fetchall()
    prod = []
    for i in range(len(data)):
        prod.append(data[i]['prod_id'])
    
    add_selectbox_2 = st.selectbox(
                        "Product ID",
                        (prod)
                    )
    
    details['prod_id'] = add_selectbox_2
    

    # put default value as 0
    add_selectbox_3 = st.text_input("Quantity:",0)

    print("Quantity: ",add_selectbox_3)
    details['quantity'] = add_selectbox_3
    
    total = 0
    query = "SELECT price FROM product WHERE prod_id = %s"
    cursor.execute(query, (add_selectbox_2,))
    data = cursor.fetchall()


    total = int(add_selectbox_3) * (data[0]['price'])
    st.write(f'Your total amount is: {total}')
    details['total'] = total

    details['invoice_id'] = 'Invoice022'
    details['order_no'] = 'Order022' 
    details['location_id'] = 'Loc001'
    details['ord_date'] = date
    details['cust_name'] = 'Olivia White'

    if st.button("Order"):
        try:

            q = "INSERT INTO orders (order_no, ord_date,cust_id, cust_name, storage_id , location_id) VALUES (%s, %s, %s, %s, %s, %s)"
            cursor.execute(q, (details['order_no'], details['ord_date'] ,details['cust_id'], details['cust_name'], details['storage_id'], details['location_id'] ))
            conn.commit()


            query = "INSERT INTO invoice (invoice_id , order_no, cust_id, no_items, total_price, prod_id) VALUES (%s, %s, %s, %s, %s, %s)"
            print("cust_id: ", cust_id)
            print("prod_id: ", add_selectbox_2)
            print("quantity: ", add_selectbox_3)
            print("total: ", total)
            cursor.execute(query, (details['invoice_id'],details['order_no'], details['cust_id'], details['quantity'], details['total'], details['prod_id']))
            conn.commit()
            st.success("Data inserted successfully!")
            st.balloons()


        except mysql.connector.Error as e:
            st.error("Error inserting data: {}".format(e))


# Close the database connection
cursor.close()
conn.close()

cursor_jack.close()
conn_jack.close()


