# Atlanta Housing

## Project Objective

Perform Data Cleaning on Real Estate Data for Georgia, to get cleaned data only pertaining to Atlanta Real Estate.

## Data Used

For the purpose of this project, the Georgia Real Estate Data of the <a href = "https://www.kaggle.com/datasets/yellowj4acket/real-estate-georgia"> First 6 months of 2021 </a>(Kaggle) was used. 

## Tools Used

1. Excel
2. Microsoft SQL Server Management Studio

## Data Cleaning Process

1. An overview of the data was extracted through the below query.

    --Real Estate Data Overview

    select * from ProjectPortfolio..RealEstate_Georgia;

2. The 'datePostedString' column. This column is in string format and hence, needs to be converted into a date format. For this purpose, a separate column called 'datePosted' was created to store the converted format of the 'datePostedString' column.

    --Creating a separate column to convert datePostedString to date format

    alter table ProjectPortfolio..RealEstate_Georgia
    add datePosted date;

    update ProjectPortfolio..RealEstate_Georgia
    set datePosted = cast(datePostedString as date);
    
3. For the Data Analysis Process, having the Year, Month and Date in separate columns is useful. For this purpose, three more columns were created, namely, 'day','month' and 'year'. These columns would then be populated by parsing from the 'datePosted' column. 

    --Split datePosted column into separate columns for month, date, and year

    select month(datePosted) as month,day(datePosted) as date,year(datePosted) as year
    from ProjectPortfolio..RealEstate_Georgia;

    alter table ProjectPortfolio..RealEstate_Georgia
    add month int,day int,year int;

    update ProjectPortfolio..RealEstate_Georgia
    set month = month(datePosted), day = day(datePosted), year = year(datePosted);
    
4. The 'id' column contains the area zipcode before the hyphen('-'). Since there is a separate column named 'zipcode' which stores the area zipcode, this can be removed from the 'id' column.

    --Excluding the zip code from the id

    update ProjectPortfolio..RealEstate_Georgia
    set id = substring(id,charindex('-',id)+1,len(id));
    
5. Under the county column, we can see that every county name ends with the word 'County', which is understood, and hence can be removed.

    -- Changing county so as to include only county name

    update ProjectPortfolio..RealEstate_Georgia
    set county = substring(county,1,charindex(' ',county)-1);

6. In the 'livingArea' column, some of the areas are given in terms of Square Feet while some of them are given in Acres. The 'livingArea' values where the 'lotAreaUnits' is given as Acres are converted into Square Feet.

    1 Acre = 43560 Square Feet
  
    --Conversion of acres into square feet

    update ProjectPortfolio..RealEstate_Georgia
    set livingArea = livingArea * 43560
    where lotAreaUnits = 'Acres';

    alter table ProjectPortfolio..RealEstate_Georgia
    add livingArea_sq_ft float;

    update ProjectPortfolio..RealEstate_Georgia
    set livingArea_sq_ft = livingArea;

7. Drop or remove columns not used for our requirement.

    --Removing unused columns

    alter table ProjectPortfolio..RealEstate_Georgia
    drop column time,F1,state,stateid,country,currency,countyId,cityId,
    datePostedString,datePosted,hasBadGeocode,description,
    livingAreaValue,lotAreaUnits,livingArea,
    pricePerSquareFoot,longitude,latitude;
 
8. The Dataset is now cleaned and any city or county of specific interest may be chosen

    select * from ProjectPortfolio..RealEstate_Georgia
    where city = 'Atlanta';
