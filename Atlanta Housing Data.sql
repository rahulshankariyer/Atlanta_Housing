select * from ProjectPortfolio..RealEstate_Georgia;

select * from ProjectPortfolio..RealEstate_Georgia
where city = 'Atlanta';

--Creating a separate column to convert datePostedString to date format

alter table ProjectPortfolio..RealEstate_Georgia
add datePosted date;

update ProjectPortfolio..RealEstate_Georgia
set datePosted = cast(datePostedString as date);

--Split datePosted column into separate columns for month, date, and year

select month(datePosted) as month,day(datePosted) as date,year(datePosted) as year
from ProjectPortfolio..RealEstate_Georgia;

alter table ProjectPortfolio..RealEstate_Georgia
add month int,day int,year int;

update ProjectPortfolio..RealEstate_Georgia
set month = month(datePosted), day = day(datePosted), year = year(datePosted);

--Excluding the zip code from the id

update ProjectPortfolio..RealEstate_Georgia
set id = substring(id,charindex('-',id)+1,len(id));

-- Changing county so as to include only county name

update ProjectPortfolio..RealEstate_Georgia
set county = substring(county,1,charindex(' ',county)-1);

--Conversion of acres into square feet

update ProjectPortfolio..RealEstate_Georgia
set livingArea = livingArea * 43560
where lotAreaUnits = 'Acres';

alter table ProjectPortfolio..RealEstate_Georgia
add livingArea_sq_ft float;

update ProjectPortfolio..RealEstate_Georgia
set livingArea_sq_ft = livingArea;

--Removing unused columns

alter table ProjectPortfolio..RealEstate_Georgia
drop column time;

alter table ProjectPortfolio..RealEstate_Georgia
drop column F1,state,stateid,country,currency;

alter table ProjectPortfolio..RealEstate_Georgia
drop column datePostedString;

alter table ProjectPortfolio..RealEstate_Georgia
drop column hasBadGeocode;

alter table ProjectPortfolio..RealEstate_Georgia
drop column countyId,cityId;

alter table ProjectPortfolio..RealEstate_Georgia
drop column livingAreaValue;

alter table ProjectPortfolio..RealEstate_Georgia
drop column lotAreaUnits;

alter table ProjectPortfolio..RealEstate_Georgia
drop column livingArea;

alter table ProjectPortfolio..RealEstate_Georgia
drop column pricePerSquareFoot,longitude,latitude,description;

alter table ProjectPortfolio..RealEstate_Georgia
drop column datePosted;