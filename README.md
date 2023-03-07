# Atlanta Housing

## Project Objective

To take Real Estate data for Georgia and perform Data Cleaning Operations on it to prepare it for Analysis particular to the Atlanta area.

## Data Used

For the purpose of this project, the Georgia Real Estate Data of the <a href = "https://www.kaggle.com/datasets/yellowj4acket/real-estate-georgia"> First 6 months of 2021 </a> was used. 

## Tools Used

1. Excel
2. Microsoft SQL Server Management Studio

## Data Cleaning Process

Before starting, an overview of the data was extracted through the below query.

    --Real Estate Data Overview

    select * from ProjectPortfolio..RealEstate_Georgia;

Now, let's start with the 'datePostedString' column. This column is in string format and hence, needs to be converted into a date format. For this purpose, a separate column called 'datePosted' was created to store the converted format of the 'datePostedString' column.

    --Creating a separate column to convert datePostedString to date format

    alter table ProjectPortfolio..RealEstate_Georgia
    add datePosted date;

    update ProjectPortfolio..RealEstate_Georgia
    set datePosted = cast(datePostedString as date);
    
During the course of the data analysis process, any analysis with respect to dates is often done revolving around years, months and sometimes even dates. So, having these in separate columns would make that process easier than having to parse the data from the entire date. For this purpose, three more columns were created, namely, 'day','month' and 'year'. These columns would then be populated by parsing from the 'datePosted' column. 

    --Split datePosted column into separate columns for month, date, and year

    select month(datePosted) as month,day(datePosted) as date,year(datePosted) as year
    from ProjectPortfolio..RealEstate_Georgia;

    alter table ProjectPortfolio..RealEstate_Georgia
    add month int,day int,year int;

    update ProjectPortfolio..RealEstate_Georgia
    set month = month(datePosted), day = day(datePosted), year = year(datePosted);
    
It is clear that the 'id' column contains the area zipcode before the hyphen('-'). Since there is already a column named 'zipcode' which stores the area zipcode, having the zipcode as part of the id also is unnecessary for the purpose of our analysis.

    --Excluding the zip code from the id

    update ProjectPortfolio..RealEstate_Georgia
    set id = substring(id,charindex('-',id)+1,len(id));
    
Under the county column, we can see that every county name ends with the word 'County'. Since it is understood that all those values represent county names, it would be convenient in our analysis to drop the word county. For example, 'Fulton County' would simply be converted into 'Fulton'.

    -- Changing county so as to include only county name

    update ProjectPortfolio..RealEstate_Georgia
    set county = substring(county,1,charindex(' ',county)-1);

In the 'livingArea' column, some of the areas are given in terms of Square Feet while some of them are given in Acres. This is indicated by the values under the 'lotAreaUnits' column. The unit conversion between Acres and Square Feet is given below:

    1 Acre = 43560 Square Feet
    
Using this conversion, we will convert all the 'livingArea' values where the 'lotAreaUnits' is given as Acres into Square Feet.
  
    --Conversion of acres into square feet

    update ProjectPortfolio..RealEstate_Georgia
    set livingArea = livingArea * 43560
    where lotAreaUnits = 'Acres';

    alter table ProjectPortfolio..RealEstate_Georgia
    add livingArea_sq_ft float;

    update ProjectPortfolio..RealEstate_Georgia
    set livingArea_sq_ft = livingArea;

In every Data Analysis Process, there are often columns which we don't use for our analysis. So now comes the final step of our analysis and that is to drop all the columns that are unlikely to be required for the analysis.

    --Removing unused columns

    alter table ProjectPortfolio..RealEstate_Georgia
    drop column time,F1,state,stateid,country,currency,countyId,cityId,
    datePostedString,datePosted,hasBadGeocode,description,
    livingAreaValue,lotAreaUnits,livingArea,
    pricePerSquareFoot,longitude,latitude;
 
## For doing analysis specific to Atlanta
 
Now that the dataset is cleaned, one can even choose to use a city or county that is of specific interest to them. In this case, my city of interest was Atlanta, in which case, I will filter the clean data further using the below query.

    select * from ProjectPortfolio..RealEstate_Georgia
    where city = 'Atlanta';
