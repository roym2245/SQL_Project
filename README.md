### Data Import and Database Setup

    Download Data:
        Go to ourworldindata.org/covid-deaths.
        Create two datasets: death_toll.xlsx and vaccination.xlsx. With Date and Population As commun Variable

    Install SQL Management Server 19:
        Install SQL Management Server 19 on your system.

    Create a New Database:
        Open SQL Management Studio.
        Connect to your SQL Server instance.
        Execute commands to create a new database named CovidData.

    Import Data:
        Use SQL Management Studio to import data from the downloaded Excel files (death_toll.xlsx and vaccination.xlsx) into respective tables within the CovidData database.

### Query for Export View

    Writing SQL Query:
        Write a SQL query to create a view that combines the necessary data for visualization in Table.

    Export View:
        Execute the SQL query to create the view.
		Export Tool to Excel file 
        
#### Use Tableau with Exported SQL view for visualization.
