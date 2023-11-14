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

# add selectbox to sidebar
add_selectbox = st.sidebar.selectbox(
    "Choose an option",
    ("Stock Information", "Dashboard")
)

# Stock Information page
if add_selectbox == "Stock Information":
    # Title and description
    st.title("MySQL Table Viewer and Query Executor")
    st.markdown("Enter your custom SQL query or use the form to insert data into the customer table.")

    st.header("View Data in Tables")
    table = st.selectbox("Select a table", ("owners", "product", "supply_chain", "orders", "supplier_details", "location", "storages", "stock", "customer", "invoice"))
    q = "select * from " + table
    cursor.execute(q)
    data = cursor.fetchall()
    st.dataframe(data)

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


# Close the database connection
cursor.close()
conn.close()

cursor_jack.close()
conn_jack.close()